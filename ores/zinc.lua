local S = factory.S

if not minetest.get_modpath("technic_worldgen") then
  local zinc_params = {
    offset = 0,
    scale = 1,
    spread = {x = 100, y = 100, z = 100},
    seed = 422,
    octaves = 3,
    persist = 0.7
  }
  local zinc_threshold = 0.5

  factory.register_metal("technic","zinc",{
    description = S("zinc"),
    oredef = {
      clust_scarcity = 8*8*8,
      clust_num_ores = 5,
      clust_size = 7,
      y_min = -32,
      y_max = 2,
      noise_params = zinc_params,
      noise_threshold = zinc_threshold,
    }
  })

	minetest.register_ore({
		ore_type = "scatter",
		ore = "technic:mineral_zinc",
		wherein = "default:stone",
		clust_scarcity = 6*6*6,
		clust_num_ores = 4,
		clust_size = 3,
		y_min = -31000,
		y_max = -32,
		flags = "absheight",
		noise_params = zinc_params,
		noise_threshold = zinc_threshold,
	})
end

minetest.register_alias("factory:zinc_lump",  "technic:zinc_lump")
minetest.register_alias("factory:zinc_ingot", "technic:zinc_ingot")
minetest.register_alias("factory:zinc_block", "technic:zinc_block")

if minetest.get_modpath("moreblocks") and not minetest.get_modpath("extranodes") then
	stairsplus:register_all("technic", "zinc_block", "technic:zinc_block", {
		description=S("@1 block", S("zinc")),
		groups={cracky=1, not_in_creative_inventory=1},
		tiles={"technic_zinc_block.png"},
	})
end
