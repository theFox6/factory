local gui = {}

gui.bg_color = "bgcolor[#080808BB;true]"
gui.bg_img = "background[5,5;1,1;gui_factoryformbg.png;true]"
gui.bg_img_2 = "background[5,5;1,1;gui_factoryformbg2.png;true]"
gui.slot_colors = "listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"

function factory.get_hotbar_bg(x,y)
	local out = ""
	--TODO: create this texture
	for i=0,7,1 do
		out = out .."image["..x+i..","..y..";1,1;gui_hb_bg.png]"
	end
	return out
end

factory.gui = gui
return gui
-- vim: et:ai:sw=2:ts=2:fdm=indent:syntax=lua
