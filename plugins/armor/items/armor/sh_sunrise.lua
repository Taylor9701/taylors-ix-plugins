ITEM.name = "Sunrise"
ITEM.model ="models/stalker/outfit/sunrise.mdl"
ITEM.replacements ="models/nasca/stalker/male_sunrise_lone.mdl"
ITEM.description= "A Sunrise suit."
ITEM.longdesc = "This DIY stalker bodysuit is a combination of twin-layered rubberised cloth with Plexiglas lining and built-in body armour. The vest stops slower, weaker pistol calibers. The suit enjoys great popularity due to its low cost and modification potential."
ITEM.width = 2
ITEM.height = 3
ITEM.price = 26400
ITEM.flag = "a"
ITEM.isHelmet = true
ITEM.isGasmask = true
ITEM.artifactcontainers = {"1"}
ITEM.img = Material("vgui/hud/sunrise.png")
ITEM.weight = 10
ITEM.res = {
	["Bullet"] = 0.20,
	["Blast"] = 0.20,
	["Fall"] = 0.20,
	["Burn"] = 0.20,
	["Radiation"] = 0.20,
	["Chemical"] = 0.20,
	["Shock"] = 0.20,
	["Psi"] = 0.00,
}

--[[
-- Example of an upgrades implementation in an item file.

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
--]]