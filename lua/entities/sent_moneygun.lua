ENT.Type = "anim"
ENT.PrintName = "Money"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose	= ""
ENT.Instructions = ""
ENT.AlreadyHit = {}
ENT.Collided = 0

local CollisionsBeforeRemove = 20
local MinSpeed = 70

if SERVER then
    AddCSLuaFile()

    function ENT:Initialize()
		self:SetModel("models/props/cs_assault/Money.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
		self.Entity:SetSolid(SOLID_VPHYSICS)
		local phys = self.Entity:GetPhysicsObject()

		if (phys:IsValid()) then
			phys:Wake()
			phys:SetMass(5)
        end

		self:GetPhysicsObject():SetMass(2)
		self.Entity:SetUseType(SIMPLE_USE)
    end

    function ENT:PhysicsCollide(data, phys)
        self.Collided = self.Collided + 1
        if self.Collided <= CollisionsBeforeRemove then
            local Ent = data.HitEntity
            if !IsValid(self.Entity) or !IsValid(Ent) or !Ent:IsPlayer() then
                return
            end

            if !self.AlreadyHit[Ent:GetName()] and self.Entity:GetVelocity():LengthSqr() > MinSpeed * MinSpeed then
                local dmg = DamageInfo()
                if IsValid(self.Owner) then
                    dmg:SetAttacker(self.Owner)
                end
                local inflictor = ents.Create("swep_moneylauncher")
                dmg:SetInflictor(inflictor)
                local r = GetConVar("ttt_moneylauncher_randomDamage"):GetFloat()
                local rand = math.random(-r, r)
                local dm = GetConVar("ttt_moneylauncher_damage"):GetInt() + rand
                dmg:SetDamage(dm > 0 and dm or 0)
                dmg:SetDamageType(DMG_GENERIC)
                Ent:TakeDamageInfo(dmg)

                local effectdata = EffectData()
                effectdata:SetStart(data.HitPos)
                effectdata:SetOrigin(data.HitPos)
                effectdata:SetScale(1)
                util.Effect("BloodImpact", effectdata)

                self.AlreadyHit[Ent:GetName()] = true
            end
        else
            timer.Simple(0, function()
                if IsValid(self) then
                    self:Remove()
                end
            end)
        end
	end
end

if CLIENT then
	function ENT:Draw()
		self.Entity:DrawModel()
	end
end
