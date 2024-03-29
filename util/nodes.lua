function factory.swap_node(pos,name)
	local node = minetest.get_node(pos)
	if node.name == name then
		return
	end
	node.name = name
	minetest.swap_node(pos,node)
end

function factory.is_within_area(pos, min, max)
  return pos.x > min.x and pos.x < max.x and
      pos.y > min.y and pos.y < max.y and
      pos.z > min.z and pos.z < max.z
end

function factory.get_objects_with_square_radius(pos, rad)
  rad = rad + .5;
  local objs = {}
  for _,object in ipairs(minetest.get_objects_inside_radius(pos, math.sqrt(3)*rad)) do
    if not object:is_player()
    and object:get_luaentity()
    and (object:get_luaentity().name == "__builtin:item" or object:get_luaentity().name == "factory:moving_item") then
      local opos = object:get_pos()
      if pos.x - rad <= opos.x and opos.x <= pos.x + rad
      and pos.y - rad <= opos.y and opos.y <= pos.y + rad
      and pos.z - rad <= opos.z and opos.z <= pos.z + rad then
        objs[#objs + 1] = object
      end
    end
  end
  return objs
end

function factory.get_node_name(node)
	local nname
	if type(node) == "string" then
		nname = node
	elseif type(node) == "table" then
		if node.name then
			nname = node.name
		elseif node.x then
			nname = minetest.get_node(node).name
		end
	end
	return nname
end

function factory.has_src_input(node)
	local nname = factory.get_node_name(node)
	if minetest.get_item_group(nname, "factory_src_input") > 0 then
		return true
	elseif nname == "default:furnace" or nname == "default:furnace_active" then
		return true
	end
	return false
end

function factory.has_fuel_input(node)
	local nname = factory.get_node_name(node)
	if minetest.get_item_group(nname, "factory_fuel_input") > 0 then
		return true
	elseif nname == "default:furnace" or nname == "default:furnace_active" then
		return true
	end
	return false
end

local known_chests = {}
if minetest.get_modpath("default") then
	table.insert(known_chests, "default:chest")
	table.insert(known_chests, "default:chest_locked")
end
if minetest.get_modpath("technic_chests") then
	local materials = { "iron", "copper", "silver", "gold", "mithril" }
	for _, material in ipairs(materials) do
		table.insert(known_chests, "technic:" .. material .. "_chest")
		table.insert(known_chests, "technic:" .. material .. "_locked_chest")
		table.insert(known_chests, "technic:" .. material .. "_protected_chest")
	end
end

function factory.has_main_inv(node)
  local nname = factory.get_node_name(node)
  if minetest.get_item_group(nname, "factory_main_inv") > 0 then
    return true
  else
    for _, chest in ipairs(known_chests) do
      if nname == chest then
        return true
      end
    end
  end
  return false
end

function factory.has_dst_output(node)
	local nname = factory.get_node_name(node)
	if minetest.get_item_group(nname, "factory_dst_output") > 0 then
		return true
	elseif nname == "default:furnace" or nname == "default:furnace_active" then
		return true
	end
	return false
end
-- vim: et:ai:sw=2:ts=2:fdm=indent:syntax=lua
