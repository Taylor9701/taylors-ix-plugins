PLUGIN.name = "Artifacts"
PLUGIN.author = "Taylor"
PLUGIN.desc = "Adds a relatively simple artifact system"

if SERVER then
	function PLUGIN:CharacterLoaded(character)
		if character then
			character:SetData("ArtiHealAmt",0)
			character:SetData("ArtiHealCur",0)
			character:SetData("Rads",0)
			character:SetData("RadsCur",0)
			character:SetData("AccumRads", 0)
			character:SetData("AntiRads",0)
			character:SetData("AntiRadsCur",0)
			character:SetData("EndBuff",0)
			character:SetData("EndBuffCur",0)
			character:SetData("EndRed",0)
			character:SetData("EndRedCur",0)
			character:SetData("WoundHeal",0)
			character:SetData("WoundHealCur",0)
			character:SetData("WeightBuff",0)
			character:SetData("WeightBuffCur",0)
		end
	end
	
	local thinkTimer = 1
	local artihealTimer = 1
	local woundhealTimer = 1
	local radsTimer = 1
	
	function PLUGIN:Think()
		if thinkTimer < CurTime() then
			thinkTimer = CurTime() + 1
			for k, v in ipairs(player.GetAll()) do
				local character = v:GetCharacter()
				
				if not character then continue end
		
				local artiheal = character:GetData("ArtiHealAmt",0)          -- Healing
				local rads = character:GetData("Rads",0)                     -- Radiation
				local antirads = character:GetData("AntiRads",0)             -- Anti-Radiation
				local endbuff = character:GetData("EndBuff",0)               -- Endurance buff
				local endred = character:GetData("EndRed",0)                 -- Endurance debuff
				local woundheal = character:GetData("WoundHeal",0)
				local radstart = character:GetData("AccumRads") or 0
				local maxhealth = v:GetMaxHealth() or 100

				local maxweight = character:GetData("MaxWeight",50)
				local weightbuff = character:GetData("WeightBuff",0)
				local weightprev = character:GetData("WeightBuffCur",0)
					
				if weightbuff ~= weightprev then
					local newweight = ((maxweight + weightbuff) - weightprev)
					character:SetData("MaxWeight",newweight)
					character:SetData("WeightBuffCur",weightbuff)
				end
				
				if artiheal > 0 then
					if artihealTimer < CurTime() then
						artihealTimer = CurTime() + 10
						if (v:IsValid() and v:Alive()) then
							v:SetHealth(math.Clamp(v:Health() + math.Clamp(artiheal,1,100), 0, maxhealth))
						end
					end
				end
				
				if woundheal > 0 then
					if woundhealTimer < CurTime() then
						woundhealTimer = CurTime() + 5
						if (v:IsValid() and v:Alive()) then
							v:SetHealth(math.Clamp(v:Health() + math.Clamp(woundheal,1,100), 0, maxhealth))
						end
					end
				end
				
				if rads > 0 or radstart > 0 then
					if radsTimer < CurTime() then
						radsTimer = CurTime() + 3
						if rads > antirads then
							if (v:IsValid() and v:Alive()) then
								
								if v:Health() <= 0 then
									v:Kill()
								end
								
								local accumrad = character:GetData("AccumRads") or 0
								local radiation = ((rads - antirads)/10)
								local buildup = accumrad + radiation
								local damage = (buildup/20)
								character:SetData("AccumRads", buildup)
								if v:Alive() == false then
									character:SetData("AccumRads", 0)
								end
								
								v:SetHealth(math.Clamp((v:Health() - damage), 0, maxhealth))
							end
						else
							if (v:IsValid() and v:Alive()) then
								if v:Health() <= 0 then
									v:Kill()
								end
										
								local accumrad = character:GetData("AccumRads") or 0 -- accumulated radiation
								local antiradcalc = (antirads - rads) or 0      -- antiradiation artis help
								local modifier = (1 + antiradcalc)                   -- add the antiradiation artis and a baseline -1 to rad together
								local radred = (accumrad - modifier)                 -- reduce the accumulated radiation value by the modifier
								local damage = (radred/30)              			 -- determine how much damage the player will receive
								character:SetData("AccumRads", radred)               -- Update the accumulated radiation value
								if radred <= 0 or v:Alive() == false then
									character:SetData("AccumRads", 0)
								end
								
								if accumrad > 45 then
									v:SetHealth(math.Clamp((v:Health() - damage), 0, maxhealth))
								end
							end
						end
					end
				end
			end
		end
	end
end 

hook.Add("PlayerDeath","ArtiWipe", function(client)
	
	local character = client:GetChar()
	
	if not character then return end
	
	for k,v in pairs(character:GetInv():GetItems()) do
		if v.isArtefact then
			v:SetData("equip",nil)
		end
	end

	character:SetData("ArtiHealAmt",0)
    character:SetData("ArtiHealCur",0)
    character:SetData("Rads",0)
    character:SetData("RadsCur",0)
	character:SetData("AccumRads", 0)
    character:SetData("AntiRads",0)
    character:SetData("AntiRadsCur",0)
    character:SetData("EndBuff",0)
    character:SetData("EndBuffCur",0)
    character:SetData("EndRed",0)
    character:SetData("EndRedCur",0)
    character:SetData("WoundHeal",0)
    character:SetData("WoundHealCur",0)
	character:SetData("WeightBuff",0)
	character:SetData("WeightBuffCur",0)
	
	hook.Run("ArtifactChange", client)
end) 