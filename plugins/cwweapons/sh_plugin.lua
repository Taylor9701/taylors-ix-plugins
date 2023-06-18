local PLUGIN = PLUGIN
PLUGIN.name = "CW Weapons"
PLUGIN.author = "Lt. Taylor"
PLUGIN.desc = "Allows CW2.0 and CW2.0 KK INS2 SWEPs to be used without issue."

if not CustomizableWeaponry then return end

ix.util.Include("sv_plugin.lua")
ix.util.Include("sh_kkins2fix.lua")
ix.util.Include("sv_ammo.lua")

--[[ Readme:

Includes item bases for CW Weapons, Attachments, Ammo, and CW2.0 KK INS2 Grenades.

Includes features to fix the big issue with using CW2.0 - raise/lower not working. This is achieved rather simply
by setting the weapons to "safe" mode when you equip them (provided keeping weapons raised is not enabled) which lowers them,
and toggling safe mode off/on for raise/lower. There is one small bug with this, cycling firemodes (using the hotkey, not the toggle raise command) 
will raise the weapon for the player, but will not raise it for anyone viewing said player. Cycling the weapon raise toggle will fix this. 
Fixing this would require editing the weapons base, which cannot be done via a plugin such as this. It is what it is.

NOTE: sh_kkins2fix.lua IS AN EXPERIMENTAL METHOD TO BUGFIX CW/KKINS2 ISSUES. If it gives you problems, it is safe to remove along with the
ix.util.Include(sh_kkins2fix.lua) line just above this. Bugs will exist, but functionality will be continued.

Advice: 
I recommend using this plugin with CW2.0 and CW2.0 KK INS2 together. This will give you access to far more 
weapon options, and more importantly, high quality SWEPs, as the bar for INS2 weapons is reasonably high and many extremely
talented creators put a large amount of work into the models, animations, and textures, which cannot always be said for
baseline CW2.0 content.

If you're going to use CW2.0 KK INS2, I recommend only including these addons from the "required" list for CW2.0 KK INS2, 
as others may cause conflicts/issues/bugs. Experiment with the others at your own risk:

"Customizable Weaponry 2.0"
"Extra Customizable Weaponry 2.0"

Using CW2.0 and CW2.0 KK INS2 should not cause any conflicts with other weapon bases to my knowledge, however I cannot guarantee that.
If you have a need to use this alongside other weapons base(s), make sure to thoroughly test them working side-by-side to
ensure there are no errors, bugs, or undesired behavior(s).


Specifics:

CW Weapons: item base includes a large number of 'examples' that cover a large number of currently available
CW2.0 KK INS2 weapons. These do not include baseline CW2.0 weapons and available SWEPs from workshop but adding them
only requires filling out the form as can be seen in all the aforementioned item files. If you're not using a specific 
weapon, just delete the specific item file and that's all you need to do.

Attachments: Includes a good number of 'examples' that cover most of the CW2.0 and CW2.0 KK INS2 attachments.
Multiple attachments can be attached to a single item, however, a single attachment item cannot activate multiple attachments at once.
This is useful in any case such as "CW2.0 KK INS2 Foregrip vs. CW2.0 Base Foregrip". They have different attachment names, but 
conceptually ought to be represented by a single item, and so they can be.

Ammo: Simple ammo items with stacking/quantities built in along with drag-and-drop stacking.
--]]

if not CustomizableWeaponry_KK then return end

function PLUGIN:GrenadeThrown(entity, grenade)
	entity = entity.Owner
	if entity:IsPlayer() then
		for k, v in pairs(entity:GetChar():GetInventory():GetItems()) do
			if v:GetData("equip", false) == true and v.isGrenade then
				entity:StripWeapon(v.class)
				entity.carryWeapons[v.weaponCategory] = nil
				v:SetData("equip", false)
				v:Remove()
			end
		end
	end
end

function PLUGIN:GrenadeOvercooked(entity, grenade)
	entity = entity.Owner
	if entity:IsPlayer() then
		for k, v in pairs(entity:GetChar():GetInventory():GetItems()) do
			if v:GetData("equip", false) == true and v.isGrenade then
				entity:StripWeapon(v.class)
				entity.carryWeapons[v.weaponCategory] = nil
				v:SetData("equip", false)
				v:Remove()
			end
		end
	end
end