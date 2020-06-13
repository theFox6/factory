local S = factory.require("translation")

factory.register_recipe_type("grinding", {
  description = S("grinding"),
  icon = "factory_grinder_front.png",
  width = 1,
  height = 1,
})

--check is actually not nessecary since it's only a recipe
if minetest.get_modpath("farming") then
  factory.register_recipe("grinding",{
    input = {"farming:seed_wheat"},
    output = "farming:flour",
    time = 1,
  })
end

factory.register_recipe("grinding",{
  input = {"default:cobble"},
  output = "default:gravel",
  time = 3,
})

factory.register_recipe("grinding",{
  input = {"default:desert_cobble"},
  output = "default:gravel",
  time = 3,
})

factory.register_recipe("grinding",{
  input = {"default:mossycobble"},
  output = "default:gravel",
  time = 3,
})

factory.register_recipe("grinding",{
  input = {"default:gravel"},
  output = "default:sand",
  time = 2,
})

--[[ default registered normal craft recipes
factory.register_recipe("grinding",{
  input={"default:sandstone"},
  output="default:sand 4",
  time = 2,
})

factory.register_recipe("grinding",{
  input={"default:desert_sandstone"},
  output="default:desert_sand 4",
  time = 2,
})

factory.register_recipe("grinding",{
  input={"default:silver_sandstone"},
  output="default:silver_sand 4",
  time = 2,
})
--]]
