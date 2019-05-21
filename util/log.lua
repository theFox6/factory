local function make_logger(level)
	return function(text, ...)
		minetest.log(level, "[factory] "..text:format(...))
	end
end

local log = {
	warning = make_logger("warning"),
	action = make_logger("action"),
	info = make_logger("info")
}

factory.log = log
return log
