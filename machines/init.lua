dofile(factory.modpath.."/machines/crafting.lua")
dofile(factory.modpath.."/machines/belt.lua")
dofile(factory.modpath.."/machines/ind_furnace.lua")
dofile(factory.modpath.."/machines/ind_squeezer.lua")
dofile(factory.modpath.."/machines/wire_drawer.lua")
dofile(factory.modpath.."/machines/stp.lua")
dofile(factory.modpath.."/machines/swapper.lua")
dofile(factory.modpath.."/machines/arm.lua")
dofile(factory.modpath.."/machines/taker.lua")
dofile(factory.modpath.."/machines/qarm.lua")
dofile(factory.modpath.."/machines/oarm.lua")
dofile(factory.modpath.."/machines/autocrafter.lua")

if factory.setting_enabled("Fan") then dofile(factory.modpath.."/machines/fan.lua") end
if factory.setting_enabled("Vacuum") then
	dofile(factory.modpath.."/machines/vacuum.lua")
	dofile(factory.modpath.."/machines/upward_vacuum.lua")
end
if factory.setting_enabled("Miner") then dofile(factory.modpath.."/machines/miner.lua") end