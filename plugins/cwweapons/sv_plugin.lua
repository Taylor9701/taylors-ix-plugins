function PLUGIN:InitializedPlugins()
		-- There is no Customization Keys.
		CustomizableWeaponry.customizationMenuKey = "" -- the key we need to press to toggle the customization menu
		CustomizableWeaponry.canDropWeapon = false
		CustomizableWeaponry.enableWeaponDrops = false
		CustomizableWeaponry.quickGrenade.enabled = false
		CustomizableWeaponry.quickGrenade.canDropLiveGrenadeIfKilled = false
		CustomizableWeaponry.quickGrenade.unthrownGrenadesGiveWeapon = false
		CustomizableWeaponry.customizationEnabled = false

		hook.Remove("PlayerInitialSpawn", "CustomizableWeaponry.PlayerInitialSpawn")
		hook.Remove("PlayerSpawn", "CustomizableWeaponry.PlayerSpawn")
		hook.Remove("AllowPlayerPickup", "CustomizableWeaponry.AllowPlayerPickup")
	do
		function CustomizableWeaponry:hasAttachment(ply, att, lookIn)		
			return true
		end
	end
end

function PLUGIN:WeaponEquip(weapon)
    if (!IsValid(weapon)) then return end
	
	local alwaysRaised = ix.config.Get("weaponAlwaysRaised",false)
 
    if (string.sub(weapon:GetClass(), 1, 3) == "cw_") then
		weapon:SetSafe(true)
    end
end
 
local playerMeta = FindMetaTable("Player")

function playerMeta:SetWepRaised(state)
    local weapon = self:GetActiveWeapon()
	
    self:SetNetVar("raised", state)
    
    if (!IsValid(weapon)) then return end
	
    if (string.sub(weapon:GetClass(), 1, 3) == "cw_") then
        if (state) then
            weapon:SetSafe(false)
        else
			weapon:SetSafe(true)
        end
    end
end

-- the below code is useful for implementing ammo-use-from-inventory and similar.
--[[

function PLUGIN:M203Fired(client)
	if not client then return end
	
	for k,v in pairs(client:GetChar():GetInventory():GetItems()) do
		if v.isAmmo == true then
			if v.ammo == "40MM" then
				local oldquan = v:GetData("quantity",1)
				if oldquan <= 1 then
					v:Remove()
				end
				v:SetData("quantity",(oldquan - 1))
				return
			end
		end
	end
end

hook.Add("M203Fired", "M203_Fired", PLUGIN.M203Fired)
--]]