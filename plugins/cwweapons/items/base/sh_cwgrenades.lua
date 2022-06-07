local PLUGIN = PLUGIN

if not CustomizableWeaponry_KK then return end

ITEM.name = "Grenade"
ITEM.description = "An object you throw at enemies for tactical reasons."
ITEM.category = "Weapons"
ITEM.model = "models/weapons/w_pistol.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.weaponCategory = "grenade"
ITEM.isWeapon = true
ITEM.isGrenade = true
ITEM.quantity = 1

ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
		local client = item.player
		local items = client:GetChar():GetInv():GetItems()
        
		client.carryWeapons = client.carryWeapons or {}
        
		for k, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]
				
				if (!itemTable) then
					client:NotifyLocalized("tellAdmin", "itemtable failed")
					return false
				else
					if (itemTable.isWeapon and client.carryWeapons[item.weaponCategory] and itemTable:GetData("equip")) then
						client:NotifyLocalized("weaponSlotFilled")
						return false
					end
				end
			end
		end
		
		if (client:HasWeapon(item.class)) then
			client:StripWeapon(item.class)
		end

		local weapon = client:Give(item.class)

		if (IsValid(weapon)) then
			client.carryWeapons[item.weaponCategory] = weapon
			client:SelectWeapon(weapon:GetClass())

			client:EmitSound("items/ammo_pickup.wav", 80)

			-- Remove default given ammo.
			if (client:GetAmmoCount(weapon:GetPrimaryAmmoType()) == weapon:Clip1() and item:GetData("ammo", 0) == 0) then
				client:RemoveAmmo(weapon:Clip1(), weapon:GetPrimaryAmmoType())
			end
			item:SetData("equip", true)
            
            if item.name == "M18 Smoke Grenade" then
                client:SetAmmo(1, "Smoke Grenades")
            end
            
			weapon:SetClip1(item:GetData("ammo", 0))
            
			if (item.onEquipWeapon) then
				item:onEquipWeapon(client, weapon)
			end
		else
			print(Format("[Nutscript] Weapon %s does not exist!", item.class))
		end

		return false
	end,
	OnCanRun = function(item)
		return (!IsValid(item.entity) and item:GetData("equip") != true)
	end
}

function ITEM:onCanBeTransfered(oldInventory, newInventory)
	if (newInventory and self:GetData("equip")) then
		return false
	end

	return true
end

function ITEM:onTransfered()
	local client = self:GetOwner()

	if IsValid(client) then
		client.armor[self.armorclass] = nil
		client:SetNetVar(self.armorclass, nil)
	end

	if self:GetData("equip") then self:SetData("equip", false) end
end

function ITEM:onLoadout()
    self.player.carryWeapons = self.player.carryWeapons or {}

    local weapon = self.player.carryWeapons[self.weaponCategory]

	if (!weapon or !IsValid(weapon)) then
		weapon = self.player:GetWeapon(self.class)	
	end

	if (weapon and weapon:IsValid()) then
		self:SetData("ammo", weapon:Clip1())
		self.player:StripWeapon(self.class)
	end

	self.player.carryWeapons[self.weaponCategory] = nil

	self:SetData("equip", nil)

	if (self.onUnequipWeapon) then
		self:onUnequipWeapon(client, weapon)
	end
end

function ITEM:onSave()
	local weapon = self.player:GetWeapon(self.class)

	if (IsValid(weapon)) then
		self:SetData("ammo", weapon:Clip1())
	end
end

ITEM:Hook("drop", function(item)
	if (item:GetData("equip")) then
		item:SetData("equip", nil)

		item.player.carryWeapons = item.player.carryWeapons or {}

		local weapon = item.player.carryWeapons[item.weaponCategory]

		if (IsValid(weapon)) then
			item:SetData("ammo", weapon:Clip1())

			item.player:StripWeapon(item.class)
			item.player.carryWeapons[item.weaponCategory] = nil
			item.player:EmitSound("items/ammo_pickup.wav", 80)
		end
	end
end)

function ITEM:onRemoved()
	local inv = ix.item.inventories[self.invID]
	if IsValid(inv) then
    	local receiver = inv.GetReceiver and inv:GetReceiver()
    
    	if (IsValid(receiver) and receiver:IsPlayer()) then
            local weapon = receiver:GetWeapon(self.class)
    
            if (IsValid(weapon)) then
                weapon:Remove()
            end
    	end
	end
end

ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/cross.png",
	OnRun = function(item)
		item.player.carryWeapons = item.player.carryWeapons or {}

		local weapon = item.player.carryWeapons[item.weaponCategory]

		if (!weapon or !IsValid(weapon)) then
			weapon = item.player:GetWeapon(item.class)	
		end

		if (weapon and weapon:IsValid()) then
			item:SetData("ammo", weapon:Clip1())
		
			item.player:StripWeapon(item.class)
		else
			print(Format("[Nutscript] Weapon %s does not exist!", item.class))
		end

		item.player:EmitSound("items/ammo_pickup.wav", 80)
		item.player.carryWeapons[item.weaponCategory] = nil

		item:SetData("equip", nil)

		if (item.onUnequipWeapon) then
			item:onUnequipWeapon(client, weapon)
		end

		return false
	end,
	OnCanRun = function(item)
		return (!IsValid(item.entity) and item:GetData("equip") == true)
	end
}

ITEM.functions.Sell = {
	name = "Sell",
	icon = "icon16/stalker/sell.png",
	sound = "physics/metal/chain_impact_soft2.wav",
	OnRun = function(item)
		local client = item.player
		local sellprice = (item.price/2)
		sellprice = math.Round(sellprice)
		client:Notify( "Sold for "..(sellprice).." rubles." )
		client:GetCharacter():GiveMoney(sellprice)
		
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) and item:GetOwner():GetCharacter():HasFlags("S")
	end
}

ITEM.functions.Value = {
	name = "Value",
	icon = "icon16/help.png",
	sound = "physics/metal/chain_impact_soft2.wav",
	OnRun = function(item)
		local client = item.player
		local sellprice = (item.price/2)
		sellprice = math.Round(sellprice)
		client:Notify( "Item is sellable for "..(sellprice).." rubles." )
		return false
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) and item:GetOwner():GetCharacter():HasFlags("S")
	end
}

if CLIENT then
    function ITEM:paintOver(item, w, h)
        surface.SetDrawColor(item:GetData("equip") and Color(110, 255, 110, 100) or Color(255, 110, 110, 100))
		surface.DrawRect(w - 16, 10, 8, 8)
	end
end