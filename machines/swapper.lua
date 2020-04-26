factory.swapper_formspec =
	"size[8,10.5]"..
	factory_gui_bg..
	factory_gui_bg_img_2..
	factory_gui_slots..
	"list[current_name;left;0,2;2,4;]"..
	"list[current_name;right;6,2;2,4;]"..
	"list[current_name;loverflow;0,0;3,1;]"..
	"list[current_name;roverflow;5,0;3,1;]"..
	"list[current_name;overflow;3,1;2,1;]"..
	"list[current_name;src;3,3;2,2;]"..
	"image[3.5,2;1,1;gui_ind_furnace_arrow_bg.png]"..
	"label[3.6,0;output]"..
	"image[3.5,0.25;1,1;factory_square_white.png]"..
	"image[0.5,1;1,1;factory_square_yellow.png]"..
	"image[6.5,1;1,1;factory_square_blue.png]"..
	"label[3.66,5;input]"..
	"image[3.5,5.25;1,1;factory_square_red.png]"..
	"list[current_player;main;0,6.5;8,1;]"..
	"list[current_player;main;0,7.75;8,3;8]"..
	"listring[current_player;main]"..
	"listring[current_name;src]"..
	"listring[current_player;main]"..
  "listring[current_name;left]"..
  "listring[current_player;main]"..
  "listring[current_name;right]"..
  "listring[current_player;main]"..
  "listring[current_name;overflow]"..
  "listring[current_player;main]"..
  "listring[current_name;loverflow]"..
  "listring[current_player;main]"..
  "listring[current_name;roverflow]"

factory.register_machine("factory:swapper", {
  description = factory.S("Swapper"),
  inv_lists = {src = 4, overflow = 2, roverflow = 3, loverflow = 3,
    right = {size = 8, volatile = true}, left = {size = 8, volatile = true}},
  groups = {cracky=3},
  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
    meta:set_string("formspec", factory.swapper_formspec)
  end,
}, {
  tiles = {"factory_machine_steel_dark.png", "factory_machine_steel_dark.png",
    "factory_machine_steel_dark.png^factory_square_blue.png", "factory_machine_steel_dark.png^factory_square_yellow.png",
    "factory_machine_steel_dark.png^factory_square_white.png", "factory_machine_steel_dark.png^factory_square_red.png"},
  legacy_facedir_simple = true,
  allow_metadata_inventory_put = function(pos, listname, index, stack)
    -- args: pos, listname, index, stack, player
    local inv = minetest.get_meta(pos):get_inventory()
    if listname == "left" or listname == "right" then
      stack:set_count(1)
      inv:set_stack(listname, index, stack)
      return 0
    end
    return stack:get_count()
  end,
  allow_metadata_inventory_take = function(pos, listname, index, stack)
    local inv = minetest.get_meta(pos):get_inventory()
    if listname == "left" or listname == "right" then
      inv:set_stack(listname, index, ItemStack(""))
      return 0
    end
    return stack:get_count()
  end,
  allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count)
    local inv = minetest.get_meta(pos):get_inventory()
    local stack = inv:get_stack(from_list, from_index)

    if from_list == "left" or from_list == "right" then
      inv:set_stack(from_list, from_index, ItemStack(""))
      return 0
    end
    if to_list == "left" or to_list == "right" then
      stack:set_count(1)
      inv:set_stack(to_list, to_index, stack)
      return 0
    end

    return count
  end,
})

minetest.register_abm({
	nodenames = {"factory:swapper"},
	neighbors = nil,
	interval = 1,
	chance = 1,
	action = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		if not inv:is_empty("src") then
			for i,item in ipairs(inv:get_list("src")) do
				if not item:is_empty() and item:get_name() ~= "" then
					local item_to_move = item:peek_item()
					--TODO: perhaps switch between left and right priority
					for _,litem in ipairs(inv:get_list("left")) do
						if litem:get_name() == item:get_name() and inv:room_for_item("loverflow", item_to_move) then
							item:take_item()
							inv:set_stack("src", i, item)
							inv:add_item("loverflow", item_to_move)
							return
						end
					end
					for _,ritem in ipairs(inv:get_list("right")) do
						if ritem:get_name() == item:get_name() and inv:room_for_item("roverflow", item_to_move) then
							item:take_item()
							inv:set_stack("src", i, item)
							inv:add_item("roverflow", item_to_move)
							return
						end
					end
					if inv:room_for_item("overflow", item_to_move) then
						item:take_item()
						inv:set_stack("src", i, item)
						inv:add_item("overflow", item_to_move)
						return
					end
				end
			end
		end
	end
})