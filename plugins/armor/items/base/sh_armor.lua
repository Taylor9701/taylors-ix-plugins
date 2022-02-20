ITEM.name = "Nice name"
ITEM.description = "Nice desc"
ITEM.longdesc = "No desc"
ITEM.width = 2
ITEM.height = 2
ITEM.isArmor = true
ITEM.price = 1
ITEM.model = "models/props_c17/BriefCase001a.mdl"
ITEM.playermodel = nil
ITEM.isBodyArmor = true
ITEM.resistance = true
ITEM.category = "Armor"
ITEM.res = {
	["Fall"] = 0,
	["Blast"] = 0,
	["Bullet"] = 0,
	["Shock"] = 0,
	["Burn"] = 0,
	["Radiation"] = 0,
	["Psi"] = 0,
}
ITEM.equipIcon = Material("materials/vgui/ui/stalker/misc/equip.png")
ITEM.skincustom = {}
ITEM.outfitCategory = "model"
ITEM.artifactcontainers = {"0"}

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

ITEM:Hook("drop", function(item)
	if (item:GetData("equip")) then
		item:SetData("equip", nil)
		if (item.armorclass != "helmet") then
			item.player:SetModel(item.player:GetChar():GetModel())
		end
	end
end)

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
	    
		if item:GetData("equip") then
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
                		
						local targetitem = ix.item.list[attData[1]]
						
                        item:SetData("RealPrice", (curPrice - targetitem.price))
                        
						if (table.Count(mods) == 0) then
							item:SetData("mod", nil)
						else
							item:SetData("mod", mods)
						end
						
						local itemweight = item:GetData("weight",0)
                        local targetweight = targetitem.weight
						local weightreduc = 0
						
						if targetitem.weightreduc then
							weightreduc = targetitem.weightreduc
						end
						
                        local totweight = itemweight - targetweight + weightreduc
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

	function ITEM:PopulateTooltip(tooltip)
		if !self.entity then
			local duratitle = tooltip:AddRow("duratitle")
			duratitle:SetText("Durability: " .. math.floor(self:GetData("durability", 10000) / 100) .. "%")
			duratitle:SizeToContents()
		end
	end
end

function ITEM:RemoveOutfit(client)
	local character = client:GetCharacter()
	local bgroups = {}

	self:SetData("equip", false)
	if (character:GetData("oldModel" .. self.outfitCategory)) then
		character:SetModel(character:GetData("oldModel" .. self.outfitCategory))
		character:SetData("oldModel" .. self.outfitCategory, nil)
	end

	if (self.newSkin) then
		if (character:GetData("oldSkin" .. self.outfitCategory)) then
			client:SetSkin(character:GetData("oldSkin" .. self.outfitCategory))
			character:SetData("oldSkin" .. self.outfitCategory, nil)
		else
			client:SetSkin(0)
		end
	end

	for k, _ in pairs(self.bodyGroups or {}) do
		local index = client:FindBodygroupByName(k)

		if (index > -1) then
			client:SetBodygroup(index, 0)

			local groups = character:GetData("groups" .. self.outfitCategory, {})

			if (groups[index]) then
				groups[index] = nil
				character:SetData("groups" .. self.outfitCategory, groups)
			end
		end
	end

	for k, v in pairs( self:GetData("origgroups")) do
		self.player:SetBodygroup( k, v )
		bgroups[k] = v
	end

	self.player:GetCharacter():SetData("groups", bgroups)

	if (self.attribBoosts) then
		for k, _ in pairs(self.attribBoosts) do
			character:RemoveBoost(self.uniqueID, k)
		end
	end

	for k, _ in pairs(self:GetData("outfitAttachments", {})) do
		self:RemoveAttachment(k, client)
	end
	character:SetData("ArtiSlots",0)
	self:OnUnequipped()
end

function ITEM:ModelOff(client)
	local character = client:GetCharacter()
	local bgroups = {}
	
	if (character:GetData("oldModel" .. self.outfitCategory)) then
		character:SetModel(character:GetData("oldModel" .. self.outfitCategory))
		character:SetData("oldModel" .. self.outfitCategory, nil)
	end

	if (self.newSkin) then
		if (character:GetData("oldSkin" .. self.outfitCategory)) then
			client:SetSkin(character:GetData("oldSkin" .. self.outfitCategory))
			character:SetData("oldSkin" .. self.outfitCategory, nil)
		else
			client:SetSkin(0)
		end
	end

	for k, _ in pairs(self.bodyGroups or {}) do
		local index = client:FindBodygroupByName(k)

		if (index > -1) then
			client:SetBodygroup(index, 0)

			local groups = character:GetData("groups" .. self.outfitCategory, {})

			if (groups[index]) then
				groups[index] = nil
				character:SetData("groups" .. self.outfitCategory, groups)
			end
		end
	end

	for k, v in pairs( self:GetData("origgroups")) do
		self.player:SetBodygroup( k, v )
		bgroups[k] = v
	end

	self.player:GetCharacter():SetData("groups", bgroups)

	if (self.attribBoosts) then
		for k, _ in pairs(self.attribBoosts) do
			character:RemoveBoost(self.uniqueID, k)
		end
	end

	for k, _ in pairs(self:GetData("outfitAttachments", {})) do
		self:RemoveAttachment(k, client)
	end
end

-- makes another outfit depend on this outfit in terms of requiring this item to be equipped in order to equip the attachment
-- also unequips the attachment if this item is dropped
function ITEM:AddAttachment(id)
	local attachments = self:GetData("outfitAttachments", {})
	attachments[id] = true

	self:SetData("outfitAttachments", attachments)
end

function ITEM:RemoveAttachment(id, client)
	local item = ix.item.instances[id]
	local attachments = self:GetData("outfitAttachments", {})

	if (item and attachments[id]) then
		item:OnDetached(client)
	end

	attachments[id] = nil
	self:SetData("outfitAttachments", attachments)
end

function ITEM:OnInstanced()
	self:SetData("durability", 10000)
end

local function skinset(item, data)
	if data then
		item.player:SetSkin(data[1])
		item:SetData("setSkin", data[1])
		if data[2] then
			--item.player:GetCharacter():SetModel(data[2])
			item:SetData("setSkinOverrideModel", data[2])
		else
			--item.player:GetCharacter():SetModel(item.replacements)
			item:SetData("setSkinOverrideModel", nil)
		end
	end
	return false
end

ITEM.functions.ModelOff = { 
	name = "Model Off",
	tip = "useTip",
	icon = "icon16/stalker/customize.png",
	OnCanRun = function(item)
		return !IsValid(item.entity) and item:GetData("equip")
	end,
	
	OnRun = function(item)
		item:ModelOff(item.player)
		return false
	end,
}

ITEM.functions.zCustomizeSkin = {
	name = "Customize Skin",
	tip = "useTip",
	icon = "icon16/stalker/customize.png",
	isMulti = true,
	multiOptions = function(item, client)
		local targets = {}

		for k, v in pairs(item.skincustom) do
			table.insert(targets, {
				name = v.name,
				data = {v.skingroup, v.modelOverride or nil},
			})
		end

		return targets
	end,
	OnCanRun = function(item)				
		return (!IsValid(item.entity) and #item.skincustom > 0 and item:GetData("equip") == true and item:GetOwner():GetCharacter():GetInventory():HasItem("paint") and item:GetOwner():GetCharacter():GetFlags("T"))
	end,
	OnRun = function(item, data)
		if !data[1] then
			return false
		end

		return skinset(item, data)
	end,
}

ITEM:Hook("drop", function(item)
	local client = item.player
	if (item:GetData("equip")) then
		item:RemoveOutfit(item:GetOwner())
		item:RemovePart(item.player)
	end
end)

function ITEM:RemovePart(client)
	local char = client:GetCharacter()

	self:SetData("equip", false)
	client:RemovePart(self.uniqueID)
end

ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/stalker/unequip.png",
	OnRun = function(item)
		local client = item.player
				
		item:RemoveOutfit(item.player)
		item:RemovePart(item.player)
		
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/stalker/equip.png",
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()
		local items = character:GetInventory():GetItems()

		for _, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = ix.item.instances[v.id]
				
				if itemTable then
					if (itemTable.pacData and v.outfitCategory == item.outfitCategory and itemTable:GetData("equip")) then
						item.player:Notify("You're already equipping this kind of outfit")

						return false
					end

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
		end

		item:SetData("equip", true)
		item.player:AddPart(item.uniqueID, item)

		local origbgroups = {}
		for k, v in ipairs(client:GetBodyGroups()) do
			origbgroups[v.id] = client:GetBodygroup(v.id)
		end
		item:SetData("origgroups", origbgroups)

		if (type(item.OnGetReplacement) == "function") then
			character:SetData("oldModel" .. item.outfitCategory, character:GetData("oldModel" .. item.outfitCategory, item.player:GetModel()))
			character:SetModel(item:OnGetReplacement())
		elseif (item.replacement or item.replacements) then
			character:SetData("oldModel" .. item.outfitCategory, character:GetData("oldModel" .. item.outfitCategory, item.player:GetModel()))

			if (type(item.replacements) == "table") then
				if (#item.replacements == 2 and type(item.replacements[1]) == "string") then
					character:SetModel(item.player:GetModel():gsub(item.replacements[1], item.replacements[2]))
				else
					for _, v in ipairs(item.replacements) do
						character:SetModel(item.player:GetModel():gsub(v[1], v[2]))
					end
				end
			else
				character:SetModel(item.replacement or item.replacements)
			end
		end

		if (item.newSkin) then
			character:SetData("oldSkin" .. item.outfitCategory, item.player:GetSkin())
			item.player:SetSkin(item.newSkin)
		end

		if item:GetData("setSkin", nil) != nil then
			client:SetSkin( item:GetData("setSkin", item.newSkin) )
		end

		if (item.bodyGroups) then
			local groups = {}

			for k, value in pairs(item.bodyGroups) do
				local index = item.player:FindBodygroupByName(k)

				if (index > -1) then
					groups[index] = value
				end
			end

			local newGroups = character:GetData("groups", {})

			for index, value in pairs(groups) do
				newGroups[index] = value
				item.player:SetBodygroup(index, value)
			end

			if (table.Count(newGroups) > 0) then
				character:SetData("groups", newGroups)
			end
		end
		
		local articont = item.artifactcontainers[1]
		local mods = item:GetData("mod")
		
		if mods then
			for k,v in pairs(mods) do
				local upgitem = ix.item.Get(v[1])
				if upgitem.articontainer then
					articont = articont + upgitem.articontainer
				end
			end
		end
		
		character:SetData("ArtiSlots",articont)
		item:OnEquipped()
		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and
			hook.Run("CanPlayerEquipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

function ITEM:OnLoadout()
	if (self:GetData("equip")) then
		local client = self.player
		local character = client:GetCharacter()
		if self.newSkin then
			client:SetSkin( self.newSkin )
		end
		
		local articont = self.artifactcontainers[1]
		local mods = self:GetData("mod")
		
		if mods then
			for k,v in pairs(mods) do
				local upgitem = ix.item.Get(v[1])
				if upgitem.articontainer then
					articont = articont + upgitem.articontainer
				end
			end
		end
		
		character:SetData("ArtiSlots",articont)
		if self:GetData("setSkin", nil) != nil then
			client:SetSkin( self:GetData("setSkin", self.newSkin) )
		end

		if self:GetData("setBG", nil) != nil then
			local data = self:GetData("setBG", nil)
			local bgroup = data[1]
			local bgroupsub = data[2]

			for i=1,#bgroup do
				client:SetBodygroup( bgroup[i], bgroupsub[i] )
			end
		end
	end
end

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
	self.player:EmitSound("stalkersound/inv_slot.mp3")
end

function ITEM:OnUnequipped()
	self.player:EmitSound("stalkersound/inv_slot.mp3")
end

ITEM.functions.Inspect = {
	name = "Inspect",
	tip = "Inspect this item",
	icon = "icon16/picture.png",
	OnClick = function(item, test)
		local customData = item:GetData("custom", {})

		local frame = vgui.Create("DFrame")
		frame:SetSize(540, 680)
		frame:SetTitle(item.name)
		frame:MakePopup()
		frame:Center()

		frame.html = frame:Add("DHTML")
		frame.html:Dock(FILL)
		
		local imageCode = [[<img src = "]]..customData.img..[["/>]]
		
		frame.html:SetHTML([[<html><body style="background-color: #000000; color: #282B2D; font-family: 'Book Antiqua', Palatino, 'Palatino Linotype', 'Palatino LT STD', Georgia, serif; font-size 16px; text-align: justify;">]]..imageCode..[[</body></html>]])
	end,
	OnRun = function(item)
		return false
	end,
	OnCanRun = function(item)
		local customData = item:GetData("custom", {})
	
		if(!customData.img) then
			return false
		end
		
		if(item.entity) then
			return false
		end
		
		return true
	end
}

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
		return !IsValid(item.entity) and item:GetOwner():GetCharacter():HasFlags("S")
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
		return !IsValid(item.entity) and item:GetOwner():GetCharacter():HasFlags("S")
	end
}

function ITEM:GetDescription()
	local quant = self:GetData("quantity", 1)
	local str = self.description.."\n"..self.longdesc
	local customData = self:GetData("custom", {})
	
	if(customData.desc) then
		str = customData.desc
	end
	
	if (self.artifactcontainers[1]) then
		str = str .. "\n\nArtifact Containers: " .. self.artifactcontainers[1]
	end
	
	if self.res then
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
		
		local mods = self:GetData("mod")
		
		if mods then
			for x,y in pairs(mods) do
				local moditem = ix.item.Get(y[1])
				local modres = moditem.res
				
				if modres then
					for k,v in pairs(modres) do
						if resistances[k] then
							resistances[k] = resistances[k] + v
						end
					end 
				end
			end
		end
		
		if self.Special then
			local spec = self.Special
			if istable(spec) then
				for k,v in pairs(spec) do
					if string.match(v,"CC") then
						cc = true
					end
				end
			end
		end
		
		if cc then
			str = str.."\n\nHas a Closed Cycle system"
		end
		
		str = str.."\n\nResistances:"
		
		for k,v in pairs(resistances) do
			if k == "Fall" then
				str = str.."\n".."Impact"..": "..(v*100).."%"
			else
				str = str.."\n"..k..": "..(v*100).."%"
			end
		end
	end

	if mods then
		str = str .. "\n\nModifications:"
		for _,v in pairs(mods) do
			local moditem = ix.item.Get(v[1])
			str = str .. "\n" .. moditem.name
		end
	end

	if (self.entity) then
		return (self.description .. "\n \nDurability: " .. math.floor(self:GetData("durability", 10000) / 100) .. "%")
	else
        return (str)
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

ITEM.functions.Clone = {
	name = "Clone",
	tip = "Clone this item",
	icon = "icon16/wrench.png",
	OnRun = function(item)
		local client = item.player	
	
		client:requestQuery("Are you sure you want to clone this item?", "Clone", function(text)
			if text then
				local inventory = client:GetCharacter():GetInventory()
				
				if(!inventory:Add(item.uniqueID, 1, item.data)) then
					client:Notify("Inventory is full")
				end
			end
		end)
		return false
	end,
	OnCanRun = function(item)
		local client = item.player
		return client:GetCharacter():HasFlags("N") and !IsValid(item.entity)
	end
}

ITEM.functions.Custom = {
	name = "Customize",
	tip = "Customize this item",
	icon = "icon16/wrench.png",
	OnRun = function(item)		
		ix.plugin.list["customization"]:startCustom(item.player, item)
		
		return false
	end,
	
	OnCanRun = function(item)
		local client = item.player
		return client:GetCharacter():HasFlags("N") and !IsValid(item.entity)
	end
}