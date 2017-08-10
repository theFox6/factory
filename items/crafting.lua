local S = factory.S

minetest.register_craft({
	output = "factory:small_steel_gear 3",
	recipe = {
		{"default:steel_ingot", "", "default:steel_ingot"},
		{"", "default:steel_ingot", ""},
		{"default:steel_ingot", "", "default:steel_ingot"}
	}
})

minetest.register_craft({
	output = "factory:small_gold_gear 2",
	recipe = {
		{"default:gold_ingot", "", "default:gold_ingot"},
		{"", "factory:small_steel_gear", ""},
		{"default:gold_ingot", "", "default:gold_ingot"}
	}
})

minetest.register_craft({
	output = "factory:small_diamond_gear 2",
	recipe = {
		{"default:diamond", "", "default:diamond"},
		{"", "factory:small_gold_gear", ""},
		{"default:diamond", "", "default:diamond"}
	}
})

minetest.register_craft({
	output = "factory:scanner_chip",
	recipe = {
		{"default:steel_ingot", "default:stick", "default:mese_crystal"},
		{"", "factory:tree_sap", ""},
		{"default:mese_crystal", "", "default:steel_ingot"}
	}
})

minetest.register_craft({
	output = "factory:storage_tank",
	recipe = {
		{"default:glass", 	"default:steel_ingot", 		"default:glass"},
		{"default:glass", 	"", 						"default:glass"},
		{"default:glass", 	"default:steel_ingot", 		"default:glass"}
	}
})

minetest.register_craft({
	output = "factory:sapling_fertilizer",
	recipe = {
		{"default:dirt", 	"default:dirt"},
		{"default:dirt",	"default:dirt"},
	}
})


minetest.register_craft({
	type = "shapeless",
	output = "factory:fan_blade",
	recipe = {
		"default:steel_ingot",
		"factory:tree_sap",
		"default:stick"
	}
})

factory.register_recipe_type("ind_squeezer", {
	description = S("squeezing"),
	icon = "factory_compressor_front.png",
	width = 1,
	height = 1,
})

factory.register_recipe("ind_squeezer",{
	output = "factory:tree_sap",
	input = {"default:tree"}
})

factory.register_recipe("ind_squeezer",{
	output = "factory:tree_sap",
	input = {"default:jungletree"}
})

factory.register_recipe("ind_squeezer",{
	output = "factory:compressed_clay",
	input = {"default:clay_lump"}
})


factory.register_recipe("ind_squeezer",{
	output = "default:sandstone",
	input = {"default:sand"}
})

minetest.register_craft({
	type = "cooking", 
	output = "factory:factory_lump",
	recipe = "factory:compressed_clay"
})