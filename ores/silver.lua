local S = factory.S

if not minetest.get_modpath("moreores") then
  factory.register_metal("moreores","silver",{
    description = S("silver"),
    oredef = {
      clust_scarcity = 11 * 11 * 11,
      clust_num_ores = 4,
      clust_size     = 11,
      y_min     = -31000,
      y_max     = -2,
    }
  })
  if minetest.get_modpath("ingots") then
    ingots.register_ingots("moreores:silver_ingot", "ingot_silver.png", false, nil, "ingots")
  end
end

minetest.register_alias("factory:silver_lump",  "moreores:silver_lump")
minetest.register_alias("factory:silver_ingot", "moreores:silver_ingot")
minetest.register_alias("factory:silver_block", "moreores:silver_block")
-- vim: et:ai:sw=2:ts=2:fdm=indent:syntax=lua
