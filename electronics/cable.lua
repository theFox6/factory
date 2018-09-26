minetest.register_node("factory:cable", {
	description = "cable",
	drawtype = "nodebox",
	tiles = {"factory_belt_bottom_clean.png"},
	groups = {factory_electronic = 1, snappy = 1},
	is_ground_content = false,
	node_box = {
		type = "connected",
		fixed = {-0.25,-0.25,-0.25,0.25,0.25,0.25},
		connect_top = {-0.25,0.25,-0.25,0.25,0.5,0.25},
		connect_bottom = {-0.25,-0.5,-0.25,0.25,-0.25,0.25},
		connect_front = {-0.25,-0.25,-0.5,0.25,0.25,-0.25},
		connect_left = {-0.5,-0.25,-0.25,-0.25,0.25,0.25},
		connect_back = {-0.25,-0.25,0.25,0.25,0.25,0.5},
		connect_right = {0.25,-0.25,-0.25,0.5,0.25,0.25},
	},
	connects_to = {"group:factory_electronic"},
	connect_sides = { "top", "bottom", "front", "left", "back", "right" },
	--[[sounds = {
            footstep = <SimpleSoundSpec>,
            dig = <SimpleSoundSpec>, -- "__group" = group-based sound (default)
            dug = <SimpleSoundSpec>,
            place = <SimpleSoundSpec>,
            place_failed = <SimpleSoundSpec>,
        },]]
	on_push_electricity = function(pos,energy,side_from)
		return factory.electronics.device.distribute(pos,energy,side_from)
	end
})

minetest.register_craft({
	output = 'factory:cable',
	recipe = {
		{"factory:fiber", "factory:copper_wire", "factory:fiber"}
	},
})