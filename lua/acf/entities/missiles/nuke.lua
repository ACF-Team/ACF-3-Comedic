local Missiles = ACF.Classes.Missiles

Missiles.RegisterItem("LITTLEBOY", "BOMB", {
	Name		= "Little Boy Nuclear Weapon",
	Description	= " Oppenheimer is a 2023 epic biographical thriller film written, co-produced, and directed by Christopher Nolan.[8] It follows the life of J. Robert Oppenheimer, the American theoretical physicist who helped develop the first nuclear weapons during World War II. Based on the 2005 biography American Prometheus by Kai Bird and Martin J. Sherwin, the film dramatizes Oppenheimer's studies, his direction of the Los Alamos Laboratory and his 1954 security hearing. Cillian Murphy stars as Oppenheimer, alongside Robert Downey Jr. as the United States Atomic Energy Commission member Lewis Strauss. The ensemble supporting cast includes Emily Blunt, Matt Damon, Florence Pugh, Josh Hartnett, Casey Affleck, Rami Malek, and Kenneth Branagh.",
	Model		= "models/acf/comedic/littleboy.mdl",
	Length		= 450,
	Caliber		= 600,
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
	Blacklist	= { "AP", "APHE", "HE", "HEAT", "HP", "FL", "SM" },
	Round = {
		Model           = "models/acf/comedic/littleboy.mdl",
		MaxLength       = 3048,
		Armor           = 5,
		ProjLength      = 3048,
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
