allow_defined_top = true

read_globals = {
	"minetest", "default",
	"dump", "vector",
	"modutil",
	"VoxelManip", "VoxelArea",
	"ItemStack", "PseudoRandom",
	"stairsplus", "intllib",
	"unified_inventory",
	math = { fields = {"sign"} }
}

globals = {
	"factory", "factory_gui_bg", "factory_gui_bg_img", "factory_gui_bg_img_2",
	"factory_gui_slots"
}

files["util/compat_nei.lua"].read_globals = {"api"}
