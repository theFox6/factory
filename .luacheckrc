max_line_length = false

read_globals = {
	"default",
	"dump",
	"intllib",
	"ItemStack",
	math = { fields = {"sign"} },
	"minetest",
	"PseudoRandom",
	"stairsplus",
	table = { fields = {"copy"} },
	"unified_inventory",
	"vector",
	"VoxelArea",
	"VoxelManip",	
}

globals = {
	"factory",
	--these should probably be moved to the factory global
	"factory_gui_bg",
	"factory_gui_bg_img",
	"factory_gui_bg_img_2",
	"factory_gui_slots",
	--from modutil
	"modutil",
	"LuaVenusCompiler",
}

files["util/compat_nei.lua"].read_globals = {"api"}
files["modutil/strings.lua"].globals = { string = {
		fields = {"starts_with","ends_with"}
}}

exclude_files={"modutil/LuaVenusCompiler/testout/"}

ignore = {
	"211",
	"212",
	"213",
	"611",
	"612",
	"621",
	"631"
}
