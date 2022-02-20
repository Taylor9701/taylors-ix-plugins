ITEM.name = "Artifact"
ITEM.width = 1
ITEM.height = 1
ITEM.category = "Artifacts"
ITEM.description = "An artifact. Valuable."
ITEM.longdesc = "Longer description here."
ITEM.equipIcon = Material("materials/vgui/ui/stalker/misc/equip.png")
ITEM.price = 1

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

    if (self.entity) then
        return (self.description)
    else
        return (str)
    end
end

function ITEM:OnLoadout()
	if self:GetData("equip") then
		self:SetData("equip", false)
	end
end
 
ITEM:Hook("drop", function(item)
    local client = item.player;
    local character = client:GetChar();

    if (item:GetData("equip")) then
        
        if item.buff == "heal" then 
            local curheal = character:GetData("ArtiHealAmt") or 0
            local newheal = (curheal - item.buffval)
            character:SetData("ArtiHealAmt", newheal)
        end
        
        if item.buff == "woundheal" then
            local curwheal = character:GetData("WoundHeal") or 0
            local newwheal = (curwheal - item.buffval)
            character:SetData("WoundHeal", newwheal)
        end
        
        if item.buff == "antirad" then
            local curantirad = character:GetData("AntiRads") or 0
            local newantirad = (curantirad - item.buffval)
            character:SetData("AntiRads", newantirad)
        end
        
        if item.buff == "end" then
            local curend = character:GetData("EndBuff") or 0
            local newend = (curend - item.buffval)
            character:SetData("EndBuff", newend)
        end
        
        if item.debuff == "rads" then
            local currads = character:GetData("Rads") or 0
            local newrads = (currads - item.debuffval) or 0
            character:SetData("Rads", newrads)
        end
        
        if item.debuff == "end" then
            local curend = character:GetData("EndRed") or 0
            local newend = (curend - item.debuffval)
            character:SetData("EndRed", newend)
        end
        
        if item.buff == "weight" then
           local curweight = character:GetData("WeightBuff") or 0
           local newweight = (curweight - item.buffval)
           character:SetData("WeightBuff",newweight)
        end
        
        item:SetData("equip", nil);
    end;
end);

ITEM.functions.Equip = 
{
    name = "Equip",
    tip = "equipTip",
    icon = "icon16/tick.png",
    
    OnRun = function(item)
        local client = item.player
		local character = client:GetCharacter()
        
        if item.buff == "heal" then
            local curheal = character:GetData("ArtiHealAmt") or 0
			curheal = math.Clamp(curheal,0,1000)
            local newheal = (curheal + item.buffval)
            character:SetData("ArtiHealAmt", newheal)
        end
        
        if item.buff == "woundheal" then
            local curwheal = character:GetData("WoundHeal") or 0
			curwheal = math.Clamp(curwheal,0,1000)
            local newwheal = (curwheal + item.buffval)
            character:SetData("WoundHeal", newwheal)
        end
        
        if item.buff == "antirad" then
            local curantirad = character:GetData("AntiRads") or 0
			curantirad = math.Clamp(curantirad,0,1000)
            local newantirad = (curantirad + item.buffval)
            character:SetData("AntiRads", newantirad)
        end
        
        if item.buff == "end" then
            local curend = character:GetData("EndBuff") or 0
			curend = math.Clamp(curend,0,1000)
            local newend = (curend + item.buffval)
            character:SetData("EndBuff", newend)
        end
        
        if item.debuff == "rads" then
            local currads = character:GetData("Rads") or 0
			currads = math.Clamp(currads,0,1000)
            local newrads = (currads + item.debuffval)
            character:SetData("Rads", newrads)
        end
        
        if item.debuff == "end" then
            local curend = character:GetData("EndRed") or 0
			curend = math.Clamp(curend,0,1000)
            local newend = (curend + item.debuffval)
            character:SetData("EndRed", newend)
        end
        
        if item.buff == "weight" then
           local curweight = character:GetData("WeightBuff") or 0
		   curweight = math.Clamp(curweight,0,1000)
           local newweight = (curweight + item.buffval)
           character:SetData("WeightBuff",newweight)
        end
        
        item:SetData("equip", true)
        
        return false
    end;
    
    OnCanRun = function(item)
        local client = item.player
		local character = client:GetCharacter()
		local artislots = character:GetData("ArtiSlots") or "0"
        local cap = util.StringToType(artislots, "int")
        local char = client:GetChar()
        local inv = char:GetInv()
        local items = inv:GetItems()
        local curr = 0
        
        for k, invItem in pairs(items) do
            if invItem.isArtefact and invItem:GetData("equip") then
                curr = curr + 1
            end
        end
        
        if cap > curr then
            return (!IsValid(item.entity) and item:GetData("equip") ~= true)
        else
            return false
        end
    end;
    
}

ITEM.functions.UnEquip =
{
    name = "Unequip",
    tip = "unequipTip",
    icon = "icon16/cross.png",
    
    OnRun = function(item)
        local client = item.player
		local character = client:GetCharacter()
        
        if item.buff == "heal" then
           local curheal = character:GetData("ArtiHealAmt") or 0
            local newheal = (curheal - item.buffval)
            character:SetData("ArtiHealAmt", newheal)
        end
        
        if item.buff == "woundheal" then
            local curwheal = character:GetData("WoundHeal") or 0
            local newwheal = (curwheal - item.buffval)
            character:SetData("WoundHeal", newwheal)
        end
        
        if item.buff == "antirad" then
            local curantirad = character:GetData("AntiRads") or 0
            local newantirad = (curantirad - item.buffval)
            character:SetData("AntiRads", newantirad)
        end
        
        if item.buff == "end" then
            local curend = character:GetData("EndBuff") or 0
            local newend = (curend - item.buffval)
            character:SetData("EndBuff", newend)
        end
        
        if item.debuff == "rads" then
            local currads = character:GetData("Rads") or 0
            local newrads = (currads - item.debuffval) or 0
            character:SetData("Rads", newrads)
        end
        
        if item.debuff == "end" then
            local curend = character:GetData("EndRed") or 0
            local newend = (curend - item.debuffval)
            character:SetData("EndRed", newend)
        end
        
        if item.buff == "weight" then
           local curweight = character:GetData("WeightBuff") or 0
           local newweight = (curweight - item.buffval)
           character:SetData("WeightBuff",newweight)
        end
        
        item:SetData("equip", false)
        
        return false
    end;
    
    OnCanRun = function(item)
        return (!IsValid(item.entity) and item:GetData("equip") == true)
    end;
}

function ITEM:GetName()
    local name = self.name
    
    local customData = self:GetData("custom", {})
    if(customData.name) then
        name = customData.name
    end
    
    return name
end

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

if (CLIENT) then
	game.AddParticles("particles/vortigaunt_fx.pcf")
	PrecacheParticleSystem("vortigaunt_charge_token_d")
	
    function ITEM:DrawEntity(entity, item)
        if LocalPlayer():GetPos():Distance(entity:GetPos()) > 150 then
            entity:SetMaterial("models/shadertest/predator.vmt")
            entity:DrawShadow(false)
			entity:StopAndDestroyParticles()
        elseif not timer.Exists("Arti") then
            entity:SetMaterial(null)
            entity:DrawShadow(true)
			local visualeffect = CreateParticleSystem(entity,"vortigaunt_charge_token_d",1)
			timer.Create("Arti", 3, 1, function() if entity:IsValid() then entity:StopAndDestroyParticles() end end)
        end

        entity:DrawModel()
    end
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

ITEM.functions.Sell = {
    icon = "icon16/coins.png",
    sound = "physics/metal/chain_impact_soft2.wav",
    OnRun = function(item)
        local client = item.player
		local character = client:GetCharacter()
		
        client:Notify( "Sold for "..(item.price/2).." rubles." )
        character:GiveMoney(item.price/2)
		
        if (item:GetData("equip")) then
			
			if item.buff == "heal" then
				local curheal = character:GetData("ArtiHealAmt") or 0
				local newheal = (curheal - item.buffval)
				character:SetData("ArtiHealAmt", newheal)
			end
			
			if item.buff == "woundheal" then
				local curwheal = character:GetData("WoundHeal") or 0
				local newwheal = (curwheal - item.buffval)
				character:SetData("WoundHeal", newwheal)
			end
			
			if item.buff == "antirad" then
				local curantirad = character:GetData("AntiRads") or 0
				local newantirad = (curantirad - item.buffval)
				character:SetData("AntiRads", newantirad)
			end
			
			if item.buff == "end" then
				local curend = character:GetData("EndBuff") or 0
				local newend = (curend - item.buffval)
				character:SetData("EndBuff", newend)
			end
			
			if item.debuff == "rads" then
				local currads = character:GetData("Rads") or 0
				local newrads = (currads - item.debuffval) or 0
				character:SetData("Rads", newrads)
			end
			
			if item.debuff == "end" then
				local curend = character:GetData("EndRed") or 0
				local newend = (curend - item.debuffval)
				character:SetData("EndRed", newend)
			end
			
			if item.buff == "weight" then
			   local curweight = character:GetData("WeightBuff") or 0
			   local newweight = (curweight - item.buffval)
			   character:SetData("WeightBuff",newweight)
			end
			
			item:SetData("equip", nil);
		end;
    end,
    OnCanRun = function(item)
        return !IsValid(item.entity) and item:GetOwner():GetCharacter():HasFlags("S")
    end
}

ITEM.functions.Value = {
    icon = "icon16/help.png",
    sound = "physics/metal/chain_impact_soft2.wav",
    OnRun = function(item)
        local client = item.player
        client:Notify( "Item is sellable for "..(item.price/2).." rubles." )
        return false
    end,
    OnCanRun = function(item)
        return !IsValid(item.entity) and item:GetOwner():GetChar():HasFlags("S")
    end
}