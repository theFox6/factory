-- saves energy and distributes it

-- local reference to the translator
local S = factory.S
-- #device local reference to the device type
local device = factory.electronics.device

minetest.register_node("factory:battery_pack", {
  description = S("battery pack"),
  tiles = {"factory_steel_noise.png", "factory_machine_steel_dark.png",
    "factory_steel_noise.png", "factory_steel_noise.png",
    "factory_steel_noise.png^factory_battery.png", "factory_steel_noise.png^factory_battery.png"},
  paramtype2 = "facedir",
  legacy_facedir_simple = true,
  groups = {factory_electronic = 1, cracky=3},
  is_ground_content = false,
  --[[sounds = {
            footstep = <SimpleSoundSpec>,
            dig = <SimpleSoundSpec>, -- "__group" = group-based sound (default)
            dug = <SimpleSoundSpec>,
            place = <SimpleSoundSpec>,
            place_failed = <SimpleSoundSpec>,
        },]]
  on_construct = function(pos)
    local meta = minetest.get_meta(pos)
    device.set_name(meta,S("battery pack"))
    device.set_energy(meta, 0)
    --5 battery items
    device.set_max_charge(meta,500)
  end,
  on_push_electricity = function(pos,energy)
    local meta = minetest.get_meta(pos)
    if meta:get_int("distribution_heat") == 0 then
      return device.store(meta,energy,100)
    else
      return energy
    end
  end
})

minetest.register_abm({
  nodenames = {"factory:battery_pack"},
  interval = 1.0,
  chance = 1,
  action = function(pos)
    local meta = minetest.get_meta(pos)
    meta:set_int("distribution_heat",1)
    local energy_before = factory.electronics.device.get_energy(meta)
    local energy_remain = device.distribute(pos, energy_before)
    if not device.try_use(meta, energy_before - energy_remain) then
      device.set_energy(meta,energy_remain)
    end
    meta:set_int("distribution_heat",0)
  end
})

minetest.register_lbm({
  label = "cooldown batteries",
  name = "factory:cooldown_batteries",
  nodenames = {"factory:battery_pack"},
  run_at_every_load = true,
  action = function(pos)
    local meta = minetest.get_meta(pos)
    meta:set_int("distribution_heat",0)
  end,
})

minetest.register_craft({
  output = "factory:battery_pack",
  recipe = {
    {"default:steel_ingot", "factory:battery_item", "default:steel_ingot"},
    {"factory:battery_item", "factory:battery_item", "factory:battery_item"},
    {"default:steel_ingot", "factory:battery_item", "default:steel_ingot"},
  },
})
