PLUGIN.name = "Armor"
PLUGIN.author = "Lt. Taylor"
PLUGIN.desc = "Armor system including durability, upgrades, and anomaly resistances."
PLUGIN.repairFlag = "R"

ix.flag.Add(PLUGIN.repairFlag, "Access to repair things.")

PLUGIN.damageTypes = {
	[DMG_FALL] = {
		name = "Fall",
		max = 1
	},
	[8194] = {
		name = "Bullet",
		func = bulBleed,
		max = 1
	},
	[DMG_BULLET] = {
		name = "Bullet",
		func = bulBleed,
		max = 1
	},
	[DMG_SLASH] = {
		name = "Bullet",
		func = bulBleed,
		max = 1
	},
	[DMG_BLAST] = {
		name = "Blast",
		max = 1
	},
	[DMG_BURN] = {
		name = "Burn",
		max = 1	
	},
	[DMG_SHOCK] = {
		name = "Shock",
		max = 1
	},
	[DMG_ACID] = {
		name = "Chemical", 
		func = chemBleed,
		max = 1
	},
	[DMG_RADIATION] = {
		name = "Radiation",
		max = 1
	},
	[DMG_SONIC] = {
		name = "Psi",
		max = 1
	}
}

if (CLIENT) then
	local PANEL = {}
	function PANEL:Init()
	    local DuraSlider = self:Add("DNumSlider")
		DuraSlider:SetText("Armor Durability")
		DuraSlider:SetMin(0)
		DuraSlider:SetMax(100)
		DuraSlider:SetDecimals(0)
		DuraSlider:Dock(FILL)
		
		self:SetTitle("Set Armor Durability")
		self:SetSize(400, 150)
		self:Center()
		self:MakePopup()

		self.submit = self:Add("DButton")
		self.submit:Dock(BOTTOM)
		self.submit:DockMargin(0, 5, 0, 0)
		self.submit:SetTall(25)
		self.submit:SetText("Confirm")
		self.submit.DoClick = function()
		    local dura = DuraSlider:GetValue()
    		netstream.Start("armordurabilityAdjust", (dura * 100), self.itemID)
    		self:Close()
		end
	end

	function PANEL:Think()
		self:MoveToFront()
	end

	vgui.Register("ArmorDurabilityMenu", PANEL, "DFrame")

	netstream.Hook("armordurabilityAdjust", function(dura, id)
		local adjust = vgui.Create("ArmorDurabilityMenu")

		if (id) then
			adjust.itemID = id
		end
	end)
else
	netstream.Hook("armordurabilityAdjust", function(client, dura, id)
		local inv = (client:GetChar() and client:GetChar():GetInv() or nil)
		if (inv) then
			local item
			if (id) then
				item = ix.item.instances[id]
    			local ent = item:GetEntity()
    			if (item and (IsValid(ent) or item:GetOwner() == client)) then
					local target = ent or client
    				target:EmitSound("buttons/combine_button1.wav", 50, 170)
                    dura = math.Round(dura)
    				item:SetData("durability", dura)
    			else
    				client:Notify("No Armor")
    			end
			end
		end
	end)
end

function PLUGIN:EntityTakeDamage(target, dmginfo)
	if(target:IsPlayer()) then
		local dmgType = self.damageTypes[dmginfo:GetDamageType()]
		
		if (dmgType) then
			if (dmgType ~= DMG_DIRECT) then
				local res, resItems = self:calculateRes(target, dmgType)
				
				dmginfo:ScaleDamage(1 - res)
				local dmg = dmginfo:GetDamage()		
				
				if(dmgType.func) then
					dmgType.func(target, res, dmg)
				end
				
				for _,item in pairs(resItems) do
					local curDura = item:GetData("durability", 0)
					if curDura ~= 0 then
						local duraDamage = (dmg/20)
						local newDura = math.Round(math.Clamp(curDura - duraDamage, 0, 100))
						item:SetData("durability", newDura)
					end
				end
			end
		end
	end
end

function PLUGIN:calculateRes(client, dmgType)
	local char = client:GetChar()
	local inventory = char:GetInv()
	
	local total = 0
	local resItems = {}
	for k, v in pairs (inventory:GetItems()) do
		if(!v:GetData("equip", false)) then continue end
	
		local res = v.res and v.res[dmgType.name]
		if (res) then
			table.insert(resItems, v)
			total = total + res
		end
		
		local modData = v:GetData("mod", {})
		for k, modTable in pairs(modData) do
			local modItem = ix.item.list[modTable[1]]
			if(!modItem) then continue end
			if(modItem.res and modItem.res[dmgType.name]) then
				if(!table.HasValue(resItems, v)) then
					table.insert(resItems, v)
				end
				total = total + modItem.res[dmgType.name]
			end
		end
	end
	
	total = math.Clamp(total, -1, 1)
	total = math.min(total, dmgType.max)
	
	return total, resItems
end