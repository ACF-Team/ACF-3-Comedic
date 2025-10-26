local ACF       = ACF
local Guidances = ACF.Classes.Guidances
local Missiles  = ACF.Classes.Missiles
local Guidance  = Guidances.Register("Fate", "Anti-radiation")

-- A hack...
timer.Simple(0.2, function()
	for Key, Value in pairs(Missiles:GetEntries()) do
		for K2, V2 in pairs(Value.Items) do
			V2.Guidance.Fate = true
		end
	end
end)

if CLIENT then
	Guidance.Description = "This guidance package will choose a contraption at random and guide the munition towards it."
else
	function Guidance:UpdateTarget(Missile)
		if not IsValid(self.Target) then -- I might make this better later but this is a shitpost anyway
			local Ents = ents.FindByClass("acf_baseplate")
			self.Target = Ents[math.random(1, #Ents)]
		end

		if IsValid(self.Target) then
			return self.Target:GetPos()
		end
	end

	function Guidance:GetTargetPosition()
		local Target = self.Target

		if not IsValid(Target) then return end

		return Target:GetPos()
	end

	function Guidance:GetGuidance(Missile)
		self:PreGuidance(Missile)

		local Override = self:ApplyOverride(Missile)

		if Override then return Override end

		local TargetPos = self:GetTargetPosition()

		if TargetPos and self:CheckConeLOS(Missile, Missile.Position, TargetPos, self.ViewConeCos) then
			return { TargetPos = TargetPos, ViewCone = self.ViewCone }
		end

		local NewTarget = self:UpdateTarget(Missile)

		if not NewTarget then return {} end

		return { TargetPos = NewTarget }
	end
end
