PLUGIN.name = "CW Weapons"
PLUGIN.author = "Lt. Taylor"
PLUGIN.desc = "Allows CW2.0 and CW2.0 KK INS2 SWEPs to be used without issue."

if not CustomizableWeaponry then return end

ix.util.Include("sv_plugin.lua")

--[[ Readme:

Includes item bases for CW Weapons, Attachments, Ammo, and CW2.0 KK INS2 Grenades.

Includes features to fix the big issue with using CW2.0 - raise/lower not working. This is achieved rather simply
by setting the weapons to "safe" mode when you equip them (provided keeping weapons raised is not enabled) which lowers them,
and toggling safe mode off/on for raise/lower. There is one small bug with this, cycling firemodes (using the hotkey, not the toggle raise command) 
will raise the weapon for the player, but will not raise it for anyone viewing said player. Cycling the weapon raise toggle will fix this. 
Fixing this would require editing the weapons base, which cannot be done via a plugin such as this. It is what it is.


Advice: 
I recommend using this plugin with CW2.0 and CW2.0 KK INS2 together. This will give you access to far more 
weapon options, and more importantly, high quality SWEPs, as the bar for INS2 weapons is reasonably high and many extremely
talented creators put a large amount of work into the models, animations, and textures, which cannot always be said for
baseline CW2.0 content.

If you're going to use CW2.0 KK INS2, I recommend only including these addons from the "required" list for CW2.0 KK INS2, 
as others may cause conflicts/issues/bugs. Experiment with the others at your own risk:

"Customizable Weaponry 2.0"
"Extra Customizable Weaponry 2.0"

If you are looking for unrealistic weaponry or obscure things, other weapons bases may serve your needs better.
Make sure to look into what is available and what will fit your needs most appropriately before getting dirty with the work.
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

Ammo: Simple ammo items with stacking/quantities built in. You can set the load amount options for each individual ammo item,
or keep the default spread as can be seen in the ammo item base. Also allows for combining partial stacks to free up inventory space.

Grenades: Along with the functions below, adds functionality for single-use grenade items that remove themselves from your
inventory on-use after unequipping. Specifically works for CW2.0 KK INS2 grenades.


NOTE:
If you are NOT going to be using CW2.0 KK INS2, remove the "cwgrenades" item base and items folder (to remove error items basically), 
as well as the two "PLUGIN:" functions below. Shouldn't cause any issues if you leave the below code in, but just in case of 
conflicts with other hooks or weapon bases, better safe than sorry.

--]]

function PLUGIN:GrenadeThrown(entity, grenade)
    entity = entity.Owner
    if entity:IsPlayer() then
        for k, v in pairs(entity:GetChar():GetInv():GetItems()) do
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
        for k, v in pairs(entity:GetChar():GetInv():GetItems()) do
            if v:GetData("equip", false) == true and v.isGrenade then
                entity:StripWeapon(v.class)
    			entity.carryWeapons[v.weaponCategory] = nil
    			v:SetData("equip", false)
    			v:Remove()
		    end
	    end
    end
end