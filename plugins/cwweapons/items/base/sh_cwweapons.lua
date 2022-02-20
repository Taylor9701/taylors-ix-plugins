ITEM.name = "Weapon"
ITEM.description = "A Weapon."
ITEM.category = "Weapons"
ITEM.model = "models/weapons/w_pistol.mdl"
ITEM.class = "weapon_pistol"
ITEM.width = 2
ITEM.height = 2
ITEM.isCW = true
ITEM.isWeapon = true
ITEM.isPLWeapon = true
ITEM.isGrenade = false
ITEM.weaponCategory = "sidearm"
ITEM.modifier = 1 		// How much durability is reduced by per-shot. 1 = 0.01% per shot. 

-- Attachment translator
local attachments = {}
--CW2.0 Attachments
attachments["md_microt1"] = {name = "Aimpoint Micro T1", slot = 1, uID = "microt1"}
attachments["md_nightforce_nxs"] = {name = "Nightforce NXS", slot = 1, uID = "nightforce"}
attachments["md_rmr"] = {name = "Trijicon RMR", slot = 1, uID = "trijiconrmr"}
attachments["md_schmidt_shortdot"] = {name = "Schmidt Shortdot", slot = 1, uID = "shortdot"}
attachments["md_pso1"] = {name = "PSO-1", slot = 1, uID = "pso1"}
attachments["md_psothermal"] = {name = "PSO-T", slot = 1, uID = "psothermal"}
attachments["md_aimpoint"] = {name = "Aimpoint CompM4", slot = 1, uID = "pso1"}
attachments["md_cmore"] = {name = "CMore Railway", slot = 1, uID = "cmore"}
attachments["md_eotech"] = {name = "Eotech Holographic Sight", slot = 1, uID = "eotech"}
attachments["md_reflex"] = {name = "King Arms MR", slot = 1, uID = "kingarmsmr"}
attachments["md_kobra"] = {name = "Kobra Sight", slot = 1, uID = "kobra"}
attachments["md_acog"] = {name = "Trijicon ACOG Sight", slot = 1, uID = "acog"}
attachments["md_pbs1"] = {name = "PBS Supressor", slot = 2, uID = "pbssuppressor"}
attachments["md_cobram2"] = {name = "Cobra M2 Suppressor", slot = 2, uID = "cobrasuppressor"}
attachments["md_tundra9mm"] = {name = "Tundra Supressor", slot = 2, uID = "tundrasuppressor"}
attachments["md_saker"] = {name = "SAKER Supressor", slot = 2, uID = "sakersuppressor"}
attachments["md_foregrip"] = {name = "Foregrip", slot = 3, uID = "foregrip"}

-- KK INS2 Attachments
attachments["kk_ins2_cstm_acog"] = {name = "Trijicon ACOG 4x32 Scope", slot = 1, uID = "acog"}
attachments["kk_ins2_aimpoint"] = {name = "Aimpoint Red Dot Sight", slot = 1, uID = "aimpoint"}
attachments["kk_ins2_anpeq15"] = {name = "AN/PEQ-15", slot = 4, uID = "anpeq"}
attachments["kk_ins2_gl_m203"] = {name = "M203 Grenade Launcher", slot = 3, uID = "attm203"}
attachments["kk_ins2_cstm_barska"] = {name = "Barska Electro Sight", slot = 1, uID = "barska"}
attachments["kk_ins2_bipod"] = {name = "Bipod", slot = 3, uID = "bipod"}
attachments["kk_ins2_cstm_cmore"] = {name = "C-More Red Dot Sight", slot = 1, uID = "cmore"}
attachments["kk_ins2_cstm_compm4s"] = {name = "Aimpoint CompM4S", slot = 1, uID = "compm4s"}
attachments["kk_ins2_elcan"] = {name = "Elcan Optical Scope", slot = 1, uID = "elcan"}
attachments["kk_ins2_eotech"] = {name = "Eotech Holographic Sight", slot = 1, uID = "eotech"}
attachments["kk_ins2_cstm_eotechxps"] = {name = "Eotech XPS2", slot = 1, uID = "eotechxps"}
attachments["kk_ins2_gl_gp25"] = {name = "GP-25 Grenade Launcher", slot = 3, uID = "gp25"}
attachments["kk_ins2_hoovy"] = {name = "Heavy Barrel", slot = 5, uID = "heavybarrel"}
attachments["kk_ins2_kobra"] = {name = "Kobra Red Dot Sight", slot = 1, uID = "kobra"}
attachments["kk_ins2_lam"] = {name = "Laser Sight", slot = 4, uID = "laser"}
attachments["kk_ins2_scope_mosin"] = {name = "Leupold Scope", slot = 1, uID = "leupold"}
attachments["kk_ins2_flashlight"] = {name = "Flashlight", slot = 4, uID = "light"}
attachments["kk_ins2_m6x"] = {name = "M6X", slot = 4, uID = "m6x"}
attachments["kk_ins2_cstm_microt1"] = {name = "Micro T-1 Red Dot Sight", slot = 1, uID = "microt1"}
attachments["kk_ins2_pbs1"] = {name = "PBS-1 Suppressor", slot = 2, uID = "pbs1"}
attachments["kk_ins2_scope_m40"] = {name = "M40a1 Scope", slot = 1, uID = "m40scope"}
attachments["kk_ins2_pbs5"] = {name = "PBS-5 Suppressor", slot = 2, uID = "pbs5"}
attachments["kk_ins2_po4"] = {name = "PO 4x24 Scope", slot = 1, uID = "po4"}
attachments["kk_ins2_mag_saiga_20"] = {name = "Saiga-12 Drum Magazine", slot = 6, uID = "saigadrum"}
attachments["kk_ins2_flashhider_big_shotgun"] = {name = "Saiga-12 Flash Hider", slot = 2, uID = "saigafh"}
attachments["kk_ins2_revolver_mag"] = {name = "Speed Loader", slot = 1, uID = ""}
attachments["kk_ins2_suppressor_shotgun"] = {name = "12 Gauge Suppressor", slot = 2, uID = "supp12"}
attachments["kk_ins2_suppressor_sec"] = {name = "NATO Suppressor", slot = 2, uID = "suppnato"}
attachments["kk_ins2_suppressor_pistol"] = {name = "Pistol Suppressor", slot = 2, uID = "supppistol"}
attachments["kk_ins2_vertgrip"] = {name = "Vertical Foregrip", slot = 1, uID = "vertgrip"}

--[[
-- This function enables the upgrade system for items that support it:
ITEM.functions.Upgrade = {
	name = "Upgrade",
	icon = "icon16/wrench.png",
	tip = "Add or remove upgrades",
	OnCanRun = function(item)
		if item:GetData("equip") or not item.upgs then
			return false
		end
		
        local char = item.player:GetChar()
        if(char:HasFlags("2")) then
            return (!IsValid(item.entity))
        end
	end,
	OnRun = function(item)
		netstream.Start(item.player, "upgradeMenu", item.id)
		return false
	end
}
--]]

-- Inventory drawing
if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip", false)) then
			surface.SetDrawColor(110, 255, 110, 255)
		else
			surface.SetDrawColor(255, 110, 110, 255)
		end
		surface.DrawRect(w-13,h-13,10,10)
		
		//Durability bar
		if item:GetData("durability") then
			local dura = item:GetData("durability",10000)
			if item:GetOwner() then
				if (item:GetOwner():GetWeapon( item.class )) and (item:GetData("equip")) then
					surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
					surface.DrawOutlinedRect( 7, h - 15, 41, 9 )
					if (dura > 0) then
						surface.SetDrawColor(110, 255, 110, 100)
						surface.DrawRect(8, h - 14, (dura/10000) * 40, 8)
					else
						surface.SetDrawColor(255, 110, 110, 100)
						surface.DrawRect(8, h - 14, 40, 8)
					end
				else
					surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
					surface.DrawOutlinedRect( 7, h - 15, 41, 9 )
					if (dura > 0) then
						surface.SetDrawColor(110, 255, 110, 100)
						surface.DrawRect(8, h - 14, (dura/10000) * 40, 8)
					else
						surface.SetDrawColor(255, 110, 110, 100)
						surface.DrawRect(8, h - 14, 40, 8)
					end
				end
			end
		end
	end
end

ITEM.functions.SetDurability = {
	name = "Set Durability",
	tip = "Dura",
	icon = "icon16/wrench.png",
	
	OnCanRun = function(item)
		local char = item.player:GetChar()
		if char:HasFlags("Z") then
			return true
		else
			return false
		end
	end,
	
	OnRun = function(item)
		netstream.Start(item.player, "armordurabilityAdjust", item:GetData("durability",10000), item.id)
		return false
	end,
}

function ITEM:GetDescription()
	local str = self.description
	local atts = self:GetData("attachments")
	
	
	if (self.entity) or self:GetData("durability") == nil then
		return (self.description .. "\n \nDurability: " .. (math.floor(self:GetData("durability", 10000))/100) .. "%")
	else
		local client = self:GetOwner()
		
		if client then
			local weapon = client:GetActiveWeapon()
			local SWEP = weapons.Get(self.class)
			local atts = SWEP.Attachments
			local activeAtts = self:GetData("attachments",{})
			
			str = str.."\n\nAttachments Available: \n"
			
			for atcat, data in pairs(atts) do
				for k, name in pairs(data.atts) do
					if attachments[name] then
						local attName = attachments[name]["name"]
						str = str..attName
						for x,y in pairs(activeAtts) do
							local attTable = ix.item.list[y[1]]
							local niceName = attTable:GetName()
							if attName == niceName then
								str = str.." ✓"
							end
						end
						str = str.."\n"
					end
				end
			end
		end
		return (str .. "\n \nDurability: " .. (math.floor(self:GetData("durability", 10000))/100) .. "%")
	end
end

-- On item is dropped, Remove a weapon from the player and keep the ammo in the item.
ITEM:Hook("drop", function(item)
	local inventory = ix.item.inventories[item.invID]

	if (!inventory) then
		return
	end

	-- the item could have been dropped by someone else (i.e someone searching this player), so we find the real owner
	local owner

	for client, character in ix.util.GetCharacters() do
		if (character:GetID() == inventory.owner) then
			owner = client
			break
		end
	end

	if (!IsValid(owner)) then
		return
	end

	if (item:GetData("equip")) then
		item:SetData("equip", nil)
		
		local character = owner:GetCharacter()
		local wepslots = character:GetData("wepSlots",{})
		
		local weapon = wepslots[item.weaponCategory]
		
		if (!IsValid(weapon)) then
			weapon = owner:GetWeapon(item.class)
		end
		
		if (IsValid(weapon)) then
			owner:StripWeapon(item.class)
			wepslots[item.weaponCategory] = nil
			character:SetData("wepSlots",wepslots)
			owner:EmitSound("stalkersound/inv_drop.mp3", 80)
		end
	end
end)

-- On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.EquipUn = {
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/cross.png",
	OnRun = function(item)
		item:Unequip(item.player, true)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true
	end
}

-- On player eqipped the item, Gives a weapon to player and load the ammo data from the item.
ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	OnRun = function(item)
		item:Equip(item.player)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true
	end
}

function ITEM:Equip(client)
	local character = client:GetCharacter()
	local items = character:GetInventory():GetItems()
	local wepslots = character:GetData("wepSlots",{})

	if wepslots[self.weaponCategory] then
		client:NotifyLocalized("weaponSlotFilled", self.weaponCategory)
		return false
	end

	if (client:HasWeapon(self.class)) then
		client:StripWeapon(self.class)
	end

	local weapon = client:Give(self.class, !self.isGrenade)

	if (IsValid(weapon)) then
		local ammoType = weapon:GetPrimaryAmmoType()

		wepslots[self.weaponCategory] = weapon
		character:SetData("wepSlots",wepslots)
		client:SelectWeapon(weapon:GetClass())
		weapon:SetWeaponHP((self:GetData("durability")/100),100)
		self:SetData("equip", true)

		if (self.isGrenade) then
			weapon:SetClip1(1)
			client:SetAmmo(0, ammoType)
		end

		weapon.ixItem = self

		if (self.OnEquipWeapon) then
			self:OnEquipWeapon(client, weapon)
		end
	else
		print(Format("[Helix] Cannot equip weapon - %s does not exist!", self.class))
	end
end

function ITEM:OnInstanced(invID, x, y)
	if !self:GetData("durability") then
		self:SetData("durability", 10000)
	end
end

function ITEM:OnEquipWeapon(client, weapon)
    local attList = {}
    local upgList = {}        
	local atts = self:GetData("attachments")
	local upgrades = self:GetData("upgrades")
	local ammotype = self:GetData("ammoType", "Normal")
	
    if (atts) then
        for k, v in pairs(atts) do
            table.insert(attList, v[2])
        end
    end
	
    if (upgrades) then
		for k, v in pairs(upgrades) do
            table.insert(upgList, v[2])
        end
    end
	
    timer.Simple(0.1, function()
		if (IsValid(weapon)) then
			if ammotype ~= "Normal" then
				weapon:attachSpecificAttachment(ammotype)
			end
    		for _, b in ipairs(attList) do
    			weapon:attachSpecificAttachment(b)
    		end
    		for _, b in ipairs(upgList) do
    			weapon:attachSpecificAttachment(b)
			end
    	end
    end)
    weapon:setM203Chamber(false)
end

function ITEM:Unequip(client, bPlaySound, bRemoveItem)
	local character = client:GetCharacter()
	local wepslots = character:GetData("wepSlots",{})
	local weapon = wepslots[self.weaponCategory]

	if (!IsValid(weapon)) then
		weapon = client:GetWeapon(self.class)
	end

	if (IsValid(weapon)) then
		weapon.ixItem = nil
		client:StripWeapon(self.class)
	else
		print(Format("[Helix] Cannot unequip weapon - %s does not exist!", self.class))
	end

	wepslots[self.weaponCategory] = nil
	character:SetData("wepSlots",wepslots)
	self:SetData("equip", nil)

	if (self.OnUnequipWeapon) then
		self:OnUnequipWeapon(client, weapon)
	end

	if (bRemoveItem) then
		self:Remove()
	end
end

function ITEM:CanTransfer(oldInventory, newInventory)
	if (newInventory and self:GetData("equip")) then
		local owner = self:GetOwner()

		if (IsValid(owner)) then
			owner:NotifyLocalized("equippedWeapon")
		end

		return false
	end

	return true
end
  
function ITEM:OnLoadout()
	if (self:GetData("equip")) then
		local client = self.player
		local character = client:GetCharacter()
		local wepslots = character:GetData("wepSlots",{})

		local weapon = client:Give(self.class)

		if (IsValid(weapon)) then
			client:RemoveAmmo(weapon:Clip1(), weapon:GetPrimaryAmmoType())
			wepslots[self.weaponCategory] = weapon
			character:SetData("wepSlots",wepslots)
			weapon:SetWeaponHP((self:GetData("durability")/100),100)
			timer.Simple(0.1,function()
			local ammotype = self:GetData("ammoType", "Normal")
				if ammotype ~= "Normal" then
					weapon:attachSpecificAttachment(ammotype)
				end
			end)

			local attList = {}
			local upgList = {}
			local attachments = self:GetData("attachments")
			local upgrades = self:GetData("upgrades")

			if (attachments) then
				for k, v in pairs(attachments) do
					table.insert(attList, v[2])
				end
			end
				
			if (upgrades) then
				for k, v in pairs(upgrades) do
					table.insert(upgList, v[2])
				end
			end

			timer.Simple(0.1, function()
				if (IsValid(weapon)) then
					for _, b in ipairs(attList) do
						weapon:attachSpecificAttachment(b)
					end
				end
			end)

			weapon.ixItem = self
		else
			print(Format("[Helix] Cannot give weapon - %s does not exist!", self.class))
		end
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
		if item:GetData("durability",0) < 9500 then
			client:Notify("Must be Repaired")
			return false
		end
		client:Notify( "Sold for "..(sellprice).." rubles." )
		client:GetCharacter():GiveMoney(sellprice)
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) and item:GetOwner():GetCharacter():HasFlags("S") and !item:GetData("equip")
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
		if item:GetData("durability",0) < 9500 then
			client:Notify("Must be Repaired")
			return false
		end
		client:Notify( "Item is sellable for "..(sellprice).." rubles." )
		return false
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) and item:GetOwner():GetCharacter():HasFlags("S") and !item:GetData("equip")
	end
}

function ITEM:OnRemoved()
	local inventory = ix.item.inventories[self.invID]
	local owner = inventory.GetOwner and inventory:GetOwner()

	if (IsValid(owner) and owner:IsPlayer()) then
		local weapon = owner:GetWeapon(self.class)

		if (IsValid(weapon)) then
			weapon:Remove()
		end
	end
end

ITEM.functions.Detach = {
	name = "Detach",
	tip = "Detach",
	icon = "icon16/arrow_branch.png",
    isMulti = true,
    multiOptions = function(item, client)
		local targets = {}
	
		for k, v in pairs(item:GetData("attachments", {})) do
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
		if (table.Count(item:GetData("attachments", {})) <= 0) then
			return false
		end
		
		return (!IsValid(item.entity))
	end,
	OnRun = function(item, data)
		local client = item.player
		if (data) then
			local char = client:GetChar()
			
			if item:GetData("equip") == true then
				if client:GetActiveWeapon():GetClass() ~= item.class then
					client:NotifyLocalized("Must Unequip or Have In-Hand")
					return false
				end
			end

			if (char) then
				local inv = char:GetInv()

				if (inv) then
					local mods = item:GetData("attachments", {})
					local attData = mods[data[1]]
					if (attData) then
					    
						inv:Add(attData[1])
						
				        local weapon = client:GetActiveWeapon()
				        
						if (IsValid(weapon) and weapon:GetClass() == item.class) then
						    for category, data in pairs(weapon.Attachments) do
						        for key, attachment in ipairs(data.atts) do
						            if attachment == attData[2] then
						                weapon:detach(category, key, false)
						                break
						            end
					            end
				            end
						end
						
						local attitem = ix.item.list[attData[1]]
						
						mods[data[1]] = nil
						item:SetData("attachments", mods)
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

hook.Add("PlayerDeath", "ixStripClip", function(client)
	local character = client:GetCharacter()
	local wepslots = character:SetData("wepSlots",{})

	for _, v in pairs(client:GetCharacter():GetInventory():GetItems()) do
		if (v.isWeapon and v:GetData("equip")) then
			v:SetData("equip", nil)
			
			if (v.pacData) then
				v:RemovePAC(client)
			end
		end
	end
end)