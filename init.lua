print("loading Factory mod")
factory={
crafts={},
empty={item=ItemStack(nil),time=0},
no_player={is_player=function() return false end},
--pipes={}, -- coming soon
worldpath=minetest.get_worldpath(),
modpath=minetest.get_modpath("factory")
}
-- Boilerplate to support localized strings if intllib mod is installed.
if minetest.get_modpath( "intllib" ) and intllib then
	factory.S = intllib.Getter()
else
	factory.S = function(s) return s end
end

dofile(factory.modpath.."/settings.txt")

dofile(factory.modpath.."/util/init.lua")
dofile(factory.modpath.."/machines/init.lua")
dofile(factory.modpath.."/items/init.lua")
dofile(factory.modpath.."/decor/init.lua")

print(factory.S("Factory mod is working"))