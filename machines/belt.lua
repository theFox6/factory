local S = factory.S
local belts = {}

minetest.register_node("factory:belt_center", {
	description = S("centering Conveyor Belt"),
	tiles = {{name="factory_belt_top_animation.png",
		animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.4}}, "factory_belt_bottom.png",
		"factory_belt_side.png", "factory_belt_side.png", "factory_belt_side.png", "factory_belt_side.png"},
	groups = {cracky=1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = true,
	legacy_facedir_simple = true,
	node_box = {
			type = "fixed",
			fixed = {{-0.5,-0.5,-0.5,0.5,0.0625,0.5},}
		},
})

minetest.register_node("factory:belt", {
	description = S("Conveyor Belt"),
	tiles = {{name="factory_belt_st_top_animation.png",
		animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.4}}, "factory_belt_bottom.png",
		"factory_belt_side.png", "factory_belt_side.png", "factory_belt_side.png", "factory_belt_side.png"},
	groups = {cracky=1},
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "facedir",
	is_ground_content = true,
	legacy_facedir_simple = true,
	node_box = {
			type = "fixed",
			fixed = {{-0.5,-0.5,-0.5,0.5,0.0625,0.5},}
		},
})

minetest.register_alias("factory:belt_straight","factory:belt")

local abm_move_player = factory.setting_enabled("abmBeltvelocity")
		and not factory.setting_enabled("stepBeltvelocity")
local belt_move_player = factory.setting_enabled("abmBeltvelocity")
    or factory.setting_enabled("stepBeltvelocity")

--perhaps move this function to moving item
function belts.move_player(player,bpos,speed,belt_node)
	local node = belt_node or minetest.get_node(bpos)
	local dir = vector.new(minetest.facedir_to_dir(node.param2))
	local ppos = player:get_pos()
	if node.name == "factory:belt_center" then
		if dir.x == 0 then
			dir.x = (bpos.x - ppos.x) * 2
		elseif dir.z == 0 then
			dir.z = (bpos.z - ppos.z) * 2
		end
	end
	-- reduce speed by portion of player velocity
	-- fast players receive less velocity
	local pv = player:get_player_velocity()
	for c,v in pairs(dir) do
		dir[c] = v*2
		--don't increase speed when already fast
		if math.sign(v) == math.sign(pv[c]) then
		  dir[c] = dir[c] - math.sign(v) * math.sqrt(math.abs(pv[c]))
		end
	end
	if belt_move_player and not player.add_player_velocity then
	  abm_move_player = false
	  minetest.settings:set_bool("factory_enableabmBeltvelocity",false)
	  minetest.settings:set_bool("factory_enablestepBeltvelocity",false)
	  belt_move_player = false
          return
	end
	player:add_player_velocity(vector.multiply(dir,speed))
end

minetest.register_abm({
	nodenames = {"factory:belt_center", "factory:belt"},
	neighbors = nil,
	interval = 1,
	chance = 1,
	action = function(pos,node,_,aocw)
		if aocw == 0 then return end
		local all_objects = minetest.get_objects_inside_radius(pos, 0.75)
		for _,obj in ipairs(all_objects) do
			if abm_move_player and obj:is_player() then
				local ppos = obj:get_pos()
				if math.abs(pos.z-ppos.z)<0.5 and math.abs(pos.x - ppos.x)<0.5 then
					belts.move_player(obj,pos,1.8,node)
				end
			elseif obj:get_luaentity() and obj:get_luaentity().name == "__builtin:item" then
				factory.do_moving_item({x = pos.x, y = pos.y + 0.15, z = pos.z}, obj:get_luaentity().itemstring)
				obj:get_luaentity().itemstring = ""
				obj:remove()
			end
		end
	end,
})

return belts
