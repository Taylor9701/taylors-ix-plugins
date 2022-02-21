PLUGIN.name = "Upgrades"
PLUGIN.author = "Taylor"
PLUGIN.desc = "UI Upgrade System"

ix.util.Include("cl_plugin.lua")

local BasicUpgTable = {
	["sun_agi1"] = {name = "Internal Thermal Regulation System", desc = "An ergonomic improvement: Special mounts attached to the bodysuit allow for carried weight to feel lighter", price = 0200, enames = {"agi"}, img = "stalker/ui/upgrade/armor/stam_1.png"},
	["sun_imp1"] = {name = "Segmented Protection", desc = "Thinner sheets of armor are layered to increase the armor's wear resistance.", price = 1000, enames = {"Impact"}, img = "stalker/ui/upgrade/armor/imp_1.png"},
	["sun_weight1"] = {name = "Solid Carbon Components", desc = "Replacing steel with carbon fiber allows the weight of body armor to be reduced without sacrificing reliability.", price = 2500, enames = {"weight"}, img = "stalker/ui/upgrade/armor/wr_1.png"},
	["sun_imp1_2"] = {name = "Additional Titanium Plates", desc = "Increased number of titanium plates considerably improves body armor durability.", price = 4000, enames = {"Impact"}, img = "stalker/ui/upgrade/armor/imp_2.png"},
	
	["sun_psy2"] = {name = "Steel Grills", desc = "A closed band of steel has been demonstrated to provide partial protection against direct psy-emissions.", price = 0200, enames = {"Psi"}, img = "stalker/ui/upgrade/armor/psy_9.png"},
	["sun_elec2"] = {name = "Constantin-based Inner Layer", desc = "A thin layer of constantin capable of insulating from electricity.", price = 1000, enames = {"Shock"}, img = "stalker/ui/upgrade/armor/elec_1.png"},
	["sun_rad2"] = {name = "Rubberized Fabric", desc = "Rubber is a basic way of protecting yourself from brief radiation exposure.", price = 2500, enames = {"Radiation"}, img = "stalker/ui/upgrade/armor/rad_1.png"},
	["sun_chem2"] = {name = "Plexiglass with Lead Mesh", desc = "Plexiglass is sewn into the Bodysuit with a Lead Mesh.", price = 4000, enames = {"Chemical"}, img = "stalker/ui/upgrade/armor/chem_4.png"},
	["sun_burn2"] = {name = "Thermal Fiberglass Layer", desc = "Fiberglass is used in bodysuits worn by natural disaster response teams for protection from burns.", price = 2000, enames = {"Burn"}, img = "stalker/ui/upgrade/armor/burn_4.png"},

	["sun_weightcarry3"] = {name = "Modular Back Frame", desc = "A back frame relieves focused shoulder load from carried weight by distributing it over the body, which increases maximum load.", price = 0200, enames = {"wcarry"}, img = "stalker/ui/upgrade/armor/wc_4.png"},
	["sun_woundheal3"] = {name = "Ray Hemostimulator", desc = "This small wave emitter is mounted on the back, effictively increasing blood clotting speed when worn consistently.", price = 1000, enames = {"woundheal"}, img = "stalker/ui/upgrade/armor/wh_1.png"},
	["sun_heal3"] = {name = "Fury Adrenaline Injector", desc = "Generation A injector, developed by one of Kiev's research institutes, regularly injects the bloodstream with tiny doses of adrenaline, which may be dangerous but could also save your life in an emergency.", price = 2500, enames = {"heal", "end"}, img = "stalker/ui/upgrade/armor/hp_1.png"},
	
	["sun_armor4"] = {name = "Kelvar Plates", desc = "Kevlar plates sewn into the inside of the suit.", price = 4000, enames = {"body", "weight"}, img = "stalker/ui/upgrade/armor/ap_3.png"},
	["sun_armor4_2"] = {name = "Polycarbonate Plates w/ Titanium Alloys", desc = "A labor-intensive and time-consuming upgrade. Not the first choice for suit modification, but may end up being a good investment.", price = 2000, enames = {"body", "limb", "weight"}, img = "stalker/ui/upgrade/armor/ap_9.png"},
	["sun_armor4_3"] = {name = "Polycarbonate Plates w/ Titanium Alloys 2", desc = "A labor-intensive and time-consuming upgrade. Not the first choice for suit modification, but may end up being a good investment.", price = 4000, enames = {"body", "limb", "weight"}, img = "stalker/ui/upgrade/armor/ap_9.png"},
	["sun_armor4_4"] = {name = "Duplicate Protective Plate Layer", desc = "Armor with an inner layer that spreads impact over a greater area.", price = 2000, enames = {"body", "limb", "weight"}, img = "stalker/ui/upgrade/armor/ap_10.png"},
	["sun_armor4_5"] = {name = "Multi-Layer Armor Sheets", desc = "Multiple layers of armor are woven together to create a failsafe barricade.", price = 4000, enames = {"body", "limb", "weight"}, img = "stalker/ui/upgrade/armor/ap_18.png"},

	["ak74_rpm1"] = {name = "RoF1", desc = "Test RoF", price = 2000, enames = {"rpm"}, img = "stalker/ui/upgrade/armor/ap_18.png"},
	["ak74_vel1"] = {name = "Pen1", desc = "Test Pen", price = 2000, enames = {"vel"}, img = "stalker/ui/upgrade/armor/ap_18.png"},
	["ak74_dmg1"] = {name = "Dmg1", desc = "Test Dmg", price = 2000, enames = {"dmg"}, img = "stalker/ui/upgrade/armor/ap_18.png"},
	["ak74_mag1"] = {name = "RoF1", desc = "Test Mag", price = 2000, enames = {"mag"}, img = "stalker/ui/upgrade/armor/ap_18.png"},
}
-- formatted as: [ID] = {pretty name, description, price, effect name, imagepath}

--[[ 
IMPORTANT FOR IMPLEMENTATION:
* Example data for the Sunrise suit using the above table, goes in the ITEM file. 

* Where things match up between the above table and this example, all must match up.

* Implementing this plugin requires a serious level of understanding how to read and implement code.
* If you don't know how to do any of that, get someone who does. Making this work is NOT just plug and play,
* this plugin simply handles a massive amount of the heavy lifting. It's not perfect and may have bugs,
* please report any you find, but I cannot feasibly assist with implementations.

* Advice: enames is short for effect names, it's what you should be looking for to implement the data figured out here
* to actually apply changes to items elsewhere. You can skip the huge monolithic UI function and go to the calls at the bottom
* for a better understanding of how things are set and how to then refer to them elsewhere.

* Known issue: The UI when being generated can cause a stutter on the client end. If you experience this please let me know.

* There is an example in the armor plugin for the sunrise suit as well.

ITEM.upgs = {
	{name = "sun_agi1", dep = {"none"}, adjacent = nil, blocks = {}, amounts = {1}, pos = 1, row = 1},
	{name = "sun_imp1", dep = {"sun_agi1"}, adjacent = {"sun_weight1"}, blocks = {"sun_weight1"}, amounts = {3}, pos = 2, row = 1},
	{name = "sun_weight1", dep = {"sun_agi1"}, adjacent = {"sun_imp1"}, blocks = {"sun_imp1"}, amounts = {-5}, pos = 2, row = 1},
	{name = "sun_imp1_2", dep = {"sun_weight1 or sun_imp1"}, adjacent = nil, blocks = {}, amounts = {5}, pos = 3, row = 1},
	
	{name = "sun_psy2", dep = {"none"}, adjacent = nil, amounts = {1, 1, 1}, pos = 1, row = 2},
	{name = "sun_elec2", dep = {"sun_psy2"}, adjacent = {"sun_rad2"}, blocks = {"sun_rad2", "sun_burn2"}, amounts = {5}, pos = 2, row = 2},
	{name = "sun_rad2", dep = {"sun_psy2"}, adjacent = {"sun_elec2"}, blocks = {"sun_elec2", "sun_chem2"}, amounts = {5}, pos = 2, row = 2},
	{name = "sun_burn2", dep = {"sun_elec2 or sun_rad2"}, adjacent = {"sun_chem2"}, blocks = {"sun_chem2"}, amounts = {10}, pos = 3, row = 2},
	{name = "sun_chem2", dep = {"sun_elec2 or sun_rad2"}, adjacent = {"sun_burn2"}, blocks = {"sun_burn2"}, amounts = {10}, pos = 3, row = 2},
	
	{name = "sun_weightcarry3", dep = {"none"}, adjacent = nil, blocks = {}, amounts = {7}, pos = 1, row = 3},
	{name = "sun_woundheal3", dep = {"sun_weightcarry3"}, adjacent = nil, blocks = {}, amounts = {1}, pos = 2, row = 3},
	{name = "sun_heal3", dep = {"sun_woundheal3"}, adjacent = nil, blocks = {}, amounts = {1, -15}, pos = 3, row = 3},
	
	{name = "sun_armor4", dep = {"none"}, adjacent = nil, amounts = {2, 2}, pos = 1, row = 4},
	{name = "sun_armor4_2", dep = {"sun_armor4"}, adjacent = {"sun_armor4_3"}, blocks = {"sun_armor4_3"}, amounts = {4, 2, 4}, pos = 2, row = 4},
	{name = "sun_armor4_3", dep = {"sun_armor4"}, adjacent = {"sun_armor4_2"}, blocks = {"sun_armor4_2"}, amounts = {4, 3, 4}, pos = 2, row = 4},
	{name = "sun_armor4_4", dep = {"sun_armor4_2 or sun_armor4_3"}, adjacent = nil, blocks = {}, amounts = {4, 2, 4}, pos = 3, row = 4},
	{name = "sun_armor4_5", dep = {"sun_armor4_4"}, adjacent = nil, blocks = {}, amounts = {2, 2, 2}, pos = 4, row = 4},
}

Example for AK74:
ITEM.upgs = {
	{name = "ak74_rof1", dep = {"none"}, adjacent = nil, blocks = {}, amounts = {"1/2"}, pos = 1, row = 1},
	{name = "ak74_pen1", dep = {"ak74_rof1"}, adjacent = {"ak74_dmg1"}, blocks = {"ak74_dmg1"}, amounts = {1}, pos = 2, row = 1},
	{name = "ak74_dmg1", dep = {"ak74_rof1"}, adjacent = {"ak74_pen1"}, blocks = {"ak74_pen1"}, amounts = {"02+02"}, pos = 2, row = 1},
	{name = "ak74_mag1", dep = {"ak74_dmg1 or ak74_pen1"}, adjacent = nil, blocks = {}, amounts = {5}, pos = 3, row = 1},
}

--]]




local PANEL = {}

if (CLIENT) then

	function Scale1080(x,y)
		if x > 0 and y > 0 then
			return (x/1920 * ScrW()), (y/1080 * ScrH())
		elseif x > 0 then
			return (x/1920 * ScrW())
		elseif y > 0 then
			return (y/1080 * ScrH())
		end
	end
	
	function PANEL:Init()
		self:SetSize(Scale1080(971,668)) 
		self:SetDrawBackground(false)
		self:SetPaintBackground(false)
		self:Center()
		self:MakePopup()
		
		
		local upgrades = {}
		
		local upgpanel = self:Add("DImage")
		upgpanel:Center()
		upgpanel:Dock(FILL)
		upgpanel:SetPaintBackground(false)
		upgpanel:SetKeepAspect(true)
		upgpanel:SetImage("stalker/ui/upgrade/background.png")
		upgpanel:SetMouseInputEnabled(true)
		upgpanel:SetDrawBackground(false)
		
		local closebutton = upgpanel:Add("DImageButton")
		closebutton:SetMouseInputEnabled(true)
		closebutton:SetImage("stalker/ui/upgrade/x.png")
		closebutton:SetSize(Scale1080(18,15))
		closebutton:SetPos(Scale1080(906,25))
		
		closebutton.DoClick = function()
			self:Remove()
		end
		
		
		local price = 0
		
		local pricebox = upgpanel:Add("DPanel")
		pricebox:SetSize(120,38)
		pricebox:SetPos(Scale1080(280,596))
		pricebox:SetDrawBackground(false)
		pricebox:SetPaintBackground(false)
		
		local pricelabel = pricebox:Add("DLabel")
		pricelabel:SetFont("stalkerregularfont")
		pricelabel:SetText("Price: ")
		pricelabel:Dock(LEFT)
		
		local priceval = pricebox:Add("DLabel")
		priceval:SetFont("stalkerregularfont")
		priceval:SetText(price)
		priceval:Dock(LEFT)
		priceval.Modify = function(pnl, amount)
			local newval = tonumber(priceval:GetText()) + amount
			local newtext = newval
			price = newval
			priceval:SetText(newtext)
		end
		
		
		local instbutton = upgpanel:Add("DImageButton")
		instbutton:SetPos(Scale1080(406,596)) 
		instbutton:SetSize(141,38)
		instbutton:SetImage("stalker/ui/upgrade/button.png")
		instbutton:SetMouseInputEnabled(true)
		instbutton:SetDrawBackground(false)
		instbutton.OnDepressed = function()
			instbutton:SetImage("stalker/ui/upgrade/button_click.png")
			return false
		end
		instbutton.OnReleased = function()
			instbutton:SetImage("stalker/ui/upgrade/button.png")
			return false
		end
		instbutton.DoClick = function()
			if LocalPlayer():GetCharacter():HasMoney(price) then
				for title,tab in pairs(upgrades) do
					for key,ename in pairs(tab.enames) do
						netstream.Start("installupg", ename, tab.amounts[key], tab.name, self.itemID)
					end
					netstream.Start("charge", tab.price, self.itemID)
				end
				self:Remove()
			else
				LocalPlayer():Notify("Insufficient Funds")
			end
		end
		
		local instlabel = instbutton:Add("DLabel")
		instlabel:SetFont("stalkerregularfont")
		instlabel:SetText("INSTALL")
		instlabel:Dock(FILL)
		instlabel:SetContentAlignment(5)
		instlabel:SetMouseInputEnabled(true)
		instlabel.OnDepressed = function()
			instbutton:SetImage("stalker/ui/upgrade/button_click.png")
			return false
		end
		instlabel.OnReleased = function()
			instbutton:SetImage("stalker/ui/upgrade/button.png")
			return false
		end
		instlabel.DoClick = function()
			if LocalPlayer():GetCharacter():HasMoney(price) then
				for title,tab in pairs(upgrades) do
					for key,ename in pairs(tab.enames) do
						netstream.Start("installupg", ename, tab.amounts[key], tab.name, self.itemID)
					end
					netstream.Start("charge", tab.price, self.itemID)
				end
				self:Remove()
			else
				LocalPlayer():Notify("Insufficient Funds")
			end
		end
		
		
		local uninstbutton = upgpanel:Add("DImageButton")
		uninstbutton:SetPos(Scale1080(580,596))
		uninstbutton:SetImage("stalker/ui/upgrade/button.png")
		uninstbutton:SetSize(141,38)
		uninstbutton:SetMouseInputEnabled(true)
		uninstbutton:SetDrawBackground(false)
		uninstbutton.OnDepressed = function()
			uninstbutton:SetImage("stalker/ui/upgrade/button_click.png")
			return false
		end
		uninstbutton.OnReleased = function()
			uninstbutton:SetImage("stalker/ui/upgrade/button.png")
			return false
		end
		uninstbutton.DoClick = function()
			for title,tab in pairs(upgrades) do
				for key,ename in pairs(tab.enames) do
					netstream.Start("uninstallupg", ename, tab.amounts[key], tab.name, self.itemID)
				end
				netstream.Start("pricedrop", tab.price, self.itemID)
			end
			self:Remove()
		end
		
		local uninstlabel = uninstbutton:Add("DLabel")
		uninstlabel:SetFont("stalkerregularfont")
		uninstlabel:SetText("UNINSTALL")
		uninstlabel:Dock(FILL)
		uninstlabel:SetContentAlignment(5)
		uninstlabel:SetMouseInputEnabled(true)
		uninstlabel.OnDepressed = function()
			uninstbutton:SetImage("stalker/ui/upgrade/button_click.png")
			return false
		end
		uninstlabel.OnReleased = function()
			uninstbutton:SetImage("stalker/ui/upgrade/button.png")
			return false
		end
		uninstlabel.DoClick = function()
			for title,tab in pairs(upgrades) do
				for key,ename in pairs(tab.enames) do
					netstream.Start("uninstallupg", ename, tab.amounts[key], title, self.itemID)
				end
				netstream.Start("pricedrop", tab.price, self.itemID)
			end
			self:Remove()
		end
		
		
		local vscroller = upgpanel:Add("DScrollPanel")
		vscroller:SetSize(Scale1080(440,476))
		vscroller:SetPos(Scale1080(10,56))
		vscroller:SetMouseInputEnabled(true)
		vscroller:SetVerticalScrollbarEnabled(true)
		
		local hscroller = vscroller:Add("DHorizontalScroller")
		hscroller:SetSize(Scale1080(440,476))
		hscroller.AdjSize = 0
		hscroller:SetMouseInputEnabled(true)
		
		local iteminfo = upgpanel:Add("DImage")
		iteminfo:SetWidth(Scale1080(0,505))
		iteminfo:Dock(RIGHT)
		iteminfo:DockMargin(0, Scale1080(0,96), Scale1080(10,0), Scale1080(0,170))
		iteminfo:SetDrawBackground(false)
		iteminfo:SetPaintBackground(false)
		iteminfo:SetImage("stalker/ui/upgrade/info_display.png")
		iteminfo:SetKeepAspect(true)
		iteminfo:SetMouseInputEnabled(true)
		
		timer.Simple(0.1, function()
			if self.itemID then
				netstream.Start("itemdata", self.itemID)
				netstream.Hook("itemdatareturn", function(data, image, model, stats)
					
					local itemdisp
					
					if image and image ~= "none" then
						local mat = Material(image)
						local w = mat:Width()
						local h = mat:Height()
						local wmargin = Scale1080(160,0)
						local hmargin = Scale1080(0,8)
						local diffw = (Scale1080(187,0) - w)
						local diffh = (Scale1080(155,0) - h)
						
						if diffw > 0 then
							wmargin = math.Truncate(wmargin + (diffw/2))
						end
						
						if diffh > 0 then
							hmargin = math.Truncate(hmargin + diffh)
						end
						
						itemdisp = iteminfo:Add("DImage")
						itemdisp:SetImage(image)
						itemdisp:SetSize(w,h)
						itemdisp:Dock(TOP)
						itemdisp:DockMargin(wmargin,hmargin,wmargin,0)
					else
						itemdisp = iteminfo:Add("ModelImage")
						itemdisp:SetSize(Scale1080(187,155))
						itemdisp:SetModel(model)
						itemdisp:Dock(TOP)
						itemdisp:DockMargin(Scale1080(160,0),Scale1080(8,0),Scale1080(160,0),0)
					end
					
					-- left side of stats box
					local itemleftsbox = iteminfo:Add("DScrollPanel")
					itemleftsbox:Dock(LEFT)
					itemleftsbox:DockMargin(Scale1080(28,0), Scale1080(0,48),0,Scale1080(0,14))
					itemleftsbox:SetSize(Scale1080(225,180))
					itemleftsbox:SetDrawBackground(false)
					itemleftsbox:SetPaintBackground(false)
					
					local itemleftboxtitles = itemleftsbox:Add("DPanel")
					itemleftboxtitles:SetSize(Scale1080(125,0))
					itemleftboxtitles:Dock(LEFT)
					itemleftboxtitles:SetDrawBackground(false)
					itemleftboxtitles:SetPaintBackground(false)
					
					local itemleftboxstats = itemleftsbox:Add("DPanel")
					itemleftboxstats:SetSize(Scale1080(85,0),0)
					itemleftboxstats:Dock(LEFT)
					itemleftboxstats:SetDrawBackground(false)
					itemleftboxstats:SetPaintBackground(false)
					
					-- right side of stats box
					local itemrightsbox = iteminfo:Add("DScrollPanel")
					itemrightsbox:Dock(LEFT)
					itemrightsbox:DockMargin(Scale1080(4,0), Scale1080(0,48), 0, Scale1080(0,14))
					itemrightsbox:SetSize(Scale1080(225,180))
					itemrightsbox:SetDrawBackground(false)
					itemrightsbox:SetPaintBackground(false)
					
					local itemrightboxtitles = itemrightsbox:Add("DPanel")
					itemrightboxtitles:SetSize(Scale1080(125,0),0)
					itemrightboxtitles:Dock(LEFT)
					itemrightboxtitles:SetDrawBackground(false)
					itemrightboxtitles:SetPaintBackground(false)
					
					local itemrightboxstats = itemrightsbox:Add("DPanel")
					itemrightboxstats:SetSize(Scale1080(85,0),0)
					itemrightboxstats:Dock(LEFT)
					itemrightboxstats:SetDrawBackground(false)
					itemrightboxstats:SetPaintBackground(false)
					
					surface.SetFont("stalkerregularfont")
					local w, h = surface.GetTextSize( self:GetText() )
					
					if stats then
						if stats["type"] == "armor" then -- SUIT definitions
							for k,v in pairs(stats["res"]) do
								if k ~= "Blast" then
									itemrightboxstats:SetTall(itemrightboxstats:GetTall() + h + 10)
									itemrightboxtitles:SetTall(itemrightboxtitles:GetTall() + h + 10)
								end
								
								if k ~= "Blast" and k ~= "Fall" then
									local val = v * 100
									local text = val.."%"
									
									local title = itemrightboxtitles:Add("DLabel")
									title:Dock(TOP)
									title:DockMargin(0,0,0,10)
									title:SetFont("stalkerregularfont")
									title:SetText(k..":")
									
									local stat = itemrightboxstats:Add("DLabel")
									stat:Dock(TOP)
									stat:DockMargin(0,0,0,10)
									stat:SetFont("stalkerregularfont")
									stat:SetText(text)
									stat:SetName(k)
									stat.Modify = function(pnl, amount, sign)
										local newval = 0
								
										if sign == "+" then
											newval = tonumber(string.TrimRight(stat:GetText(),"%")) + amount
										elseif sign == "-" then
											newval = tonumber(string.TrimRight(stat:GetText(),"%")) - amount
										end
										
										local newtext = newval.."%"
										local valcomp = tonumber(val)
										
										stat:SetText(newtext)
										if newval == valcomp then
											stat:SetTextColor(Color(255,255,255))
										elseif newval > valcomp then
											stat:SetTextColor(Color(54,212,49))
										elseif newval < valcomp then
											stat:SetTextColor(Color(196,0,0))
										end
									end
									
								elseif k == "Fall" then
									local val = v * 100
									
									local title = itemrightboxtitles:Add("DLabel")
									title:Dock(TOP)
									title:DockMargin(0,0,0,10)
									title:SetFont("stalkerregularfont")
									title:SetText("Impact:")
									
									local stat = itemrightboxstats:Add("DLabel")
									stat:Dock(TOP)
									stat:DockMargin(0,0,0,10)
									stat:SetFont("stalkerregularfont")
									stat:SetText(val.."%")
									stat:SetName("Impact")
									stat.Modify = function(pnl, amount, sign)
										local newval = 0
								
										if sign == "+" then
											newval = tonumber(string.TrimRight(stat:GetText(),"%")) + amount
										elseif sign == "-" then
											newval = tonumber(string.TrimRight(stat:GetText(),"%")) - amount
										end
										
										local newtext = newval.."%"
										local valcomp = tonumber(val)
										stat:SetText(newtext)
										
										if newval == valcomp then
											stat:SetTextColor(Color(255,255,255))
										elseif newval > valcomp then
											stat:SetTextColor(Color(54,212,49))
										elseif newval < valcomp then
											stat:SetTextColor(Color(196,0,0))
										end
									end
								end
							end
							
							--[[ 
							-- This is part of the dependency mentioned below. As such, it is commented out. Un-comment and make adjustments to add something else.
							-- Or insert new stuff entirely around here.
							
							for k,v in pairs(stats["armor"]) do
								itemleftboxstats:SetTall(itemleftboxstats:GetTall() + h + 10)
								itemleftboxtitles:SetTall(itemleftboxtitles:GetTall() + h + 10)
							
								local areatext
								if k == "body" then
									areatext = "Body AP:"
								elseif k == "limb" then
									areatext = "Limb AP:"
								end
								
								local val = v
								
								local title = itemleftboxtitles:Add("DLabel")
								title:Dock(TOP)
								title:DockMargin(0,0,0,10)
								title:SetFont("stalkerregularfont")
								title:SetText(areatext)
								
								local stat = itemleftboxstats:Add("DLabel")
								stat:Dock(TOP)
								stat:DockMargin(0,0,0,10)
								stat:SetFont("stalkerregularfont")
								stat:SetText(val)
								stat:SetName(k)
								stat.Modify = function(pnl, amount, sign)
									local newval = 0
								
									if sign == "+" then
										newval = tonumber(duraimpstat:GetText()) + amount
									elseif sign == "-" then
										newval = tonumber(duraimpstat:GetText()) - amount
									end
								
									local valcomp = tonumber(val)
									stat:SetText(newval)
									
									if newval == valcomp then
										stat:SetTextColor(Color(255,255,255))
									elseif newval > valcomp then
										stat:SetTextColor(Color(54,212,49))
									elseif newval < valcomp then
										stat:SetTextColor(Color(196,0,0))
									end
								end
							end
							--]]
							
							itemleftboxstats:SetTall(itemleftboxstats:GetTall() + h + 10)
							itemleftboxtitles:SetTall(itemleftboxtitles:GetTall() + h + 10)
							
							local artislots = stats["artis"][1]
							
							local artititle = itemleftboxtitles:Add("DLabel")
							artititle:Dock(TOP)
							artititle:DockMargin(0,0,0,10)
							artititle:SetFont("stalkerregularfont")
							artititle:SetText("Arti Slots:")
							
							local artistat = itemleftboxstats:Add("DLabel")
							artistat:Dock(TOP)
							artistat:DockMargin(0,0,0,10)
							artistat:SetFont("stalkerregularfont")
							artistat:SetText(artislots)
							artistat:SetName("artislots")
							artistat.Modify = function(pnl, amount, sign)
								local newval = 0
								
								if sign == "+" then
									newval = tonumber(artistat:GetText()) + amount
								elseif sign == "-" then
									newval = tonumber(artistat:GetText()) - amount
								end
								
								local valcomp = tonumber(artislots)
								artistat:SetText(newval)
								
								if newval == artislots then
									artistat:SetTextColor(Color(255,255,255))
								elseif newval > artislots then
									artistat:SetTextColor(Color(54,212,49))
								elseif newval < artislots then
									artistat:SetTextColor(Color(196,0,0))
								end
							end
							
							
							itemleftboxstats:SetTall(itemleftboxstats:GetTall() + h + 10)
							itemleftboxtitles:SetTall(itemleftboxtitles:GetTall() + h + 10)
							
							local whval = 0
							
							local woundhealtitle = itemleftboxtitles:Add("DLabel")
							woundhealtitle:Dock(TOP)
							woundhealtitle:DockMargin(0,0,0,10)
							woundhealtitle:SetFont("stalkerregularfont")
							woundhealtitle:SetText("Wound Heal:")
							
							local woundhealstat = itemleftboxstats:Add("DLabel")
							woundhealstat:Dock(TOP)
							woundhealstat:DockMargin(0,0,0,10)
							woundhealstat:SetFont("stalkerregularfont")
							woundhealstat:SetText(whval)
							woundhealstat:SetName("woundheal")
							woundhealstat.Modify = function(pnl, amount, sign)
								local newval = 0
								
								if sign == "+" then
									newval = tonumber(woundhealstat:GetText()) + amount
								elseif sign == "-" then
									newval = tonumber(woundhealstat:GetText()) - amount
								end
								
								local valcomp = tonumber(whval)
								woundhealstat:SetText(newval)
								
								if newval == valcomp then
									woundhealstat:SetTextColor(Color(255,255,255))
								elseif newval > valcomp then
									woundhealstat:SetTextColor(Color(54,212,49))
								elseif newval < valcomp then
									woundhealstat:SetTextColor(Color(196,0,0))
								end
							end
							
							
							itemleftboxstats:SetTall(itemleftboxstats:GetTall() + h + 10)
							itemleftboxtitles:SetTall(itemleftboxtitles:GetTall() + h + 10)
							
							local healval =  0
							
							local healtitle = itemleftboxtitles:Add("DLabel")
							healtitle:Dock(TOP)
							healtitle:DockMargin(0,0,0,10)
							healtitle:SetFont("stalkerregularfont")
							healtitle:SetText("Healing:")
							
							local healstat = itemleftboxstats:Add("DLabel")
							healstat:Dock(TOP)
							healstat:DockMargin(0,0,0,10)
							healstat:SetFont("stalkerregularfont")
							healstat:SetText(healval)
							healstat:SetName("heal")
							healstat.Modify = function(pnl, amount, sign)
								local newval = 0
								
								if sign == "+" then
									newval = tonumber(healstat:GetText()) + amount
								elseif sign == "-" then
									newval = tonumber(healstat:GetText()) - amount
								end
								
								local valcomp = tonumber(healval)
								healstat:SetText(newval)
								
								if newval == valcomp then
									healstat:SetTextColor(Color(255,255,255))
								elseif newval > valcomp then
									healstat:SetTextColor(Color(54,212,49))
								elseif newval < valcomp then
									healstat:SetTextColor(Color(196,0,0))
								end
							end
							
							
							itemleftboxstats:SetTall(itemleftboxstats:GetTall() + h + 10)
							itemleftboxtitles:SetTall(itemleftboxtitles:GetTall() + h + 10)
							
							local endval = 0
							
							local endtitle = itemleftboxtitles:Add("DLabel")
							endtitle:Dock(TOP)
							endtitle:DockMargin(0,0,0,10)
							endtitle:SetFont("stalkerregularfont")
							endtitle:SetText("Endurance:")
							
							local endstat = itemleftboxstats:Add("DLabel")
							endstat:Dock(TOP)
							endstat:DockMargin(0,0,0,10)
							endstat:SetFont("stalkerregularfont")
							endstat:SetText(endval)
							endstat:SetName("end")
							endstat.Modify = function(pnl, amount, sign)
								local newval = 0
								
								if sign == "+" then
									newval = tonumber(endstat:GetText()) + amount
								elseif sign == "-" then
									newval = tonumber(endstat:GetText()) - amount
								end
								
								local valcomp = tonumber(endval)
								endstat:SetText(newval)
								
								if newval == valcomp then
									endstat:SetTextColor(Color(255,255,255))
								elseif newval > valcomp then
									endstat:SetTextColor(Color(54,212,49))
								elseif newval < valcomp then
									endstat:SetTextColor(Color(196,0,0))
								end
							end
							
							
							itemleftboxstats:SetTall(itemleftboxstats:GetTall() + h + 10)
							itemleftboxtitles:SetTall(itemleftboxtitles:GetTall() + h + 10)
							
							local agival = 0
							
							local agititle = itemleftboxtitles:Add("DLabel")
							agititle:Dock(TOP)
							agititle:DockMargin(0,0,0,10)
							agititle:SetFont("stalkerregularfont")
							agititle:SetText("Agility:")
							
							local agistat = itemleftboxstats:Add("DLabel")
							agistat:Dock(TOP)
							agistat:DockMargin(0,0,0,10)
							agistat:SetFont("stalkerregularfont")
							agistat:SetText(agival)
							agistat:SetName("agi")
							agistat.Modify = function(pnl, amount, sign)
								local newval = 0
								
								if sign == "+" then
									newval = tonumber(agistat:GetText()) + amount
								elseif sign == "-" then
									newval = tonumber(agistat:GetText()) - amount
								end
								
								local valcomp = tonumber(agival)
								agistat:SetText(newval)
								
								if newval == valcomp then
									agistat:SetTextColor(Color(255,255,255))
								elseif newval > valcomp then
									agistat:SetTextColor(Color(54,212,49))
								elseif newval < valcomp then
									agistat:SetTextColor(Color(196,0,0))
								end
							end
							
							
							itemleftboxstats:SetTall(itemleftboxstats:GetTall() + h + 10)
							itemleftboxtitles:SetTall(itemleftboxtitles:GetTall() + h + 10)
							
							local wcval = 0
							
							local wctitle = itemleftboxtitles:Add("DLabel")
							wctitle:Dock(TOP)
							wctitle:DockMargin(0,0,0,10)
							wctitle:SetFont("stalkerregularfont")
							wctitle:SetText("Weight Carry:")
							
							local wcstat = itemleftboxstats:Add("DLabel")
							wcstat:Dock(TOP)
							wcstat:DockMargin(0,0,0,10)
							wcstat:SetFont("stalkerregularfont")
							wcstat:SetText(wcval)
							wcstat:SetName("wcarry")
							wcstat.Modify = function(pnl, amount, sign)
								local newval = 0
								
								if sign == "+" then
									newval = tonumber(wcstat:GetText()) + amount
								elseif sign == "-" then
									newval = tonumber(wcstat:GetText()) - amount
								end
								
								local valcomp = tonumber(wcval)
								wcstat:SetText(newval)
								
								if newval == valcomp then
									wcstat:SetTextColor(Color(255,255,255))
								elseif newval > valcomp then
									wcstat:SetTextColor(Color(54,212,49))
								elseif newval < valcomp then
									wcstat:SetTextColor(Color(196,0,0))
								end
							end
							
							
							itemleftboxstats:SetTall(itemleftboxstats:GetTall() + h + 10)
							itemleftboxtitles:SetTall(itemleftboxtitles:GetTall() + h + 10)
							
							local duraimpval = 0
							
							local duraimptitle = itemleftboxtitles:Add("DLabel")
							duraimptitle:Dock(TOP)
							duraimptitle:DockMargin(0,0,0,10)
							duraimptitle:SetFont("stalkerregularfont")
							duraimptitle:SetText("Dur. Imp.:")
							
							local duraimpstat = itemleftboxstats:Add("DLabel")
							duraimpstat:Dock(TOP)
							duraimpstat:DockMargin(0,0,0,10)
							duraimpstat:SetFont("stalkerregularfont")
							duraimpstat:SetText(duraimpval)
							duraimpstat:SetName("duraimp")
							duraimpstat.Modify = function(pnl, amount, sign)
								local newval = 0
								
								if sign == "+" then
									newval = tonumber(duraimpstat:GetText()) + amount
								elseif sign == "-" then
									newval = tonumber(duraimpstat:GetText()) - amount
								end
								
								local valcomp = tonumber(duraimpval)
								duraimpstat:SetText(newval)
								
								if newval == valcomp then
									duraimpstat:SetTextColor(Color(255,255,255))
								elseif newval > valcomp then
									duraimpstat:SetTextColor(Color(54,212,49))
								elseif newval < valcomp then
									duraimpstat:SetTextColor(Color(196,0,0))
								end
							end
						end -- end SUIT definition
						
						if stats["type"] == "weapon" then
							itemleftboxstats:SetTall(itemleftboxstats:GetTall() + h + 10)
							itemleftboxtitles:SetTall(itemleftboxtitles:GetTall() + h + 10)
							
							local rpmval = stats["rpm"]
							
							local rpmtitle = itemleftboxtitles:Add("DLabel")
							rpmtitle:Dock(TOP)
							rpmtitle:DockMargin(0,0,0,10)
							rpmtitle:SetFont("stalkerregularfont")
							rpmtitle:SetText("RPM:")
							
							local rpmstat = itemleftboxstats:Add("DLabel")
							rpmstat:Dock(TOP)
							rpmstat:DockMargin(0,0,0,10)
							rpmstat:SetFont("stalkerregularfont")
							rpmstat:SetText(rpmval)
							rpmstat:SetName("rpm")
							rpmstat.Modify = function(pnl, amount, sign)
								local newval = 0
								
								if sign == "+" then
									newval = tonumber(rpmstat:GetText()) + amount
								elseif sign == "-" then
									newval = tonumber(rpmstat:GetText()) - amount		
								end
								
								local valcomp = tonumber(rpmval)
								rpmstat:SetText(newval)
								
								if newval == valcomp then
									rpmstat:SetTextColor(Color(255,255,255))
								elseif newval > valcomp then
									rpmstat:SetTextColor(Color(54,212,49))
								elseif newval < valcomp then
									rpmstat:SetTextColor(Color(196,0,0))
								end
							end
							
							
							itemleftboxstats:SetTall(itemleftboxstats:GetTall() + h + 10)
							itemleftboxtitles:SetTall(itemleftboxtitles:GetTall() + h + 10)
							
							local dmgval = stats["dmg"]
							
							local dmgtitle = itemleftboxtitles:Add("DLabel")
							dmgtitle:Dock(TOP)
							dmgtitle:DockMargin(0,0,0,10)
							dmgtitle:SetFont("stalkerregularfont")
							dmgtitle:SetText("Damage:")
							
							local dmgstat = itemleftboxstats:Add("DLabel")
							dmgstat:Dock(TOP)
							dmgstat:DockMargin(0,0,0,10)
							dmgstat:SetFont("stalkerregularfont")
							dmgstat:SetText(dmgval)
							dmgstat:SetName("dmg")
							dmgstat.Modify = function(pnl, amount, sign)
								local newval = 0
								
								if sign == "+" then
									newval = tonumber(dmgstat:GetText()) + amount
								elseif sign == "-" then
									newval = tonumber(dmgstat:GetText()) - amount		
								end
								
								local valcomp = tonumber(dmgval)
								dmgstat:SetText(newval)
								
								if newval == valcomp then
									dmgstat:SetTextColor(Color(255,255,255))
								elseif newval > valcomp then
									dmgstat:SetTextColor(Color(54,212,49))
								elseif newval < valcomp then
									dmgstat:SetTextColor(Color(196,0,0))
								end
							end
							
							
							itemleftboxstats:SetTall(itemleftboxstats:GetTall() + h + 10)
							itemleftboxtitles:SetTall(itemleftboxtitles:GetTall() + h + 10)
							
							local velval = stats["vel"]
							
							local veltitle = itemleftboxtitles:Add("DLabel")
							veltitle:Dock(TOP)
							veltitle:DockMargin(0,0,0,10)
							veltitle:SetFont("stalkerregularfont")
							veltitle:SetText("Velocity:")
							
							local velstat = itemleftboxstats:Add("DLabel")
							velstat:Dock(TOP)
							velstat:DockMargin(0,0,0,10)
							velstat:SetFont("stalkerregularfont")
							velstat:SetText(velval)
							velstat:SetName("vel")
							velstat.Modify = function(pnl, amount, sign)
								local newval = 0
								
								if sign == "+" then
									newval = tonumber(velstat:GetText()) + amount
								elseif sign == "-" then
									newval = tonumber(velstat:GetText()) - amount		
								end
								
								local valcomp = tonumber(velval)
								velstat:SetText(newval)
								
								if newval == valcomp then
									velstat:SetTextColor(Color(255,255,255))
								elseif newval > valcomp then
									velstat:SetTextColor(Color(54,212,49))
								elseif newval < valcomp then
									velstat:SetTextColor(Color(196,0,0))
								end
							end
							
							
							itemleftboxstats:SetTall(itemleftboxstats:GetTall() + h + 10)
							itemleftboxtitles:SetTall(itemleftboxtitles:GetTall() + h + 10)
							
							local magval = stats["mag"]
							
							local magtitle = itemleftboxtitles:Add("DLabel")
							magtitle:Dock(TOP)
							magtitle:DockMargin(0,0,0,10)
							magtitle:SetFont("stalkerregularfont")
							magtitle:SetText("Mag Size:")
							
							local magstat = itemleftboxstats:Add("DLabel")
							magstat:Dock(TOP)
							magstat:DockMargin(0,0,0,10)
							magstat:SetFont("stalkerregularfont")
							magstat:SetText(magval)
							magstat:SetName("mag")
							magstat.Modify = function(pnl, amount, sign)
								local newval = 0
								
								if sign == "+" then
									newval = tonumber(magstat:GetText()) + amount
								elseif sign == "-" then
									newval = tonumber(magstat:GetText()) - amount		
								end
								
								local valcomp = tonumber(magval)
								magstat:SetText(newval)
								
								if newval == valcomp then
									magstat:SetTextColor(Color(255,255,255))
								elseif newval > valcomp then
									magstat:SetTextColor(Color(54,212,49))
								elseif newval < valcomp then
									magstat:SetTextColor(Color(196,0,0))
								end
							end
						end
						
						-- Stats that apply to ALL items go here
						
						itemleftboxstats:SetTall(itemleftboxstats:GetTall() + h + 10)
						itemleftboxtitles:SetTall(itemleftboxtitles:GetTall() + h + 10)
						
						local weight = stats["weight"]
						
						local weighttitle = itemleftboxtitles:Add("DLabel")
						weighttitle:Dock(TOP)
						weighttitle:DockMargin(0,0,0,10)
						weighttitle:SetFont("stalkerregularfont")
						weighttitle:SetText("Weight:")
						
						local weightstat = itemleftboxstats:Add("DLabel")
						weightstat:Dock(TOP)
						weightstat:DockMargin(0,0,0,10)
						weightstat:SetFont("stalkerregularfont")
						weightstat:SetText(weight)
						weightstat:SetName("weight")
						weightstat.Modify = function(pnl, amount, sign)
							local newval = 0
							
							if sign == "+" then
								newval = tonumber(weightstat:GetText()) + amount
							elseif sign == "-" then
								newval = tonumber(weightstat:GetText()) - amount
							end
							
							local valcomp = tonumber(weight)
							weightstat:SetText(newval)
							
							if newval == valcomp then
								weightstat:SetTextColor(Color(255,255,255))
							elseif newval < valcomp then
								weightstat:SetTextColor(Color(54,212,49))
							elseif newval > valcomp then
								weightstat:SetTextColor(Color(196,0,0))
							end
						end
					end
					
					table.sort(data, function(a,b)
						if a.row < b.row then
							return true
						elseif a.row == b.row and a.pos < b.pos then
							return true
						else
							return false
						end
					end)
					
					local lastpos = 0
					local lastrow = 0
					
					for k,v in ipairs(data) do
						lastpos = v.pos
					end
					
					for k,v in ipairs(data) do
						lastrow = v.row
					end
					
					for i = 1, lastpos do
						
						local upgradeouterbox = hscroller:Add("DPanel")
						upgradeouterbox:Dock(LEFT)
						upgradeouterbox:SetWidth(Scale1080(100,0))
						upgradeouterbox:SetDrawBackground(false)
						upgradeouterbox:SetPaintBackground(false)
						upgradeouterbox:SetMouseInputEnabled(true)
						
						for _,upgs in ipairs(data) do
							if upgs.pos == i and not upgs.done then
								if i == 1 then
									hscroller.AdjSize = (hscroller.AdjSize + Scale1080(0,150))
									if hscroller:GetTall() < hscroller.AdjSize then
										hscroller:SetTall(hscroller.AdjSize)
									end
								end
								
								upgs.done = true
								
								local lastrow = 0
								local row = upgs.row
								local topmargin = 30
								
								if upgradeouterbox:HasChildren() then
									for k,v in pairs(upgradeouterbox:GetChildren()) do
										if v.Row > lastrow then
											lastrow = v.Row
										end
									end
								end
								
								if (row - 1) ~= lastrow and row > lastrow then
									topmargin = (105 * (row - lastrow))
								end
								
								local upgradebox = upgradeouterbox:Add("DPanel")
								upgradebox:Dock(TOP)
								upgradebox:DockMargin(0,topmargin,0,0)
								upgradebox:SetSize(Scale1080(100,100))
								upgradebox:SetDrawBackground(false)
								upgradebox:SetPaintBackground(false)
								upgradebox.Row = upgs.row
								
								local upgrade = upgradebox:Add("DImageButton")
								upgrade:SetImage(BasicUpgTable[upgs.name].img)
								upgrade:SetSize(Scale1080(90,44))
								upgrade:SetName(upgs.name)
								upgrade.Selected = false
								upgrade.Installed = false
								upgrade.Blocked = false
								upgrade.Blocks = upgs.blocks
								upgrade.Dependencies = upgs.dep
								upgrade:SetHelixTooltip(function(tooltip)
									local upgtable = BasicUpgTable[upgs.name]
									
									local title = tooltip:AddRow("title")
									title:SetImportant()
									title:SetText(BasicUpgTable[upgs.name].name) -- desc
									title:SetBackgroundColor(ix.config.Get("color"))
									title:SizeToContents()
									
									local description = tooltip:AddRow("description")
									description:SetText(upgtable.desc)
									description:SizeToContents()
									
									for key,ename in pairs(upgtable.enames) do
										local stats = tooltip:AddRow("stats")
										
										if isnumber(upgs.amounts[key]) then
											if upgs.amounts[key] > 0 then
												if ename == "body" then
													stats:SetText("Body AP: " .. "+" .. upgs.amounts[key])
												elseif ename == "limb" then
													stats:SetText("Limb AP: " .. "+" .. upgs.amounts[key])
												elseif ename == "artislots" then
													stats:SetText("Artifact Slots: ".. "+" .. upgs.amounts[key])
												elseif ename == "woundheal" then
													stats:SetText("Wound Healing: ".. "+" .. upgs.amounts[key])
												elseif ename == "weight" then
													stats:SetText("Weight: ".. "+" .. upgs.amounts[key])
												elseif ename == "agi" then
													stats:SetText("Agility: " .. "+" .. upgs.amounts[key])
												elseif ename == "heal" then
													stats:SetText("Healing: ".. "+" .. upgs.amounts[key])
												elseif ename == "wcarry" then
													stats:SetText("Carry Limit: " .. "+" .. upgs.amounts[key])
												elseif ename == "end" then
													stats:SetText("Endurance: " .. "+" .. upgs.amounts[key])
												elseif ename == "Fall" then
													stats:SetText("Impact: " .. "+" .. upgs.amounts[key])
												elseif ename == "duraimp" then
													stats:SetText("Dura. Improvement: " .. "+" .. upgs.amounts[key])
												else
													stats:SetText(ename..": +"..upgs.amounts[key])
												end
											else
												if ename == "body" then
													stats:SetText("Body AP: " .. upgs.amounts[key])
												elseif ename == "limb" then
													stats:SetText("Limb AP: " .. upgs.amounts[key])
												elseif ename == "artislots" then
													stats:SetText("Artifact Slots: ".. upgs.amounts[key])
												elseif ename == "woundheal" then
													stats:SetText("Wound Healing: " .. upgs.amounts[key])
												elseif ename == "weight" then
													stats:SetText("Weight: " .. upgs.amounts[key])
												elseif ename == "agi" then
													stats:SetText("Agility: " .. upgs.amounts[key])
												elseif ename == "heal" then
													stats:SetText("Healing: " .. upgs.amounts[key])
												elseif ename == "wcarry" then
													stats:SetText("Carry Limit: " .. upgs.amounts[key])
												elseif ename == "end" then
													stats:SetText("Endurance: " .. upgs.amounts[key])
												elseif ename == "Fall" then
													stats:SetText("Impact: " .. upgs.amounts[key])
												elseif ename == "duraimp" then
													stats:SetText("Dura. Improvement: " .. upgs.amounts[key])
												else
													stats:SetText(ename..": "..upgs.amounts[key])
												end
											end
										elseif isstring(upgs.amounts[key]) then
											if string.match(upgs.amounts[key],"/") then
												stats:SetText("Rate of Fire: "..upgs.amounts[key])
											elseif string.match(upgs.amounts[key],"+") then
												stats:SetText("Damage Change: "..upgs.amounts[key])
											end
										end
										stats:SizeToContents()
									end
								end)
								
								local enames = BasicUpgTable[upgs.name].enames
								local pnlname = upgs.name
								local amnts = upgs.amounts
								
								netstream.Start("isupginstalled", self.itemID, enames, pnlname, amnts)
								netstream.Hook("upginstalled", function(names, panelname, amounts, enames)
									local panel
									
									if hscroller:HasChildren() then
										for _,upgoutbox in ipairs(hscroller:GetChildren()) do
											for _,upgbox in ipairs(upgoutbox:GetChildren()) do
												for _,v in ipairs(upgbox:GetChildren()) do
													if v:GetName() == panelname then
														panel = v
													end
												end
											end
										end
									end
									
									if panel then
										if istable(names) then
											for _,name in pairs(names) do
												local upgname = BasicUpgTable[panelname].name
												if name == upgname then
													for key,ename in pairs(enames) do
														if amounts[key] ~= 0 then
															if itemrightboxstats:HasChildren() then
																for _,child in pairs(itemrightboxstats:GetChildren()) do
																	if child:GetName() == ename then
																		child:Modify(amounts[key], "+")
																	end
																end
															end
															if itemleftboxstats:HasChildren() then
																for _,child in pairs(itemleftboxstats:GetChildren()) do
																	if child:GetName() == ename then
																		child:Modify(amounts[key], "+")
																	end
																end
															end
														end
														amounts[key] = 0
													end
													panel.Installed = true
												end
											end
										end
										
										if panel.Blocks then
											for _,upgoutbox in pairs(hscroller:GetChildren()) do
												for _,upgbox in pairs(upgoutbox:GetChildren()) do
													for _,upgr in pairs(upgbox:GetChildren()) do
														for _,block in pairs(panel.Blocks) do
															if upgr:GetName() == block and not upgr.Installed and panel.Installed then
																upgr.Blocked = true
															end
														end
													end
												end
											end
										end
									end
								end)
								
								timer.Simple(0.5, function()
									if upgrade.Installed and not upgrade.Blocked then
										local hoverinst = upgrade:Add("DImage")
										hoverinst:SetSize(Scale1080(6,38))
										hoverinst:Dock(LEFT)
										hoverinst:DockMargin(2,1,0,2)
										hoverinst:SetImage("stalker/ui/upgrade/install.png")
										hoverinst.Installed = true
									end
												
									if upgrade.Blocked and not upgrade.Installed then
										local hoverblock = upgrade:Add("DImage")
										hoverblock:SetSize(Scale1080(6,38))
										hoverblock:Dock(LEFT)
										hoverblock:DockMargin(2,1,0,2)
										hoverblock:SetImage("stalker/ui/upgrade/denied.png")
										hoverblock.Installed = true
									end
								end)
								
								upgrade.OnMouseHover = function()
									
									if upgrade.Blocked then return end
									
									local alreadyexists = false
									local installed = false
									
									if upgrade:GetChildren() then
										for _,pan in pairs(upgrade:GetChildren()) do
											if pan.IsOverlay then
												alreadyexists = true
											end
											
											if pan.Installed then
												installed = true
											end
										end
									end
									
									if not alreadyexists then
									
										local modify = "not installed"
										
										if installed then
											for _,pan in pairs(upgrade:GetChildren()) do
												if pan.Installed then
													pan:Remove()
													modify = "installed"
												end
											end
										end
										
										local hover = upgrade:Add("DImage")
										hover:SetSize(Scale1080(6,38))
										hover:Dock(LEFT)
										hover:DockMargin(2,1,0,2)
										hover:SetImage("stalker/ui/upgrade/select.png")
										hover.IsOverlay = true
										hover.Installed = installed
										if itemrightboxstats:GetChildren() then
											for _,pan in pairs(itemrightboxstats:GetChildren()) do
												for key,ename in pairs(BasicUpgTable[upgs.name].enames) do
													if pan:GetName() == ename then
														if modify == "not installed" then
															pan:Modify(upgs.amounts[key], "+")
														elseif modify == "installed" then
															pan:Modify(upgs.amounts[key], "-")
														end
													end
												end
											end
										end
											
										if itemleftboxstats:GetChildren() then
											for _,pan in pairs(itemleftboxstats:GetChildren()) do
												for key,ename in pairs(BasicUpgTable[upgs.name].enames) do
													if pan:GetName() == ename then
														if modify == "not installed" then
															pan:Modify(upgs.amounts[key], "+")
														elseif modify == "installed" then
															pan:Modify(upgs.amounts[key], "-")
														end
													end
												end
											end
										end
									end
								end
								
								upgrade.OnMouseLeave = function()
									if not upgrade.Selected and not upgrade.Blocked then
										local installed = false
										local modify = "not installed"
										
										if upgrade:GetChildren() then
											for _,pan in pairs(upgrade:GetChildren()) do
												if pan.IsOverlay then 
													pan:Remove()
													if pan.Installed then
														installed = true
														modify = "installed"
													end
												end
											end
										end
										
										if installed then
											local hoverinst = upgrade:Add("DImage")
											hoverinst:SetSize(Scale1080(6,38))
											hoverinst:Dock(LEFT)
											hoverinst:DockMargin(2,1,0,2)
											hoverinst:SetImage("stalker/ui/upgrade/install.png")
											hoverinst.Installed = true
										end
										
										if itemrightboxstats:GetChildren() then
											for _,pan in pairs(itemrightboxstats:GetChildren()) do
												for key,ename in pairs(BasicUpgTable[upgs.name].enames) do
													if pan:GetName() == ename then
														if modify == "not installed" then
															pan:Modify(upgs.amounts[key], "-")
														elseif modify == "installed" then
															pan:Modify(upgs.amounts[key], "+")
														end
													end
												end
											end
										end
										
										if itemleftboxstats:GetChildren() then
											for _,pan in pairs(itemleftboxstats:GetChildren()) do
												for key,ename in pairs(BasicUpgTable[upgs.name].enames) do
													if pan:GetName() == ename then
														if modify == "not installed" then
															pan:Modify(upgs.amounts[key], "-")
														elseif modify == "installed" then
															pan:Modify(upgs.amounts[key], "+")
														end
													end
												end
											end
										end
									end
								end
								
								upgrade.DoClick = function()
									
									if upgrade.Blocked then 
										return 
									end
									
									for name,info in pairs(upgrades) do
										for _,upgoutbox in pairs(hscroller:GetChildren()) do
											for _,upgbox in pairs(upgoutbox:GetChildren()) do
												for _,upgr in pairs(upgbox:GetChildren()) do
													if istable(upgr.Blocks) then
														if upgr.Selected or upgr.Installed then
															for _,blocks in pairs(upgr.Blocks) do
																if upgs.name == blocks then
																	LocalPlayer():Notify("Cannot Select Exclusive")
																	return
																end
															end
														end
													end
												end
											end
										end
									end
									
									local singlefail = false
									
									if upgs.dep[1] ~= "none" then
										for _,upgoutbox in pairs(hscroller:GetChildren()) do
											for _,upgbox in pairs(upgoutbox:GetChildren()) do
												for _,upgr in pairs(upgbox:GetChildren()) do
													for _,dep in pairs(upgs.dep) do
														
														local alt = false
														local strtable
														
														if string.match(dep, " or ") then
															alt = true
															strtable = string.Split(dep, " or ")
														end
														
														local installed = false
														
														if strtable and alt then
															for _,dname in pairs(strtable) do
																if dname == upgr:GetName() and not upgr.Installed then
																	for k,v in pairs(upgrades) do
																		if k == upgr:GetName() then
																			installed = true
																		end
																	end
																	
																	if singlefail and not installed then
																		singlefail = false
																		LocalPlayer():Notify("1: Must Select one of Previous Upgrades First")
																		return
																	end
																	
																	if not installed then
																		singlefail = true
																	end
																end
															end
														else
															if dep == upgr:GetName() and not upgr.Installed then
																for k,v in pairs(upgrades) do
																	if k == dep then
																		installed = true
																	end
																end
																
																if not installed then
																	LocalPlayer():Notify("2: Must Select Previous Upgrade First")
																	return
																end
															end
														end
													end
												end
											end
										end
									end
									
									if upgrade.Selected then
										if upgrade.Installed then
											for _,upgoutbox in pairs(hscroller:GetChildren()) do
												for _,upgbox in pairs(upgoutbox:GetChildren()) do
													for _,upgr in pairs(upgbox:GetChildren()) do
														if istable(upgrade.Dependencies) then
															for _,dep in pairs(upgrade.Dependencies) do
																if dep ~= "none" then
																	if upgr.Selected then
																		local alt = false
																		local strtable
																		
																		if string.match(dep, " or ") then
																			alt = true
																			strtable = string.Split(dep, " or ")
																		end
																		
																		if strtable and alt then
																			for k,v in pairs(strtable) do
																				if v == upgr:GetName() then
																					LocalPlayer():Notify("1: Check Upgrades Prior")
																					return
																				end
																			end
																		else
																			if dep == upgr:GetName() then
																				LocalPlayer():Notify("2: Check Upgrades Prior")
																				return
																			end
																		end
																	end
																end
															end
														end
													end
												end
											end
										else
											for _,upgoutbox in pairs(hscroller:GetChildren()) do
												for _,upgbox in pairs(upgoutbox:GetChildren()) do
													for _,upgr in pairs(upgbox:GetChildren()) do
														if istable(upgr.Dependencies) then
															for _,dep in pairs(upgr.Dependencies) do
																if dep ~= "none" then
																	if upgr.Selected then
																		local alt = false
																		local strtable
																		
																		if string.match(dep, " or ") then
																			alt = true
																			strtable = string.Split(dep, " or ")
																		end
																		
																		if strtable and alt then
																			for k,v in pairs(strtable) do
																				if v == upgrade:GetName() then
																					LocalPlayer():Notify("1: Check Upgrades Ahead")
																					return
																				end
																			end
																		else
																			if dep == upgrade:GetName() then
																				LocalPlayer():Notify("2: Check Upgrades Ahead")
																				return
																			end
																		end
																	end
																end
															end
														end
													end
												end
											end
										end
										
										if not upgrade.Installed then
											priceval:Modify(BasicUpgTable[upgs.name].price, "-")
										end
										
										upgrade.Selected = false
										upgrades[upgs.name] = nil
									else
										
										local fail1 = false
										
										for _,upgoutbox in pairs(hscroller:GetChildren()) do
											for _,upgbox in pairs(upgoutbox:GetChildren()) do
												for _,upgr in pairs(upgbox:GetChildren()) do
													if istable(upgr.Dependencies) then
														for _,dep in pairs(upgr.Dependencies) do
															if dep ~= "none" then
																if upgr.Installed and not upgr.Selected and not upgr.Blocked then
																	local alt = false
																	local strtable
																	
																	if string.match(dep, " or ") then
																		alt = true
																		strtable = string.Split(dep, " or ")
																	end
																	
																	if strtable and alt then
																		for k,v in pairs(strtable) do
																			if v == upgrade:GetName() then
																				LocalPlayer():Notify("1: Check Upgrades Ahead")
																				return
																			end
																		end
																	else
																		if dep == upgrade:GetName() then
																			LocalPlayer():Notify("2: Check Upgrades Ahead")
																			return
																		end
																	end
																end
															end
														end
													end
												end
											end
										end
										
										if not upgrade.Installed then
											priceval:Modify(BasicUpgTable[upgs.name].price, "+")
										end
										
										upgrade.Selected = true
										
										local upgtab = BasicUpgTable[upgs.name]
										upgtab["amounts"] = upgs.amounts
										upgtab["name"] = upgs.name
										upgrades[upgs.name] = upgtab
									end
								end
								
								upgrade.Paint = function(panel, width, height)
									local mouseX, mouseY = gui.MousePos()
									local x,y = upgrade:LocalToScreen(0,0)
									
									if (mouseX >= x and mouseX <= x + width and
										mouseY >= y and mouseY <= y + height) then
										if !upgrade.bHovered then
											upgrade.bHovered = true
											upgrade:OnMouseHover()
										end
									elseif upgrade.bHovered then
										upgrade.bHovered = false
										upgrade:OnMouseLeave()
									end
								end
								
								if upgs.adjacent == nil then
									upgrade:Center()
								else
									upgrade:Dock(TOP)
									upgrade:DockMargin(5,3,5,3)
									
									for _,upgs2 in ipairs(data) do
										if upgs2.pos == i and not upgs2.done then
											for _,name in ipairs(upgs.adjacent) do
												if name == upgs2.name then
													local upgrade2 = upgradebox:Add("DImageButton")
													upgrade2:SetImage(BasicUpgTable[upgs2.name].img)
													upgrade2:SetSize(Scale1080(90,44))
													upgrade2:Dock(TOP)
													upgrade2:DockMargin(5,3,5,3)
													upgrade2:SetName(upgs2.name)
													
													upgrade2.Selected = false
													upgrade2.Installed = false
													upgrade2.Blocked = false
													upgrade2.Blocks = upgs2.blocks
													upgrade2.Dependencies = upgs2.dep
													upgs2.done = true
													
													upgrade2:SetHelixTooltip(function(tooltip)
														local upgtable = BasicUpgTable[upgs2.name]
														
														local title = tooltip:AddRow("title")
														title:SetImportant()
														title:SetText(BasicUpgTable[upgs2.name].name) -- desc
														title:SetBackgroundColor(ix.config.Get("color"))
														title:SizeToContents()
														
														local description = tooltip:AddRow("description")
														description:SetText(upgtable.desc)
														description:SizeToContents()
														
														for key,ename in pairs(upgtable.enames) do
															local stats = tooltip:AddRow("stats")
															
															if isnumber(upgs2.amounts[key]) then
																if upgs2.amounts[key] > 0 then
																	if ename == "body" then
																		stats:SetText("Body AP: " .. "+" .. upgs2.amounts[key])
																	elseif ename == "limb" then
																		stats:SetText("Limb AP: " .. "+" .. upgs2.amounts[key])
																	elseif ename == "artislots" then
																		stats:SetText("Artifact Slots: ".. "+" .. upgs2.amounts[key])
																	elseif ename == "woundheal" then
																		stats:SetText("Wound Healing: ".. "+" .. upgs2.amounts[key])
																	elseif ename == "weight" then
																		stats:SetText("Weight: ".. "+" .. upgs2.amounts[key])
																	elseif ename == "agi" then
																		stats:SetText("Agility: " .. "+" .. upgs2.amounts[key])
																	elseif ename == "heal" then
																		stats:SetText("Healing: ".. "+" .. upgs2.amounts[key])
																	elseif ename == "wcarry" then
																		stats:SetText("Carry Limit: " .. "+" .. upgs2.amounts[key])
																	elseif ename == "end" then
																		stats:SetText("Endurance: " .. "+" .. upgs2.amounts[key])
																	elseif ename == "Fall" then
																		stats:SetText("Impact: " .. "+" .. upgs2.amounts[key])
																	elseif ename == "duraimp" then
																		stats:SetText("Dura. Improvement: " .. "+" .. upgs2.amounts[key])
																	else
																		stats:SetText(ename..": +"..upgs2.amounts[key])
																	end
																else
																	if ename == "body" then
																		stats:SetText("Body AP: " .. upgs2.amounts[key])
																	elseif ename == "limb" then
																		stats:SetText("Limb AP: " .. upgs2.amounts[key])
																	elseif ename == "artislots" then
																		stats:SetText("Artifact Slots: ".. upgs2.amounts[key])
																	elseif ename == "woundheal" then
																		stats:SetText("Wound Healing: " .. upgs2.amounts[key])
																	elseif ename == "weight" then
																		stats:SetText("Weight: " .. upgs2.amounts[key])
																	elseif ename == "agi" then
																		stats:SetText("Agility: " .. upgs2.amounts[key])
																	elseif ename == "heal" then
																		stats:SetText("Healing: " .. upgs2.amounts[key])
																	elseif ename == "wcarry" then
																		stats:SetText("Carry Limit: " .. upgs2.amounts[key])
																	elseif ename == "end" then
																		stats:SetText("Endurance: " .. upgs2.amounts[key])
																	elseif ename == "Fall" then
																		stats:SetText("Impact: " .. upgs2.amounts[key])
																	elseif ename == "duraimp" then
																		stats:SetText("Dura. Improvement: " .. upgs2.amounts[key])
																	else
																		stats:SetText(ename..": "..upgs2.amounts[key])
																	end
																end
															elseif isstring(upgs2.amounts[key]) then
																if string.match(upgs2.amounts[key],"/") then
																	stats:SetText("Rate of Fire: "..upgs2.amounts[key])
																elseif string.match(upgs2.amounts[key],"+") then
																	stats:SetText("Damage Change: "..upgs2.amounts[key])
																end
															end
															stats:SizeToContents()
														end
													end)
													
													local enames2 = BasicUpgTable[upgs2.name].enames
													local pnlname2 = upgs2.name
													local amnt2 = upgs2.amounts
													
													netstream.Start("isupginstalled", self.itemID, enames2, pnlname2, amnt2)
													
													timer.Simple(0.5, function()
														if upgrade2.Installed and not upgrade2.Blocked then
															local hoverinst2 = upgrade2:Add("DImage")
															hoverinst2:SetSize(Scale1080(6,38))
															hoverinst2:Dock(LEFT)
															hoverinst2:DockMargin(2,1,0,2)
															hoverinst2:SetImage("stalker/ui/upgrade/install.png")
															hoverinst2.Installed = true
														end
																	
														if upgrade2.Blocked and not upgrade2.Installed then
															local hoverblock2 = upgrade2:Add("DImage")
															hoverblock2:SetSize(Scale1080(6,38))
															hoverblock2:Dock(LEFT)
															hoverblock2:DockMargin(2,1,0,2)
															hoverblock2:SetImage("stalker/ui/upgrade/denied.png")
															hoverblock2.Installed = true
														end
													end)
													
													upgrade2.OnMouseHover = function()
									
														if upgrade2.Blocked then return end
														
														local alreadyexists = false
														local installed = false
														
														if upgrade2:GetChildren() then
															for _,pan in pairs(upgrade2:GetChildren()) do
																if pan.IsOverlay then
																	alreadyexists = true
																end
																
																if pan.Installed then
																	installed = true
																end
															end
														end
														
														if not alreadyexists then
														
															local modify = "not installed"
															
															if installed then
																for _,pan in pairs(upgrade2:GetChildren()) do
																	if pan.Installed then
																		pan:Remove()
																		modify = "installed"
																	end
																end
															end
															
															local hover = upgrade2:Add("DImage")
															hover:SetSize(Scale1080(6,38))
															hover:Dock(LEFT)
															hover:DockMargin(2,1,0,2)
															hover:SetImage("stalker/ui/upgrade/select.png")
															hover.IsOverlay = true
															hover.Installed = installed
															if itemrightboxstats:GetChildren() then
																for _,pan in pairs(itemrightboxstats:GetChildren()) do
																	for key,ename in pairs(BasicUpgTable[upgs2.name].enames) do
																		if pan:GetName() == ename then
																			if modify == "not installed" then
																				pan:Modify(upgs2.amounts[key], "+")
																			elseif modify == "installed" then
																				pan:Modify(upgs2.amounts[key], "-")
																			end
																		end
																	end
																end
															end
															
															if itemleftboxstats:GetChildren() then
																for _,pan in pairs(itemleftboxstats:GetChildren()) do
																	for key,ename in pairs(BasicUpgTable[upgs2.name].enames) do
																		if pan:GetName() == ename then
																			if modify == "not installed" then
																				pan:Modify(upgs2.amounts[key], "+")
																			elseif modify == "installed" then
																				pan:Modify(upgs2.amounts[key], "-")
																			end
																		end
																	end
																end
															end
														end
													end
													
													upgrade2.OnMouseLeave = function()
														if not upgrade2.Selected and not upgrade2.Blocked then
															local installed = false
															local modify = "not installed"
															
															if upgrade2:GetChildren() then
																for _,pan in pairs(upgrade2:GetChildren()) do
																	if pan.IsOverlay then 
																		pan:Remove()
																		if pan.Installed then
																			installed = true
																			modify = "installed"
																		end
																	end
																end
															end
															
															if installed then
																local hoverinst = upgrade2:Add("DImage")
																hoverinst:SetSize(Scale1080(6,38))
																hoverinst:Dock(LEFT)
																hoverinst:DockMargin(2,1,0,2)
																hoverinst:SetImage("stalker/ui/upgrade/install.png")
																hoverinst.Installed = true
															end
														
															if itemrightboxstats:GetChildren() then
																for _,pan in pairs(itemrightboxstats:GetChildren()) do
																	for key,ename in pairs(BasicUpgTable[upgs2.name].enames) do
																		if pan:GetName() == ename then
																			if modify == "not installed" then
																				pan:Modify(upgs2.amounts[key], "-")
																			elseif modify == "installed" then
																				pan:Modify(upgs2.amounts[key], "+")
																			end
																		end
																	end
																end
															end
															
															if itemleftboxstats:GetChildren() then
																for _,pan in pairs(itemleftboxstats:GetChildren()) do
																	for key,ename in pairs(BasicUpgTable[upgs2.name].enames) do
																		if pan:GetName() == ename then
																			if modify == "not installed" then
																				pan:Modify(upgs2.amounts[key], "-")
																			elseif modify == "installed" then
																				pan:Modify(upgs2.amounts[key], "+")
																			end
																		end
																	end
																end
															end
														end
													end
													
													upgrade2.DoClick = function()
									
														if upgrade2.Blocked then 
															return 
														end
														
														for name,info in pairs(upgrades) do
															for _,upgoutbox in pairs(hscroller:GetChildren()) do
																for _,upgbox in pairs(upgoutbox:GetChildren()) do
																	for _,upgr in pairs(upgbox:GetChildren()) do
																		if istable(upgr.Blocks) then
																			if upgr.Selected or upgr.Installed then
																				for _,blocks in pairs(upgr.Blocks) do
																					if upgs2.name == blocks then
																						LocalPlayer():Notify("Cannot Select Exclusive")
																						return
																					end
																				end
																			end
																		end
																	end
																end
															end
														end
														
														local singlefail = false
														
														if upgs2.dep[1] ~= "none" then
															for _,upgoutbox in pairs(hscroller:GetChildren()) do
																for _,upgbox in pairs(upgoutbox:GetChildren()) do
																	for _,upgr in pairs(upgbox:GetChildren()) do
																		for _,dep in pairs(upgs2.dep) do
																			
																			local alt = false
																			local strtable
																			
																			if string.match(dep, " or ") then
																				alt = true
																				strtable = string.Split(dep, " or ")
																			end
																			
																			local installed = false
																			
																			if strtable and alt then
																				for _,dname in pairs(strtable) do
																					if dname == upgr:GetName() and not upgr.Installed then
																						for k,v in pairs(upgrades) do
																							if k == upgr:GetName() then
																								installed = true
																							end
																						end
																						
																						if singlefail and not installed then
																							singlefail = false
																							LocalPlayer():Notify("1: Must Select one of Previous Upgrades First")
																							return
																						end
																						
																						if not installed then
																							singlefail = true
																						end
																					end
																				end
																			else
																				if dep == upgr:GetName() and not upgr.Installed then
																					for k,v in pairs(upgrades) do
																						if k == dep then
																							installed = true
																						end
																					end
																					
																					if not installed then
																						LocalPlayer():Notify("2: Must Select Previous Upgrade First")
																						return
																					end
																				end
																			end
																		end
																	end
																end
															end
														end
														
														if upgrade2.Selected then
															if upgrade2.Installed then
																for _,upgoutbox in pairs(hscroller:GetChildren()) do
																	for _,upgbox in pairs(upgoutbox:GetChildren()) do
																		for _,upgr in pairs(upgbox:GetChildren()) do
																			if istable(upgrade2.Dependencies) then
																				for _,dep in pairs(upgrade2.Dependencies) do
																					if dep ~= "none" then
																						if upgr.Selected then
																							local alt = false
																							local strtable
																							
																							if string.match(dep, " or ") then
																								alt = true
																								strtable = string.Split(dep, " or ")
																							end
																							
																							if strtable and alt then
																								for k,v in pairs(strtable) do
																									if v == upgr:GetName() then
																										LocalPlayer():Notify("1: Check Upgrades Prior")
																										return
																									end
																								end
																							else
																								if dep == upgr:GetName() then
																									LocalPlayer():Notify("2: Check Upgrades Prior")
																									return
																								end
																							end
																						end
																					end
																				end
																			end
																		end
																	end
																end
															else
																for _,upgoutbox in pairs(hscroller:GetChildren()) do
																	for _,upgbox in pairs(upgoutbox:GetChildren()) do
																		for _,upgr in pairs(upgbox:GetChildren()) do
																			if istable(upgr.Dependencies) then
																				for _,dep in pairs(upgr.Dependencies) do
																					if dep ~= "none" then
																						if upgr.Selected then
																							local alt = false
																							local strtable
																							
																							if string.match(dep, " or ") then
																								alt = true
																								strtable = string.Split(dep, " or ")
																							end
																							
																							if strtable and alt then
																								for k,v in pairs(strtable) do
																									if v == upgrade2:GetName() then
																										LocalPlayer():Notify("1: Check Upgrades Ahead")
																										return
																									end
																								end
																							else
																								if dep == upgrade2:GetName() then
																									LocalPlayer():Notify("2: Check Upgrades Ahead")
																									return
																								end
																							end
																						end
																					end
																				end
																			end
																		end
																	end
																end
															end
															
															if not upgrade2.Installed then
																priceval:Modify(BasicUpgTable[upgs2.name].price, "-")
															end
															
															upgrade2.Selected = false
															upgrades[upgs2.name] = nil
														else
															
															local fail1 = false
															
															for _,upgoutbox in pairs(hscroller:GetChildren()) do
																for _,upgbox in pairs(upgoutbox:GetChildren()) do
																	for _,upgr in pairs(upgbox:GetChildren()) do
																		if istable(upgr.Dependencies) then
																			for _,dep in pairs(upgr.Dependencies) do
																				if dep ~= "none" then
																					if upgr.Installed and not upgr.Selected and not upgr.Blocked then
																						local alt = false
																						local strtable
																						
																						if string.match(dep, " or ") then
																							alt = true
																							strtable = string.Split(dep, " or ")
																						end
																						
																						if strtable and alt then
																							for k,v in pairs(strtable) do
																								if v == upgrade2:GetName() then
																									LocalPlayer():Notify("1: Check Upgrades Ahead")
																									return
																								end
																							end
																						else
																							if dep == upgrade2:GetName() then
																								LocalPlayer():Notify("2: Check Upgrades Ahead")
																								return
																							end
																						end
																					end
																				end
																			end
																		end
																	end
																end
															end
															
															if not upgrade2.Installed then
																priceval:Modify(BasicUpgTable[upgs2.name].price, "+")
															end
															
															upgrade2.Selected = true
															local upgtab = BasicUpgTable[upgs2.name]
															upgtab["amounts"] = upgs2.amounts
															upgtab["name"] = upgs2.name
															upgrades[upgs2.name] = upgtab
														end
													end
																		
													upgrade2.Paint = function(panel, width, height)
														local mouseX, mouseY = gui.MousePos()
														local x,y = upgrade2:LocalToScreen(0,0)
														
														if (mouseX >= x and mouseX <= x + width and
															mouseY >= y and mouseY <= y + height) then
															if !upgrade2.bHovered then
																upgrade2.bHovered = true
																upgrade2:OnMouseHover()
															end
														elseif upgrade2.bHovered then
															upgrade2.bHovered = false
															upgrade2:OnMouseLeave()
														end
													end
												end
											end
										end
									end
								end
							end
						end
						upgradeouterbox:SizeToContentsY()
					end
				end)
			end
		end)
		
		netstream.Hook("upgradeschanged", function()
			self:Remove()
		end)
	end
	
	function PANEL:Think()
		self:MoveToFront()
	end
	
	vgui.Register("UpgradeMenu", PANEL, "DPanel")
	
	netstream.Hook("upgradeMenu", function(id)
		local upgmenu = vgui.Create("UpgradeMenu")
		
		if id then
			upgmenu.itemID = id
		end
	end)
	
else

	netstream.Hook("isupginstalled", function(client, id, enames, panel, amount)
		local item = ix.item.instances[id]
		local upgradedata = item:GetData(enames[1])
		
		if upgradedata then
			if istable(upgradedata[enames[1]].name) then
				local names = upgradedata[enames[1]].name
				netstream.Start(client, "upginstalled", names, panel, amount, enames)
			end
		end
	end)
	
	local success = false

	netstream.Hook("installupg", function(client, ename, value, name, id)
		local item = ix.item.instances[id]
		local character = client:GetCharacter()
		local newval = false
		local newtab = {}
		success = false
		
		if item then
			local curdata = item:GetData(ename)
			
			if curdata then
				for key,tab in pairs(curdata) do
					
					if curdata[key].name then
						for _,names in pairs(curdata[key].name) do
							if names == name then
								client:NotifyLocalized("Upgrade Already Installed")
								return
							end
						end
					end
					
					local pass
					pass = table.insert(curdata[key].name, name)
					
					if pass then
						curdata[key].amount = tab.amount + value
					end
				end
			else
				newtab = {
					[ename] = {
						["amount"] = value,
						["ename"] = ename,
						["name"] = {name},
					},
				}
			end
			
			if table.IsEmpty(newtab) then
				item:SetData(ename,curdata)
				success = true
			else
				item:SetData(ename,newtab)
				success = true
			end
		end
	end)
	
	netstream.Hook("charge", function(client, price, id)
		local item = ix.item.instances[id]
		if item and success then
			local addPrice = item:GetData("addPrice",0)
			local newAddPrice = price + addPrice
			item:SetData("addPrice",newAddPrice)
			local character = client:GetCharacter()
			character:TakeMoney(price)
		end
	end)
	
	netstream.Hook("pricedrop", function(client, price, id)
		local item = ix.item.instances[id]
		if item then
			local addPrice = item:GetData("addPrice")
			if addPrice then
				local newAddPrice = addPrice - price
				item:SetData("addPrice",newAddPrice)
			end
		end
	end)
	
	netstream.Hook("uninstallupg", function(client, ename, value, name, id)
		local item = ix.item.instances[id]
		local character = client:GetCharacter()
		local newval = false
		
		if item then
			local curdata = item:GetData(ename)
			
			if curdata then
				for key,tab in pairs(curdata) do
					local pass
					pass = table.RemoveByValue(curdata[key].name, name)
					
					if pass then
						curdata[key].amount = tab.amount - value
						newval = true
					end
				end
			end
			
			if newval then
				item:SetData(ename,curdata)
			end
		end
	end)

	netstream.Hook("itemdata", function(client, id)
		local item = ix.item.instances[id]
		if item then
			local image = item.image or "none"
			local model = item.model
			local stats = {}
			
			if item.isArmor or item.isGasmask or item.isHelmet then
				stats = {
					["type"] = "armor",
					["res"] = item.res,
					--["armor"] = item.ballisticrpglevels, -- this is excluded as it is a dependency on non-present code. Replace it with something else if you want.
					["artis"] = item.artifactcontainers,
					["weight"] = item.weight,
				}
			end
			
			if item.isCW then
				local wep = weapons.Get(item.class)
				
				if wep then
					stats = {
						["type"] = "weapon",
						["rpm"] = (60/wep.FireDelay),
						["dmg"] = wep.Damage,
						["vel"] = wep.MuzzleVelocity,
						["mag"] = wep.Primary.ClipSize,
						["weight"] = item.weight,
					}
				end
			end
			
			if item.upgs then
				netstream.Start(client, "itemdatareturn", item.upgs, image, model, stats)
			end
		end
	end)
end
