local S = factory.S
factory.electronics.device = {}

local facedir_to_dir = {
	{x= 0, y=0,  z= 1},
	{x= 1, y=0,  z= 0},
	{x= 0, y=0,  z=-1},
	{x=-1, y=0,  z= 0},
	{x= 0, y=-1, z= 0},
	{x= 0, y=1,  z= 0},
}

function factory.electronics.device.set_infotext(meta)
	local desc = meta:get_string("factory_description")
	local status = meta:get_string("factory_status")
	if status ~= "" then
		desc = desc .. "\nstatus: " .. status
	end
	meta:set_string("infotext", S("@1charge: @2%", desc.."\n", meta:get_int("factory_energy")))
end

function factory.electronics.device.get_energy(meta)
	return meta:get_int("factory_energy")
end

function factory.electronics.device:set_energy(meta,value)
	meta:set_int("factory_energy", value)
	self.set_infotext(meta)
end

function factory.electronics.device:set_name(meta,device_name)
	meta:set_string("factory_description", device_name)
	self.set_infotext(meta)
end

function factory.electronics.device:set_status(meta,status)
	meta:set_string("factory_status", status)
	self.set_infotext(meta)
end

function factory.electronics.device:store(meta, push_energy, max_energy)
	local energy = self.get_energy(meta)
	local taken = math.min(push_energy, max_energy - energy)
	self:set_energy(meta, taken + energy)
	return push_energy - taken
end

function factory.electronics.device:try_use(meta,energy_amount)
	local energy = self.get_energy(meta)
	if energy >= energy_amount then
		self:set_energy(meta, energy - energy_amount)
		return true
	else
		return false
	end
end

function factory.electronics.is_device(node)
	local nname
	if type(node) == "string" then
		nname = node
	elseif type(node) == "table" then
		if node.name then
			nname = node.name
		elseif node.x then
			nname = minetest.get_node(node).name
		end
	end
	return minetest.get_item_group(nname, "factory_electronic") > 0
end

function factory.electronics.device.distribute(pos,energy_amount,exclude_sides)
	--FIXME: perhaps rotate or remember taken side
	local remain = energy_amount
	local ex = exclude_sides
	if exclude_sides == nil then
		ex = {vector.new(0,0,0)}
	elseif type(exclude_sides) == "number" then
		ex = {facedir_to_dir[exclude_sides]}
	elseif exclude_sides.x then
		ex = {exclude_sides}
	end
	local sides = {}
	for _,side in pairs(facedir_to_dir) do
		local exclude = false
		for _,el in pairs(ex) do
			if vector.equals(side,el) then
				exclude = true
				break
			end
		end
		if not exclude then
			table.insert(sides,side)
		end
	end
	for _,dir in pairs(sides) do
		if remain == 0 then
			break
		end
		local node = minetest.get_node(vector.add(pos,dir))
		if factory.electronics.is_device(node) then
			local nodedef = minetest.registered_nodes[node.name]
			if nodedef then
				local pushfunc = nodedef.on_push_electricity
				if pushfunc then
					remain = pushfunc(vector.add(pos,dir),remain, vector.multiply(dir,-1))
				end
			end
		end
	end
	return remain
end