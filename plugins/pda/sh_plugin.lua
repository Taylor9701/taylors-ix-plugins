PLUGIN.name = "PDA chatting system"
PLUGIN.author = "Verne & Taylor"
PLUGIN.description = "PDA chatting system, supporting avatars and nicknames"

ix.chat.Register("gpda", {
	CanSay = function(self, speaker, text)
		local pda = speaker:GetCharacter():GetData("pdaequipped", false)
		if pda then
			return true
		else 
			return false
		end
		return true
	end,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		chat.AddText(Color(0,191,255), Material(data[2]), "[GPDA-"..data[1].."]", color_white, ": "..text)
	end,
	--prefix = {"/gpda"},
	CanHear = function(self, speaker, listener)
		local pda = listener:GetCharacter():GetData("pdaequipped", false)
		if pda then
			listener:EmitSound( "stalker/pda/pda_beep_1.ogg", 50, 100, 1, CHAN_AUTO )
			return true
		else
			return false
		end
	end,
})

ix.chat.Register("pda", {
	CanSay = function(self, speaker, text)
		local pda = speaker:GetCharacter():GetData("pdaequipped", false)
		if pda then
			return true
		else 
			return false
		end
		return true
	end,
	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		chat.AddText(Color(255, 180, 51), Material(data[2]), "[PDA-"..data[1].."] ", color_white, ": "..text)
	end,
	--prefix = {"/gpda"},
	CanHear = function(speaker, listener)
		local pda = listener:GetCharacter():GetData("pdaequipped", false)
		if pda then
			listener:EmitSound( "stalker/pda/pda_beep_1.ogg", 50, 100, 1, CHAN_AUTO )
			return true
		else
			return false
		end
	end,
})

ix.command.Add("gpda", {
	description = "Sends a message on the global PDA network.",
	arguments = ix.type.text,
	OnRun = function(self, client, text)
		maximum = math.Clamp(maximum or 100, 0, 1000000)

		ix.chat.Send(client, "gpda", text, nil, nil, {
			client:GetCharacter():GetData("pdanickname") or client:GetCharacter():GetName(), client:GetCharacter():GetData("pdaavatar") or "vgui/icons/face_31.png"
		})
	end
})

ix.command.Add("pda", {
	description = "Sends a message to a specific user on the network.",
	arguments = {
		ix.type.string,
		ix.type.text
	},
	OnRun = function(self, client, target, text)
		local targetplayer = ix.util.FindPlayer(target)
		
		if not targetplayer then
			for k,v in pairs(player.GetAll()) do
				if ix.util.StringMatches(v:GetCharacter():GetData("pdanickname",""),target) then
					targetplayer = v
				end
			end
		elseif not targetplayer:IsPlayer() then
			for k,v in pairs(player.GetAll()) do
				if ix.util.StringMatches(v:GetCharacter():GetData("pdanickname",""),target) then
					targetplayer = v
				end
			end
		end
		
		ix.chat.Send(client, "pda", text, nil, {client, targetplayer}, {
			client:GetCharacter():GetData("pdanickname") or client:GetCharacter():GetName(), client:GetCharacter():GetData("pdaavatar") or "vgui/icons/face_31.png"
		})
	end
})