local init = os.clock()
if minetest.settings:get_bool("log_mods") then
  minetest.log("action", "[MOD] "..minetest.get_current_modname()..": loading")
else
  print("[MOD] "..minetest.get_current_modname()..": loading")
end

factory={
	crafts={},
	empty={item=ItemStack(nil),time=0},
	no_player={is_player=function() return false end},
	--pipes={}, -- coming soon (perhaps...)
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

--ready
local time_to_load= os.clock() - init
if minetest.settings:get_bool("log_mods") then
  minetest.log("action", string.format("[MOD] "..minetest.get_current_modname()..factory.S(": loaded in %.4f s"), time_to_load))
else
  print(string.format("[MOD] "..minetest.get_current_modname()..factory.S(": loaded in %.4f s"), time_to_load))
end