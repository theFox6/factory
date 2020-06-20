factory.require("machines/crafting")
factory.require("machines/belt")
factory.require("machines/ind_furnace")
factory.require("machines/ind_squeezer")
factory.require("machines/wire_drawer")
factory.require("machines/grinder")
factory.require("machines/stp")
factory.require("machines/swapper")
factory.require("machines/arm")
factory.require("machines/taker")
factory.require("machines/qarm")
factory.require("machines/oarm")
factory.require("machines/autocrafter")

if factory.setting_enabled("Fan") then
  factory.require("machines/fan")
end
if factory.setting_enabled("Vacuum") then
	factory.require("machines/vacuum")
	factory.require("machines/upward_vacuum")
end
if factory.setting_enabled("Miner") then
  factory.require("machines/miner")
end