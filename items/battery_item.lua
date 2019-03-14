local S = factory.S
--can save 100 energy (10s fuel)
minetest.register_craftitem("factory:battery_item", {
	description = S("battery"),
	inventory_image = "factory_battery.png"
})

minetest.register_craft({
	output = 'factory:battery_item',
	recipe = {
		{'moreores:silver_ingot'},
		{'group:wood'},
		{'technic:zinc_ingot'},
	}
})
