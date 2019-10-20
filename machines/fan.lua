local S = factory.S

local fan = {
  registered_fans = {},
  default = {
    description = S("Fan"),
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "wallmounted",
    is_ground_content = true,
  },
  default_specs = {
    tiles_off = {"factory_fan_off.png", "factory_belt_bottom.png", "factory_belt_side.png",
      "factory_belt_side.png", "factory_belt_side.png", "factory_belt_side.png"},
    tiles_on = {{name="factory_fan.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.2}},
      "factory_belt_bottom.png", "factory_belt_side.png", "factory_belt_side.png", "factory_belt_side.png",
      "factory_belt_side.png"},
    radius = 0.75,
    range = 2,
    cone = false,
  }
}

function fan.get_objects_within_line(pos,dir,radius,range)
  local other_dirs = vector.multiply(vector.subtract(dir,1),-1)
  local min = vector.subtract(pos,vector.multiply(other_dirs,radius))
  local max = vector.add(pos,vector.multiply(other_dirs,radius))
  max = vector.add(max,vector.multiply(dir,range))

  local halfway = vector.add(pos, vector.multiply(dir,range/2))

  local all_objects = minetest.get_objects_inside_radius(halfway, radius + range/2)
  local ret = {}
  for _,obj in pairs(all_objects) do
    local opos = obj:getpos()
    if factory.is_within_area(opos, min, max) then
      table.insert(ret,obj)
    end
  end
  return ret
end

function fan.get_objects_within_cone(pos, dir, radius, range)
  local coord
  for i,v in pairs(dir) do
    if v ~= 0 then
      if coord then
        error("diagonal direction given")
      end
      coord = i
    end
  end

  local maxcoord = pos[coord] + range
  local center = vector.new(pos)
  center[coord] = maxcoord

  local all_objects = minetest.get_objects_inside_radius(center, radius + range)
  local ret = {}
  for _,obj in pairs(all_objects) do
    local opos = obj:getpos()
    if opos[coord] < maxcoord then
      table.insert(ret,obj)
    end
  end
  return ret
end

function fan.register_states(basename, node_def, fan_specs)
  local off_def = table.copy(node_def)
  local on_def = table.copy(node_def)

  off_def.tiles = fan_specs.tiles_off
  on_def.tiles = fan_specs.tiles_on

  off_def.groups.mesecon_effector_off = 1
  on_def.groups.mesecon_effector_on = 1

  off_def.groups.not_in_creative_inventory = 1
  off_def.drop = basename .. "_on"

  off_def.on_rightclick = function(pos, node)
    minetest.swap_node(pos, {name = basename.."_on", param2 = node.param2})
  end
  on_def.on_rightclick = function(pos, node)
    minetest.swap_node(pos, {name = basename.."_off", param2 = node.param2})
  end

  off_def.mesecons = {effector = {
    action_off = function(pos, node)
      minetest.swap_node(pos, {name = basename.."_on", param2 = node.param2})
    end
  }}
  on_def.mesecons = {effector = {
    action_on = function(pos, node)
      minetest.swap_node(pos, {name = basename .. "_off", param2 = node.param2})
    end
  }}

  minetest.register_node(basename .. "_off",off_def)
  minetest.register_node(basename .. "_on",on_def)
end

local function copy_defaults(t,d)
  for i,v in pairs(d) do
    if t[i] == nil then
      t[i] = v
    end
  end
end

local move_player = factory.setting_enabled("Fanmove", false)

function fan.register(basename, node_def, fan_specs)
  if fan.registered_fans[basename] then
    error("fan " .. basename .. " is already registered",1)
  end
  copy_defaults(fan_specs, fan.default_specs)
  copy_defaults(node_def, fan.default)
  fan.registered_fans[basename] = fan_specs

  -- inheriting tables can cause unwanted overwriting
  if not node_def.groups then
    -- assign the groups directly
    node_def.groups = {cracky=3}
  end
  if not node_def.node_box then
    node_def.node_box = {
      type = "fixed",
      fixed = {{-0.5,-0.5,-0.5,0.5,0.0625,0.5},}
    }
  end

  fan.register_states(basename, node_def,fan_specs)

  minetest.register_abm({
    nodenames = {basename.."_on"},
    neighbors = nil,
    interval = 1,
    chance = 1,
    action = function(pos,node)
      local dir = minetest.facedir_to_dir(node.param2)
      print("fan facedir: " .. minetest.pos_to_string(dir))
      local all_objects
      if fan_specs.cone then
        all_objects = fan.get_objects_within_cone(pos,dir,fan_specs.radius,fan_specs.range)
      else
        all_objects = fan.get_objects_within_line(pos,dir,fan_specs.radius,fan_specs.range)
      end

      local keep = vector.multiply(vector.subtract(dir,1),-1)
      for _,obj in ipairs(all_objects) do
        local opos = obj:getpos()
        print("object pos: ".. minetest.pos_to_string(opos))
        -- use nodepos in facedir and copy other coords
        opos = vector.add(vector.multiply(opos,keep),vector.multiply(pos,dir))
        print("cut object pos: "..minetest.pos_to_string(opos))
        dir = vector.multiply(dir,fan_specs.range)
        print("fan blowing dir. "..minetest.pos_to_string(dir))
        dir = vector.add(dir,opos)
        print("resulting object pos: "..minetest.pos_to_string(dir))
        if move_player and obj:is_player() then
          obj:moveto(dir)
        else
          local ent = obj:get_luaentity()
          if ent and (ent.name == "__builtin:item" or ent.name == "factory:moving_item") then
            print("fan move")
            obj:moveto(dir)
          end
        end
      end
    end,
  })
end

--[[TODO: write functions for easier implementation
minetest.register_node("factory:fan_on", {
	description = S("Fan"),
	tiles = {{name="factory_fan.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.2}},
		"factory_belt_bottom.png", "factory_belt_side.png", "factory_belt_side.png", "factory_belt_side.png",
		"factory_belt_side.png"},
	groups = {cracky=3, mesecon_effector_off = 1},
	drawtype = "nodebox",
	paramtype = "light",
	is_ground_content = true,
	node_box = {
			type = "fixed",
			fixed = {{-0.5,-0.5,-0.5,0.5,0.0625,0.5},}
		},
	on_rightclick = function(pos, node)
		minetest.swap_node(pos, {name = "factory:fan_off", param2 = node.param2})
	end,
	mesecons = {effector = {
		action_on = function(pos, node)
			minetest.swap_node(pos, {name = "factory:fan_off", param2 = node.param2})
		end
	}}
})

minetest.register_node("factory:fan_off", {
	description = S("Fan"),
	tiles = {"factory_fan_off.png", "factory_belt_bottom.png", "factory_belt_side.png",
		"factory_belt_side.png", "factory_belt_side.png", "factory_belt_side.png"},
	groups = {cracky=3, not_in_creative_inventory=1, mesecon_effector_on = 1},
	drawtype = "nodebox",
	paramtype = "light",
	is_ground_content = true,
	drop="factory:fan_on",
	node_box = {
			type = "fixed",
			fixed = {{-0.5,-0.5,-0.5,0.5,0.0625,0.5},}
		},
	on_rightclick = function(pos, node)
		minetest.swap_node(pos, {name = "factory:fan_on", param2 = node.param2})
	end,
	mesecons = {effector = {
		action_off = function(pos, node)
			minetest.swap_node(pos, {name = "factory:fan_on", param2 = node.param2})
		end
	}}
})

minetest.register_abm({
	nodenames = {"factory:fan_on"},
	neighbors = nil,
	interval = 1,
	chance = 1,
	action = function(pos)
		local all_objects = minetest.get_objects_inside_radius({x = pos.x, y = pos.y, z = pos.z}, 1)
		for _,obj in ipairs(all_objects) do
			if move_player and obj:is_player() then
				obj:moveto({x = obj:getpos().x, y = obj:getpos().y + 3, z = obj:getpos().z})
			else
				local ent = obj:get_luaentity()
				if ent and (ent.name == "__builtin:item" or ent.name == "factory:moving_item") then
					obj:moveto({x = obj:getpos().x, y = obj:getpos().y + 3, z = obj:getpos().z})
				end
			end
		end
	end,
})




minetest.register_node("factory:fan_wall_on", {
	description = S("Wall Fan"),
	tiles = {"factory_belt_side.png^[transformFY", "factory_belt_side.png", "factory_belt_side.png^[transformR90",
		"factory_belt_side.png^[transformR270", "factory_belt_bottom.png", {name="factory_fan.png",
		animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.2}}},
	groups = {cracky=3, mesecon_effector_off = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = true,
	legacy_facedir_simple = true,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 0.5, 0.5},
		}
	},
	on_rightclick = function(pos, node)
		minetest.swap_node(pos, {name = "factory:fan_wall_off", param2 = node.param2})
	end,
	mesecons = {effector = {
		action_on = function(pos, node)
			minetest.swap_node(pos, {name = "factory:fan_wall_off", param2 = node.param2})
		end
	}}
})

minetest.register_node("factory:fan_wall_off", {
	description = S("Wall Fan"),
	tiles = {"factory_belt_side.png^[transformFY", "factory_belt_side.png", "factory_belt_side.png^[transformR90",
		"factory_belt_side.png^[transformR270", "factory_belt_bottom.png", "factory_fan_off.png"},
	groups = {cracky=3, not_in_creative_inventory=1, mesecon_effector_on = 1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = true,
	legacy_facedir_simple = true,
	drop="factory:fan_wall_on",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.0625, 0.5, 0.5, 0.5},
		}
	},
	on_rightclick = function(pos, node)
		minetest.swap_node(pos, {name = "factory:fan_wall_on", param2 = node.param2})
	end,
	mesecons = {effector = {
		action_off = function(pos, node)
			minetest.swap_node(pos, {name = "factory:fan_wall_on", param2 = node.param2})
		end
	}}
})

minetest.register_abm({
	nodenames = {"factory:fan_wall_on"},
	neighbors = nil,
	interval = 1,
	chance = 1,
	action = function(pos)
		local a = minetest.facedir_to_dir(minetest.get_node(pos).param2)
		local all_objects = minetest.get_objects_inside_radius({x = pos.x - a.x/2, y = pos.y, z = pos.z - a.z/2}, 1)
		for _,obj in ipairs(all_objects) do
			if move_player and obj:is_player() then
				obj:move_to({x = obj:getpos().x - a.x*2.0, y = obj:getpos().y, z = obj:getpos().z - a.z*2.0})
			else
				local ent = obj:get_luaentity()
				if ent and (ent.name == "__builtin:item" or ent.name == "factory:moving_item") then
					obj:move_to({x = obj:getpos().x - a.x*2.0, y = obj:getpos().y, z = obj:getpos().z - a.z*2.0})
				end
			end
		end
	end,
})
]]
return fan
