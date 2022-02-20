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

-- If you know what you're doing (are an experienced Lua coder) the below code may prove useful for setting up 
-- a system with the CW2.0/CW2.0 KK INS2 Base, depending on which one you're using, to pull ammo from
-- the inventory instead of needing to use the load command on ammunition.

--[[
local delay = 0

function PLUGIN:WeaponFired(entity)
    if entity:IsPlayer() then
		local wep = entity:GetActiveWeapon()
		local wepclass = wep:GetClass()
		local item
		local ammo
		
		for k,v in pairs(entity:GetChar():GetInv():GetItems()) do
			if v.isAmmo == true then
				if wep.Primary.Ammo == v.ammo then
					ammo = v
				end
			end
			if v.isPLWeapon then
				if v:GetData("equip",false) == true then
					if wepclass == v.class then
						item = v
					end
				end
			end
		end
		
		local newAmmo
		if ammo then
			local ammoCount = ammo:GetData("quantity") or 1
			if ammoCount == 1 then
				ammo:Remove()
			end
			newAmmo = ammoCount - 1
		end
		
		if delay < CurTime() then
			delay = CurTime() + 3
			if ammo then
				ammo:SetData("quantity",newAmmo)
			end
		else
			if ammo then
				ammo:SetData("quantity",newAmmo,nil,true)
			end
		end
    end
end

hook.Add("WeaponFired", "Weapon_Fired", WeaponFired)

function PLUGIN:AmmoCheck(client, weapon)
	local ammoCount = 0
	local ammoCountGL = 0
	local ammoType = weapon.Primary.Ammo
	
	if string.match(weapon:GetClass(),"cw_kk_ins2_nade") then return end
	
	for k,v in pairs(client:GetChar():GetInv():GetItems()) do
		if v.isAmmo == true then
			if ammoType == v.ammo then
				ammoCount = ammoCount + v:GetData("quantity",1)
			elseif "40MM" == v.ammo then
				ammoCountGL = ammoCount + v:GetData("quantity",1)
			end
		end
	end
	
	if ammoCount > 0 then
		client:SetAmmo((ammoCount - weapon:Clip1()), ammoType)
	else
		client:SetAmmo(0,ammoType)
		weapon:SetClip1(0)
	end
	
	if ammoCountGL > 0 then
		client:SetAmmo((ammoCountGL - weapon:Clip1()),"40MM")
	else
		client:SetAmmo(0,"40MM")
	end
end

hook.Add("AmmoCheck", "Ammo_Check", AmmoCheck)

function PLUGIN:M203Fired(client)
	for k,v in pairs(client:GetChar():GetInv():GetItems()) do
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

hook.Add("M203Fired", "M203_Fired", M203Fired)
--]]