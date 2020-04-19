local cmnp = modutil.require("check_prefix","venus")

local registered_machines = {}

local machine_node_def = {
  paramtype2 = "facedir",
  is_ground_content = false,
}

local function set_default(t,i,v,copy)
  if not t[i] then
    if copy then
      t[i] = v[i]
    else
      t[i] = v
    end
  end
end

local function set_defaults(t,d)
  if not d then return end
  for i,v in pairs(d) do
    if not t[i] then
      t[i] = v
    end
  end
end

local function machine_construct(mSpec)
  return function(pos)
    local meta = minetest.get_meta(pos)
    meta:set_string("infotext", mSpec.description)
    local inv = meta:get_inventory()
    for n,s in pairs(mSpec.inv_lists) do
      inv:set_size(n, s)
    end
  end
end

local function machine_can_dig(mSpec)
  return function(pos)
    local meta = minetest.get_meta(pos);
    local inv = meta:get_inventory()
    for n in pairs(mSpec.inv_lists) do
      if not inv:is_empty(n) then
        return false
      end
    end
    return true
  end
end

local function match_inv_list(lists,groups,listname,groupname,default_size)
  if lists[listname] then
    set_default(groups,groupname,1,false)
    return true
  elseif groups[groupname] > 0 then
    set_default(lists,listname,default_size,false)
    return true
  end
end

function factory.register_machine(itemstring,machine_specs,node_def)
  local nID = cmnp(itemstring)

  local mSpec = machine_specs or {}
  set_default(mSpec,"description",node_def,true)
  set_default(mSpec,"inv_lists",{},false)

  local nDef = node_def or {}
  if nDef.groups then
    set_defaults(nDef.groups,mSpec.groups)
  else
    nDef.groups = mSpec.groups
  end
  local found_inv_list = false
  if match_inv_list(mSpec.inv_lists,nDef.groups,"src","factory_src_input",1) then
    found_inv_list = true
  end
  if match_inv_list(mSpec.inv_lists,nDef.groups,"fuel","factory_fuel_input",1) then
    found_inv_list = true
  end
  if match_inv_list(mSpec.inv_lists,nDef.groups,"dst","factory_dst_output",4) then
    found_inv_list = true
  end
  if not found_inv_list then
    set_defaults(mSpec.inv_lists,{src=1,dst=4})
    set_defaults(nDef.groups, {factory_src_input=1,factory_dst_output=1})
  end

  registered_machines[nID] = mSpec

  set_default(nDef,"description",machine_specs,true)
  set_defaults(nDef,machine_node_def)

  if not nDef.on_construct then
    if mSpec.on_construct then
      nDef.on_construct = function(...)
        machine_construct(mSpec)(...)
        mSpec.on_construct(...)
      end
    else
      nDef.on_construct = machine_construct(mSpec)
    end
  end
  if not nDef.can_dig then
    if mSpec.can_dig then
      nDef.can_dig = function(...)
        local ret1 = machine_can_dig(mSpec)(...)
        local ret2 = mSpec.can_dig(...)
        return ret1 and ret2
      end
    else
      nDef.can_dig = machine_can_dig(mSpec)
    end
  end

  minetest.register_node(itemstring,nDef)
end

factory.registered_machines = registered_machines
factory.set_default = set_default
factory.set_defaults = set_defaults
