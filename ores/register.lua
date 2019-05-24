local S = factory.S

local default_stone_sounds = default and default.node_sound_stone_defaults()
local default_metal_sounds = default and default.node_sound_metal_defaults()

local function register_metal(modname, name, def)
  local item_base = modname..":"..name
  local texture_base = modname.."_"..name
  local description = def.description or name

  local lump = item_base.."_lump"
  minetest.register_craftitem(":"..lump, {
    description = S("@1 Lump", description),
    inventory_image = texture_base.."_lump.png",
  })

  local ingot = item_base.."_ingot"
  minetest.register_craftitem(":"..ingot, {
    description = S("@1 Ingot", description),
    inventory_image = texture_base.."_ingot.png",
  })

  minetest.register_craft({
    type = "cooking",
    recipe = lump,
    output = ingot,
  })

  local block = item_base.."_block"
  minetest.register_node(":"..block, {
    description = S("@1 Block", description),
    tiles = { texture_base.."_block.png" },
    --def sounds or default metal sound or group based (nil)
    sounds = def.sounds or default_metal_sounds,
    groups = def.groups or {snappy = 1, bendy = 2, cracky = 1, melty = 2, level = 2},
  })

  minetest.register_craft({
    output = block,
    recipe = {
      {ingot, ingot, ingot},
      {ingot, ingot, ingot},
      {ingot, ingot, ingot},
    }
  })

  minetest.register_craft({
    output = ingot.." 9",
    recipe = {
      {block}
    }
  })

  local mineral = modname..":mineral_"..name
  minetest.register_node(":"..mineral,{
    description = S("@1 Ore", description),
    tiles = {"default_stone.png^"..modname.."_mineral_"..name..".png"},
    groups = {cracky = 3},
    sounds = default_stone_sounds,
    drop = lump,
  })

  local oredef = def.oredef
  oredef.ore = mineral
  oredef.wherein = "default:stone"
  if not oredef.type then oredef.type = "scatter" end

  minetest.register_ore(oredef)
end

factory.register_metal = register_metal
return register_metal
