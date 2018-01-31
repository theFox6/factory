local S = factory.S

factory.miner = {}
function factory.miner.afterdig(pos, oldnode, oldmetadata, digger)
	for i = 1, factory.minerDigLimit do
		local node = minetest.get_node({x = pos.x, y = pos.y-i, z = pos.z})
		if node.name == "ignore" then
			minetest.get_voxel_manip():read_from_map({x = pos.x, y = pos.y-i, z = pos.z}, {x = pos.x, y = pos.y-i-2, z = pos.z})
			node = minetest.get_node({x = pos.x, y = pos.y-i, z = pos.z})
		end
		if node.name == "factory:miner_drillbit" then
			minetest.set_node({x = pos.x, y = pos.y-i, z = pos.z}, {name="air"})
		end
	end
end

minetest.register_node("factory:miner_on", {
	description = S("Industrial Miner"),
	tiles = {{name="factory_fan.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.2}}, "factory_belt_bottom.png", "factory_belt_bottom_clean.png",
		"factory_belt_bottom_clean.png", "factory_belt_bottom_clean.png", {name="factory_miner.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.7}}},
	groups = {cracky = 2, mesecon_effector_off = 1},
	paramtype2 = "facedir",
	is_ground_content = true,
	legacy_facedir_simple = true,
	mesecons = {effector = {
		action_on = function(pos, node)
			local meta = minetest.get_meta(pos)
			meta:set_string("infotext",S("Industrial Miner was switched off"))
			minetest.swap_node(pos, {name = "factory:miner_off", param2 = node.param2})
		end
	}},
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local meta = minetest:get_meta(pos)
		if placer:is_player() then
			meta:set_string("owner", placer:get_player_name())
			meta:set_string("infotext",S("Industrial Miner"))
		end
	end,
	after_dig_node = factory.miner.afterdig,
})

minetest.register_node("factory:miner_off", {
	description = S("Industrial Miner"),
	tiles = {"factory_fan_off.png", "factory_belt_bottom.png", "factory_belt_bottom_clean.png",
		"factory_belt_bottom_clean.png", "factory_belt_bottom_clean.png", "factory_miner_off.png"},
	groups = {cracky = 2, not_in_creative_inventory = 1, mesecon_effector_on = 1},
	paramtype2 = "facedir",
	is_ground_content = true,
	legacy_facedir_simple = true,
	drop="factory:miner_on",
	mesecons = {effector = {
		action_off = function(pos, node)
			local meta = minetest.get_meta(pos)
			meta:set_string("infotext",S("Industrial Miner"))
			minetest.swap_node(pos, {name = "factory:miner_on", param2 = node.param2})
		end
	}},
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		-- not supposed to be placed. switch to factory:miner_on
		minetest.swap_node(pos, {name = "factory:miner_on", param2 = node.param2})
	end,
	after_dig_node = factory.miner.afterdig,
})

minetest.register_node("factory:miner_drillbit", {
	tiles = {"factory_machine_steel_dark.png"},
	diggable = false,
	groups = {not_in_creative_inventory = 1},
	drawtype = "nodebox",
	paramtype = "light",
	drop = nil,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.125, -0.5, -0.125, 0.125, 0.5, 0.125},
		}
	}
})

minetest.register_abm({
	nodenames = {"factory:miner_on"},
	neighbors = nil,
	interval = 4.8,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.get_meta(pos)
		for i = 1, factory.minerDigLimit do
			local node = minetest.get_node({x = pos.x, y = pos.y-i, z = pos.z})
			local registered = minetest.registered_nodes[node.name]
			if node.name == "ignore" then
				minetest.get_voxel_manip():read_from_map({x = pos.x, y = pos.y-i, z = pos.z}, {x = pos.x, y = pos.y-i-2, z = pos.z})
				--minetest.forceload_block({x = pos.x, y = pos.y-i, z = pos.z})
				--minetest.forceload_block({x = pos.x, y = pos.y-i-2, z = pos.z})
				node = minetest.get_node({x = pos.x, y = pos.y-i, z = pos.z})
			end
			if node.name ~= "factory:miner_drillbit" then
				if meta:get_string("owner") ~= nil and minetest.is_protected(node.pos, meta:get_string("owner")) then
					node = minetest.get_node(pos)
					meta:set_string("infotext",S("Industrial Miner hit protected block"))
					minetest.swap_node(pos, {name = "factory:miner_off", param2 = node.param2})
					return
				end
				if string.find(node.name, "lava") then
					node = minetest.get_node(pos)
					meta:set_string("infotext",S("Industrial Miner hit lava"))
					minetest.swap_node(pos, {name = "factory:miner_off", param2 = node.param2})
					return
				end
				if node.name ~= "air" and registered.diggable ~= nil and not registered.diggable then
					node = minetest.get_node(pos)
					meta:set_string("infotext",S("Industrial Miner hit undiggable block"))
					minetest.swap_node(pos, {name = "factory:miner_off", param2 = node.param2})
					return
				end
				minetest.set_node({x = pos.x, y = pos.y-i, z = pos.z}, {name="factory:miner_drillbit"})
				if node.name == "air" then return end
				local itemstacks = minetest.get_node_drops(node.name)
				for _, itemname in ipairs(itemstacks) do
					minetest.add_item({x = pos.x, y = pos.y+1, z = pos.z}, itemname)
				end
				return
			end
		end
		local node = minetest.get_node(pos)
		meta:set_string("infotext",S("Industrial Miner has reached the maximum length"))
		minetest.swap_node(pos, {name = "factory:miner_off", param2 = node.param2})
	end,
})

--

minetest.register_node("factory:miner_upgraded_on", {
	description = S("Upgraded Miner"),
	tiles = {{name="factory_fan.png^factory_gold_ring_x2.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.2}}, "factory_belt_bottom.png^factory_gold_ring.png", "factory_belt_bottom_clean.png^factory_gold_ring.png",
		"factory_belt_bottom_clean.png^factory_gold_ring.png", "factory_belt_bottom_clean.png^factory_gold_ring.png", {name="factory_miner_upgraded.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.7}}},
	groups = {cracky = 2, mesecon_effector_off = 1},
	paramtype2 = "facedir",
	is_ground_content = true,
	legacy_facedir_simple = true,
	mesecons = {effector = {
		action_on = function(pos, node)
			local meta = minetest.get_meta(pos)
			meta:set_string("infotext",S("Upgraded Miner was switched off"))
			minetest.swap_node(pos, {name = "factory:miner_upgraded_off", param2 = node.param2})
		end
	}},
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		local meta = minetest:get_meta(pos)
		if placer:is_player() then
			meta:set_string("owner", placer:get_player_name())
			meta:set_string("infotext",S("Upgraded Miner"))
		end
	end,
	after_dig_node = factory.miner.afterdig,
})

minetest.register_node("factory:miner_upgraded_off", {
	description = "Upgaded Miner",
	tiles = {"factory_fan_off.png^factory_gold_ring_x2.png", "factory_belt_bottom.png^factory_gold_ring.png", "factory_belt_bottom_clean.png^factory_gold_ring.png",
		"factory_belt_bottom_clean.png^factory_gold_ring.png", "factory_belt_bottom_clean.png^factory_gold_ring.png", "factory_miner_upgraded_off.png"},
	groups = {cracky = 2, not_in_creative_inventory = 1, mesecon_effector_on = 1},
	paramtype2 = "facedir",
	is_ground_content = true,
	legacy_facedir_simple = true,
	drop="factory:miner_on",
	mesecons = {effector = {
		action_off = function(pos, node)
			local meta = minetest.get_meta(pos)
			meta:set_string("infotext",S("Upgraded Miner"))
			minetest.swap_node(pos, {name = "factory:miner_upgraded_on", param2 = node.param2})
		end
	}},
	after_place_node = function(pos, placer, itemstack, pointed_thing)
		-- not supposed to be placed. switch to factory:miner_on
		minetest.swap_node(pos, {name = "factory:miner_upgraded_on", param2 = node.param2})
	end,
	after_dig_node = factory.miner.afterdig,
})

minetest.register_abm({
	nodenames = {"factory:miner_upgraded_on"},
	neighbors = nil,
	interval = 1.8,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.get_meta(pos)
		for i = 1, factory.minerDigLimit do
			local node = minetest.get_node({x = pos.x, y = pos.y-i, z = pos.z})
			local registered = minetest.registered_nodes[node.name]
			if node.name == "ignore" then
				minetest.get_voxel_manip():read_from_map({x = pos.x, y = pos.y-i, z = pos.z}, {x = pos.x, y = pos.y-i-2, z = pos.z})
				--minetest.forceload_block({x = pos.x, y = pos.y-i-2, z = pos.z})
				node = minetest.get_node({x = pos.x, y = pos.y-i, z = pos.z})
			end
			if node.name ~= "factory:miner_drillbit" then
				if meta:get_string("owner") ~= nil and minetest.is_protected(node.pos, meta:get_string("owner")) then
					node = minetest.get_node(pos)
					meta:set_string("infotext",S("Upgraded Miner hit protected block"))
					minetest.swap_node(pos, {name = "factory:miner_upgraded_off", param2 = node.param2})
					return
				end
				if string.find(node.name, "lava") then
					node = minetest.get_node(pos)
					meta:set_string("infotext",S("Upgraded Miner hit lava"))
					minetest.swap_node(pos, {name = "factory:miner_upgraded_off", param2 = node.param2})
					return
				end
				if node.name ~= "air" and registered.diggable ~= nil and not registered.diggable then
					node = minetest.get_node(pos)
					meta:set_string("infotext",S("Upgraded Miner hit undiggable block"))
					minetest.swap_node(pos, {name = "factory:miner_upgraded_off", param2 = node.param2})
					return
				end
				minetest.set_node({x = pos.x, y = pos.y-i, z = pos.z}, {name="factory:miner_drillbit"})
				if node.name == "air" then return end
				local itemstacks = minetest.get_node_drops(node.name)
				for _, itemname in ipairs(itemstacks) do
					minetest.add_item({x = pos.x, y = pos.y+1, z = pos.z}, itemname)
				end
				return
			end
		end
		local node = minetest.get_node(pos)
		minetest.swap_node(pos, {name = "factory:miner_upgraded_off", param2 = node.param2})
		meta:set_string("infotext",S("Upgraded Miner has reached the maximum length"))
	end,
})