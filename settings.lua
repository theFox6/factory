-- LemonLake's Factories: Config

--TODO: turn into registrations

-- Logging
factory.logTaker = false

-- NB: miners require fans in the crafting recipe. recommended to enable fans if miners are enabled.
-- 	   alternatively change the crafting recipe manually in crafting.lua

factory.enableMiner = true
factory.enableFan = true
factory.enableVacuum = true

factory.fertilizerGeneration = true

factory.minerDigLimit = 512

-- Defines the device types for movers and takers.
-- Don't change unless you know what you're doing.

-- Requires fuel and src inventory lists.
armDevicesFurnacelike = {"default:furnace", "default:furnace_active",
						"factory:ind_furnace", "factory:ind_furnace_active",
						"factory:ind_squeezer", "factory:ind_squeezer_active",
						"factory:wire_drawer", "factory:wire_drawer_active",
						"factory:stp"}
-- Requires src invenory list.
armDevicesCrafterlike = {"factory:autocrafter"}

-- Requires dst inventory list.
takerDevicesFurnacelike = {"default:furnace", "default:furnace_active",
						"factory:ind_furnace", "factory:ind_furnace_active",
						"factory:ind_squeezer", "factory:ind_squeezer_active",
						"factory:wire_drawer", "factory:wire_drawer_active",
						"factory:stp", "factory:autocrafter"}

-- Fuel types for the generator
--generatorFuel = {{name = "factory:tree_sap", value = 20}}
-- TODO: Add items for other Technic blocks

-- Sapling IO for the Sapling Treatment Plant
factory.stpIO = {	{input = "default:sapling", output = "default:tree",				min = 4, 	max = 7},
					{input = "default:junglesapling", output="default:jungletree",		min = 8, 	max = 12},
					-- these moretrees values are incorrect, please change them to your liking
					{input = "moretrees:beech_sapling", output="moretrees:beech_trunk", min = 4,	max = 8},
					{input = "moretrees:apple_tree_sapling", output="moretrees:apple_tree_trunk",	min = 4, max = 8},
					{input = "moretrees:oak_sapling", output="moretrees:oak_trunk",		min = 4, max = 8},
					{input = "moretrees:sequoia_sapling", output="moretrees:sequoia_trunk", min = 4, max = 8},
					{input = "moretrees:birch_sapling", output="moretrees:birch_trunk", min = 4, max = 8},
					{input = "moretrees:palm_sapling", output="moretrees:palm_trunk", 	min = 4, max = 8},
					{input = "moretrees:spruce_sapling", output="moretrees:spruce_trunk", min = 4, max = 8},
					{input = "moretrees:pine_sapling", output="moretrees:pine_trunk", 	min = 4, max = 8},
					{input = "moretrees:willow_sapling", output="moretrees:willow_trunk", min = 4, max = 8},
					{input = "moretrees:acacia_sapling", output="moretrees:acacia_trunk", min = 4, max = 8},
					{input = "moretrees:rubber_tree_sapling", output="moretrees:rubber_tree_trunk", min = 4, max = 8},
					{input = "moretrees:fir_sapling", output="moretrees:fir_trunk", 	min = 4, max = 8},
					-- your trees here
		 }