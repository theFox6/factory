-- local reference to the translator
local S = factory.S
-- #device local reference to the device type
local device = factory.require("electronics/device")
-- #table local reference to the logging functions
local log = factory.require("log")

local electronic_grinder = {
  node_box = {
    type = "fixed",
    fixed = {
      {-0.5,-0.5,-0.5, 0.5,    0,   0.5},
      {-0.5, 0,  -0.5, 0.5,    0.5,-0.375},
      {-0.5, 0,   0.5, 0.5,    0.5, 0.375},
      {-0.5, 0,  -0.5,-0.375,  0.5, 0.5},
      { 0.5, 0,  -0.5, 0.375,  0.5, 0.5},
    }
  }
}

local fallthrough_items = {}
electronic_grinder.fallthrough_items = fallthrough_items

function electronic_grinder.register_fallthrough(itemstring)
  fallthrough_items[itemstring] = true
end

function electronic_grinder.is_fallthrough(itemstring)
  for i,v in pairs(fallthrough_items) do
    if i:find("group:") == 1 then
      if minetest.get_item_group(itemstring, i:sub(7)) > 0 then
        if v then
          return true
        end
      end
    else
      if itemstring == i then
        return v
      end
    end
  end
  return false
end

factory.register_machine("factory:electronic_grinder", {
  description = S("electronic grinder"),
  groups = {cracky=3,factory_electronic = 1},
}, {
  tiles = {--TODO: some kind of grinder icon on the side
    "factory_grinder_top_animation.png^[verticalframe:6:1",
    "factory_grinder_top_animation.png^[transformFY^[transformFX^[verticalframe:6:1",
    "factory_machine_steel_dark.png", "factory_machine_steel_dark.png",
    "factory_machine_steel_dark.png", "factory_machine_steel_dark.png"
  },
  drawtype = "nodebox",
  node_box = electronic_grinder.node_box,
  paramtype = "light",
  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
    device.set_name(meta,S("electronic grinder"))
    device.set_energy(meta, 0)
    device.set_max_charge(meta,200)
  end,
  on_push_electricity = function(pos,energy)
    local meta = minetest.get_meta(pos)
    return device.store(meta,energy)
  end
})

factory.register_machine("factory:electronic_grinder_active", {
  description = S("electronic grinder (grinding)"),
  groups = {cracky=3, factory_electronic = 1, not_in_creative_inventory = 1},
}, {
  tiles = {--TODO: some kind of grinder icon on the side
    {
      name="factory_grinder_top_animation.png",
      animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1}
    },{
      name="factory_grinder_top_animation.png^[transformFY^[transformFX",
      animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1}
    },
    "factory_machine_steel_dark.png", "factory_machine_steel_dark.png",
    "factory_machine_steel_dark.png", "factory_machine_steel_dark.png"
  },
  drawtype = "nodebox",
  node_box = electronic_grinder.node_box,
  paramtype = "light",
  drop = "factory:electronic_grinder",
  damage_per_second = 8,
  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
    device.set_name(meta,S("electronic grinder"))
    device.set_energy(meta, 0)
    device.set_max_charge(meta,200)
  end,
  on_push_electricity = function(pos,energy)
    local meta = minetest.get_meta(pos)
    return device.store(meta,energy)
  end
})

function electronic_grinder.grind_one(ent,obj,pos)
  local input = ItemStack(ent.itemstring)
  local result = factory.get_recipe("grinding", {input})
  local output_stacks

  if type(result) == "table" then
    local output = result.output
    if type(output) ~= "table" then output = { output } end
    output_stacks = {}
    for _, o in ipairs(output) do
      table.insert(output_stacks, ItemStack(o))
    end
  end
  if output_stacks then
    for _, o in ipairs(output_stacks) do
      minetest.add_item(vector.add(pos,{x=0,y=-0.8,z=0}), o)
    end
    if type(result.new_input) == "table" then
      for _,i in ipairs(result.new_input) do
        minetest.add_item(vector.add(pos,{x=0,y=0.25,z=0}), i)
      end
    end
    obj:get_luaentity().itemstring = ""
    obj:remove()
    return true
  else
    if electronic_grinder.is_fallthrough(input:get_name()) then
      --move below
      obj:move_to(vector.add(pos,{x=0,y=-0.8,z=0}))
      return true --let's say that takes time too
    else
      --move off the opposite side of the grinder
      local opos = obj:get_pos()
      local dir = vector.subtract(opos,pos);
      if dir.x == 0 and dir.z == 0 then
        dir.x = math.random() * 1.3 - 0.65
        dir.z = math.random() * 1.3 - 0.65
      end
      local xv = math.sqrt(math.abs(dir.x)) * math.sign(dir.x) * -3
      local zv = math.sqrt(math.abs(dir.z)) * math.sign(dir.z) * -3
      obj:add_velocity({x = xv, y = 6.5, z = zv})
      return false
    end
  end
end

minetest.register_abm({
  nodenames = {"factory:electronic_grinder","factory:electronic_grinder_active"},
  interval = 1.0,
  chance = 1,
  action = function(pos, node, _, aocw)
    if aocw == 0 then return end
    local meta = minetest.get_meta(pos)

    --TODO: get blocked when too many items are below

    local all_objects = minetest.get_objects_inside_radius(pos, 0.75)
    if #all_objects > 0 and device.try_use(meta,5) then
      if node.name == "factory:electronic_grinder" then
        factory.swap_node(pos,"factory:electronic_grinder_active")
        return
      end
    else
      if node.name == "factory:electronic_grinder_active" then
        factory.swap_node(pos,"factory:electronic_grinder")
      end
      return
    end
    for _,obj in pairs(all_objects) do
      if obj:is_player() then
        log.info(obj:get_player_name() .. " stands in a grinder")
      else
        local ent = obj:get_luaentity()
        if ent and ent.name == "__builtin:item" then
          if electronic_grinder.grind_one(ent,obj,pos) then break end
        end
      end
    end
  end,
})

-- crafting recipe for electronic furnace
-- TODO: electric engine
do
  local s = "default:steel_ingot"
  local b = "factory:battery_item"
  local g = "factory:small_diamond_gear"
  minetest.register_craft({
    output = "factory:electronic_grinder",
    recipe = {
      {s,"", s},
      {g, s, g},
      {b, s, b},
    },
  })
end

return electronic_grinder