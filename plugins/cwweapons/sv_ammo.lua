local PLUGIN = PLUGIN

if not CustomizableWeaponry_KK then return end

local timerdelay = 1

function PLUGIN:Think()
	if timerdelay < CurTime() then
		timerdelay = CurTime() + 5
        if not ix.config.Get("Custom Ammo",false) then return end
		for id,ply in pairs(player.GetHumans()) do
			wep = ply:GetActiveWeapon()
			if (wep.Base == "cw_kk_ins2_base") then
				PLUGIN:AmmoCheck(ply,wep)
			end
		end
	end
end

function PLUGIN:AmmoCheck(client, weapon)
	if not weapon || not ix.config.Get("Custom Ammo",false) then return end
	
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
	elseif ammoType != "40MM" then
		client:SetAmmo(0,"40MM")
	end
end

function WeaponFired(entity)
	if entity and entity:IsPlayer() and ix.config.Get("Custom Ammo",false) then
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

        if item && ix.config.Get("durability") then
            if item.modifier then
                item:SetData("durability", (item:GetData("durability",10000) - item.modifier))
            end
        end
		
		if ammo then
			local ammoCount = ammo:GetData("quantity") or 1
			if ammoCount == 1 then
				ammo:Remove()
			end
			newAmmo = ammoCount - 1
			ammo:SetData("quantity",newAmmo)
		end
	end
end

hook.Add("AmmoConsumption", "AmmoConsumption", WeaponFired)