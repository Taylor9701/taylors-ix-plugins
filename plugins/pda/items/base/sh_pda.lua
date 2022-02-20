ITEM.name = "Radio Base"
ITEM.model = "models/deadbodies/dead_male_civilian_radio.mdl"
ITEM.description = "A PDA used for communicating with other people."
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Communication"
ITEM.price = 150
ITEM.isPDA = true

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		if (item:GetData("equip")) then
			surface.SetDrawColor(110, 255, 110, 255)
		else
			surface.SetDrawColor(255, 110, 110, 255)
		end

		surface.SetMaterial(item.equipIcon)
		surface.DrawTexturedRect(w-23,h-23,19,19)
	end
end

function ITEM:CanTransfer(oldInventory, newInventory)
	if (newInventory and self:GetData("equip")) then
		return false
	end

	return true
end

ITEM.functions.Equip = { -- sorry, for name order.
	name = "Equip",
	tip = "useTip",
	icon = "icon16/stalker/equip.png",
	sound = "stalkersound/inv_dozimetr.ogg",
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()
		local items = character:GetInventory():GetItems()
		local wepslots = character:GetData("wepSlots",{})

		if item:GetData("equip") then
			client:NotifyLocalized("You are already equipping this PDA.")
			return false
		end
					
		if wepslots[item.weaponCategory] then
			client:NotifyLocalized("weaponSlotFilled", item.weaponCategory)
			return false
		end
		
		wepslots[item.weaponCategory] = item.Name
		character:SetData("wepSlots",wepslots)
		character:SetData("pdaavatar", item:GetData("avatar", "vgui/icons/face_31.png"))
		character:SetData("pdanickname", item:GetData("nickname", item.player:GetName()))
		item:SetData("equip", true)
		character:SetData("pdaequipped", true)

		return false
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") != true and
			hook.Run("CanPlayerUnequipItem", client, item) != false and item.invID == client:GetCharacter():GetInventory():GetID()
	end
}

ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/stalker/unequip.png",
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()
		local wepslots = character:GetData("wepSlots",{})
		item:SetData("equip", false)
		character:SetData("pdaequipped", false)
		character:SetData("pdanickname", "NIL")
		wepslots[item.weaponCategory] = nil
		character:SetData("wepSlots",wepslots)
		return false 
	end,
	OnCanRun = function(item)
		local client = item.player

		return !IsValid(item.entity) and IsValid(client) and item:GetData("equip") == true
	end
}

function ITEM:OnEquipped()

end

function ITEM:OnUnEquipped()

end

ITEM.functions.Sell = {
	name = "Sell",
	icon = "icon16/stalker/sell.png",
	sound = "physics/metal/chain_impact_soft2.wav",
	OnRun = function(item)
		local client = item.player
		local sellprice = item.price
		sellprice = math.Round(sellprice*0.75)
		client:Notify( "Sold for "..(sellprice).." rubles." )
		client:GetCharacter():GiveMoney(sellprice)
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) and item:GetOwner():GetCharacter():HasFlags("1") and !item:GetData("equip")
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
		client:Notify( "Item is sellable for "..(sellprice).." rubles." )
		return false
	end,
	OnCanRun = function(item)
		return !IsValid(item.entity) and item:GetOwner():GetCharacter():HasFlags("1") and !item:GetData("equip")
	end
}