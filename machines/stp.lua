-- local reference to the translator
local S = factory.S

-- Sapling IO for the Sapling Treatment Plant
factory.stpIO = {}

function factory.registerSapling(sapling,wood,minWood,maxWood,leaves,minLeaves,maxLeaves)
  local defType = type(sapling)
  if defType == "table" and wood == nil then
    table.insert(factory.stpIO, sapling)
  elseif defType == "string" then
    table.insert(factory.stpIO, {
	sapling = sapling,
	wood = wood,
	minWood = minWood,
	maxWood = maxWood,
	leaves = leaves,
	minLeaves = minLeaves,
	maxLeaves = maxLeaves})
  else
    factory.log.warning("invalid sapling definition type: "..defType)
  end
end

--register the default saplings
factory.registerSapling("default:sapling","default:tree",4,10,"default:leaves",65,70)
factory.registerSapling("default:junglesapling","default:jungletree",12,30,"default:jungleleaves",65,90)
factory.registerSapling("default:pine_sapling","default:pine_tree",6,10,"default:pine_needles",55,80)
factory.registerSapling("default:acacia_sapling","default:acacia_tree",12,12,"default:acacia_leaves",71,71)
factory.registerSapling("default:aspen_sapling","default:aspen_tree",7,11,"default:aspen_leaves",80,90)

factory.forms.stp_formspec =
	"size[8,8.5]"..
	factory_gui_bg..
	factory_gui_bg_img_2..
	factory_gui_slots..
	"list[current_name;src;2.75,0.5;1,1;]"..
	"list[current_name;fuel;2.75,2.5;1,1;]"..
	"image[3.75,1.5;1,1;gui_ind_furnace_arrow_bg.png^[transformR270]"..
	"list[current_name;dst;4.75,0.5;2,3;]"..
	"list[current_player;main;0,4.25;8,1;]"..
	"list[current_player;main;0,5.5;8,3;8]"..
	factory.get_hotbar_bg(0,4.25)..
	"listring[current_player;main]"..
	"listring[current_name;src]"..
	"listring[current_player;main]"..
	"listring[current_name;fuel]"..
	"listring[current_player;main]"..
	"listring[current_name;dst]"

minetest.register_node("factory:sapling_fertilizer", {
	tiles = {
		"default_dirt.png"
	},
	inventory_image = "factory_sapling_fertilizer.png",
	description = S("Sapling Fertilizer"),
	drawtype = "nodebox",
	paramtype = "light",
	is_ground_content = true,
	groups = {seed = 1, snappy = 3, attached_node = 1},
	node_box = {
		type = "fixed",
		fixed = {
			{-0.1875, -0.5, -0.1875, 0.1875, -0.4375, 0.1875},
			{-0.125, -0.4375, -0.125, 0.125, -0.375, 0.125},
			{0, -0.375, -0.0625, 0.0625, -0.3125, 0.0625},
			{0, -0.3125, -0.0625, 0.0625, -0.25, 0},
			{-0.0625, -0.375, -0.0625, 0, -0.3125, 0},
		}
	}
})

minetest.register_abm({
	nodenames = {"factory:sapling_fertilizer"},
	neighbors = nil,
	interval = 3,
	chance = 6,
	action = function(pos)
		minetest.add_particlespawner({
			amount = 3,
			time = 1,
			minpos = {x = pos.x - 0.05, y = pos.y, z = pos.z - 0.05},
			maxpos = {x = pos.x + 0.05, y = pos.y, z = pos.z + 0.05},
			minvel = {x=-0.25, y=0.02, z=-0.25},
			maxvel = {x=0.25, y=0.10, z=0.25},
			minacc = {x=0, y=0, z=0},
			maxacc = {x=0, y=0, z=0},
			minexptime = 0.8,
			maxexptime = 2,
			minsize = 0.05,
			maxsize = 0.23,
			collisiondetection = true,
			vertical = false,
			texture = "factory_flies.png",
			playername = nil,
		})
	end,
})

minetest.register_node("factory:stp", {
	description = S("Sapling Treatment Plant"),
	tiles = {"factory_machine_brick_1.png", "factory_machine_brick_2.png", "factory_machine_side_1.png",
		"factory_machine_side_1.png", "factory_machine_side_1.png", "factory_stp_front.png"},
	paramtype2 = "facedir",
	groups = {cracky=3,factory_src_input=1,factory_fuel_input=1,factory_dst_output=1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", factory.forms.stp_formspec)
		meta:set_string("infotext", S("Sapling Treatment Plant"))
		local inv = meta:get_inventory()
		inv:set_size("fuel", 1)
		inv:set_size("src", 1)
		inv:set_size("dst", 6)
	end,
	can_dig = function(pos)
		local meta = minetest.get_meta(pos);
		local inv = meta:get_inventory()
		if not inv:is_empty("fuel") then
			return false
		elseif not inv:is_empty("dst") then
			return false
		elseif not inv:is_empty("src") then
			return false
		end
		return true
	end,
	allow_metadata_inventory_put = function(_, listname, _, stack)
	  -- args: pos, listname, index, stack, player
		if listname == "fuel" then
			if stack:get_name() == "factory:sapling_fertilizer" then
				return stack:get_count()
			else
				return 0
			end
		elseif listname == "src" then
			return stack:get_count()
		elseif listname == "dst" then
			return 0
		end
	end,
	allow_metadata_inventory_move = function(_, _, _, to_list, _, count)
		if to_list == "fuel" then
			return count
		elseif to_list == "src" then
			return count
		elseif to_list == "dst" then
			return 0
		end
	end,
})

minetest.register_abm({
	nodenames = {"factory:stp"},
	interval = 25,
	chance = 1,
	action = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()

		if inv:contains_item("fuel", ItemStack("factory:sapling_fertilizer 1")) then
			for _,v in ipairs(factory.stpIO) do
				if inv:contains_item("src", ItemStack({name = v.sapling})) then
					local randWood = math.random(v.minWood, v.maxWood)
					local randLeaves = math.random(v.minLeaves, v.maxLeaves)
					local randSaplings = math.random(v.minLeaves/20, v.maxLeaves/20)
					randLeaves = randLeaves - randSaplings
					if inv:room_for_item("dst", {name = v.wood, count = randWood}) and
					   inv:room_for_item("dst", {name = v.sapling, count = randSaplings}) and
					   inv:room_for_item("dst", {name = v.leaves, count = randLeaves}) then

						factory.start_smoke(vector.add(pos,{x=0,y=-1,z=0}),0.5,8,32)

						inv:add_item("dst", ItemStack({name = v.wood, count = randWood}))
						inv:add_item("dst", ItemStack({name = v.sapling, count = randSaplings}))
						inv:add_item("dst", ItemStack({name = v.leaves, count = randLeaves}))

						inv:remove_item("src", ItemStack({name = v.sapling, count = 1}))
						inv:remove_item("fuel", ItemStack({name = inv:get_stack("fuel", 1):get_name(), count = 1}))
					end
				end
			end
		end
	end,
})