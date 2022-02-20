--[[


This is a list of bug-fixes for both the CW2.0 KK INS2 and CW2.0 base to resolve various issues 
with either base that you may come across. If you are even somewhat experienced with looking at code,
and know how to follow these directions, I encourage you to try these things if you run into the 
issues I mention. I cannot guarantee they will work and will not cause other issues for you, but
they worked for me on live servers with 20-40 players for several weeks, and lower pop over many months, 
so I have a reasonable degree of confidence in them.


CW2.0 KK INS2 FIXES:

PAC Models won't render when looking down sights:

rt_sight.lua - line 112, add:
if pac then
    pac.ForceRendering(true)
end
 
If PAC is enabled, using a sight will forcibly render PACs and cause them to no longer disappear when 
aiming down a sight at a player using one. Only runs if PAC is installed, obviously.
 


I keep getting an error at the line mentioned below when using other weapons base(s):
 
o_shared.lua - line 160 changed to:
"if lastFM != "safe" and wep.Base == "cw_kk_ins2_base" then"
 
Avoids conflicts with other SWEP bases that may have similarly named calls.



I'm getting errors in this file at these lines for whatever reason:
 
o_shared.lua - lines 767 & 768 replaced with:
if isnumber(self.HolsterSpeedMult) then
    self.dt.HolsterDelay = CT + (self:GetHolsterTime() / (self.HolsterSpeed * self.HolsterSpeedMult))
elseif isnumber(self.HolsterSpeed) then
    self.dt.HolsterDelay = CT + (self:GetHolsterTime() / self.HolsterSpeed)
end
 
Simply avoids erroring out if holster data is either missing or invalid. Specifically 
useful if no speedmult is desired and is then removed under the assumption it is not a 
necessary var. Also allows for minimal delay holstering if such behavior is specifically desired.



I keep getting errors at/near this set of lines:

o_cl_model.lua - lines 494-512 replaced with:
 
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

Simply adds an additional check to ensure that the BoneID is valid.



Players leave render distance with a weapon in-hand, but upon re-rendering, the gun is gone:

o_cl_model.lua - lines 520-526 replaced with:
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
 
Ensures that, upon rendering, if the WMEnt is invalid, it recreates the WM instead of simply 
returning and ignoring the invalid data. Fixes the issue where other players using the SWEPs, 
upon exiting and then re-entering render distance, no longer have the SWEPs in-hand.



I keep getting occasional errors at the lines mentioned below:

sh_nwext.lua - lines 120 & 121 replaced with:
if istable(wep.ActiveAttachments) then
    net.WriteTable(wep.ActiveAttachments)
    net.Send(ply)
end
 
Simply add a check to ensure ActiveAttachments are in table format and not just nil. 
Occasionally caused bugs otherwise, attempting to write nil data into a WriteTable 
command which causes problems. Rare, but does occur. Not sure why, but this removes the error, 
whatever was causing it never actually resulted in undesired behavior, just console errors.



CW2.0 SOUND FIX:

Sounds for shooting/reloading/etc keep cutting out randomly when doing things such as walking:

cw_sounds.lua
lines 7-35:
change "channel = CHAN_AUTO," to "channel = CHAN_WEAPON," in all three tables.
 
line 54:
change "channel = channel or CHAN_AUTO" to "channel = channel or CHAN_WEAPON"
 
Resolves the issue where sounds cut one another out sometimes, especially with a 
large number of sounds loaded at one time through this system. CHAN_AUTO still has 
limitations to how intelligently it will assign sounds to appropriate channels, 
while the CHAN_WEAPON is, aside from weapons sounds set directly to it, typically 
unused, so it's a safer bet, and obviously a more appropriate choice.
(I'm convinced that, despite it saying it auto-determines the best channel, 
it just slaps it in a default channel with 0 considerations whatsoever)
--]]