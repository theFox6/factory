local S = factory.S
local insert = factory.insert_object_item

local function qarm_handle (a, b, target, stack, minv, obj)
	local found = false
	if factory.has_main_inv(target) then
		local meta = minetest.env:get_meta(b)
		local inv = meta:get_inventory()

		if insert(inv,"main", stack, obj) then found = true end
	end
	if factory.has_fuel_input(target) then
		local meta = minetest.env:get_meta(b)
		local inv = meta:get_inventory()

		if minetest.dir_to_facedir({x = -a.x, y = -a.y, z = -a.z}) == minetest.get_node(b).param2 then
			-- back, fuel
			if insert(inv,"fuel", stack, obj) then found = true end
		end
	end
	if factory.has_src_input(target) and not found then
		local meta = minetest.env:get_meta(b)
		local inv = meta:get_inventory()

		if insert(inv,"src", stack, obj) then found = true end
	end
	if not found then
		if not insert(minv,"main", stack, obj) then
			obj:setvelocity({x=0,y=0,z=0})
			obj:moveto({x = b.x + a.x, y = b.y + 0.5, z = b.z + a.z}, false)
		end
	end
end

factory.qformspec =
	"size[8,8.5]"..
	factory_gui_bg..
	factory_gui_bg_img..
	factory_gui_slots..
	"list[current_name;main;0,0.3;8,3;]"..
	"list[current_player;main;0,4.25;8,1;]"..
	"list[current_player;main;0,5.5;8,3;8]"..
	factory.get_hotbar_bg(0,4.25)..
	"listring[current_player;main]"..
	"listring[current_name;main]"

factory.register_machine("factory:queuedarm",{
  description = S("Queued Pneumatic Mover"),
  inv_lists = {main = 8*3},
  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
    meta:set_string("formspec",factory.qformspec)
  end,
}, {
  drawtype = "nodebox",
  tiles = {"factory_steel_noise.png"},
  groups = {cracky=3, factory_mover=1},
  paramtype = "light",
  legacy_facedir_simple = true,
  node_box = {
    type = "fixed",
    fixed = {
      {-0.5,-0.5,-0.5,0.5,-0.4375,0.5}, --base1
      {-0.125,-0.5,-0.375,0.125,0.0625,0.375}, --base2
      {-0.125,0.25,-0.5,0.125,0.3125,0.375}, --tube
      {-0.375,-0.5,-0.1875,0.375,0.0625,0.0625}, --base3
      {-0.125,-0.125,0.375,0.125,0.125,0.5}, --tube2
      {-0.125,0.0625,0.3125,0.125,0.25,0.375}, --nodebox6
      {-0.125,0.0625,-0.5,-0.0625,0.25,0.3125}, --nodebox7
      {0.0625,0.0625,-0.5,0.125,0.25,0.3125}, --nodebox8
      {-0.0625,0.0625,-0.5,0.0625,0.125,0.3125}, --nodebox9
      {-0.25,0.3125,-0.125,0.25,0.8,0.375}, --NodeBox10
      {-0.1875,0.1875,-0.5,-0.125,0.3125,0.375}, --NodeBox11
      {0.125,0.1875,-0.5,0.1875,0.3125,0.375}, --NodeBox12
      {-0.125,0.3125,-0.4375,0.125,0.5,-0.125}, --NodeBox13
    }
  },
  selection_box = {
    type = "fixed",
    fixed = {
      {-0.5,-0.5,-0.5,0.5,0.8,0.5},
    }
  },
  on_metadata_inventory_move = function(pos, _, _, _, _, _, player)
    factory.log.action("%s moves stuff in queued mover at %s",
      player:get_player_name(),minetest.pos_to_string(pos))
  end,
    on_metadata_inventory_put = function(pos, _, _, _, player)
    factory.log.action("%s moves stuff to queued mover at %s",
      player:get_player_name(),minetest.pos_to_string(pos))
  end,
    on_metadata_inventory_take = function(pos, _, _, _, player)
    factory.log.action("%s takes stuff from queued mover at %s",player:get_player_name(),minetest.pos_to_string(pos))
  end,
})

minetest.register_abm({
	nodenames = {"factory:queuedarm"},
	neighbors = nil,
	interval = 1,
	chance = 1,
	action = function(pos)
		local mmeta = minetest.env:get_meta(pos)
		local minv = mmeta:get_inventory()
		local all_objects = minetest.get_objects_inside_radius(pos, 0.5)
		local a = minetest.facedir_to_dir(minetest.get_node(pos).param2)
		local b = {x = pos.x + a.x, y = pos.y + a.y, z = pos.z + a.z,}
		local target = minetest.get_node(b)
		for _,obj in ipairs(all_objects) do
			if not obj:is_player() and obj:get_luaentity()
			and (obj:get_luaentity().name == "__builtin:item" or obj:get_luaentity().name == "factory:moving_item") then
				local objStack = ItemStack(obj:get_luaentity().itemstring)
				qarm_handle(a, b, target, objStack, minv, obj)
			end
		end
		for _,stack in ipairs(minv:get_list("main")) do
			if stack:get_name() ~= "" then
				minv:remove_item("main", stack)
				qarm_handle(a, b, target, stack, minv, nil)
				return
			end
		end
	end,
})
