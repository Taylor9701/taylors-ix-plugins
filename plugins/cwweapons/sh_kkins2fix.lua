local PLUGIN = PLUGIN

--[[
	Much of the code here is attributed to the authors of KK INS2 mainly, and CW2.0 otherwise.
	Changes are simply made to override their functions to add further compatability
	for things like PAC and working side-by-side with other SWEP bases. Essentially,
	this is bugfixing, and the only credit claimed is for adding a line or two to each
	function.
	
	This is to be considered an "Experimental" method for now until proper multiplayer dedicated
	server testing is done with it. Works in a LAN server, but this is not quite the same as
	a live server. Use at your own risk.
--]]

if not CustomizableWeaponry then return end

CustomizableWeaponry.reloadSoundTable = {
	channel = CHAN_WEAPON, 
	volume = 1,
	level = CustomizableWeaponry.reloadSoundVolume, 
	pitchstart = 100,
	pitchend = 100,
	name = "noName",
	sound = "path/to/sound"
}
	
CustomizableWeaponry.fireSoundTable = {
	channel = CHAN_WEAPON, 
	volume = 1,
	level = 97, 
	pitchstart = 92,
	pitchend = 112,
	name = "noName",
	sound = "path/to/sound"
}
	
CustomizableWeaponry.regularSoundTable = {
	channel = CHAN_WEAPON,
	volume = 1,
	level = 65, 
	pitchstart = 92,
	pitchend = 112,
	name = "noName",
	sound = "path/to/sound"
}

if not CustomizableWeaponry_KK then return end

CustomizableWeaponry_KK.ins2.rtSight = CustomizableWeaponry_KK.ins2.rtSight or {}

function CustomizableWeaponry_KK.ins2.rtSight:renderTarget(wep, att)
	if not att then return end
	if not wep.ActiveAttachments[att.name] then return end
	
	local alpha = 0.5
	local cvFOVDesired = GetConVar("fov_desired")
	local cvFreeze = CustomizableWeaponry_KK.ins2.conVars.other["cw_kk_freeze_reticles"]
	local cvDrawVM = CustomizableWeaponry_KK.ins2.conVars.main["cw_kk_ins2_draw_vm_in_rt"]
	local tblLams = {
		"kk_ins2_lam",
		"kk_ins2_m6x",
		"kk_ins2_anpeq15"
	}
	local cd = {}
	cd.aspectratio = 1
	cd.x = 0
	cd.y = 0
	cd.w = 1024
	cd.h = 1024
	cd.drawhud = false
	cd.drawmonitors = true
	cd.drawviewmodel = false
	cd.viewmodelfov = 10
	cd.dopostprocess = false
	cd.bloomtone = false
	
	complexTelescopics = wep:canUseComplexTelescopics()

	if not complexTelescopics then
		wep.TSGlass:SetTexture("$basetexture", iMatLens:GetTexture("$basetexture"))
		return
	end

	if !wep.dt.INS2GLActive and wep:canSeeThroughTelescopics(att.aimPos[1]) then
		alpha = math.Approach(alpha, 0, FrameTime() * 5)
	else
		alpha = math.Approach(alpha, 1, FrameTime() * 5)
	end

	attachmEnt = wep.AttachmentModelsVM[att.name].ent
	-- attachmEnt:SetupBones()
	mdlAttRear = attachmEnt:GetAttachment(1)
	mdlAttFront = attachmEnt:GetAttachment(2)

	if not (mdlAttRear and mdlAttFront) then
		CustomizableWeaponry_KK.ins2.stencilSight:_SpamErrors(wep, att)
		return
	end

	ang = mdlAttRear.Ang
	ang:RotateAroundAxis(ang:Forward(), -90)

	rtSize = wep:getRenderTargetSize()

	-- // fovmods
	local retSizeMult = 1 / (wep.AttachmentModelsVM[att.name].retSizeMult or 1)
	local curCLFOV = math.Clamp(cvFOVDesired:GetInt() + wep.CurFOVMod, 0, cvFOVDesired:GetInt())
	local fovDiff = math.Clamp(curCLFOV - wep.CurVMFOV, 0, curCLFOV)
	local camOriginDist = EyePos():Distance(mdlAttRear.Pos) * retSizeMult
	local niceZoomSetting = att.zoomDesired

	wep.rt2 = {
		["curCLFOV"] = curCLFOV,
		["fovDiff"] = fovDiff,
		["camOriginDist"] = camOriginDist,
		["scopeLength"] = mdlAttRear.Pos:Distance(mdlAttFront.Pos),
	}

	cd.fov = att._rtFov
	-- cd.angles = ang
	-- cd.origin = EyePos()

	-- cd.fov = fovDiff * (1 / niceZoomSetting) / (camOriginDist) * 8
	cd.angles = mdlAttRear.Ang
	cd.origin = mdlAttRear.Pos

	cd.w = rtSize
	cd.h = rtSize

	render.PushRenderTarget(wep.ScopeRT, 0, 0, rtSize, rtSize)
		
		if pac then
			pac.ForceRendering(true)
		end
		
		if alpha != 1 then
			wep._skipDrawingScope = att.name
			render.RenderView(cd)
			wep._skipDrawingScope = false
		end

		cam.Start3D(mdlAttRear.Pos, ang)
			if cvDrawVM:GetInt() == 1 then
				wep.CW_VM:DrawModel()
				
				-- wep:drawAttachments()
				-- wep.AttachmentModelsVM.kk_ins2_optic_iron.ent:DrawModel()

				-- for _,e in pairs(wep.AttachmentModelsVM) do
					-- e.ent:Draw()
				-- end
			end

			oldStencilChk = wep._KK_INS2_stencilsDisableLaser
			wep._KK_INS2_stencilsDisableLaser = false
				for _,lam in pairs(tblLams) do
					if wep.ActiveAttachments[lam] then
						CW2ATTS[lam].elementRender(wep)
					end
				end
			wep._KK_INS2_stencilsDisableLaser = oldStencilChk

			-- self:DrawParallax(wep, att)
		cam.End3D()

		cam.Start2D()
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetTexture(att._rtReticle or iInnerRim)
			surface.DrawTexturedRect(0, 0, rtSize, rtSize)

			if cvFreeze:GetInt() == 1 then
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetTexture(iRearMat)
				for _ = 1,3 do
					surface.DrawTexturedRect(-rtSize/2, -rtSize/2, rtSize * 2, rtSize * 2)
				end
			end

			surface.SetDrawColor(0, 0, 0, 255 * alpha)
			surface.DrawRect(0, 0, rtSize, rtSize, 90)
		cam.End2D()

	render.PopRenderTarget()

	if wep.TSGlass then
		wep.TSGlass:SetTexture("$basetexture", wep.ScopeRT)
	end
end

if CLIENT then
	local ply, mode, wep, lastFM

	local function CW_ReceiveFireMode(um)
		ply = um:ReadEntity()
		mode = um:ReadString()

		if IsValid(ply) then
			wep = ply:GetActiveWeapon()
			lastFM = wep.FireMode
			wep.FireMode = mode

			if IsValid(ply) and IsValid(wep) and wep.CW20Weapon and wep.Base == "cw_kk_ins2_base" then
				if CustomizableWeaponry.firemodes.registeredByID[mode] then
					t = CustomizableWeaponry.firemodes.registeredByID[mode]

					wep.Primary.Automatic = t.auto
					wep.BurstAmount = t.burstamt
					wep.FireModeDisplay = t.display
					wep.BulletDisplay = t.buldis
					wep.CheckTime = CurTime() + 2

					if lastFM != "safe" then
						wep:firemodeAnimFunc()
					end
				end
			end
		end
	end

	usermessage.Hook("CW_KK_INS2_FIREMODE", CW_ReceiveFireMode)
end

for id,wepdata in pairs(weapons.GetList()) do 
	if wepdata.Base == "cw_kk_ins2_base" then
		SWEP = weapons.GetStored(wepdata.ClassName)
		local _reg = debug.getregistry()
		local _ent = _reg.Entity
		local EntGetBoneMatrix = _ent.GetBoneMatrix
		
		local _ang = _reg.Angle
		local AngRotateAroundAxis = _ang.RotateAroundAxis
		local AngUp = _ang.Up
		local AngRight = _ang.Right
		local AngForward = _ang.Forward
		
		function SWEP:Holster(wep)			-- Holstering Error Fix
			
			
			if not IsValid(wep) and not IsValid(self.SwitchWep) then
				self.SwitchWep = nil
				return false
			end

			local CT = CurTime()

			if self.dt.PinPulled then
				return false
			end

			if CT < self.GlobalDelay or CT < self.HolsterWait then
				return false
			end

			if self.dt.HolsterDelay ~= 0 and CT < self.dt.HolsterDelay then
				return false
			end

			if #self._activeSequences > 0 then
				return false
			end

			if self.ReloadDelay then
				return false
			end

			if self.dt.State ~= CW_HOLSTER_START then
				if isnumber(self.HolsterSpeedMult) then
					self.dt.HolsterDelay = CT + (self:GetHolsterTime() / (self.HolsterSpeed * self.HolsterSpeedMult))
				elseif isnumber(self.HolsterSpeed) then
					self.dt.HolsterDelay = CT + (self:GetHolsterTime() / self.HolsterSpeed) 
				end
			end

			self.dt.State = CW_HOLSTER_START

			if self.SwitchWep and self.dt.State == CW_HOLSTER_START and CT > self.dt.HolsterDelay then
				self.dt.State = CW_IDLE
				self.dt.HolsterDelay = 0

				CustomizableWeaponry.callbacks.processCategory(self, "holsterEnd", self.SwitchWep)

				return true
			end
			
			self.ShotgunReloadState = 0
			self.ReloadDelay = nil
			
			if self:filterPrediction() then
				if self.holsterSound then
					self.holsterSound = false

					if IsFirstTimePredicted() then
						if self.holsterAnimFunc then
							self:holsterAnimFunc()
						else
							if self.Animations.holster then
								self:sendWeaponAnim("holster")
							end
						end
					end
				end
			end
			
			self.SwitchWep = wep
			self.SuppressTime = nil
		end
		
		function SWEP:DrawWorldModel() -- WM Error Fix
			if self.dt.Safe then
				if self.CHoldType != self.RunHoldType then
					self:SetHoldType(self.RunHoldType)
					self.CHoldType = self.RunHoldType
				end
			else
				if self.dt.State == CW_RUNNING or self.dt.State == CW_ACTION then
					if self.CHoldType != self.RunHoldType then
						self:SetHoldType(self.RunHoldType)
						self.CHoldType = self.RunHoldType
					end
				else
					if self.CHoldType != self.NormalHoldType then
						self:SetHoldType(self.NormalHoldType)
						self.CHoldType = self.NormalHoldType
					end
				end
			end
			
			if IsValid(self.Owner) then
				if not self.OwnerAttachBoneID then
					self.OwnerAttachBoneID = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
				end
				
				if isnumber(self.OwnerAttachBoneID) then
					m = EntGetBoneMatrix(self.Owner, self.OwnerAttachBoneID)
					
					if not m then
						if isnumber(EntLookupBone(self.Owner, "ValveBiped.Bip01_R_Hand")) then
							m = EntGetBoneMatrix(self.Owner, EntLookupBone(self.Owner, "ValveBiped.Bip01_R_Hand"))
				
							if not m then
								return
							end
						end
					end
					
					
			
					pos = m:GetTranslation()
					ang = m:GetAngles()
			
					pos = pos + AngForward(ang) * self.WMPos.x + AngRight(ang) * self.WMPos.y + AngUp(ang) * self.WMPos.z
			
					AngRotateAroundAxis(ang, AngUp(ang), self.WMAng.y)
					AngRotateAroundAxis(ang, AngRight(ang), self.WMAng.x)
					AngRotateAroundAxis(ang, AngForward(ang), self.WMAng.z)
				end
			else
				self.OwnerAttachBoneID = false

				pos = self:GetPos()
				ang = self:GetAngles()
			end

			if !IsValid(self.WMEnt) then
				self.WMEnt = self:createManagedCModel(self.WorldModel, RENDERGROUP_BOTH)
				self.WMEnt:SetNoDraw(true)
				self.WMEnt:SetupBones()
				self:setupAttachmentWModels()
			end
			
			if isvector(pos) then
				self.WMEnt:SetPos(pos)
			end
			
			if isangle(ang) then
				self.WMEnt:SetAngles(ang)
			end
			
			self.WMEnt:DrawShadow(true)

			local overrideVM = false
			if self.AttachmentModelsWM then
				for _,e in pairs(self.AttachmentModelsWM) do
					overrideVM = overrideVM or (e.active and e.hideVM)
					if overrideVM then break end
				end
			end

			if not overrideVM then
				self.WMEnt:DrawModel()
			end

			self:drawAttachmentsWorld(self.WMEnt)

			self.HUD_3D2DScale = self.HUD_3D2DScale * 1.5
			self.CustomizationMenuScale = self.CustomizationMenuScale * 1.5

			if IsValid(self.Owner) and self.Owner == LocalPlayer() and IsValid(cvAmmoHud) then
				cam.IgnoreZ(true)
				self:drawInteractionMenu()
				if cvAmmoHud:GetInt() >= 1 then
					self:draw3D2DHUD()
				end
				cam.IgnoreZ(false)
			end

			self.HUD_3D2DScale = self.HUD_3D2DScale / 1.5
			self.CustomizationMenuScale = self.CustomizationMenuScale / 1.5
		end
	end
end

