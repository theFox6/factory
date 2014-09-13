minetest.register_node("factory:belt", {
	description = "Conveyor Belt",
	tiles = {{name="factory_belt_top_animation.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=0.4}}, "factory_belt_bottom.png", "factory_belt_side.png",
		"factory_belt_side.png", "factory_belt_side.png", "factory_belt_side.png"},
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

minetest.register_abm({
	nodenames = {"factory:belt"},
	neighbors = nil,
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local all_objects = minetest.get_objects_inside_radius(pos, 1)
		local _,obj
		for _,obj in ipairs(all_objects) do
			if not obj:is_player() and obj:get_luaentity() and obj:get_luaentity().name == "__builtin:item" then
				factory.do_moving_item({x = pos.x, y = pos.y + 0.15, z = pos.z}, obj:get_luaentity().itemstring)
				obj:get_luaentity().itemstring = ""
				obj:remove()
			end
		end
	end,
})

-- Based off of the pipeworks item code

function factory.do_moving_item(pos, item)
	local stack = ItemStack(item)
	local obj = luaentity.add_entity(pos, "factory:moving_item")
	obj:set_item(stack:to_string())
	return obj
end

minetest.register_entity("factory:moving_item", {
	initial_properties = {
		hp_max = 1,
		physical = false,
		collisionbox = {0.125, 0.125, 0.125, 0.125, 0.125, 0.125},
		visual = "wielditem",
		visual_size = {x = 0.2, y = 0.2},
		textures = {""},
		spritediv = {x = 1, y = 1},
		initial_sprite_basepos = {x = 0, y = 0},
		is_visible = false,
	},

	physical_state = false,

	from_data = function(self, itemstring)
		local stack = ItemStack(itemstring)
		local itemtable = stack:to_table()
		local itemname = nil
		if itemtable then
			itemname = stack:to_table().name
		end
		local item_texture = nil
		local item_type = ""
		if minetest.registered_items[itemname] then
			item_texture = minetest.registered_items[itemname].inventory_image
			item_type = minetest.registered_items[itemname].type
		end
		self.object:set_properties({
			is_visible = true,
			textures = {stack:get_name()}
		})
		local def = stack:get_definition()
		self.object:setyaw((def and def.type == "node") and 0 or math.pi * 0.25)
	end,

	get_staticdata = luaentity.get_staticdata,
	on_activate = function(self, staticdata)
		if staticdata == "" or staticdata == nil then
			return
		end
		if staticdata == "toremove" then
			self.object:remove()
			return
		end
		local item = minetest.deserialize(staticdata)

		factory.do_moving_item(self.object:getpos(), item.velocity, item.itemstring)
		self.object:remove()
	end,
})

luaentity.register_entity("factory:moving_item", {
	itemstring = '',
	item_entity = nil,

	set_item = function(self, item)
		local itemstring = ItemStack(item):to_string() -- Accept any input format
		if self.itemstring == itemstring then
			return
		end
		if self.item_entity then
			self:remove_attached_entity(self.item_entity)
		end
		self.itemstring = itemstring
		self.item_entity = self:add_attached_entity("factory:moving_item", itemstring)
	end,

	on_step = function(self, dtime)
		local pos = self:getpos()
		local stack = ItemStack(self.itemstring)
		local napos = minetest.get_node(pos) 

		local veldir = self:getvelocity();

		if napos.name == "factory:belt" then
			local speed = 0.8
			local dir = minetest.facedir_to_dir(napos.param2)
			self:setvelocity({x = dir.x / speed, y = 0, z = dir.z / speed})
		else
			minetest.item_drop(stack, "", {x = pos.x + veldir.x / 2, y = pos.y, z = pos.z + veldir.z / 1.5})
			self:remove()
		end

	end
})