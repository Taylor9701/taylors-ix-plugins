local PLUGIN = PLUGIN

ITEM.name = "Attachment"
ITEM.description = "An attachment. It goes on a weapon."
ITEM.category = "Attachments"
ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.slot = 1
ITEM.isAttachment = true
ITEM.attSearch = { "kk_ins2_kobra", }


-- Slot Numbers Defined:

-- Sights = 1
-- Barrels = 2
-- Lasers/Lights = 3
-- Magazines = 4
-- Underbarrel = 5

-- Additional slots can be added so long as they line up with the SWEP's attachment code appropriately.

local function attachment(item, data)
    local client = item.player
    local char = client:GetChar()
    local inv = char:GetInv()
    local items = inv:GetItems()
    local target
    for k, invItem in pairs(items) do
        if data then
            if (invItem:GetID() == data[1]) then
                target = invItem
                break
            end
        end
    end
	
    if (!target) then
        client:NotifyLocalized("No Weapon Found")
        return false
    else
        local class = target.class
        local SWEP = weapons.Get(class)
		
		if target:GetData("equip") == true then
			if client:GetActiveWeapon():GetClass() ~= class then
				client:NotifyLocalized("Must Unequip or Have In-Hand")
				return false
			end
		end

        if (target.isCW) then
            -- Insert Weapon Filter here if you just want to create weapon specific shit. 
            local atts = SWEP.Attachments
            local mods = target:GetData("attachments", {})
            
            if (atts) then		                                
                -- Is the Weapon Slot Filled?
                if (mods[item.slot]) then
                    client:NotifyLocalized("Attachment already fills this slot")
                    return false
                end

                local attachment

                for atcat, data in pairs(atts) do
                    if (attachment) then
                        break
                    end
                    
                    for k, name in pairs(data.atts) do
                        if (attachment) then
                            break
                        end

                        for _, doAtt in pairs(item.attSearch) do
                            if (name == doAtt) then
                                attachment = doAtt
                                break
                            end
                        end
                    end
                end

                if (!attachment) then
                    client:NotifyLocalized("Attachment does not fit")
                    return false
                end
                
                mods[item.slot] = {item.uniqueID, attachment}
                target:SetData("attachments", mods)
                local wepon = client:GetActiveWeapon()

                if (IsValid(wepon) and wepon:GetClass() == target.class) then
                    wepon:attachSpecificAttachment(attachment)
                end
				
				client:EmitSound("cw/holster4.wav")

                return true
            else
                client:NotifyLocalized("notCW")
            end
        end
    end

    client:NotifyLocalized("No Weapon Found")
    return false
end

ITEM.functions.Attach = {
    name = "Attach",
    tip = "Puts this attachment on the specified weapon.",
	icon = "icon16/arrow_merge.png",
    
    OnCanRun = function(item)
        return (!IsValid(item.entity))
    end,
	
    OnRun = function(item, data)
		return attachment(item, data)
	end,
    
    isMulti = true,
    
    multiOptions = function(item, client)
        local targets = {}
        local char = client:GetChar()
        if (char) then
            local inv = char:GetInv()
            if (inv) then
                local items = inv:GetItems()
                for k, v in pairs(items) do
                    if (v.isPLWeapon and v.isCW) then
                        table.insert(targets, {
                        name = L(v.name),
                        data = {v:GetID()},
                    })
					else
						continue
					end
				end
			end
		end
    return targets
	end,
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
		return !IsValid(item.entity) and item:GetOwner():GetCharacter():HasFlags("1")
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
		return !IsValid(item.entity) and item:GetOwner():GetCharacter():HasFlags("1")
	end
}