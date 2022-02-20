local PLUGIN = PLUGIN

ITEM.name = "FNUpgrade"
ITEM.description = "An attachment. It goes on a weapon."
ITEM.category = "Attachments"
ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.price = 1
ITEM.slot = 1
ITEM.quantity = 1
ITEM.flag = "2"
ITEM.isAttachment = true

-- Slot Numbers Defined

-- Under Armor: 1
-- Armor: 2
-- NVGs: 3
-- Helmet Upgrades: 4
-- Anom Upgrades 1: 5
-- Anom Upgrades 2: 6
-- Anom Upgrades 3: 7
-- Respirator Upgrades: 8
-- Side Armor: 9
-- Anom Upgrades 4: 10

local function attachment(item, data, combine)
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
	
    if (!target.isArmor) then
        client:NotifyLocalized("noArmorTarget")
        return false
    else
        
        if target:GetData("durability", 100) < 100 then
            client:NotifyLocalized("Must Repair Armor")
            return false
        end
        
        local mods = target:GetData("mod", {})
        -- Is the Armor Slot Filled?
        if (mods[item.slot]) then
            client:NotifyLocalized("Slot Filled")
            return false
        end
        
        curPrice = target:GetData("RealPrice")
	    if !curPrice then
		    curPrice = target.price
		end
		
        target:SetData("RealPrice", (curPrice + item.price))
        
        mods[item.slot] = {item.uniqueID, item.name}
        target:SetData("mod", mods)
        local itemweight = item.weight or 0
        local targetweight = target:GetData("weight",target.weight)
		local weightreduc = 0
		
		if item.weightreduc then
			weightreduc = item.weightreduc
		end
		
		local totweight = ((itemweight + targetweight) - weightreduc)
		
        target:SetData("weight", totweight)
        
		client:EmitSound("cw/holster4.wav")
        return true
    end
    client:NotifyLocalized("noArmor")
    return false
end

ITEM.functions.Upgrade = {
    name = "Upgrade",
    tip = "Puts this upgrade on the specified piece of armor.",
    icon = "icon16/wrench.png",
	isMulti = true,
    
    multiOptions = function(item, client)
        --local client = item.player
        local targets = {}
        local char = client:GetChar()
        if (char) then
            local inv = char:GetInv()
            if (inv) then
                local items = inv:GetItems()

                for k, v in pairs(items) do
                    if v.isBodyArmor and item.isArmorUpg then
                        table.insert(targets, {
                            name = L(v.name),
                            data = {v:GetID()},
                        })
                    elseif v.isHelmet and item.isHelmetUpg then
                        table.insert(targets, {
                            name = L(v.name),
                            data = {v:GetID()},
                        })
                    elseif v.isGasmask and item.isGasmaskUpg then
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
    
    OnCanRun = function(item)
        local char = item.player:GetChar()
        if(char:HasFlags("2")) then
            return (!IsValid(item.entity))
        else
			return false
		end
    end,
	
    OnRun = function(item, data)
		return attachment(item, data, false)
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
		return !IsValid(item.entity) and item:GetOwner():GetCharacter():HasFlags("2")
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
		return !IsValid(item.entity) and item:GetOwner():GetCharacter():HasFlags("2")
	end
}

function ITEM:GetDescription()
	local description = self.description
	description = description.."\nWeight: "..self.weight.."kg"
	return description
end