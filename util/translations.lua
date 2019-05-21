local log = factory.require("util/log")
local S

if not minetest.translate then
	log.warning("Minetest translator not found!")
	local function translate(_, str, ...)
		local arg = {n=select('#', ...), ...}
		return str:gsub("@(.)", function (matched)
			local c = string.byte(matched)
			if string.byte("1") <= c and c <= string.byte("9") then
				return arg[c - string.byte("0")]
			else
				return matched
			end
		end)
	end
	if minetest.get_translator then
		log.warning("minetest.translate not found, this is really strange...")
		S = minetest.get_translator("factory")
	else
		local function get_translator(textdomain)
			return function(str,...)
				return translate(textdomain or "", str, ...)
			end
		end
		S = get_translator("factory")
	end
else
	if not minetest.get_translator then
		log.warning("minetest.get_translator not found, this is really strange...")
		local function get_translator(textdomain)
			return function(str,...)
				return minetest.translate(textdomain or "", str, ...)
			end
		end
		S = get_translator("factory")
	else
		S = minetest.get_translator("factory")
	end
end

factory.S = S
return S
