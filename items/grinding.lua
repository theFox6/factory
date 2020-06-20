local S = factory.require("translation")
local egrinder = factory.require("electronics/electronic_grinder")

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
egrinder.register_fallthrough("farming:flour")

factory.register_recipe("grinding",{
  input = {"default:stone"},
  output = "default:cobble",
  time = 3,
})

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
egrinder.register_fallthrough("group:sand")

--are registered as single registrations, but there are no differences in the wood output
factory.register_recipe("grinding",{
  input = {"group:tree"},
  output = "default:stick 16",
  time = 2,
})

----
-- default registered normal craft recipes
----

factory.register_recipe("grinding",{
  input = {"group:wood"},
  output = "default:stick 4",
  time = 2,
})

--[[ sandstone
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
