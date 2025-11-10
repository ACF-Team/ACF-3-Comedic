local Missiles = ACF.Classes.Missiles

Missiles.RegisterItem("LITTLEBOY", "BOMB", {
	Name		= "Little Boy Nuclear Weapon",
	Description	= "oppenheimer",
	Model		= "models/acf/comedic/littleboy.mdl",
	Length		= 450,
	Caliber		= 27700,
	Mass		= 4400,
	Year		= 1945,
	Diameter	= 22 * ACF.InchToMm, -- in mm
	ReloadTime	= 2,
	Offset		= Vector(42, 0, -3),
	Racks		= { ["1xRK"] = true },
	Guidance	= { Dumb = true },
	Navigation  = "Chase",
	Fuzes		= { Contact = true, Optical = true},
	Agility		= 1,
	ArmDelay	= 3,
	Round = {
		Model           = "models/acf/comedic/littleboy.mdl",
		MaxLength       = 4450,
		Armor           = 5,
		ProjLength      = 4450,
		PropLength      = 0,
		Thrust          = 1, -- in kg*in/s^2
		FuelConsumption = 0.1, -- in g/s/f
		StarterPercent  = 0.005,
		MaxAgilitySpeed = 1, -- in m/s
		DragCoef        = 0.1,
		FinMul          = 0.01,
		GLimit          = 1,
		TailFinMul      = 200,
		PenMul          = 1,
		FillerRatio     = 0.85,
		ActualLength    = 800,
		ActualWidth     = 50
	},
	Preview = {
		FOV = 80,
	},
})
