local S = factory.require("translation")
local egrinder = factory.require("electronics/electronic_grinder")

local register_grinding = function(input, output, time)
  factory.register_recipe("grinding",{
    input = { input },
    output = output,
    time = time or 1,
  })
end

factory.register_recipe_type("grinding", {
  description = S("grinding"),
  icon = "factory_grinder_front.png",
  width = 1,
  height = 1,
})

--check is actually not nessecary since it's only a recipe
if minetest.settings:get_bool("factory_grindSeeds", false) and minetest.get_modpath("farming") then
  register_grinding("farming:seed_wheat", "farming:flour")
  egrinder.register_fallthrough("farming:flour")
  if farming and farming.mod then
    minetest.register_craftitem(":farming:multigrain", {
      description = "Multigrain",
      inventory_image = "farming_multigrain.png",
      groups = {food_wheat = 1, flammable = 4}
    })

    minetest.register_craft({
      type = "shapeless",
      output = "farming:multigrain 4",
      recipe = { "farming:seed_wheat", "farming:seed_barley", "farming:seed_oat", "farming:seed_rye" }
    })

    register_grinding("farming:multigrain", "farming:flour_multigrain")
    register_grinding("farming:seed_barley", "farming:flour")
    register_grinding("farming:seed_oat", "farming:flour")
    register_grinding("farming:seed_rye", "farming:flour")
    register_grinding("farming:seed_rice", "farming:rice_flour")
    egrinder.register_fallthrough("farming:flour")
  end
end

register_grinding("default:stone", "default:cobble", 3)

egrinder.register_fallthrough("default:cobble")

register_grinding("default:cobble", "default:gravel", 3)

register_grinding("default:desert_cobble", "default:gravel", 3)

register_grinding("default:mossycobble", "default:gravel", 3)

egrinder.register_fallthrough("default:gravel")



register_grinding("default:gravel", "default:sand", 2)

register_grinding("default:glass","default:silver_sand",2)

register_grinding("vessels:glass_fragments","default:silver_sand")

egrinder.register_fallthrough("group:sand")

--are registered as single registrations, but there are no differences in the wood output
register_grinding("group:tree", "default:stick 16", 2)

register_grinding("default:ice", "default:snowblock", 2 )
egrinder.register_fallthrough("default:snowblock")

if minetest.get_modpath("tnt") then
	register_grinding("default:flint", "tnt:gunpowder", 2 )
	egrinder.register_fallthrough("tnt:gunpowder")
end
