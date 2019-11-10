if SERVER then
	resource.AddFile("materials/vgui/ttt/icon_moneylauncher_64.jpg")
	resource.AddFile("sound/money.wav")
	resource.AddFile("sound/money_altfire.wav")
 end

SWEP.PrintName = "Money Launcher"
SWEP.Author	= "smith"
SWEP.Instructions = "Give the money"
SWEP.Category = "TTT"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Icon = "vgui/ttt/icon_moneylauncher_64.jpg"
SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_EQUIP1
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.InLoadoutFor = nil
SWEP.LimitedStock = true
SWEP.EquipMenuData = {
   type = "Weapon",
   desc = "You have too much money."
};
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = false
SWEP.AutoSpawnable = false
SWEP.HoldType = "pistol"
SWEP.Primary.ClipSize = GetConVar("ttt_moneylauncher_clipSize"):GetInt()
SWEP.Primary.DefaultClip = GetConVar("ttt_moneylauncher_ammo"):GetInt()
SWEP.Primary.Automatic = GetConVar("ttt_moneylauncher_automaticFire"):GetBool()
SWEP.Primary.RPS = GetConVar("ttt_moneylauncher_rps"):GetFloat()
SWEP.Primary.Ammo = "none"
SWEP.Weight	= 7
SWEP.DrawAmmo = true
SWEP.DrawCrosshair = false
SWEP.ViewModel = "models/weapons/v_pist_fiveseven.mdl"
SWEP.WorldModel	= "models/weapons/w_pist_fiveseven.mdl"

local ShootSound = Sound("money.wav")
local SecondSound = Sound("money_altfire.wav")

function SWEP:Initialize()
	if (CLIENT) then
		return
	end

	self.Primary.ClipSize = GetConVar("ttt_moneylauncher_clipSize"):GetInt()
	self.Primary.DefaultClip = GetConVar("ttt_moneylauncher_ammo"):GetInt()
	self.Primary.Automatic = GetConVar("ttt_moneylauncher_automaticFire"):GetBool()
	self.Primary.RPS = GetConVar("ttt_moneylauncher_rps"):GetFloat()
end

function SWEP:PrimaryAttack()
	self.Weapon:SetNextPrimaryFire(CurTime() + 1 / self.Primary.RPS)

	if not self:CanPrimaryAttack() then
		return 
	end

	self:TakePrimaryAmmo(1)
	self:EmitSound(ShootSound) 

	if (CLIENT) then 
		return 
	end

	local ent = ents.Create("sent_moneygun")
	if (!IsValid(ent)) then 
		return 
	end
	ent:SetModel("models/props/cs_assault/Money.mdl")
	ent:SetAngles(self.Owner:EyeAngles())
	ent:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 16))
	ent:SetOwner(self.Owner) -- Prevents all normal phys damage to all entities for whatever reason, but we actually want this to be the case
	ent:Spawn()
	ent.Owner = self.Owner
	ent:Activate()
 	util.SpriteTrail(ent, 0, Color(255,215,0), false, 16, 1, 6, 1/(15+1)*0.5, "trails/laser.vmt")
	local phys = ent:GetPhysicsObject()
	if (!IsValid(phys)) then 
		ent:Remove()
		return 
	end
	phys:SetMass(2)
	phys:SetVelocity(self.Owner:GetAimVector() * 100000)
	local anglo = Angle(-10, -5, 0)		
	self.Owner:ViewPunch(anglo)
end

function SWEP:SecondaryAttack()
   self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
   
   self:EmitSound(SecondSound)
end