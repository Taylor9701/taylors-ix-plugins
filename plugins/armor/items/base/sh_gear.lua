ITEM.name = "PAC Outfit"
ITEM.description = "A PAC Outfit Base."
ITEM.longdesc = "No Longer Description Available"
ITEM.category = "Outfit"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 2
ITEM.height = 2
ITEM.pacData = {}
ITEM.resistance = true
ITEM.isHelmet = nil
ITEM.isGasmask = nil
ITEM.equipIcon = Material("materials/vgui/ui/stalker/misc/equip.png")
ITEM.isArmor = true

ITEM.functions.RemoveUpgrade = {
	name = "Remove Upgrade",
	tip = "Remove",
	icon = "icon16/wrench.png",
    isMulti = true,
    multiOptions = function(item, client)
	
	local targets = {}

	for k, v in pairs(item:GetData("mod", {})) do
		local attTable = ix.item.list[v[1]]
		local niceName = attTable:GetName()
		table.insert(targets, {
			name = niceName,
			data = {k},
		})
    end
    return targets
end,
	OnCanRun = function(item)
		if (table.Count(item:GetData("mod", {})) <= 0) then
			return false
		end
	    
        local char = item.player:GetChar()
        if(char:HasFlags("2")) then
            return (!IsValid(item.entity))
        end
	end,
	OnRun = function(item, data)
		local client = item.player
		
	    if item:GetData("durability", 10000) < 10000 then
            client:NotifyLocalized("Must Repair Armor")
            return false
        end
		
		if (data) then
			local char = client:GetChar()

			if (char) then
				local inv = char:GetInv()

				if (inv) then
					local mods = item:GetData("mod", {})
					local attData = mods[data[1]]

					if (attData) then
						inv:Add(attData[1])
						mods[data[1]] = nil
                        
                        curPrice = item:GetData("RealPrice")
                	    if !curPrice then
                		    curPrice = item.price
                		end
                		
                        item:SetData("RealPrice", (curPrice - ix.item.list[attData[1]].price))
                        
						if (table.Count(mods) == 0) then
							item:SetData("mod", nil)
						else
							item:SetData("mod", mods)
						end
						
						local itemweight = item:GetData("weight",0)
                        local targetweight = ix.item.list[attData[1]].weight
                        local totweight = itemweight - targetweight
                        item:SetData("weight", totweight)
						
						client:EmitSound("cw/holster4.wav")
					else
						client:NotifyLocalized("notAttachment")
					end
				end
			end
		else
			client:NotifyLocalized("detTarget")
		end
	
	return false
end,
}

function ITEM:GetDescription()
	local quant = self:GetData("quantity", 1)
	local str = self.description
	if self.longdesc then
		str = str.."\n"..(self.longdesc or "")
	end

	local customData = self:GetData("custom", {})
	if(customData.desc) then
		str = customData.desc
	end
	
	if self.res then
		str = str.."\n\nResistances:"
		
		local mods = self:GetData("mod")
		local resistances = {
			["Fall"] = 0,
			["Shock"] = 0,
			["Burn"] = 0,
			["Radiation"] = 0,
			["Chemical"] = 0,
			["Psi"] = 0,
		}
		
		for k,v in pairs(self.res) do
			if resistances[k] then
				resistances[k] = resistances[k] + v
			end
		end
		
		if mods then
			for x,y in pairs(mods) do
				local item = ix.item.Get(y[1])
				local modres = item.res
				
				if modres then
					for k,v in pairs(modres) do
						if resistances[k] then
							resistances[k] = resistances[k] + v
						end
					end
				end
			end
		end
		
		for k,v in pairs(resistances) do
			if k == "Fall" then
				str = str.."\n".."Impact"..": "..(v*100).."%"
			else
				str = str.."\n"..k..": "..(v*100).."%"
			end
		end
	end

	if (self.entity) then
		return (self.description .. "\n \nDurability: " .. math.floor(self:GetData("durability", 10000)/100) .. "%")
	else
        return (str.. "\n \nDurability: " .. math.floor(self:GetData("durability", 10000)/100) .. "%")
	end
end

function ITEM:GetName()
	local name = self.name
	
	local customData = self:GetData("custom", {})
	if(customData.name) then
		name = customData.name
	end
	
	return name
end

-- Inventory drawing
if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 255)
		else
			surface.SetDrawColor(255, 110, 110, 255)
		end

		surface.SetMaterial(item.equipIcon)
		surface.DrawTexturedRect(w-23,h-23,19,19)

		if (item:GetData("durability")) then
			surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
			surface.DrawOutlinedRect( 7, h - 15, 41, 9 )
			if (item:GetData("durability") > 0) then
				surface.SetDrawColor(110, 255, 110, 100)
				surface.DrawRect(8, h - 14, (item:GetData("durability")/10000) * 40, 8)
			else
				surface.SetDrawColor(255, 110, 110, 100)
				surface.DrawRect(8, h - 14, 40, 8)
			end
		end
	end
end

function ITEM:OnInstanced()
	self:SetData("durability", 10000)
end

function ITEM:RemovePart(client)
	local char = client:GetCharacter()

	self:SetData("equip", false)
	client:RemovePart(self.uniqueID)

	if (self.attribBoosts) then
		for k, _ in pairs(self.attribBoosts) do
			char:RemoveBoost(self.uniqueID, k)
		end
	end

	self:OnUnequipped()
end

function ITEM:TogglePart(client)
	local char = client:GetCharacter()
	client:RemovePart(self.uniqueID)
end

-- On item is dropped, Remove a weapon from the player and keep the ammo in the item.
ITEM:Hook("drop", function(item)
	if (item:GetData("equip")) then
		item:RemovePart(item.player)
	end
end)

-- On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/stalker/unequip.png",
	OnRun = function(item)
		item:RemovePart(item.player)

		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

ITEM.functions.ModelOff = {
	name = "Model Off",
	tip = "equipTip",
	icon = "icon16/stalker/unequip.png",
	OnRun = function(item)
		item:TogglePart(item.player)
		return false
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) and item:GetData("equip")
	end,
}

-- On player eqipped the item, Gives a weapon to player and load the ammo data from the item.
ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip", 
	icon = "icon16/stalker/equip.png",
	OnRun = function(item)
		local char = item.player:GetCharacter()
		local items = char:GetInventory():GetItems()

		for _, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]

				if (v.isHelmet == true and item.isHelmet == true and itemTable:GetData("equip")) then
					item.player:Notify("You are already equipping a helmet!")

					return false
				end

				if (v.isGasmask == true and item.isGasmask == true and itemTable:GetData("equip")) then
					item.player:Notify("You are already equipping a gasmask!")

					return false
				end
			end
		end

		item:SetData("equip", true)
		item.player:AddPart(item.uniqueID, item)

		if (item.attribBoosts) then
			for k, v in pairs(item.attribBoosts) do
				char:AddBoost(item.uniqueID, k, v)
			end
		end

		item:OnEquipped()
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

	return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and
			hook.Run("CanPlayerEquipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

function ITEM:CanTransfer(oldInventory, newInventory)
	if (newInventory and self:GetData("equip")) then
		return false
	end

	return true
end

function ITEM:OnRemoved()
	local inventory = ix.item.inventories[self.invID]
	local owner = inventory.GetOwner and inventory:GetOwner()

	if (IsValid(owner) and owner:IsPlayer()) then
		if (self:GetData("equip")) then
			self:RemovePart(owner)
		end
	end
end

function ITEM:OnEquipped()
	if self.isGasmask == true then
		self.player:EmitSound("stalkersound/gasmask_on.ogg")
		return
	end
end

function ITEM:OnUnequipped()
	if self.isGasmask == true then
		self.player:EmitSound("stalkersound/gasmask_off.ogg")
		return
	end
end

ITEM.functions.Sell = {
	name = "Sell",
	icon = "icon16/stalker/sell.png",
	sound = "physics/metal/chain_impact_soft2.wav",
	OnRun = function(item)
		local client = item.player
		local sellprice = item:GetData("RealPrice") or item.price
		sellprice = math.Round(sellprice*0.75)
		if item:GetData("durability",0) < 10000 then
			client:Notify("Must be Repaired")
			return false
		end
		client:Notify( "Sold for "..(sellprice).." rubles." )
		client:GetCharacter():GiveMoney(sellprice)
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) and item.player:GetCharacter():HasFlags("S") and !item:GetData("equip")
	end
}

ITEM.functions.Value = {
	name = "Value",
	icon = "icon16/help.png",
	sound = "physics/metal/chain_impact_soft2.wav",
	OnRun = function(item)
		local client = item.player
		local sellprice = item:GetData("RealPrice") or item.price
		sellprice = math.Round(sellprice*0.75)
		if item:GetData("durability",0) < 10000 then
			client:Notify("Must be Repaired")
			return false
		end
		client:Notify( "Item is sellable for "..(sellprice).." rubles." )
		return false
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) and item.player:GetCharacter():HasFlags("S") and !item:GetData("equip")
	end
}