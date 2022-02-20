local PLUGIN = PLUGIN
PLUGIN.name = "Rollable Stats"
PLUGIN.author = "Verne & Taylor"
PLUGIN.desc = "Stats used for rolling in various situations."

local calibers = {}
calibers["22"] = {short = "1d10+1", medium = "1d10+2"}
calibers["38"] = {short = "1d10", medium = "1d10+1"}
calibers["9x18"] = {short = "1d10+1", medium = "1d10+2", long = "1d10+3"}
calibers["9x19"] = {short = "1d10+2", medium = "1d10+3", long = "1d10+4"}
calibers["762x25"] = {short = "1d10+1", medium = "1d10+2"}
calibers["45"] = {short = "1d10+3", medium = "1d10+4"}
calibers["57x28"] = {short = "1d10", medium = "1d10+1"}
calibers["357"] = {short = "1d10+4", medium = "1d10+5"}
calibers["545x39"] = {short = "1d10+2", medium = "1d10+3", long = "1d10+4"}
calibers["556x45"] = {short = "1d10+2", medium = "1d10+3", long = "1d10+4"}
calibers["762x39"] = {short = "1d10+4", medium = "1d10+5", long = "1d10+6"}
calibers["9x39"] = {short = "1d10+4"}
calibers["762x51"] = {short = "1d10+4", medium = "1d10+5", long = "1d10+6"}
calibers["762x54"] = {short = "1d10+4", medium = "1d10+5", long = "1d10+6"}
calibers["12g"] = {short = "1d10+3", medium = "1d10+6"}
calibers["23x75"] = {short = "2d10+2"}
calibers["338"] = {short = "1d10+7"}
calibers["145"] = {short = "2d10+3"}

function PLUGIN:CharacterAttributeUpdated(client, self, key)				
	local character = client:GetCharacter()

	if key == "endurance" then
		character:SetAttrib("healthpoints", 8 + math.floor(tonumber(character:GetAttribute("endurance")/10)))
	end

	if key == "agility" then
		character:SetAttrib("movement", math.floor(tonumber(character:GetAttribute("agility")/10)))
		character:SetAttrib("initiative", math.floor(tonumber(character:GetAttribute("agility")/10)))
	end
end

function PLUGIN:CharacterAttributeBoosted(client, self, key)
	local character = client:GetCharacter()
	local totalboost = 0

	if key == "endurance" then
		character:SetAttrib("healthpoints", 8 + math.floor(tonumber(character:GetAttribute("endurance")/10)))
	end

	if key == "agility" then
		local agi = character:GetAttribute("agility", 0)

		if character:GetBoost("agility") then
			for k, v in pairs(character:GetBoost("agility")) do
				totalboost = v + totalboost
			end
		end

		character:RemoveBoost("agiderivativeboost", "movement")
		character:RemoveBoost("agiderivativeboost2", "initiative")

		character:AddBoost("agiderivativeboost", "movement", math.floor(totalboost)/10)
		character:AddBoost("agiderivativeboost2", "initiative", math.floor(totalboost)/10)
		
	end
end

function PLUGIN:OnCharacterCreated(client, character)
	character:SetAttrib("healthpoints", 8 + math.floor(tonumber(character:GetAttribute("endurance")/10)))
	character:SetAttrib("movement", math.floor(tonumber(character:GetAttribute("agility")/10)))
	character:SetAttrib("initiative", math.floor(tonumber(character:GetAttribute("agility")/10)))
end

ix.command.Add("rollstat", {
	description = "Tests the given attribute against a roll of 100.",
	arguments = {
		ix.type.string,
		ix.type.string,
		ix.type.text
	},
	OnRun = function(self, client, stat, modifier, description)
		local character = client:GetCharacter()
		local modsign
		local perkmodifier
		local parentstat
		local parentstattranslated
		local str = "tested their "
		local realattriname
		local perksign = nil
		
		for k, v in pairs(ix.perks.list) do
			if v.shortname == stat or v.name == stat or k == stat then
				if client:GetCharacter():GetPerk(k, 0) == 0 then
					perkmodifier = -20
					perksign = ""
				elseif client:GetCharacter():GetPerk(k, 0) == 1 then
					perkmodifier = 0
					perksign = ""
				elseif client:GetCharacter():GetPerk(k, 0) == 2 then
					perkmodifier = 10
					perksign = "+"
				elseif client:GetCharacter():GetPerk(k, 0) == 3 then
					perkmodifier = 20
					perksign = "+"
				elseif client:GetCharacter():GetPerk(k, 0) == 4 then
					perkmodifier = 30
					perksign = "+"
				elseif client:GetCharacter():GetPerk(k, 0) == 5 then
					perkmodifier = 40
					perksign = "+"
				end
				
				if v.name != nil then
					internalattriname = v.parent
					str = str..(v.shortname).." "..character:GetAttribute(internalattriname)
					realattriname = v.name
				end
			end
		end

		for k, v in pairs(ix.attributes.list) do
			if v.shortname == stat or v.name == stat or k == stat then
				if v.name != nil then
					internalattriname = k
					str = str..(v.shortname).." "..character:GetAttribute(internalattriname, 0)
					realattriname = v.name
				end
			end
		end

		if realattriname == nil then
			client:Notify("You typed in an invalid perk/attribute!")
			return false
		end

		if string.len(modifier) != 0 then
			if string.sub(modifier, 1, 1) == "+" then
				modifier = string.sub(modifier, 2)
				modsign = "+"
			elseif string.sub(modifier, 1, 1) == "-" then
				modifier = string.sub(modifier, 2)
				modifier = modifier - modifier - modifier
				modsign = ""
			elseif modifier == "0" then
				modsign = ""
			else
				return client:Notify("Please include a + or - in front of your modifier.")
			end

			str = str.." (Difficulty: "..modsign..modifier..")"
		else
			modsign = ""
			modifier = ""
		end
		
		if perksign != nil then
			str = str.." (Perk: "..perksign..perkmodifier..")"
		end

		if (character and character:GetAttribute(internalattriname, 0)) then
			local statvalue = character:GetAttribute(internalattriname, 0)
			local roll = tostring(math.random(1, 100))
			local successrate = math.floor(math.abs(((modifier+statvalue+(perkmodifier or 0))-roll))/10)

			if modifier then
				str = str.." (You: "..statvalue+(modifier or 0)+(perkmodifier or 0).." vs System: "..roll..")"
			end

			if string.len(description) != 0 then
				str = str.." \""..description.."\""
			end

			if (modifier+statvalue+(perkmodifier or 0))-roll >=0 then
				str = str.." Success by "..successrate
			else
				str = str.." Failure by "..successrate
			end
		end

		ix.chat.Send(client, "rollstat", str, nil, nil)
		hook.Run("RPGRoll", client, str)
	end
})

ix.command.Add("damage",{
	description = "Calculate damage to a target.",
	arguments = {
		ix.type.number,
		ix.type.number,
		ix.type.number
	},
	OnRun = function(self,client,ap,pen,damage)
		str = "Calculated Damage to be: "
		str = str..attackdamage(nil,nil,damage,ap,pen)
		str = str.."\n(AP: "..ap.." Pen: "..pen.." DAM: "..damage..")"
		ix.chat.Send(client, "rollstat", str, nil, nil)
		hook.Run("RPGRoll", client, str)
	end
})

ix.command.Add("parry",{
	description = "Parry an incoming attack.",
	arguments = {
		bit.bor(ix.type.number, ix.type.optional)
	},
	OnRun = function(self,client,modifier)
		local character = client:GetCharacter()
		local str = "attempted to parry an attack "
		local melee = character:GetAttribute("meleeskill")
		local parry = character:GetPerk("parry")
		local parrymod
		local total = 0
		
		if not modifier then
			modifier = 0
		end
		
		if parry == 0 then
			parrymod = -20
			
		elseif parry == 1 then
			parrymod = 0
			
		elseif parry == 2 then
			parrymod = 10
			
		elseif parry == 3 then
			parrymod = 20
			
		elseif parry == 4 then
			parrymod = 30
			
		elseif parry == 5 then
			parrymod = 40
		end
		
		total = melee + parrymod + modifier
		local sysroll = math.random(1,100)
		
		if total < sysroll then
			str = str.."but failed."
		else
			str = str.."and managed to."
		end
		str = str.."\n(Modifier: "..modifier..")"
		ix.chat.Send(client, "rollstat", str, nil, nil)
		hook.Run("RPGRoll", client, str)
	end
})

ix.command.Add("dodge",{
	description = "Dodge an incoming attack.",
	arguments = {
		bit.bor(ix.type.number, ix.type.optional)
	},
	OnRun = function(self,client,modifier)
		local character = client:GetCharacter()
		local str = "attempted to dodge an attack "
		local agi = character:GetAttribute("agility") or 20
		local dodge = character:GetPerk("dodge") or 0
		local dodgemod = 0
		local total = 0
		local mod = modifier or 0
		
		if dodge == 0 then
			dodgemod = -20
			
		elseif dodge == 1 then
			dodgemod = 0
			
		elseif dodge == 2 then
			dodgemod = 10
			
		elseif dodge == 3 then
			dodgemod = 20
			
		elseif dodge == 4 then
			dodgemod = 30
			
		elseif dodge == 5 then
			dodgemod = 40
		end
		
		total = agi + dodgemod + mod
		local sysroll = math.random(1,100)
		
		if total < sysroll then
			str = str.."but failed to move out of the way in time."
		else
			local totaldodge = math.Truncate((total - sysroll)/10) + 1
			if totaldodge > 1 then
				str = str.."and managed to dodge "..totaldodge.." hits."
			else
				str = str.."and managed to dodge a single hit."
			end
		end
		str = str.."\n(Modifier: "..mod..")"
		ix.chat.Send(client, "rollstat", str, nil, nil)
		hook.Run("RPGRoll", client, str)
	end
})

ix.command.Add("melee",{
	description = "Attack with a melee weapon.",
	arguments = {
		bit.bor(ix.type.string, ix.type.optional),  -- aim status: none/half/full
		bit.bor(ix.type.number, ix.type.optional), -- modifier
		bit.bor(ix.type.string, ix.type.optional),	-- bodypart aimed for (if NIL then not specific)
		bit.bor(ix.type.bool, ix.type.optional)
	},
	OnRun = function(self, client, aimstatus, modifier, bodypart, debugbool)
		local str = "attacked "
		local aimmod = 0
		local character = client:GetCharacter()
		local meleeskill = character:GetAttribute("meleeskill")
		local inv = character:GetInv()
		local total = 0
		local bodypartmod = 0
		local endur = character:GetAttribute("endurance")
		local pen
		local damage
		local weapon = client:GetActiveWeapon()
		local wepclass = weapon:GetClass()
		local dambonus = math.Truncate(character:GetAttribute("strength")/10)
		local target
		
		if not aimstatus then
			aimstatus = "none"
		end
		
		if bodypart == "none" or bodypart == "nil" then
			bodypart = nil
		end
		
		if bodypart then
			bodypartmod = -20
		end
		
		if not modifier then
			modifier = 0
		end
		
		if aimstatus == "full" then
			aimmod = 20
		elseif aimstatus == "half" then
			aimmod = 10
		elseif aimstatus == "none" then
			aimmod = 0
		end
		
		local eyetrace2 = util.TraceLine( {
			start = client:EyePos(),
			endpos = client:EyePos() + client:EyeAngles():Forward() * 30000,
			filter = function(ent)
				if ent ~= client then
					if ent:IsPlayer() or ent:GetClass() == "prop_ragdoll" or ent:GetClass() == "prop_animatable" then
						if not target then
							target = ent
						end
						return true
					end
				end
			end
		})
		
		if inv then
			local items = inv:GetItems()
			for k,v in pairs(items) do
				if v.class == wepclass and v:GetData("equip") then
					damage = v.Dmg
					pen = v.Pen
				end
			end
		end
		
		if not damage then
			damage = "1d10"
			pen = 0
		end
		
		if not target or not target:IsPlayer() then
			str = str.."someone"
		else
			str = str..target:GetCharacter():GetName()
		end
		
		total = meleeskill + tonumber(modifier) + bodypartmod + aimmod
		local systemroll = math.random(1,100)
		
		if total < systemroll then
			str = str.." but missed their target."
		else
			str = attackdamage(client,str,damage,1,pen,bodypart,dambonus,target,"melee",false)
			
			if not target then
				str = str.."\n(Modifier: "..modifier..", Aim: "..aimstatus..", Pen: "..pen.." NO TARGET, DO AP)"
			else
				str = str.."\n(Modifier: "..modifier..", Aim: "..aimstatus..", Pen: "..pen..")"
			end
		end
		
		if debugbool then
			str = str.."\n".."System: "..systemroll.." User: "..total
		end
		
		ix.chat.Send(client, "rollstat", str, nil, nil)
		hook.Run("RPGRoll", client, str)
	end
})

ix.command.Add("initiative", {
	description = "Calculate your initiative",
	OnRun = function(self, client)
		local character = client:GetCharacter()
		local agi = character:GetAttribute("agility")
		local agibonus = math.Truncate(agi/10)
		local initroll = math.random(1,10) + agibonus
		local str = "rolled an initiative of "..initroll.."."
		ix.chat.Send(client, "rollstat", str, nil, nil)
		hook.Run("RPGRoll", client, str)
	end
})

function bodypartrand()
	local partroll = math.random(1,100)
	local targetpart
	
	if partroll <= 10 then
		targetpart = "head"

	elseif partroll <= 20 then
		targetpart = "rightarm"
		
	elseif partroll <=30 then
		targetpart = "leftarm"
		
	elseif partroll <= 70 then
		targetpart = "torso"
	
	elseif partroll <= 85 then
		targetpart = "rightleg"
		
	else
		targetpart = "leftleg"
		
	end
	return targetpart
end

function attackdamage(client,str,damage,hits,pen,bodypart,dambonus,target,attType,armorpiercing)
	
	if not dambonus then
		dambonus = 0
	end
	
	if not attType then
		attType = "ranged"
	end
	
	if not str then
		local ap = hits
		local apleftover = ap - pen
		
		if apleftover > 0 then
			damage = damage - apleftover
		end
		
		if damage < 0 then
			damage = 0
		end
		
		return damage
	end
	
	local bodyprot = 0
	local limbprot = 0
	local headprot = 0
	local damagecap = 1000
	
	if target then
		if target:IsPlayer() then
			local targetinv = target:GetChar():GetInv()
			local endur = math.Truncate(target:GetChar():GetAttribute("endurance")/10)
			damagecap = (8 + endur)/2
			
			if attType == "ranged" then
				headprot = target:GetChar():GetAttribute("armorpointshead", head) or endur
				bodyprot = target:GetChar():GetAttribute("armorpointsbody", body) or endur
				limbprot = target:GetChar():GetAttribute("armorpointslimb", limb) or endur
			end
			
			if targetinv then
				if attType == "melee" then
					for k,v in pairs(targetinv:GetItems()) do
						if v.res and v:GetData("equip") == true then
							local res = v.res
							
							if v.isHelmet or v.isGasmask then
								headprot = (res["Fall"] * 100)
							end
							
							limbprot = (res["Fall"] * 100)
							bodyprot = (res["Fall"] * 100)
							
							local mods = v:GetData("mod")
							
							if mods then
								for x,y in pairs(mods) do
									if y.res then
										limbprot = limbprot + (y.res["Fall"] * 100)
										bodyprot = bodyprot + (y.res["Fall"] * 100)
									end
								end
							end
						end
						
						if bodyprot == 0 then
							bodyprot = endur
						elseif limbprot == 0 then
							limbprot = endur
						elseif headprot == 0 then
							headprot = endur
						end
					end
				end
			else
				client:Notify("Error: TargetNoInv")
				return
			end
		end
	end
	
	if armorpiercing then
		headprot = (headprot / 2)
		limbprot = (limbprot / 2)
		bodyprot = (bodyprot / 2)
	end
	
	if not bodypart then
		local i = 0
		while i < hits do
			bodypart = bodypartrand()
			if bodypart == "head" then
				targetpart = "head"
				if i == 0 then
					str = str.." hitting them in the head for "
				else
					str = str.." the head for "
				end
			elseif bodypart == "rightarm" then
				targetpart = "limb"
				if i == 0 then
					str = str.." hitting them in the right arm for "
				else
					str = str.." the right arm for "
				end
			elseif bodypart == "leftarm" then
				targetpart = "limb"
				if i == 0 then
					str = str.." hitting them in the left arm for "
				else
					str = str.." the left arm for "
				end
			elseif bodypart == "torso" then
				targetpart = "torso"
				if i == 0 then
					str = str.." hitting them in the torso for "
				else
					str = str.." the torso for "
				end
			elseif bodypart == "rightleg" then
				targetpart = "limb"
				if i == 0 then
					str = str.." hitting them in the right leg for "
				else
					str = str.." the right leg for "
				end
			elseif bodypart == "leftleg" then
				targetpart = "limb"
				if i == 0 then
					str = str.." hitting them in the left leg for "
				else
					str = str.." the left leg for "
				end
			else
				client:Notify("ERROR: Incorrect bodypart selected. May leave blank.")
				return "return"
			end
				
			local numdice = tonumber(string.sub(damage,1,1))
			local rolltop = tonumber(string.sub(damage,3,4))
			local bonus
			local apleftover
			local damagerolled = 0
			local crippled
			
			if damage ~= "1d10" then
				bonus = tonumber(string.sub(damage,6,6)) + dambonus
			else
				bonus = dambonus
			end
				
			local k = 0
			while k < numdice do
				if bonus then
					damagerolled = damagerolled + (math.random(1,rolltop) + bonus)
				else
					damagerolled = damagerolled + math.random(1,rolltop)
				end
				k = k + 1
			end
				
			local damagedealt
			if target and target:IsPlayer() then
				if targetpart then
					if targetpart == "torso" then
						apleftover = bodyprot - pen

					elseif targetpart == "limb" then
						apleftover = limbprot - pen

					else
						apleftover = headprot - pen
							
					end
					if apleftover > 0 then
						damagedealt = damagerolled - apleftover
					else
						damagedealt = damagerolled
					end
				else
					client:Notify("Error: TargetPart")
					return
				end
			else
				damagedealt = damagerolled
			end
			
			if targetpart == "limb" then	
				damagedealt = math.Clamp(damagedealt, 0, damagecap)
				if damagedealt == damagecap then
					crippled = true
				end
			end
				
			damagedealt = math.Truncate(math.Clamp(damagedealt,0,1000))
			str = str..damagedealt
				
			if i < hits - 1 then
				str = str..", "
			end
				
			if i == hits - 2 then
				str = str.." and" 
			end
				
			i = i + 1
		end
			
		str = str.." damage"
		
		if crippled then
			str = str.." crippling their limb(s)."
		else
			str = str.."."
		end
		crippled = false
	else
		bodypart = string.lower(bodypart)
		
		if bodypart == "leftarm" or bodypart == "left arm" then
			str = str.." hitting them in the left arm for "
			targetpart = "limb"
				
		elseif bodypart == "rightarm" or bodypart == "right arm" then
			str = str.." hitting them in the right arm for "
			targetpart = "limb"
				
		elseif bodypart == "leftleg" or bodypart == "left leg" then
			str = str.." hitting them in the left leg for "
			targetpart = "limb"
					
		elseif bodypart == "rightleg" or bodypart == "right leg" then
			str = str.." hitting them in the right leg for "
			targetpart = "limb"
				
		elseif bodypart == "head" then
			str = str.." hitting them in the head for "
			targetpart = "head"
				
		elseif bodypart == "torso" or bodypart == "chest" or bodypart == "center" or bodypart == "body" then
			str = str.." hitting them in the torso for "
			targetpart = "torso"
		else
			client:Notify("ERROR: Incorrect bodypart selected. May leave blank.")
			return "return"
		end
			
		local i = 0
		while i < hits do
			local numdice = tonumber(string.sub(damage,1,1))
			local rolltop = tonumber(string.sub(damage,3,4))
			local bonus 
			local damagerolled = 0
			local apleftover
			local crippled
			
			if damage ~= "1d10" then
				bonus = tonumber(string.sub(damage,6,6)) + dambonus
			else
				bonus = dambonus
			end
			
			local k = 0
			while k < numdice do
				if bonus then
					damagerolled = damagerolled + (math.random(1,rolltop) + bonus)
				else
					damagerolled = damagerolled + math.random(1,rolltop)
				end
				k = k + 1
			end
				
			local damagedealt
			if target and target:IsPlayer() then
				if targetpart then
					if targetpart == "torso" then
						apleftover = bodyprot - pen

					elseif targetpart == "limb" then
						apleftover = limbprot - pen
						
					else
						apleftover = headprot - pen
						
					end
						
					if apleftover > 0 then
						damagedealt = (damagerolled - apleftover)
					else
						damagedealt = damagerolled
					end
				else
					client:Notify("Error: TargetPart")
					return
				end
			else
				damagedealt = damagerolled
			end
				
			if targetpart == "limb" then
				damagedealt = math.Clamp(damagedealt, 0, damagecap)
				if damagedealt == damagecap then
					crippled = true
				end
			end
				
			damagedealt = math.Truncate(math.Clamp(damagedealt,0,1000))
				
			str = str..damagedealt
				
			if i < hits - 1 then
				str = str..", "
			end
			
			if i == hits - 2 then
				str = str.."and "
			end
			
			i = i + 1
		end
		str = str.." damage"
			
		if crippled then
			str = str.." crippling their limb."
		else
			str = str.."."
		end
		crippled = false
	end
	return str
end

ix.command.Add("shoot", {
	description = "Attack with a ranged weapon.",
	arguments = {
		ix.type.string, -- number of rounds
		bit.bor(ix.type.string, ix.type.optional), -- aim status: none/half/full
		bit.bor(ix.type.string, ix.type.optional),	-- additional modifiers
		bit.bor(ix.type.string, ix.type.optional),	-- bodypart aimed for (if NIL then not specific)
		bit.bor(ix.type.bool, ix.type.optional)
	},
	OnRun = function(self, client, rounds, aimstatus, modifier, bodypart, debugbool)
		local character = client:GetCharacter()
		local str = "fired "
		local range
		local damage
		local pen
		local roundsfired
		local target
		local playerpos = client:GetPos()
		local total = 0
		local targetpart
		local bodypartmod = 0
		local aimmod = 0
		local rangemod = 0
		local rofmod = 0
		local rangeadj = 0
		local baladj = 0
		local jamroll = math.random(0,100)
		local balskill = character:GetAttribute("ballisticskill")
		local weapon = client:GetActiveWeapon()
		local wepclass = weapon:GetClass()
		local wepitem
		local inv = character:GetInv()
		local ammotype
		local fullauto = false
		local semiauto = false
		local single = false
		local storm = false
		local ap = false
		local systemroll = math.random(1,100)
		local foregrip = false
		
		if not aimstatus then
			aimstatus = "none"
		end
		
		if not modifier then
			modifier = 0
		end
		
		if bodypart == "none" or bodypart == "nil" then
			bodypart = nil
		end
		
		if bodypart then
			bodypartmod = -20
		end
		
		if inv then
			local items = inv:GetItems()
			for k,v in pairs(items) do
				if v.class == wepclass and v:GetData("equip") then
					
					local dura = math.Round(v:GetData("durability") /100)
					if dura < jamroll then
						str = str.."but their weapon jammed!"
						ix.chat.Send(client, "rollstat", str, nil, nil)
						hook.Run("RPGRoll", client, str)
						return
					end
					
					if string.match(v.RoF, rounds) then
						roundsfired = rounds
					elseif rounds == "1" then
						roundsfired = "1"
					else
						client:Notify("Incorrect number of rounds specified.(IE: 3)")
						return
					end
					
					if roundsfired == "S" or roundsfired == "1" then
						rofmod = 10
						single = true
					elseif string.sub(v.RoF,3,3) == roundsfired then
						rofmod = 0
						semiauto = true
					elseif string.match(v.RoF,roundsfired) then
						rofmod = -10
						fullauto = true
						if string.match(v.Special,"Assault") then
							rofmod = 0
						end
					else
						client:Notify("ERROR: Could Not Determine Fire Rate")
						return
					end
					
					if string.match(v.Special,"Storm") then
						storm = true
					end
					
					if weapon:Clip1() < tonumber(rounds) then
						client:Notify("Not enough rounds.")
						return
					end
					
					damage = v.Dmg
					pen = tonumber(v.Pen)
					range = tonumber(v.Range)
					
					if string.match(v.Special,"Foregrip") or string.match(v.Special,"foregrip") then
						foregrip = true
					end
					
					wepitem = v
					ammotype = weapon.Primary.Ammo
				end
			end
		end
		
		if not damage then
			client:Notify("ERROR: Equip a gun.")
			return
		end
		
		str = str..roundsfired.." rounds "
		
		if wepitem:GetData("attachments") then
			for atcat,data in pairs(wepitem:GetData("attachments")) do
				local attItem = ix.item.list[data[1]]
				local spec = ""
				
				if attItem.Range then
					rangeadj = rangeadj + attItem.Range
				end
					
				if attItem.Bal then
					baladj = baladj + attItem.Bal
				end
					
				if attItem.Special then
					spec = attItem.Special
				end
				
				if spec == "5 BAL FULL AUTO" then
					foregrip = true
				end

				if spec == "20 BAL FULL AIM" and aimstatus == "full" then
					baladj = baladj + 20
				elseif spec == "10 BAL HALF/FULL AIM" then
					if aimstatus == "half" or aimstatus == "full" then
						baladj = baladj + 10
					end
				end
			end
		end
		
		if wepitem:GetData("upgrades") then
			for _,upg in pairs(wepitem:GetData("upgrades")) do
				for cal,dmglist in pairs(calibers) do
					if string.match(upg[2],cal) then
						if wepitem.barrel == "short" then
							damage = dmglist.short
						elseif wepitem.barrel == "medium" then
							damage = dmglist.medium
						elseif wepitem.barrel == "long" then
							damage = dmglist.long
						end
					end
				end
			end
		end
		
		if foregrip and fullauto then
			baladj = baladj + 5
		end
		
		local headprot = 0
		local bodyprot = 0
		local limbprot = 0
		local damend = string.sub(damage,6,6) or 0
		local dambonus = string.sub(damage,6,6) or 0
		
		if string.match(ammotype, "AP") then
			dambonus = math.Clamp((dambonus - 3),0,1000)
			ap = true
			
		elseif string.match(ammotype,"BD") then
			range = (range - 10)
			pen = (pen - 2)
			
		elseif string.match(ammotype,"SG") then
			range = (range + 20)
			dambonus = dambonus + 1
			pen = pen + 5
			
		elseif string.match(ammotype,"TR") then
			dambonus = dambonus + 3
			
		elseif string.match(ammotype,"ZL") then
			dambonus = dambonus - 1
			range = math.Truncate(range * 0.5)
			pen = math.Clamp(pen - 2,0,1000)
			
		end
		
		local eyetrace2 = util.TraceLine( {
			start = client:EyePos(),
			endpos = client:EyePos() + client:EyeAngles():Forward() * 30000,
			filter = function(ent)
				if ent ~= client then
					if ent:IsPlayer() or ent:GetClass() == "prop_ragdoll" or ent:GetClass() == "prop_animatable" then
						if not target then
							target = ent
						end
						return true
					end
				end
			end
		})
		
		if not target or not target:IsPlayer() then
			str = str.."at someone"
		else
			str = str.."at "..target:GetCharacter():GetName()
		end
		
		if target then
			local hitpos = target:GetPos()
			local rangeunits = ((range + rangeadj)*39.37)
			local distance = playerpos:Distance(hitpos)
			if distance < 118 then
				rangemod = 30
				if string.match(ammotype,"BD") then
					rangemod = 50
				elseif ammotype == "12 Gauge" then
					dambonus = dambonus + 3
					rangemod = 40
				end
							
			elseif distance < (rangeunits*0.5) then
				rangemod = 10
				if string.match(ammotype,"BD") then
					rangemod = 30
					dambonus = dambonus - 3
				elseif ammotype == "12 Gauge" then
					rangemod = 20
				end
							
			elseif distance > (rangeunits*2) then
				rangemod = -10
				if string.match(ammotype,"BD") then
					dambonus = dambonus - 5
				elseif ammotype == "12 Gauge" then
					dambonus = dambonus - 3
				end
				
			elseif distance > (rangeunits*3) then
				rangemod = -30
				if string.match(ammotype,"BD") then
					dambonus = dambonus - 5
				elseif ammotype == "12 Gauge" then
					dambonus = dambonus - 3
				end
			end
		end
		
		if aimstatus == "full" then
			aimmod = 20

		elseif aimstatus == "half" then
			aimmod = 10
			
		elseif aimstatus == "none" then
			aimmod = 0
		end
		
		total = balskill + tonumber(modifier) + bodypartmod + aimmod + rangemod + rofmod + baladj
		
		if total < systemroll then
			str = str.." but missed their target."
			if debugbool then
				str = str.."\n".."System: "..systemroll.." User: "..total
			end
			ix.chat.Send(client, "rollstat", str, nil, nil)
			hook.Run("RPGRoll", client, str)
			return
		end
		
		local extrahits
		
		if semiauto then
			extrahits = ((total - systemroll)/20)
		elseif fullauto then
			extrahits = ((total - systemroll)/10)
		end
		
		local shots = tonumber(roundsfired)
		local hits = 1
		
		if shots > 1 then
			hits = math.Truncate(math.Clamp(extrahits,0,(shots - 1))) + 1
		end
		
		if storm and semiauto then
			hits = math.Clamp(hits*2,0,shots)
		end
		
		if damend then
			damage = string.Replace(damage,"+"..damend,"+"..dambonus)
		end
		
		str = attackdamage(client,str,damage,hits,pen,bodypart,0,target,"ranged",ap)
		
		if not target or not target:IsPlayer() then
			str = str.."\n(Modifier: "..modifier..", Aim: "..aimstatus..", Pen: "..pen.." NO TARGET, DO AP)"
		else
			str = str.."\n(Modifier: "..modifier..", ".."Aim: "..aimstatus..")"
		end
		
		if debugbool then
			str = str.."\n".."System: "..systemroll.." User: "..total
		end
		
		ix.chat.Send(client, "rollstat", str, nil, nil)
		hook.Run("RPGRoll", client, str)
	end
})


ix.command.Add("roll", {
	description = "Rolls the given dies with a modifier.",
	arguments = {
		ix.type.number,
		ix.type.number,
		ix.type.string,
		ix.type.text
	},
	OnRun = function(self, client, dies, sides, modifier, description)
		local character = client:GetCharacter()
		local modsign
		local perkmodifier
		local parentstat
		local parentstattranslated
		local str = "rolled "
		local realattriname
		local perksign = nil
		local roll = 0

		str = str..dies.."d"..sides

		for i = 1, dies do
			roll = roll + math.random(1, sides)
		end

		roll = roll + modifier

		if string.len(modifier) != 0 then
			if string.sub(modifier, 1, 1) == "+" then
				modifier = string.sub(modifier, 2)
				modsign = "+"
			elseif string.sub(modifier, 1, 1) == "-" then
				modifier = string.sub(modifier, 2)
				modsign = "-"
			elseif modifier == "0" then
				modsign = ""
			else
				return client:Notify("Please include a + or - in front of your modifier.")
			end

			str = str..modsign..modifier
		else
			modsign = ""
			modifier = ""
		end

		str = str.." totalling "..roll.."."

		if (character) then
			local statvalue = character:GetAttribute(internalattriname, 0)
			local roll = tostring(math.random(1, sides))
			local successrate = math.floor(math.abs(((modifier+statvalue+(perkmodifier or 0))-roll))/10)

			if string.len(description) != 0 then
				str = str.." \""..description.."\""
			end
		end
		hook.Run("RPGRoll", client, str)
		ix.chat.Send(client, "rollstat", str, nil, nil)
	end
})


-- Roll information in chat.
ix.chat.Register("rollstat", {
	format = "** %s has %s",
	color = Color(155, 111, 176),
	CanHear = (ix.config.Get("chatRange", 280) * 5),
	deadCanChat = true,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		
		chat.AddText(self.color, string.format(self.format,
			speaker:GetName(), text
		))
	end
})


local charMeta = ix.meta.character

if (SERVER) then
	function charMeta:setRPGValues()
		local inventory = self:GetInventory()
		local head = 0
		local body = 0
		local limb = 0
		local endboost = 0
		local agiboost = 0
		local strboost = 0
		local perboost = 0
		
		if self:GetData("boosted",false) == false then
			self:SetData("endorig", self:GetAttribute("endurance"))
			self:SetData("agiorig", self:GetAttribute("agility"))
			self:SetData("strorig", self:GetAttribute("strength"))
			self:SetData("perorig", self:GetAttribute("perception"))
		end
		
		if inventory then
			local items = self:GetInventory():GetItems()

			for _,item in pairs(items) do
				if item:GetData("equip") == true then
					
					if item:GetData("head") then
						for _,tab in pairs(item:GetData("head")) do
							head = head + tab.amount
						end
					end
					
					if item:GetData("body") then
						for _,tab in pairs(item:GetData("body")) do
							body = body + tab.amount
						end
					end
					
					if item:GetData("limb") then
						for _,tab in pairs(item:GetData("limb")) do
							limb = limb + tab.amount
						end
					end
					
					if item:GetData("end") then
						for _,tab in pairs(item:GetData("end")) do
							endboost = endboost + tab.amount
						end
					end
					
					if item:GetData("agi") then
						for _,tab in pairs(item:GetData("agi")) do
							agiboost = agiboost + tab.amount
						end
					end
					
					if item:GetData("str") then
						for _,tab in pairs(item:GetData("str")) do
							strboost = strboost + tab.amount
						end
					end
					
					if item:GetData("per") then
						for _,tab in pairs(item:GetData("per")) do
							perboost = perboost + tab.amount
						end
					end
					
					if item.ballisticrpglevels then
						if item.ballisticrpglevels["head"] then
							head = head + tonumber(item.ballisticrpglevels["head"])
						end
						
						if item.ballisticrpglevels["body"] then
							body = body + tonumber(item.ballisticrpglevels["body"])
						end
						
						if item.ballisticrpglevels["limb"] then
							limb = limb + tonumber(item.ballisticrpglevels["limb"])
						end
					end
				end
			end
			
			if endboost > 0 or agiboost > 0 or strboost > 0 or perboost > 0 then
				self:SetData("boosted",true)
			else
				self:SetData("boosted",false)
			end
			
			if endboost then
				self:SetAttrib("endurance",(self:GetData("endorig") + endboost))
			else
				self:SetAttrib("endurance",self:GetData("endorig"))
			end
			
			if agiboost then
				self:SetAttrib("agility",(self:GetData("agiorig") + agiboost))
			else
				self:SetAttrib("agility",self:GetData("agiorig"))
			end
			
			if strboost then
				self:SetAttrib("strength",(self:GetData("strorig") + strboost))
			else
				self:SetAttrib("strength",self:GetData("strorig"))
			end
			
			if perboost then
				self:SetAttrib("strength",(self:GetData("perorig") + perboost))
			else
				self:SetAttrib("strength",self:GetData("perorig"))
			end
			
			local endur = math.Truncate(self:GetAttribute("endurance")/10)
			
			head = head + endur
			body = body + endur
			limb = limb + endur
			self:SetAttrib("armorpointshead", head)
			self:SetAttrib("armorpointsbody", body)
			self:SetAttrib("armorpointslimb", limb)
		end
	end
end