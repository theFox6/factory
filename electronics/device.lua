--- local reference to the translator
local S = factory.S

---
-- the base for electronic devices
-- @type device
local device = {}

factory.electronics = {
  device = device
}

--- #list<#table> facedir table for iterating
local facedir_to_dir = {
	{x= 0, y=0,  z= 1},
	{x= 1, y=0,  z= 0},
	{x= 0, y=0,  z=-1},
	{x=-1, y=0,  z= 0},
	{x= 0, y=-1, z= 0},
	{x= 0, y=1,  z= 0},
}

---
-- set the infotext of a device:
-- the device's description, status, energy and max charge as infotext
--
-- @function [parent=#device] set_infotext
-- @param #userdata meta the metadata of the device
function device.set_infotext(meta)
	local desc = meta:get_string("factory_description")
	local status = meta:get_string("factory_status")
	if status ~= "" then
		desc = S("@1status: @2",desc.."\n",status)
	end
	local charge = meta:get_int("factory_energy") .. "/" .. meta:get_int("factory_max_charge")
	meta:set_string("infotext", S("@1charge: @2", desc.."\n", charge))
end

---
-- gets the current amount of energy
-- stored in the device
--
-- @function [parent=#device] get_energy
-- @param #userdata meta the metadata of the device
-- @return #number the energy sored in the device
function device.get_energy(meta)
	return meta:get_int("factory_energy")
end

---
-- sets the current amount of energy
-- stored in the device
--
-- @function [parent=#device] set_energy
-- @param #userdata meta the metadata of the device
-- @param #number value the energy that will be stored in the device
function device.set_energy(meta,value)
	meta:set_int("factory_energy", value)
	device.set_infotext(meta)
end

---
-- sets the description of the device
-- shown in the infotext
--
-- @function [parent=#device] set_name
-- @param #userdata meta the metadata of the device
-- @param #string device_name the name of the device
function device.set_name(meta,device_name)
	meta:set_string("factory_description", device_name)
	device.set_infotext(meta)
end

---
-- sets the status of the device
-- shown in the infotext
--
-- @function [parent=#device] set_status
-- @param #userdata meta the metadata of the device
-- @param #string status the status of the device
function device.set_status(meta,status)
	meta:set_string("factory_status", status)
	device.set_infotext(meta)
end

---
-- sets the max charge,
-- the maximal amount of energy that can be stored in the device
--
-- @function [parent=#device] set_max_charge
-- @param #userdata meta the metadata of the device
-- @param #number max_charge the maximal mount of energy
function device.set_max_charge(meta,max_charge)
	meta:set_int("factory_max_charge", max_charge)
	device.set_infotext(meta)
end

---
-- gets the max charge,
-- the maxmimal amount of energy that ca be stored in the device
--
-- @function [parent=#device] get_max_charge
-- @param #userdata meta the metadata of the device
-- @return #number the maximal mount of energy
function device.get_max_charge(meta)
	return meta:get_int("factory_max_charge")
end

---
-- stores energy into the device
-- if too much energy is pushed it's not stored but returned
--
-- @function [parent=#device] store
-- @param #userdata meta the metadata of the device
-- @param #number push_energy the energy pushed to the device
-- @param #number max_amount an extra limit apart from the max_charge
-- @return #number the amount of energy that was not stored into the device
function device.store(meta, push_energy, max_amount)
  assert(push_energy >= 0, "energy amount should not be negative")
	local energy = device.get_energy(meta)
	local max_energy = device.get_max_charge(meta)
	local taken = math.min(push_energy, max_energy - energy)
	if max_amount ~= nil and max_amount >= 0 then
	 taken = math.min(taken, max_amount)
	end
	device.set_energy(meta, taken + energy)
	return push_energy - taken
end

---
-- tries to use the energy
-- if there is enough it's taken and true is returned else false is returned
--
-- @function [parent=#device] try_use
-- @param #userdata meta the metadata of the device
-- @param #number energy_amount the amount of energy that is to be used
-- @return #boolean if the energy was consumed or not
function device.try_use(meta,energy_amount)
  assert(energy_amount >= 0, "energy amount should not be negative")
	local energy = device.get_energy(meta)
	if energy >= energy_amount then
		device.set_energy(meta, energy - energy_amount)
		return true
	else
		return false
	end
end

---
-- check if a given node is a factory device,
-- the item group of the node will be checked for factory_electronic
--
-- @function [parent=#electronics] is_device
-- @param #userdata node the node to be checked
-- @return #boolean whether the group is present
function factory.electronics.is_device(node)
	local nname = factory.get_node_name(node)
	return minetest.get_item_group(nname, "factory_electronic") > 0
end

---
-- try to distribute energy
-- to the surrounding devices
--
-- @function [parent=#device] distribute
-- @param #table pos the position of the energy source
-- @param #number energy_amount the amount of energy to be distributed
-- @param #number max_amount the maximal amount of energy distributed to each side
-- @return #number the energy that was not distributed
function device.distribute(pos,energy_amount, max_amount)
  assert(energy_amount >= 0, "energy amount should not be negative")
	local remain = energy_amount
	for _,dir in pairs(facedir_to_dir) do
		if remain == 0 then
			break
		end
		local nodepos = vector.add(pos,dir)
		local node = minetest.get_node(nodepos)
		if factory.electronics.is_device(node) then
			local nodedef = minetest.registered_nodes[node.name]
			if nodedef then
				local pushfunc = nodedef.on_push_electricity
				if pushfunc then
				  local pushed_energy = remain
				  if max_amount ~= nil and max_amount >= 0 then
				    pushed_energy = math.min(pushed_energy,max_amount)
				  end
				  local extra = remain - pushed_energy
					remain = pushfunc(nodepos,pushed_energy) + extra
				end
			end
		end
	end
	return remain
end

return device
