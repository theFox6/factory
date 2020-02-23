--the time when this mod started loading
local init = os.clock()
if minetest.settings:get_bool("log_mods") then
  minetest.log("action", "[MOD] "..minetest.get_current_modname()..": loading")
else
  print("[MOD] "..minetest.get_current_modname()..": loading")
end

factory={
	crafts={},
	empty={item=ItemStack(nil),time=0},
	--no_player={is_player=function() return false end},
	worldpath=minetest.get_worldpath(),
	modpath=minetest.get_modpath("factory"),
	forms={},
}

if not modutil then
    dofile(factory.modpath.."/modutil/portable.lua")
end

local modules = {
	init = factory,
	log = modutil.require("logging").make_loggers(),
	translation = modutil.require("translations","venus")("factory")
}

modutil.require("local_require")(factory,modules)

function factory.setting_enabled(name, default)
	local b = minetest.settings:get_bool("factory_enable"..name)
	if b == nil then
		if default == nil then
			return true
		end
		return default
	end
	return b
end

factory.require("util/init")
factory.require("ores/init")
factory.require("items/init")
factory.require("machines/init")
factory.require("decor/init")

if factory.setting_enabled("Electronics") then
  factory.require("electronics/init")
end

--the time needed for loading
local time_to_load= os.clock() - init
if minetest.settings:get_bool("log_mods") then
  minetest.log("action", string.format(
	"[MOD] "..minetest.get_current_modname()..factory.S(": loaded in %.4f s"), time_to_load))
else
  print(string.format("[MOD] %s: loaded in %.4f s",minetest.get_current_modname(), time_to_load))
end

return factory
