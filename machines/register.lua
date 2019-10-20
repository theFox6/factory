
if factory.setting_enabled("Fan") then
  local fan = factory.require("machines/fan")

  fan.register("factory:power_fan",{},{
    radius = 1,
    range = 3,
  })
  minetest.register_alias("factory:fan_on","factory:power_fan_on")
  minetest.register_alias("factory:fan_off","factory:power_fan_off")

  fan.register("factory:wide_fan",{},{
    radius = 1,
    range = 2,
  })

  --
  minetest.register_alias("factory:fan_wall_on", "factory:wide_fan_on")
  minetest.register_alias("factory:fan_wall_off", "factory:wide_fan_off")
  --]]

  --[[minetest.register_lbm({
    label = "Upgrade legacy wall fan",
    name = "factory:replace_legacy_fan_wall",
    nodenames = {"factory:fan_wall_on","factory:fan_wall_off"},
    run_at_every_load = true,
    action = function(pos, node)
      minetest.swap_node(pos, {name = "factory:fan_wall_on", param2 = node.param2})
      minetest.swap_node(pos, {name = "factory:fan_wall_on", param2 = node.param2})
    end,
  })]]
end
