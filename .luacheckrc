allow_defined_top = true

read_globals = {
	"minetest", "default",
	"dump", "vector",
	"modutil",
	"VoxelManip", "VoxelArea",
	"ItemStack", "PseudoRandom",
	"stairsplus", "intllib",
	"unified_inventory",
	math = { fields = {"sign"} },
	table = { fields = {"copy"} }
}

globals = {"factory"}

files["util/compat_nei.lua"].read_globals = {"api"}
files["modutil/strings.lua"].globals = { string = {
		fields = {"starts_with","ends_with"}
}}
