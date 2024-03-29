minetest.register_craft({
	output = "factory:belt 12",
	recipe = {
		{"", "", ""},
		{"default:stone", "factory:small_steel_gear", "default:stone"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
	}
})

minetest.register_craft({
	output = "factory:belt_center 12",
	recipe = {
		{"", "default:gold_ingot", ""},
		{"default:stone", "factory:small_steel_gear", "default:stone"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "factory:belt_center",
	recipe = {"factory:belt", "default:gold_ingot"}
})

minetest.register_craft({
	output = "factory:arm",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "farming:hoe_steel"},
		{"default:steel_ingot", "factory:small_steel_gear", "factory:small_steel_gear"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
	}
})

minetest.register_craft({
	output = "factory:ind_furnace",
	recipe = {
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
		{"default:steel_ingot", "default:furnace", "default:steel_ingot"},
		{"default:stonebrick", "default:obsidian", "default:stonebrick"}
	}
})

minetest.register_craft( {
	output = "factory:autocrafter",
	recipe = {
		{ "factory:factory_brick", "factory:factory_brick", "factory:factory_brick" },
		{ "factory:small_diamond_gear", "default:steel_ingot", "factory:small_diamond_gear" },
		{ "factory:factory_brick", "factory:factory_brick", "factory:factory_brick" }
	},
})

minetest.register_craft({
	output = "factory:taker",
	recipe = {
		{"default:shovel_steel", "default:steel_ingot", "default:steel_ingot"},
		{"factory:small_steel_gear", "factory:small_steel_gear", "default:steel_ingot"},
		{"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "factory:taker_gold",
	recipe = {"factory:taker", "factory:small_gold_gear"} --"default:goldblock"
})

minetest.register_craft({
	type = "shapeless",
	output = "factory:taker_diamond",
	recipe = {"factory:taker_gold", "factory:small_diamond_gear"} --"default:diamondblock"
})

minetest.register_craft({
	type = "shapeless",
	output = "factory:queuedarm",
	recipe = {"factory:arm", "default:chest", "factory:small_gold_gear"}
})

minetest.register_craft({
	type = "shapeless",
	output = "factory:overflowarm",
	recipe = {"factory:arm", "farming:hoe_steel", "factory:small_gold_gear"}
})

minetest.register_craft({
	output = "factory:ind_squeezer",
	recipe = {
		{"default:glass", "factory:piston", "default:glass"},
		{"default:glass", "", "default:glass"},
		{"factory:small_gold_gear", "factory:ind_furnace", "factory:small_gold_gear"}
	}
})

minetest.register_craft({
	output = "factory:wire_drawer",
	recipe = {
		{"default:glass", "default:stick", "default:glass"},
		{"default:glass", "default:stick", "default:glass"},
		{"factory:small_gold_gear", "default:furnace", "factory:small_gold_gear"}
	}
})

minetest.register_craft({
	output = "factory:grinder",
	recipe = {
		{"default:stonebrick",  "default:stonebrick", "default:stonebrick"},
		{"factory:small_diamond_gear", "",    "factory:small_diamond_gear"},
		{"default:stonebrick",  "default:furnace",    "default:stonebrick"}
	}
})

minetest.register_craft({
	output = "factory:swapper",
	recipe = {
		{   "default:steel_ingot",   "default:steel_ingot",    "default:steel_ingot"},
		{            "",                "default:chest",                ""},
		{"factory:small_steel_gear", "factory:scanner_chip", "factory:small_steel_gear"}
	}
})

minetest.register_craft({
	output = "factory:fan_on",
	recipe = {
		{"default:steel_ingot", "factory:fan_blade", "default:steel_ingot"},
		{"factory:fan_blade", "factory:small_gold_gear", "factory:fan_blade"},
		{"default:steel_ingot", "factory:fan_blade", "default:steel_ingot"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "factory:fan_wall_on",
	recipe = {"factory:fan_on"}
})

minetest.register_craft({
	output = "factory:miner_on",
	recipe = {
		{"default:steel_ingot", 	"factory:fan_on", 			"default:steel_ingot"},
		{"factory:small_gold_gear", "factory:taker_on", 		"factory:small_gold_gear"},
		{"default:steel_ingot", 	"default:pick_mese", 		"default:steel_ingot"}
	}
})

minetest.register_craft({
	output = "factory:miner_upgraded_on",
	recipe = {
		{"", 						"factory:small_diamond_gear",	""},
		{"factory:small_gold_gear", "factory:miner_on", 		"factory:small_gold_gear"},
		{"default:gold_ingot", 		"default:pick_diamond", 	"default:gold_ingot"}
	}
})

minetest.register_craft({
	output = "factory:vacuum_on",
	recipe = {
		{"default:steel_ingot", 	"factory:taker_on", 			"default:steel_ingot"},
		{"factory:small_steel_gear",	"factory:small_gold_gear", 		"factory:small_steel_gear"},
		{"", 				"default:steel_ingot", 			""}
	}
})

minetest.register_craft({
	output = "factory:upward_vacuum_off",
	recipe = {
		{"default:steel_ingot", 	"default:steel_ingot",		"default:steel_ingot"},
		{"default:steel_ingot",		"factory:small_gold_gear", 	"factory:taker_on"},
		{"factory:scanner_chip", 	"factory:vacuum_on", 		"factory:scanner_chip"}
	}
})

if factory.setting_enabled("StpCraft") then
	minetest.register_craft({
		output = "factory:stp",
		recipe = {
			{ "factory:factory_brick", "factory:small_diamond_gear", "factory:factory_brick" },
			{ "default:glass",         "default:dirt",               "factory:factory_brick" },
			{ "factory:factory_brick", "default:mese_crystal",        "factory:factory_brick" }
		}
	})
end
-- vim: et:ai:sw=2:ts=2:fdm=indent:syntax=lua
