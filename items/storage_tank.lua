local S = factory.S

factory.registered_storage_tanks = {}
factory.buckets_tanks = {}

minetest.register_node("factory:storage_tank", {
	description = S("Storage Tank"),
	drawtype = "glasslike_framed", --FIXME: connects to others
	tiles = {"factory_steel_noise.png","factory_glass.png^factory_measure.png",
		"factory_glass.png^factory_port.png", "factory_steel_noise.png"},
	inventory_image = "factory_storage_tank.png",
	use_texture_alpha = "blend",
	paramtype = "light",
	sunlight_propagates = true,
	groups = {oddly_breakable_by_hand = 2},

	on_rightclick = function(pos, _, clicker, itemstack)
		local stack = ItemStack(itemstack)
		local n = factory.buckets_tanks[stack:get_name()]
		if not n then return end

		local d = factory.registered_storage_tanks[n]
		minetest.swap_node(pos, {
			name = "factory:storage_tank_"..n,
			param2 = d.increment - 1 + 64 + 128
		})
		local meta = minetest.get_meta(pos)
		meta:set_int("stored", d.increment)
		local inv = clicker:get_inventory()
		stack:take_item(1)
		if inv:room_for_item("main", {name=d.bucket_empty}) then
			inv:add_item("main", d.bucket_empty)
		else
			local ppos = clicker:get_pos()
			ppos.y = math.floor(ppos.y + 0.5)
			minetest.add_item(ppos, d.bucket_empty)
		end
		return stack
	end,
})

function factory.register_storage_tank(name, increment, tiles, plaintile, light, bucket_full, bucket_empty)
	factory.registered_storage_tanks[name] = {
		increment = increment,
		bucket_full = bucket_full,
		bucket_empty = bucket_empty
	}
	factory.buckets_tanks[bucket_full] = name -- Revert lookup table
	--TODO: support bucket tables for multiple vessels or bucket registration
	minetest.register_node("factory:storage_tank_" .. name, {
		drawtype = "glasslike_framed",
		tiles = {"factory_steel_noise.png","factory_glass.png^factory_measure.png",
			"factory_glass.png^factory_port.png", "factory_steel_noise.png"},
		special_tiles = tiles,
		paramtype2 = "glasslikeliquidlevel",
		paramtype = "light",
		sunlight_propagates = true,
		light_source = light,
		groups = {oddly_breakable_by_hand = 2, not_in_creative_inventory = 1},
		drop = nil,
		on_dig = function(pos, _, digger)
			local inv = digger:get_inventory()
			local meta = minetest.get_meta(pos)
			local stored = meta:get_int("stored")
			local stack = ItemStack("factory:storage_tank_" .. name .. "_inventory")
			stack:get_meta():set_int("stored", stored)

			if inv:room_for_item("main", stack) then
				inv:add_item("main", stack)
			else
				minetest.add_item(pos, stack)
			end
			minetest.set_node(pos, {name = "air"})
		end,
		on_rightclick = function(pos, _, clicker, itemstack)
			local stack = ItemStack(itemstack)
			if stack:get_name() == bucket_full then
				local meta = minetest.get_meta(pos)
				local stored = meta:get_int("stored")
				if stored < 63 then
					stored = stored + increment
					meta:set_int("stored", stored)
					meta:set_string("infotext",
						"Storage Tank (" .. name .. "): " ..
						math.floor((100/64)*stored) .."% full"
					)
					minetest.swap_node(pos, {
						name = "factory:storage_tank_" .. name,
						param2 = stored - 1 + 64 + 128
					})
					return ItemStack(bucket_empty)
				end
			end
			if stack:get_name() == bucket_empty then
				local meta = minetest.get_meta(pos)
				local stored = meta:get_int("stored")
				if stored > increment then
					stored = stored - increment
					meta:set_int("stored", stored)
					meta:set_string("infotext",
						"Storage Tank (" .. name .. "): " ..
						math.floor((100/64)*stored) .. "% full"
					)
					minetest.swap_node(pos, {
					  name = "factory:storage_tank_" .. name,
						param2 = stored - 1 + 64 + 128
					})
				elseif stored <= increment then
					meta:set_string("infotext", nil)
					minetest.swap_node(pos, {name = "factory:storage_tank"})
				end
				local inv = clicker:get_inventory()
				stack:take_item(1)
				if inv:room_for_item("main", {name=bucket_full}) then
					inv:add_item("main", bucket_full)
				else
					local ppos = clicker:get_pos()
					ppos.y = math.floor(ppos.y + 0.5)
					minetest.add_item(ppos, bucket_full)
				end
				return stack
			end
		end,

	})

	minetest.register_craftitem("factory:storage_tank_" .. name .. "_inventory", {
		description = S("Storage Tank (@1)",S(name)),
		inventory_image = "[inventorycube{"--TODO: perhaps take the lowpart of the plaintile
			..plaintile.."&factory_steel_frame.png&factory_glass.png&factory_port.png{"
			..plaintile.."&factory_steel_frame.png&factory_glass.png&factory_measure.png{"
			..plaintile.."&factory_steel_frame.png&factory_glass.png",
		wield_image = "factory_storage_tank.png",
		groups = {not_in_creative_inventory = 1},
		stack_max = 1,
		on_place = function(itemstack, _, pointed_thing)
			if not pointed_thing or pointed_thing.type ~= "node" then
				return
			end

			local under = vector.copy(pointed_thing.above)
			under.y = under.y - 1
			local node_under = minetest.get_node(under)
			local above = minetest.get_node(pointed_thing.above)

			if	not minetest.registered_nodes[above.name].buildable_to or	-- Can we build here
				not minetest.registered_nodes[node_under.name] or			-- Node under is known
				minetest.registered_nodes[node_under.name].buildable_to		-- Node under is solid
			then
				return
			end

			-- Place the node
			minetest.place_node(pointed_thing.above, {
				name="factory:storage_tank_" .. name,
				param2 = 192
			})

			-- Update metadata and textures
			local stored = itemstack:get_meta():get_int("stored")
			local meta = minetest.get_meta(pointed_thing.above)
			meta:set_int("stored", stored)
			meta:set_string("infotext", S("Storage Tank (@1): @2% full",S(name),math.floor((100/64)*stored)))
			minetest.swap_node(pointed_thing.above, {
				name="factory:storage_tank_" .. name,
				param2 = stored - 1 + 64 + 128
			})

			return ""
		end
	})
end

factory.register_storage_tank("water", 4,
	{{name="default_water_source_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.0}}},
	"default_water.png", 0, "bucket:bucket_water", "bucket:bucket_empty")
factory.register_storage_tank("lava", 8,
	{{name="default_lava_source_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}}},
	"default_lava.png", 13, "bucket:bucket_lava", "bucket:bucket_empty")
factory.register_storage_tank("river_water", 4,
	{{name="default_river_water_source_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=2.0}}},
	"default_water.png", 0, "bucket:bucket_river_water", "bucket:bucket_empty")

-- vim: sw=2:tw=2:noet:
-- vim: et:ai:sw=2:ts=2:fdm=indent:syntax=lua
