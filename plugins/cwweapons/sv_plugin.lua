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
local delay = 0

function PLUGIN:WeaponFired(entity)
    if entity and entity:IsPlayer() then
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
		
		local dura
		if delay < CurTime() then
			delay = CurTime() + 3
			if ammo then
				ammo:SetData("quantity",newAmmo)
			end
			if not item then return end
			if ammo then
				wep:SetWeaponHP((item:GetData("durability")/100),100)
			end
			dura = item:GetData("durability", 10000)
			if (dura ~= 0) then
				if string.EndsWith(wep.Primary.Ammo, " -ZL-") then
					newdura = (dura - math.Round(item.modifier))
				else
					newdura = (dura - math.Round(item.modifier/2))
				end
				item:SetData("durability", newdura)
			end
			
			if (newdura <= 0) then
				item:SetData("equip", false)
				entity:StripWeapon(wepclass)
			end
		else
			if ammo then
				ammo:SetData("quantity",newAmmo,nil,true)
			end
			if not item then return end
			dura = item:GetData("durability", 10000)
			if (dura ~= 0) then
				if string.EndsWith(wep.Primary.Ammo, " -ZL-") then
					newdura = (dura - math.Round(item.modifier))
				else
					newdura = (dura - math.Round(item.modifier/2))
				end
				item:SetData("durability", newdura, nil, true)
			end
		end
		if (newdura <= 0) then
			item:SetData("equip", false)
			entity:StripWeapon(wepclass)
		end
    end
end

hook.Add("WeaponFired", "Weapon_Fired", PLUGIN.WeaponFired)

function PLUGIN:AmmoCheck(client, weapon)
	if not weapon then return end
	
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

hook.Add("AmmoCheck", "Ammo_Check", PLUGIN.AmmoCheck)

function PLUGIN:M203Fired(client)
	if not client then return end
	
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

hook.Add("M203Fired", "M203_Fired", PLUGIN.M203Fired)
--]]