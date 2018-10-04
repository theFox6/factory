--FIXME: actually don't overwrite minetest.translate

if not minetest.translate then
	if minetest.get_translator then
		factory.log.warning("minetest.translate not found, this is really strange...")
	end
	rawset(minetest,"translate",function(_, str, ...)
		local arg = {n=select('#', ...), ...}
		return str:gsub("@(.)", function (matched)
			local c = string.byte(matched)
			if string.byte("1") <= c and c <= string.byte("9") then
				return arg[c - string.byte("0")]
			else
				return matched
			end
		end)
	end)
end

if not minetest.get_translator then
	factory.log.warning("Minetest translator not found!")
	rawset(minetest,"get_translator",function(textdomain)
		return function(str,...) return minetest.translate(textdomain or "", str, ...) end
	end)
end

factory.S=minetest.get_translator("factory")