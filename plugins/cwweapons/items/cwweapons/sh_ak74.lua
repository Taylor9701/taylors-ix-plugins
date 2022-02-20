ITEM.name = "AK-74"
ITEM.description = "The AK-74 is the replacement for the AKM and the most notable difference between the two is the drop in caliber from 7.62x39mm to 5.45x39mm."
ITEM.model = "models/weapons/ethereal/item_ak74.mdl"
ITEM.class = "cw_kk_ins2_ak74"
ITEM.weaponCategory = "primary"
ITEM.width = 4
ITEM.height = 2
ITEM.price = 24600
ITEM.weight = 6

--[[
-- Example for the upgrades system:
ITEM.upgs = {
	{name = "ak74_rpm1", dep = {"none"}, adjacent = nil, blocks = {}, amounts = {30}, pos = 1, row = 1},
	{name = "ak74_vel1", dep = {"ak74_rpm1"}, adjacent = {"ak74_dmg1"}, blocks = {"ak74_dmg1"}, amounts = {20}, pos = 2, row = 1},
	{name = "ak74_dmg1", dep = {"ak74_rpm1"}, adjacent = {"ak74_vel1"}, blocks = {"ak74_vel1"}, amounts = {2}, pos = 2, row = 1},
	{name = "ak74_mag1", dep = {"ak74_dmg1 or ak74_vel1"}, adjacent = nil, blocks = {}, amounts = {5}, pos = 3, row = 1},
}
--]]