ENT.Type = "anim"
ENT.PrintName = "Money"
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose	= ""
ENT.Instructions = ""

if SERVER then
    AddCSLuaFile()

    function ENT:Initialize()
		self:SetModel("models/props/cs_assault/Money.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
        self.Armed = true
		local phys = self:GetPhysicsObject()

		if (phys:IsValid()) then
			phys:Wake()
			phys:SetMass(5)
        end

		self:GetPhysicsObject():SetMass(2)
		self:SetUseType(SIMPLE_USE)
    end

    function ENT:Think()
        self.lifetime = self.lifetime or CurTime() + 10
        if CurTime() > self.lifetime then self:Remove() end
    end

    function ENT:Disable()
        self.PhysicsCollide = function() end
        self.lifetime = CurTime() + 15
    end

    function ENT:PhysicsCollide(data, phys)
        local hitEnt = data.HitEntity
        if not IsValid(self) or self.HasHit or not self.Armed then return end
        if not IsValid(hitEnt) or not hitEnt:IsPlayer() or not hitEnt:IsTerror() then
            self.Armed = false
            self:Disable()
            return
        end

        self.HasHit = true
        self.Armed = false
        local dmg = DamageInfo()
        local attacker = self:GetOwner()
        local inflictor = ents.Create("swep_moneylauncher")
        if not IsValid(attacker) then attacker = self end
        dmg:SetAttacker(attacker)
        dmg:SetInflictor(inflictor)
        local r = GetConVar("ttt_moneylauncher_randomDamage"):GetFloat()
        local rand = math.random(-r, r)
        local dm = GetConVar("ttt_moneylauncher_damage"):GetInt() + rand
        dmg:SetDamage(dm > 0 and dm or 0)
        dmg:SetDamageType(DMG_GENERIC)
        hitEnt:TakeDamageInfo(dmg)
        local effectdata = EffectData()
        effectdata:SetStart(data.HitPos)
        effectdata:SetOrigin(data.HitPos)
        effectdata:SetScale(1)
        util.Effect("BloodImpact", effectdata)
        self:Disable()
    end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end
