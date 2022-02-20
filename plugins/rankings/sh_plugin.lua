local PLUGIN = PLUGIN
PLUGIN.name = "Rankings"
PLUGIN.author = "Taylor"
PLUGIN.desc = "Ranking list plugin."

local PANEL = {}
local headcolor = Color(104, 104, 104)
local repcolor = Color(107,104,175)
local stndcolor = Color(255,255,255)

-- If you're not using the upgrades plugin, uncomment this line:
-- ix.util.Include("cl_plugin.lua")

if CLIENT then
	
	local thinktime = 1
	local marg5v = (.0046296296296296*ScrH())
	local marg5h = (.0026041666666667*ScrW())
	
	local PANELEDIT = {}

	function PANELEDIT:GetContentSize()
		surface.SetFont( self:GetFont() )
		local w, h = surface.GetTextSize( self:GetText() )
		local heightorig = h
		
		while self:GetWide() < w do
			h = h + (heightorig)
			w = w - (self:GetWide())
		end
		h = h + (heightorig) + 5
		
		return w, h
	end

	vgui.Register( "DTextEntry_Edit", PANELEDIT, "DTextEntry" )

	function PANEL:Init()
	
		local client = LocalPlayer()
		local character = client:GetCharacter()
		local image = character:GetData("pdaavatar","vgui/icons/face_31.png")
		local description = character:GetDescription()
		local rank = client:getCurrentRankName()
		local reputation = client:getReputation()
		local advanced = character:GetData("RankAdvanced",false)
		local basic = character:GetData("RankBasic",false)
		
		-- calculating new image resolutions to keep things lookin gud
		local listimage = Material(image)
		local w = listimage:Width()
		local h = listimage:Height()
		local scale = w/((.09375)*ScrW())
		local newheight = h/scale
		local difference = ((.13240740740741)*ScrH()) - newheight
		
		if difference < 10 then
			difference = 10
		end
		
		local margin = (difference/2)
		
		local chardata = {
			[1] = {"Name: ", character:GetName() or "Unknown"},
			[2] = {"Age: ", character:GetData("sheetAge","Unknown")},
			[3] = {"Nationality: ", character:GetData("sheetNationality","Unknown")},
			[4] = {"Race: ", character:GetData("sheetRace","Unknown")},
			[5] = {"PDA Handle: ", character:GetData("pdanickname","No PDA Name")},
		}
		
		self:SetSize(((2/3)*ScrW()), ((.66759259259259)*ScrH()))
		self:Center()
		self:SetDrawBackground(false)
		self:SetPaintBackground(false)
		
		local pdabg = self:Add("DImage")
		pdabg:Center()
		pdabg:Dock(FILL)
		pdabg:SetPaintBackground(false)
		pdabg:SetImage("stalker/ui/pda/background.png")
		pdabg:SetMouseInputEnabled(true)
		
		-- PLAYER PROFILE PANEL
		local profbox = pdabg:Add("DImage")
		profbox:SetSize(((0.625)*ScrW()),((.14166666666667)*ScrH()))
		profbox:Dock(TOP)
		profbox:DockMargin((.018229166666667*ScrW()),(.032407407407407*ScrH()),(.018229166666667*ScrW()),0)
		profbox:SetImage("stalker/ui/rankings/profile.png")
		profbox:SetMouseInputEnabled(true)
		
		local plyimg = profbox:Add("DImage")
		plyimg:SetImage(image)
		plyimg:CenterVertical()
		plyimg:Dock(LEFT)
		
		if w < ((.09375)*ScrW()) and h < ((.12314814814815)*ScrH()) then
			local marg = ((.13240740740741*ScrH())-h)/2
			
			plyimg:SetSize(w,h)
			plyimg:DockMargin(marg5h,marg,0,marg)
		else
			plyimg:SetSize(((.09375)*ScrW()), newheight)
			plyimg:DockMargin(marg5h,margin,0,margin)
		end
		
		local plyinfo = profbox:Add("DScrollPanel")
		plyinfo:SetPos((plyimg:GetWide() + 20),20)
		plyinfo:SetSize(((0.135416666667)*ScrW()),profbox:GetTall())
		plyinfo:CenterVertical()
		plyinfo:Dock(LEFT)
		plyinfo:DockMargin(marg5h,0,0,0)
		
		local plyinfoleft = plyinfo:Add("DPanel")
		plyinfoleft:SetSize(80,plyinfo:GetTall())
		plyinfoleft:Dock(LEFT)
		plyinfoleft:SetDrawBackground(false)
		
		local plyinforight = plyinfo:Add("DPanel")
		plyinforight:SetSize(((.09375)*ScrW()),plyinfo:GetTall())
		plyinforight:Dock(RIGHT)
		plyinforight:SetDrawBackground(false)
		
		for _,data in ipairs(chardata) do
			local infolabelleft = plyinfoleft:Add("DLabel")
			infolabelleft:SetSize(80,20)
			infolabelleft:SetTextColor(headcolor)
			infolabelleft:SetText(data[1])
			infolabelleft:SetFont("stalkerregularfont")
			infolabelleft:Dock(TOP)
			infolabelleft:DockMargin(0,marg5v,0,marg5v)
			
			local infolabelright = plyinforight:Add("DLabel")
			infolabelright:SetSize(((.09375)*ScrW()),20)
			infolabelright:SetTextColor(stndcolor)
			infolabelright:SetText(data[2])
			infolabelright:SetFont("stalkerregularfont")
			infolabelright:Dock(TOP)
			infolabelright:DockMargin(0,marg5v,0,marg5v)
		end
		
		local descbox = profbox:Add("DScrollPanel")
		descbox:SetSize(((.23958333333333)*ScrW()),((.092592592592593)*ScrH()))
		descbox:SetDrawBackground(false)
		descbox:SetMouseInputEnabled(true)
		descbox:Dock(LEFT)
		descbox:DockMargin(marg5h,0,0,0)
		
		local desclabel = descbox:Add("DLabel")
		desclabel:SetTextColor(headcolor)
		desclabel:SetFont("stalkerregularfont")
		desclabel:SetText("Description:")
		desclabel:SetAutoStretchVertical(true)
		desclabel:Dock(TOP)
		desclabel:SetWidth(((.23958333333333)*ScrW()))
		
		local plydesc = descbox:Add("DTextEntry_Edit")
		plydesc:SetWidth(((.23958333333333)*ScrW()))
		plydesc:SetValue(description)
		plydesc:SetFont("stalkerregularfont")
		plydesc:SetDrawBackground(false)
		plydesc:SetMultiline(true)
		plydesc:SetTextColor(Color(255,255,255))
		plydesc:Dock(FILL)
		plydesc:SetEditable(false)
		plydesc:SizeToContentsY()
		
		local rankbox = profbox:Add("DPanel")
		rankbox:SetDrawBackground(false)
		rankbox:SetSize(((.052083333333333)*ScrW()),20)
		rankbox:Dock(LEFT)
		
		local ranklabel = rankbox:Add("DLabel")
		ranklabel:SetAutoStretchVertical(true)
		ranklabel:SetSize(((.052083333333333)*ScrW()),20)
		ranklabel:Dock(TOP)
		ranklabel:DockMargin(marg5h,marg5v,marg5h,0)
		ranklabel:SetTextColor(headcolor)
		ranklabel:SetText("Rank:")
		ranklabel:SetFont("stalkerregularfont")
		
		local rankname = rankbox:Add("DLabel")
		rankname:SetAutoStretchVertical(true)
		rankname:SetSize(((.052083333333333)*ScrW()),20)
		rankname:Dock(TOP)
		rankname:DockMargin(marg5h,marg5v,marg5h,marg5v)
		rankname:SetText(rank)
		rankname:SetFont("stalkerregularfont")
		
		local replabel = rankbox:Add("DLabel")
		replabel:SetAutoStretchVertical(true)
		replabel:SetSize(((.052083333333333)*ScrW()),20)
		replabel:Dock(TOP)
		replabel:DockMargin(marg5h,marg5v,marg5h,0)
		replabel:SetTextColor(headcolor)
		replabel:SetText("Reputation:")
		replabel:SetFont("stalkerregularfont")
		
		local repvalue = rankbox:Add("DLabel")
		repvalue:SetAutoStretchVertical(true)
		repvalue:SetSize(((.052083333333333)*ScrW()),20)
		repvalue:Dock(TOP)
		repvalue:DockMargin(marg5h,marg5v,marg5h,marg5v)
		repvalue:SetText(reputation)
		repvalue:SetTextColor(repcolor)
		repvalue:SetFont("stalkerregularfont")
		
		local buttontitle1 = profbox:Add("DLabel")
		buttontitle1:Dock(TOP)
		buttontitle1:DockMargin((.020833333333333*ScrW()),marg5v,0,0)
		buttontitle1:SetText("Profile Publicity")
		buttontitle1:SetFont("stalkerregularfont")
		
		local buttonadvanced = profbox:Add("DImageButton")
		if advanced then
			buttonadvanced:SetImage("stalker/ui/pda/pda_button_click.png")
		else
			buttonadvanced:SetImage("stalker/ui/pda/pda_button.png")
		end
		buttonadvanced:Dock(TOP)
		buttonadvanced:DockMargin(marg5h,(.013888888888889*ScrH()),0,0)
		buttonadvanced:SetSize(((.090104166666667)*ScrW()),20)
		buttonadvanced:SetText("Advanced")
		buttonadvanced:SetFont("stalkerregularfont")
		buttonadvanced:SetMouseInputEnabled(true)
		buttonadvanced.DoClick = function()
			if string.match(buttonadvanced:GetImage(), "pda_button.png") then
				buttonadvanced:SetImage("stalker/ui/pda/pda_button_click.png")
			else
				buttonadvanced:SetImage("stalker/ui/pda/pda_button.png")
			end
			netstream.Start("ProfileChange", "advanced")
		end 
		
		local buttonbasic = profbox:Add("DImageButton")
		if basic then
			buttonbasic:SetImage("stalker/ui/pda/pda_button_click.png")
		else
			buttonbasic:SetImage("stalker/ui/pda/pda_button.png")
		end
		buttonbasic:Dock(TOP)
		buttonbasic:DockMargin(marg5h,(.013888888888889*ScrH()),0,0)
		buttonbasic:SetText("Basic")
		buttonbasic:SetFont("stalkerregularfont")
		buttonbasic:SetMouseInputEnabled(true)
		buttonbasic.DoClick = function()
			if string.match(buttonbasic:GetImage(), "pda_button.png") then
				buttonbasic:SetImage("stalker/ui/pda/pda_button_click.png")
			else
				buttonbasic:SetImage("stalker/ui/pda/pda_button.png")
			end
			netstream.Start("ProfileChange", "basic")
		end
		
		-- PLAYERS LIST PANEL
		
		local ranklistbox = pdabg:Add("DImage")
		ranklistbox:SetSize(((.29739583333333)*ScrW()),((.45185185185185)*ScrH()))
		ranklistbox:Dock(RIGHT)
		ranklistbox:DockMargin((.018229166666667*ScrW()),marg5v,(.018229166666667*ScrW()),(.037037037037037*ScrH()))
		ranklistbox:SetImage("stalker/ui/rankings/rank_list.png")
		ranklistbox:SetName("RankListBox")
		ranklistbox:SetMouseInputEnabled(true)
		
		-- PLAYER INFO PANEL
		local rankinfo = pdabg:Add("DImage")
		rankinfo:Center()
		rankinfo:SetSize(((.33177083333333)*ScrW()),((.45185185185185)*ScrH()))
		rankinfo:Dock(LEFT)
		rankinfo:DockMargin((.018229166666667*ScrW()),marg5v,marg5h,(.020833333333333*ScrW()))
		rankinfo:SetImage("stalker/ui/rankings/rank_display.png")
		rankinfo:SetMouseInputEnabled(true)
		
		netstream.Hook("SetupInfoPanel", function(plydata)
			local desc
			local name
			local age
			local nationality
			local race
			local image
			local pdaname
			local rank
			local reputation
			local backstory
			
			for k,v in pairs(plydata) do
				if k == "description" then
					desc = v
					
				elseif k == "name" then
					name = v
				
				elseif k == "age" then
					age = v
					
				elseif k == "nationality" then
					nationality = v
					
				elseif k == "race" then
					race = v
					
				elseif k == "pdaimage" then
					image = v
					
				elseif k == "pdaname" then
					pdaname = v
					
				elseif k == "rank" then
					rank = v 
					
				elseif k == "reputation" then
					reputation = v
					
				elseif k == "backstory" then
					backstory = v
				end
			end
			
			if rankinfo:HasChildren() then
				for k,v in pairs(rankinfo:GetChildren()) do
					v:Remove()
				end
			end
			
			local listimage = Material(image)
			local w = listimage:Width()
			local h = listimage:Height()
			local scale = w/((.09375)*ScrW())
			local newheight = h/scale
			local difference = (.13240740740741*ScrH()) - newheight
			
			if difference < 10 then
				difference = 10
			end
			
			local imgmargin = difference/2
			
			local infoimage = rankinfo:Add("DImage")
			infoimage:SetImage(image)
			infoimage:SetName("InfoImage")
			infoimage:SetPos(5,5)
			
			if w < ((.09375)*ScrW()) and h < ((.12314814814815)*ScrH()) then
				infoimage:SetSize(w,h)
			else
				infoimage:SetSize(((.09375)*ScrW()),newheight)
			end
			
			local x,y = infoimage:GetPos()
			local infow = ((.11458333333333)*ScrW())
			local toprow = y
			
			local leftbox = rankinfo:Add("DPanel")
			leftbox:SetDrawBackground(false)
			leftbox:SetSize(infow,(.13240740740741*ScrH()))
			leftbox:SetPos(x + (.096354166666667*ScrW()), y) 
			
			local leftlabelbox = leftbox:Add("DPanel")
			leftlabelbox:SetSize(77,(.13240740740741*ScrH()))
			leftlabelbox:Dock(LEFT)
			leftlabelbox:SetDrawBackground(false)
			
			local leftlabelpda = leftlabelbox:Add("DLabel")
			leftlabelpda:Dock(TOP)
			leftlabelpda:SetWidth(77)
			leftlabelpda:SetTextColor(headcolor)
			leftlabelpda:SetFont("stalkerregularfont")
			leftlabelpda:SetAutoStretchVertical(true)
			leftlabelpda:SetText("PDA Handle:")
			leftlabelpda:DockMargin(0,marg5v,0,marg5v)
			
			local leftlabelrank = leftlabelbox:Add("DLabel")
			leftlabelrank:Dock(TOP)
			leftlabelrank:SetWidth(77)
			leftlabelrank:SetTextColor(headcolor)
			leftlabelrank:SetFont("stalkerregularfont")
			leftlabelrank:SetAutoStretchVertical(true)
			leftlabelrank:SetText("Rank:")
			leftlabelrank:DockMargin(0,marg5v,0,marg5v)
			
			local leftlabelrep = leftlabelbox:Add("DLabel")
			leftlabelrep:Dock(TOP)
			leftlabelrep:SetWidth(77)
			leftlabelrep:SetTextColor(headcolor)
			leftlabelrep:SetFont("stalkerregularfont")
			leftlabelrep:SetAutoStretchVertical(true)
			leftlabelrep:SetText("Reputation:")
			leftlabelrep:DockMargin(0,marg5v,0,marg5v)
			
			local leftinfobox = leftbox:Add("DPanel")
			leftinfobox:SetDrawBackground(false)
			leftinfobox:SetSize(((.071875)*ScrW()),(.13240740740741*ScrH()))
			leftinfobox:Dock(RIGHT)
			
			local leftinfo1 = leftinfobox:Add("DLabel")
			leftinfo1:SetAutoStretchVertical(true)
			leftinfo1:SetSize(((.071875)*ScrW()),10)
			leftinfo1:SetFont("stalkerregularfont")
			leftinfo1:Dock(TOP)
			leftinfo1:SetText(pdaname)
			leftinfo1:DockMargin(0,marg5v,0,marg5v)
			
			local leftinfo2 = leftinfobox:Add("DLabel")
			leftinfo2:SetAutoStretchVertical(true)
			leftinfo2:SetSize(((.071875)*ScrW()),10)
			leftinfo2:SetFont("stalkerregularfont")
			leftinfo2:Dock(TOP)
			leftinfo2:SetText(rank)
			leftinfo2:DockMargin(0,marg5v,0,marg5v)
			
			local leftinfo3 = leftinfobox:Add("DLabel")
			leftinfo3:SetSize(((.071875)*ScrW()),10)
			leftinfo3:SetAutoStretchVertical(true)
			leftinfo3:SetFont("stalkerregularfont")
			leftinfo3:Dock(TOP)
			leftinfo3:SetTextColor(repcolor)
			leftinfo3:SetText(reputation)
			leftinfo3:DockMargin(0,marg5v,0,marg5v)
			
			x,y = leftbox:GetPos()
			
			local rightbox = rankinfo:Add("DPanel")
			rightbox:SetPos(x +((.11458333333333)*ScrW()), toprow)
			rightbox:SetSize(infow,(.13240740740741*ScrH()))
			rightbox:SetDrawBackground(false)
			
			local rightlabelbox = rightbox:Add("DPanel")
			rightlabelbox:SetSize(((.039583333333333)*ScrW()),(.13240740740741*ScrH()))
			rightlabelbox:SetDrawBackground(false)
			rightlabelbox:Dock(LEFT)
			
			local rightlabelname = rightlabelbox:Add("DLabel")
			rightlabelname:Dock(TOP)
			rightlabelname:SetSize(((.038020833333333)*ScrW()),10)
			rightlabelname:SetAutoStretchVertical(true)
			rightlabelname:SetTextColor(headcolor)
			rightlabelname:SetFont("stalkerregularfont")
			rightlabelname:SetText("Name:")
			rightlabelname:DockMargin(0,marg5v,0,marg5v)
			
			local rightlabelage = rightlabelbox:Add("DLabel")
			rightlabelage:Dock(TOP)
			rightlabelage:SetSize(((.038020833333333)*ScrW()),10)
			rightlabelage:SetAutoStretchVertical(true)
			rightlabelage:SetTextColor(headcolor)
			rightlabelage:SetFont("stalkerregularfont")
			rightlabelage:SetText("Age:")
			rightlabelage:DockMargin(0,marg5v,0,marg5v)
			
			local rightlabelnat = rightlabelbox:Add("DLabel")
			rightlabelnat:Dock(TOP)
			rightlabelnat:SetSize(((.038020833333333)*ScrW()),10)
			rightlabelnat:SetAutoStretchVertical(true)
			rightlabelnat:SetTextColor(headcolor)
			rightlabelnat:SetFont("stalkerregularfont")
			rightlabelnat:SetText("Nationality:")
			rightlabelnat:DockMargin(0,marg5v,0,marg5v)
			
			local rightlabelrace = rightlabelbox:Add("DLabel")
			rightlabelrace:Dock(TOP)
			rightlabelrace:SetSize(((.038020833333333)*ScrW()),10)
			rightlabelrace:SetAutoStretchVertical(true)
			rightlabelrace:SetTextColor(headcolor)
			rightlabelrace:SetFont("stalkerregularfont")
			rightlabelrace:SetText("Race:")
			rightlabelrace:DockMargin(0,marg5v,0,marg5v)
			
			local rightinfobox = rightbox:Add("DPanel")
			rightinfobox:SetDrawBackground(false)
			rightinfobox:SetSize(((.075)*ScrW()),(.13240740740741*ScrH()))
			rightinfobox:Dock(RIGHT)
			
			local rightinfoname = rightinfobox:Add("DLabel")
			rightinfoname:Dock(TOP)
			rightinfoname:SetSize(((.075)*ScrW()),20)
			rightinfoname:SetAutoStretchVertical(true)
			rightinfoname:SetFont("stalkerregularfont")
			rightinfoname:DockMargin(0,marg5v,0,marg5v)
			
			if name then
				rightinfoname:SetText(name)
			else
				rightinfoname:SetText("N/A")
			end
			
			local rightinfoage = rightinfobox:Add("DLabel")
			rightinfoage:Dock(TOP)
			rightinfoage:SetSize(((.075)*ScrW()),20)
			rightinfoage:SetAutoStretchVertical(true)
			rightinfoage:SetFont("stalkerregularfont")
			rightinfoage:DockMargin(0,marg5v,0,marg5v)
			
			if age then
				rightinfoage:SetText(age)
			else
				rightinfoage:SetText("N/A")
			end
			
			local rightinfonat = rightinfobox:Add("DLabel")
			rightinfonat:Dock(TOP)
			rightinfonat:SetSize(((.075)*ScrW()),20)
			rightinfonat:SetAutoStretchVertical(true)
			rightinfonat:SetFont("stalkerregularfont")
			rightinfonat:DockMargin(0,marg5v,0,marg5v)
			
			if nationality then
				rightinfonat:SetText(nationality)
			else
				rightinfonat:SetText("N/A")
			end
			
			local rightinforace = rightinfobox:Add("DLabel")
			rightinforace:Dock(TOP)
			rightinforace:SetSize(((.075)*ScrW()),20)
			rightinforace:SetAutoStretchVertical(true)
			rightinforace:SetFont("stalkerregularfont")
			rightinforace:DockMargin(0,marg5v,0,marg5v)
			
			if race then
				rightinforace:SetText(race)
			else
				rightinforace:SetText("N/A")
			end
			
			x,y = infoimage:GetPos()
			
			local descbackbox = rankinfo:Add("DScrollPanel")
			descbackbox:SetSize(((.328125)*ScrW()),((.30648148148148)*ScrH()))
			descbackbox:SetPos(x, y + (.13240740740741*ScrH()))
			descbackbox:SetMouseInputEnabled(true)
			
			local infodesclabel = descbackbox:Add("DLabel")
			infodesclabel:Dock(TOP)
			infodesclabel:SetWidth(((.328125)*ScrW()))
			infodesclabel:SetAutoStretchVertical(true)
			infodesclabel:SetTextColor(headcolor)
			infodesclabel:SetFont("stalkerregularfont")
			infodesclabel:SetText("Description:")
			
			local infodesc = descbackbox:Add("DTextEntry_Edit")
			infodesc:SetDrawBackground(false)
			infodesc:SetMultiline(true)
			infodesc:SetTextColor(Color(255,255,255))
			infodesc:SetFont("stalkerregularfont")
			infodesc:SetEditable(false)
			infodesc:SetWidth(((.328125)*ScrW()))
			infodesc:Dock(TOP)
			if desc then
				infodesc:SetValue(desc)
			else
				infodesc:SetValue("N/A")
			end
			infodesc:SizeToContentsY()
			
			local infobacklabel = descbackbox:Add("DLabel")
			infobacklabel:Dock(TOP)
			infobacklabel:SetWidth(((.328125)*ScrW()))
			infobacklabel:SetAutoStretchVertical(true)
			infobacklabel:SetTextColor(headcolor)
			infobacklabel:SetFont("stalkerregularfont")
			infobacklabel:SetText("Backstory:")
			
			local infoback = descbackbox:Add("DTextEntry_Edit")
			infoback:SetDrawBackground(false)
			infoback:SetMultiline(true)
			infoback:SetTextColor(Color(255,255,255))
			infoback:SetFont("stalkerregularfont")
			infoback:SetEditable(false)
			infoback:SetWidth(((.328125)*ScrW()))
			infoback:Dock(TOP)
			infoback:DockMargin(0,(.0092592592592593*ScrH()),0,0)
			if desc and backstory then
				infoback:SetValue(backstory)
			else
				infoback:SetValue("N/A")
			end
			infoback:SizeToContentsY()
		end)
		
		netstream.Start("GetRankListData")
		netstream.Hook("RankListData", function(rankdata)
			local ranklistold
			local img
			local name
			local rnk
			local repu
			local plyr
			local count = 1
			
			if ranklistbox:GetChildren() then
				for x,y in pairs(ranklistbox:GetChildren()) do
					if y:GetName() == "RankList" then
						y:Remove()
					end
				end
			end
			
			local marg4h = (.0020833333333333*ScrW())
			local marg4v = (.0037037037037037*ScrH())
			local ranklist = ranklistbox:Add("DScrollPanel")
			ranklist:Dock(FILL)
			ranklist:DockMargin(marg4h,marg4v,marg4h,marg4v)
			ranklist:SetName("RankList")
			ranklist:SetMouseInputEnabled(true)
				
			for k,v in ipairs(rankdata) do
				
				for x,y in pairs(v) do
					if x == "pdaimage" then
						img = y
						
					elseif x == "pdaname" then
						name = y
						
					elseif x == "rank" then
						rnk = y
						
					elseif x == "reputation" then
						repu = y
							
					elseif x == "player" then
						plyr = y
					
					end
				end
				
				local plyrankbox = ranklist:Add("DImageButton")
				plyrankbox:SetSize(((.284375)*ScrW()),121)
				plyrankbox:Dock(TOP)
				plyrankbox:DockMargin(marg5h,marg5v,marg5h,marg5v)
				plyrankbox:SetImage("stalker/ui/rankings/rank_list_box.png")
				plyrankbox:SetMouseInputEnabled(true)
				plyrankbox.Player = plyr
					
				if rnk and name and repu and img then
					local listimage = Material(img)
					local w = listimage:Width() 
					local h = listimage:Height()
					local scale = w/((.072916666666667)*ScrW())
					local newheight = h/scale
					local difference = ((.10277777777778)*ScrH()) - newheight
					local vertmarg = ((.030555555555556)*ScrH())
					
					if difference < 10 then
						difference = 10
					end
					
					local rankings = plyrankbox:Add("DLabel")
					rankings:SetText(count..".")
					rankings:SetTextColor(Color(255,255,255))
					rankings:SetFont("stalkerregularfont")
					rankings:SetPos(((.27239583333333)*ScrW()),3)
					rankings:SetAutoStretchVertical(true)
					rankings:SizeToContentsX()
					rankings:Dock(LEFT)
					rankings:DockMargin(5,((.046296296296296)*ScrH()),0,0)
					rankings:SetMouseInputEnabled(true)
					
					local margin = (difference/2)
					local pdaimage = plyrankbox:Add("DImage")
					pdaimage:SetImage(img)
					pdaimage:Dock(LEFT)
					
					if w < ((.072916666666667)*ScrW()) and h < ((.093518518518519)*ScrH()) then
						local marg = (((.10277777777778)*ScrH())-h)/2
						
						pdaimage:SetSize(w,h)
						pdaimage:DockMargin(marg5h,marg,0,marg)
					else
						pdaimage:SetSize(((.072916666666667)*ScrW()), newheight)
						pdaimage:DockMargin(marg5h,margin,0,margin)
					end
					
					local pdanamebox = plyrankbox:Add("DButton")
					pdanamebox:SetSize(((.0578125)*ScrW()),((.11203703703704)*ScrH()))
					pdanamebox:SetDrawBackground(false)
					pdanamebox:Dock(LEFT)
					pdanamebox:SetMouseInputEnabled(true)
					pdanamebox:SetText(" ")
					
					local pdanamelabel = pdanamebox:Add("DLabel")
					pdanamelabel:SetSize(((.0578125)*ScrW()),((.037037037037037)*ScrH()))
					pdanamelabel:SetAutoStretchVertical(true)
					pdanamelabel:SetTextColor(headcolor)
					pdanamelabel:SetText("PDA Handle:")
					pdanamelabel:SetFont("stalkerregularfont")
					pdanamelabel:Dock(TOP)
					pdanamelabel:DockMargin((.013020833333333*ScrW()),vertmarg,marg5h,marg5v)
					pdanamelabel:SetMouseInputEnabled(true)
					
					local pdaname = pdanamebox:Add("DLabel")
					pdaname:SetSize(((.0578125)*ScrW()),((.037037037037037)*ScrH()))
					pdaname:SetAutoStretchVertical(true)
					pdaname:SetText(name)
					pdaname:SetFont("stalkerregularfont")
					pdaname:Dock(TOP)
					pdaname:DockMargin((.013020833333333*ScrW()),2,marg5h,0)
					pdaname:SetMouseInputEnabled(true)
					
					local rankbox = plyrankbox:Add("DButton")
					rankbox:SetSize(((.0578125)*ScrW()),((.11203703703704)*ScrH()))
					rankbox:SetDrawBackground(false)
					rankbox:Dock(LEFT)
					rankbox:SetMouseInputEnabled(true)
					rankbox:SetText(" ")
					
					local ranklabel = rankbox:Add("DLabel")
					ranklabel:SetAutoStretchVertical(true)
					ranklabel:SetSize(((.0578125)*ScrW()),((.037037037037037)*ScrH()))
					ranklabel:SetText("Rank:")
					ranklabel:SetTextColor(headcolor)
					ranklabel:SetFont("stalkerregularfont")
					ranklabel:Dock(TOP)
					ranklabel:DockMargin((.013020833333333*ScrW()),vertmarg,marg5h,marg5v)
					ranklabel:SetMouseInputEnabled(true)
					
					local rank = rankbox:Add("DLabel")
					rank:SetAutoStretchVertical(true)
					rank:SetSize(((.0578125)*ScrW()),((.037037037037037)*ScrH()))
					rank:SetText(rnk)
					rank:SetFont("stalkerregularfont")
					rank:Dock(TOP)
					rank:DockMargin((.013020833333333*ScrW()),2,marg5h,0)
					rank:SetMouseInputEnabled(true)
					
					local reputationbox = plyrankbox:Add("DButton")
					reputationbox:SetSize(((.0578125)*ScrW()),((.11203703703704)*ScrH()))
					reputationbox:SetDrawBackground(false)
					reputationbox:Dock(LEFT)
					reputationbox:SetMouseInputEnabled(true)
					reputationbox:SetText(" ")
					
					local reputationlabel = reputationbox:Add("DLabel")
					reputationlabel:SetAutoStretchVertical(true)
					reputationlabel:SetSize(((.0578125)*ScrW()),((.037037037037037)*ScrH()))
					reputationlabel:SetTextColor(headcolor)
					reputationlabel:SetText("Reputation:")
					reputationlabel:SetFont("stalkerregularfont")
					reputationlabel:Dock(TOP)
					reputationlabel:DockMargin((.013020833333333*ScrW()),vertmarg,marg5h,marg5v)
					reputationlabel:SetMouseInputEnabled(true)
					
					local reputation = reputationbox:Add("DLabel")
					reputation:SetAutoStretchVertical(true)
					reputation:SetSize(((.0578125)*ScrW()),((.037037037037037)*ScrH()))
					reputation:SetTextColor(repcolor)
					reputation:SetText(repu)
					reputation:SetFont("stalkerregularfont")
					reputation:Dock(TOP)
					reputation:DockMargin((.013020833333333*ScrW()),2,marg5h,0)
					reputation:SetMouseInputEnabled(true)
					
					count = count + 1
						
					rnk = nil
					repu = nil
					name = nil
					image = nil
					plyr = nil
					
					pdanamebox.DoClick = function()
						if plyrankbox.Player then
							netstream.Start("SetInfoPanel", plyrankbox.Player)
						else
							LocalPlayer():Notify("Error Referencing Player")
						end
					end
					
					rankbox.DoClick = function()
						if plyrankbox.Player then
							netstream.Start("SetInfoPanel", plyrankbox.Player)
						else
							LocalPlayer():Notify("Error Referencing Player")
						end
					end
					
					reputationbox.DoClick = function()
						if plyrankbox.Player then
							netstream.Start("SetInfoPanel", plyrankbox.Player)
						else
							LocalPlayer():Notify("Error Referencing Player")
						end
					end
					
					plyrankbox.DoClick = function()
						if plyrankbox.Player then
							netstream.Start("SetInfoPanel", plyrankbox.Player)
						else
							LocalPlayer():Notify("Error Referencing Player")
						end
					end
				end
			end
		end)
	end
	
	vgui.Register("RankingsListFrame", PANEL, "DPanel")

	hook.Add("CreateMenuButtons", "ixRankings", function(tabs)
		tabs["Rankings"] = function(container)
			container:Add("RankingsListFrame")
		end
	end)
else
	netstream.Hook("GetRankListData",function(client)
		local rankdata = {}
		local plylist = player.GetAll()
		
		for k,v in pairs(plylist) do
			local character = v:GetCharacter()
			if character then
				if character:GetData("RankAdvanced",false) or character:GetData("RankBasic",false) then
					rankdata[k] = {
						["player"] = v,
						["pdaimage"] = character:GetData("pdaavatar","vgui/icons/face_31.png"),
						["pdaname"] = character:GetData("pdanickname","Unknown"),
						["rank"] = v:getCurrentRankName() or "Tourist",
						["reputation"] = v:getReputation() or 0,
					}
				end
			end
		end
		
		if not table.IsEmpty(rankdata) then
			
			local counter = 1
			local newrankdata = {}
			
			if not table.IsSequential(rankdata) then
				for k,v in pairs(rankdata) do
					newrankdata[counter] = v
					counter = counter + 1
				end
				rankdata = newrankdata
			end
			
			if #rankdata >= 2 then
				table.sort(rankdata, function(a, b)
					return a["reputation"] > b["reputation"]
				end)
			end
			
			netstream.Start(client, "RankListData", rankdata)
		end
	end)
	
	netstream.Hook("ProfileChange", function(client, pubtype)
		local character = client:GetCharacter()
		if pubtype == "basic" then
			if character:GetData("RankBasic",false) then
				character:SetData("RankBasic",false)
			else
				character:SetData("RankBasic",true)
			end
		elseif pubtype == "advanced" then
			if character:GetData("RankAdvanced",false) then
				character:SetData("RankAdvanced",false)
			else
				character:SetData("RankAdvanced",true)
			end
		end
	end)
	
	netstream.Hook("SetInfoPanel", function(client, ply)
		local plylist = player.GetAll()
		local target
		local plydata = {}
		
		for k,v in pairs(plylist) do
			if v == ply then
				target = v
			end
		end
		
		local character = target:GetCharacter()
		
		if character:GetData("RankAdvanced",false) then
			plydata = {
				["description"] = character:GetDescription() or "Unknown",
				["name"] = character:GetName() or "Unknown",
				["age"] = character:GetData("sheetAge",25),
				["nationality"] = character:GetData("sheetNationality","Unknown"),
				["race"] = character:GetData("sheetRace"),
				["backstory"] = character:GetData("sheetBackstory"),
				["pdaimage"] = character:GetData("pdaavatar","vgui/icons/face_31.png"),
				["pdaname"] = character:GetData("pdanickname","Unknown"),
				["rank"] = target:getCurrentRankName() or "Tourist",
				["reputation"] = target:getReputation() or 0,
			}
		elseif character:GetData("RankBasic",false) then
			plydata = {
				["pdaimage"] = character:GetData("pdaavatar","vgui/icons/face_31.png"),
				["pdaname"] = character:GetData("pdanickname","Unknown"),
				["rank"] = target:getCurrentRankName() or "Tourist",
				["reputation"] = target:getReputation() or 0,
			}
		end
		if not table.IsEmpty(plydata) then
			netstream.Start(client, "SetupInfoPanel", plydata)
		end
	end)
end

--[[
The below code was originally written by Verne, known currently for the Call Of The Zone schema.
I've made some changes to it, and the above code depends on this to function properly.
--]]

PLUGIN.repDefs = {
	{"Rookie", 0},
	{"Experienced", 2000},
	{"Seasoned", 17000},
	{"Veteran", 74000},
	{"Master", 174000},
	{"Legendary", 400000},
}

local playerMeta = FindMetaTable("Player")
local entityMeta = FindMetaTable("Entity")

function playerMeta:getReputation()
	return (self:GetNetVar("reputation")) or 0
end

function playerMeta:getRepName()
	return (self:GetNetVar("repOverride")) or 0
end

function playerMeta:addReputation(amount)
	self:SetNetVar("reputation", self:getReputation() + amount)
end

function playerMeta:setReputation(amount)
	self:SetNetVar("reputation", amount)
end

function playerMeta:getCurrentRankName()
	local rep = self:GetNetVar("reputation") or 0

	if self:getRepName() != 0 then
		return self:getRepName()
	end
	
	for i = 1, #PLUGIN.repDefs do
		if PLUGIN.repDefs[i][2] > rep then
			return PLUGIN.repDefs[i-1][1]
		end
	end

	return PLUGIN.repDefs[#PLUGIN.repDefs][1]
end

function playerMeta:getArbitraryRankName(rep)
	for i = 1, #PLUGIN.repDefs do
		if PLUGIN.repDefs[i][2] > rep then
			return PLUGIN.repDefs[i-1][1]
		end
	end

	return PLUGIN.repDefs[#PLUGIN.repDefs][1]
end

function PLUGIN:PopulateCharacterInfo(client, character, container)
	local repnametext = container:AddRow("reputation")
	repnametext:SetText(client:getCurrentRankName())
	repnametext:SetTextColor(Color(138, 43, 226))
	repnametext:SizeToContents()
end

if (SERVER) then
	local PLUGIN = PLUGIN
	
	function PLUGIN:CharacterPreSave(character)
		character:SetData("reputation", character.player:getReputation())
		character:SetData("repOverride", character.player:getRepName())
	end

	function PLUGIN:PlayerLoadedCharacter(client, character, lastChar)	
		if (character:GetData("reputation")) then
			client:SetNetVar("reputation", character:GetData("reputation"))
		else
			client:SetNetVar("reputation", 0)
		end

		if (character:GetData("repOverride")) then
			client:SetNetVar("repOverride", character:GetData("repOverride"))
		else
			client:SetNetVar("repOverride", 0)
		end
	end
end

ix.command.Add("charsetreputation", {
	adminOnly = true,
	arguments = {
		ix.type.string,
		ix.type.number
	},
	OnRun = function(self, client, target, reputation)
		local target = ix.util.FindPlayer(target)
		local reputation = tonumber(reputation)

		target:setReputation(reputation)

		if client == target then
            client:Notify("You have set your reputation to "..reputation)
        else
            client:Notify("You have set "..target:Name().."'s reputation to "..reputation)
            target:Notify(client:Name().." has set your reputation to "..reputation)
        end
	end
})

ix.command.Add("charaddreputation", {
	adminOnly = true,
	arguments = {
		ix.type.string,
		ix.type.number
	},
	OnRun = function(self, client, target, reputation)
		local target = ix.util.FindPlayer(target)
		local reputation = tonumber(reputation)

		target:addReputation(reputation)

		if client == target then
            client:Notify("You have added "..reputation.." to your reputation.")
        else
            client:Notify("You have added "..reputation.." to "..target:Name().."'s reputation.")
            target:Notify(client:Name().." has added "..reputation.." to your reputation.")
        end
	end
})

ix.command.Add("charcheckreputation", {
	adminOnly = true,
	arguments = {
		ix.type.string,
	},
	OnRun = function(self, client, target)
		local target = ix.util.FindPlayer(target)

		if target then 
        	client:Notify(target:Name() .. " has "..target:getReputation().." reputation.")
    	else
            client:Notify("Player not found")
        end
	end
})

ix.command.Add("charrepnameset", {
	adminOnly = true,
	arguments = {
		ix.type.string,
		ix.type.string
	},
	OnRun = function(self, client, target, name)
		local target = ix.util.FindPlayer(target)
		local reputation = name

		target:SetNetVar("repOverride", reputation)

		if client == target then
            client:Notify("Custom rankname set.")
        else
            client:Notify("Custom rankname set.")
            target:Notify(client:Name().." has set your repname.")
        end
	end
})

ix.command.Add("charrepnameremove", {
	adminOnly = true,
	arguments = {
		ix.type.string,
	},
	OnRun = function(self, client, target)
		local target = ix.util.FindPlayer(target)

		target:SetNetVar("repOverride", 0)

		if client == target then
            client:Notify("Custom rankname removed.")
        else
            client:Notify("Custom rankname removed.")
            target:Notify(client:Name().." has removed your repname.")
        end
	end
})

