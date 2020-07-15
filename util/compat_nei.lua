--TODO: check for trinium_api's modpath instead of the global
local recipes = minetest.global_exists("api") and api.recipes or nil -- when NEI mod is not loaded, it's nil
local S = factory.S

function factory.register_nei_recipe(typename, index) -- adds "Fake" recipe
	if not api then return end
	if not recipes.methods[typename] then
		factory.log.warning("Not registered NEI Handler: " .. typename)
		return
	end

	local recipe = factory.recipes[typename].recipes[index]
	local i,o,d = recipe.input, recipe.output, {time = recipe.time}
	if type(o) ~= table then
		o = {o} -- at least output is in (almost) the same form
	end

	local i2 = {}
	for k,v in pairs(i) do
		i2[#i2 + 1] = k .. " " .. v -- I have itemstacks in input even though I should use itemmaps
	end
	recipes.add(typename, i2, o, d)
end

-- I decided to hardcode handlers for now because factory.register_craft_type API is broken (width, height, icon...)
-- If a handler for a method is not registered, it will log a warning whenever recipe with that method is registered
-- Will rewrite this so it's automatic when the API stabilizes (when args in crafting.lua will be the same as in the
-- factory.register_craft_type)
local function register_1x1_method(name, desc, machine)
	if not minetest.global_exists("api") then return end
	recipes.add_method(name, {
		input_amount = 1,
		output_amount = 1,
		get_input_coords = recipes.coord_getter(1, -1, 0),
		get_output_coords = recipes.coord_getter(1, 1, 0),
		formspec_width = 5,
		formspec_height = 4,
		formspec_name = desc,
		formspec_begin = function(data)
			return ("image[1,1;1,1;gui_ind_furnace_arrow_bg.png^[transformR270]textarea[0.25,2.25;4.5,1.5;;;%s]")
					:format(api.S("Time: @1 seconds", data.time))
		end,
	})
	recipes.add_implementor(name, machine)
end
register_1x1_method("ind_squeezer", S"Industrial Squeezer", "factory:ind_squeezer")
register_1x1_method("wire_drawer", S"Wire Drawer", "factory:wire_drawer")
