local S = factory.S

if not minetest.get_modpath("homedecor") then
	minetest.register_craftitem(":homedecor:copper_wire", {
		description = S("spool of @1 wire",S("copper")),
		inventory_image = "homedecor_copper_wire.png"
	})

	minetest.register_craftitem(":homedecor:steel_wire", {
		description = S("spool of @1 wire",S("steel")),
		inventory_image = "homedecor_steel_wire.png"
	})
end

minetest.register_alias("factory:copper_wire", "homedecor:copper_wire")
minetest.register_alias("factory:steel_wire", "homedecor:steel_wire")
--1 ingot = 2 wire spools