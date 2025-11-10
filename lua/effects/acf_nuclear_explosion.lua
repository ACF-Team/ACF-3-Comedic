local TraceData = { start = true, endpos = true, mask = MASK_SOLID }
local TraceLine = util.TraceLine
local GetIndex  = ACF.GetAmmoDecalIndex
local GetDecal  = ACF.GetRicochetDecal
local Effects   = ACF.Utilities.Effects
local Sounds    = ACF.Utilities.Sounds
local Debug     = ACF.Debug
local White     = Color(255, 255, 255)
local Yellow    = Color(255, 255, 0)
local Colors    = Effects.MaterialColors

function EFFECT:Init(Data)
	self.Start = CurTime()
	self.ShockwaveLife = 0.1

	local Origin  = Data:GetOrigin()
	local Normal  = Data:GetNormal():GetNormalized() -- Gross
	local Size    = Data:GetScale()
	local Radius  = math.max(Size * 0.02, 1)
	local Emitter = ParticleEmitter(Origin)
	local Mult    = LocalPlayer():GetInfoNum("acf_cl_particlemul", 1)

	self.Radius = Radius

	Debug.Cross(Origin, 15, 15, Yellow, true)
	--Debug.Sphere(Origin, Size, 15, Yellow, true)

	TraceData.start  = Origin - Normal * 5
	TraceData.endpos = Origin + Normal * Radius

	local Impact     = TraceLine(TraceData)
	local SmokeColor = Colors[Impact.MatType] or Colors.Default

	if Impact.HitSky or not Impact.Hit then
		TraceData.start = Origin
		TraceData.endpos = Origin - Vector(0, 0, Size * 2)
		TraceData.collisiongroup = 1
		local Impact = TraceLine(TraceData)
		self:Airburst(Emitter, Impact.Hit, Origin, Impact.HitPos, Radius * 0.5, Normal, SmokeColor, Colors[Impact.MatType] or Colors.Default, Mult)
	else
		local HitNormal = Impact.HitNormal
		local Entity    = Impact.Entity

		self:GroundImpact(Emitter, Origin, Radius, HitNormal, SmokeColor, Mult)

		if Radius > 1 and (IsValid(Entity) or Impact.HitWorld) then
			local Size = Radius * 0.66
			local Type = GetIndex("HE")
			if Type then
				util.DecalEx(GetDecal(Type), Entity, Impact.HitPos, HitNormal, White, Size, Size)
			end
		end
	end

	util.ScreenShake(Origin, 100, 45, 20, 200000, true)
end

function EFFECT:Core(Origin, Radius)

	local SoundData = Sounds.GetExplosionSoundPath(Radius)

	Sounds.PlaySound(Origin, SoundData.SoundPath:format(math.random(0, 4)), SoundData.SoundVolume, SoundData.SoundPitch, 1)
end

function EFFECT:GroundImpact(Emitter, Origin, Radius, HitNormal, SmokeColor, Mult)
	self:Core(Origin, Radius)

	if not IsValid(Emitter) then return end
	Radius = Radius * 10

	-- Debris flecks flown off by the explosion
	local DebrisParts = 5 * math.Clamp(Radius, 1, 400) * Mult
	for _ = 0, DebrisParts do
		local Debris = Emitter:Add("effects/fleck_tile" .. math.random(1, 2), Origin)

		if Debris then
			Debris:SetVelocity((HitNormal + VectorRand()) * 150 * Radius)
			Debris:SetLifeTime(0)
			Debris:SetDieTime(math.Rand(0.5, 1) * Radius * 40)
			Debris:SetStartAlpha(255)
			Debris:SetEndAlpha(0)
			Debris:SetStartSize(math.Clamp(Radius, 1, 7))
			Debris:SetEndSize(math.Clamp(Radius, 1, 7))
			Debris:SetRoll(math.Rand(0, 360))
			Debris:SetRollDelta(math.Rand(-3, 3))
			Debris:SetAirResistance(30)
			Debris:SetGravity(Vector(0, 0, -650))
			Debris:SetColor(120, 120, 120)
		end
	end

	-- Embers flown off by the explosion
	local EmberParts = 5 * math.Clamp(Radius, 7, 10) * Mult
	for _ = 0, EmberParts do
		local Embers = Emitter:Add("particles/flamelet" .. math.random(1, 5), Origin)

		if Embers then
			Embers:SetVelocity((HitNormal + VectorRand()) * 170 * Radius)
			Embers:SetLifeTime(0)
			Embers:SetDieTime(20 * math.Rand(0.4, 0.8) * Radius)
			Embers:SetStartAlpha(255)
			Embers:SetEndAlpha(0)
			Embers:SetStartSize(Radius * 1.2)
			Embers:SetEndSize(0)
			Embers:SetStartLength(Radius * 3)
			Embers:SetEndLength(0)
			Embers:SetRoll(math.Rand(0, 360))
			Embers:SetRollDelta(math.Rand(-0.2, 0.2))
			Embers:SetAirResistance(5)
			Embers:SetGravity(Vector(0, 0, -2000))
			Embers:SetColor(200, 200, 200)
		end
	end

	local DietimeMod = math.Clamp(Radius, 1, 14) * 4

	local SmokeParts = math.Clamp(Radius, 3, 150) * Mult
	for _ = 0, SmokeParts do
		if Radius >= 4 then
			local Smoke = Emitter:Add("particle/smokesprites_000" .. math.random(1, 9), Origin)

			if Smoke then
				Smoke:SetVelocity((HitNormal + VectorRand() * 0.75) * 1 * Radius)
				Smoke:SetLifeTime(0)
				Smoke:SetDieTime(math.Rand(0.02, 0.04) * Radius * 40)
				Smoke:SetStartAlpha(math.Rand(180, 255))
				Smoke:SetEndAlpha(0)
				Smoke:SetStartSize(30 * Radius)
				Smoke:SetEndSize(40 * Radius)
				Smoke:SetAirResistance(0)
				Smoke:SetColor(SmokeColor.r, SmokeColor.g, SmokeColor.b)
				Smoke:SetStartLength(Radius * 20)
				Smoke:SetEndLength(Radius * 125)
			end
		end

		local Smoke  = Emitter:Add("particle/smokesprites_000" .. math.random(1, 9), Origin)
		local Radmod = Radius * 0.25
		local ScaleAdd = _ * 30
		if Smoke then
			Smoke:SetVelocity((HitNormal + VectorRand() * 0.237) * (math.random(300, 450) + ScaleAdd * 1.3) * Radmod)
			Smoke:SetLifeTime(0)
			Smoke:SetDieTime(math.Rand(0.8, 1) * DietimeMod * 40)
			Smoke:SetStartAlpha(math.Rand(150, 200))
			Smoke:SetEndAlpha(0)
			Smoke:SetStartSize(((50 + (SmokeParts * 4)) + ScaleAdd * 0.3) * Radmod)
			Smoke:SetEndSize(((85 + (SmokeParts * 4)) + ScaleAdd * 0.34) * Radmod)
			Smoke:SetRoll(math.Rand(150, 360))
			Smoke:SetRollDelta(math.Rand(-0.2, 0.2))
			Smoke:SetAirResistance(14 * Radius)
			Smoke:SetGravity(Vector(math.random(-2, 2) * Radius, math.random(-2, 2) * Radius, (math.random(2, 5) + (_ * 20)) * Radius))
			Smoke:SetColor(SmokeColor.r, SmokeColor.g, SmokeColor.b)
		end
	end

	local Density = math.Clamp(Radius, 10, 90) * math.Clamp(math.Remap(FrameTime(), 0, 0.02, 8, 1), 1, 8)
	local HitNormalAngle = HitNormal:Angle()
	local HitNormalForward = HitNormalAngle:Forward()
	local Angle = HitNormalAngle

	local DustParts = Density * Mult
	for _ = 0, DustParts do
		Angle:RotateAroundAxis(Angle:Forward(), 360 / DustParts)

		local TracePoint = util.TraceLine {
			start = Origin + (HitNormalForward * 2) * math.Rand(2, 4) * Radius,
			endpos = (Origin + (Angle:Up() * math.Rand(-2, -100) * Radius)) - (HitNormalForward * 10)
		}

		-- debugoverlay.Line(TracePoint.StartPos, TracePoint.HitPos, 2, Color(255, 0, 0), true)
		-- debugoverlay.Cross(TracePoint.StartPos, 4, 4, Color(255, 111, 111), true)
		-- debugoverlay.Cross(TracePoint.HitPos, 4, 4, Color(120, 255, 142), true)

		if TracePoint.Hit then
			local TraceTime = TracePoint.StartPos:Distance(TracePoint.HitPos) / 2000
			local Smoke = Emitter:Add("particle/smokesprites_000" .. math.random(1, 9), TracePoint.HitPos)

			if Smoke then
				Smoke:SetVelocity((-Angle:Up() * math.Rand(70, 180 * Radius)) + (HitNormalForward * math.Rand(70 * Radius, 140 * Radius)))
				Smoke:SetLifeTime(-TraceTime)
				Smoke:SetDieTime(math.Rand(0.5, 0.6) * DietimeMod* 40)
				Smoke:SetStartAlpha(math.Rand(100, 140))
				Smoke:SetEndAlpha(0)
				Smoke:SetStartSize(10 * Radius)
				Smoke:SetEndSize(25 * Radius)
				Smoke:SetRoll(math.Rand(0, 360))
				Smoke:SetRollDelta(math.Rand(-0.2, 0.2))
				Smoke:SetAirResistance(35 * Radius)
				Smoke:SetGravity(Vector(math.Rand(-20, 20), math.Rand(-20, 20), -math.Rand(220, 400)))
				Smoke:SetColor(SmokeColor.r, SmokeColor.g, SmokeColor.b)
			end

			local Smoke = Emitter:Add("particle/smokesprites_000" .. math.random(1, 9), TracePoint.HitPos)

			if Smoke then
				Smoke:SetVelocity((-Angle:Up() * math.Rand(70, 180 * Radius)) + (HitNormalForward * math.Rand(70 * Radius, 140 * Radius)))
				Smoke:SetLifeTime(-TraceTime)
				Smoke:SetDieTime(math.Rand(0.2, 0.4) * DietimeMod * 40)
				Smoke:SetStartAlpha(math.Rand(70, 120))
				Smoke:SetEndAlpha(0)
				Smoke:SetStartSize(5 * Radius)
				Smoke:SetEndSize(10 * Radius)
				Smoke:SetRoll(math.Rand(0, 360))
				Smoke:SetRollDelta(math.Rand(-0.2, 0.2))
				Smoke:SetAirResistance(75 * Radius)
				Smoke:SetGravity(Vector(math.Rand(-20, 20), math.Rand(-20, 20), -math.Rand(220, 400)))
				Smoke:SetColor(SmokeColor.r, SmokeColor.g, SmokeColor.b)
			end
		end


		local EF = Emitter:Add("effects/muzzleflash" .. math.random(1, 4), Origin)

		if EF then
			EF:SetVelocity((Angle:Up() + HitNormal * math.random(0.3, 5)):GetNormalized() *  1)
			EF:SetAirResistance(100)
			EF:SetDieTime(24)
			EF:SetStartAlpha(240)
			EF:SetEndAlpha(0)
			EF:SetStartSize(15 * Radius * 400)
			EF:SetEndSize(4 * Radius * 100)
			EF:SetRoll(800)
			EF:SetRollDelta( math.random(-1, 1) )
			EF:SetColor(255, 255, 255)
			EF:SetStartLength(Radius * 20)
			EF:SetEndLength(Radius * 1)
		end
	end

	-- The initial explosion flash
	for _ = 0, 255 do
		local Flame = Emitter:Add("effects/muzzleflash" .. math.random(1, 4), Origin)

		if Flame then
			Flame:SetVelocity((HitNormal + VectorRand()) * 150 * Radius)
			Flame:SetLifeTime(0)
			Flame:SetDieTime(24)
			Flame:SetStartAlpha(220)
			Flame:SetEndAlpha(5)
			Flame:SetStartSize(Radius * 90 * 500)
			Flame:SetEndSize(Radius * 100 * 150)
			Flame:SetRoll(math.random(120, 360))
			Flame:SetRollDelta(math.Rand(-1, 1))
			Flame:SetAirResistance(30)
			Flame:SetGravity(Vector(0, 0, 255))
			Flame:SetColor(255, 255, 255)
		end
	end
	-- print("DebrisParts", DebrisParts, "EmberParts", EmberParts, "SmokeParts", SmokeParts, "DustParts", DustParts)
	Emitter:Finish()
end

function EFFECT:Airburst(Emitter, GroundHit, Origin, GroundOrigin, Radius, Direction, SmokeColor, GroundColor, Mult)
	self:Core(Origin, Radius)

	if not IsValid(Emitter) then return end

	local rv = 20
	for _ = 0, rv do
		local rrv = 360 / rv
		Angle:RotateAroundAxis(Angle:Forward(), rrv)
		GroundAngle :RotateAroundAxis(GroundAngle:Forward(), rrv)

		local EF = Emitter:Add("effects/muzzleflash" .. math.random(1, 4), Origin)

		if EF then
			EF:SetVelocity((Angle:Up() + Direction * math.random(0.3, 5)):GetNormalized() *  1)
			EF:SetAirResistance(100)
			EF:SetDieTime(10)
			EF:SetStartAlpha(240)
			EF:SetEndAlpha(20)
			EF:SetStartSize(1525 * Radius)
			EF:SetEndSize(255 * Radius)
			EF:SetRoll(800)
			EF:SetRollDelta( math.random(-1, 1) )
			EF:SetColor(255, 255, 255)
			EF:SetStartLength(Radius * 25)
			EF:SetEndLength(Radius * 1)
		end
	end

	Emitter:Finish()
end

function EFFECT:Think()
	return (CurTime() - self.Start) < self.ShockwaveLife
end