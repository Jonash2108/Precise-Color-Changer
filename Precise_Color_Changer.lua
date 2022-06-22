--[[
    Author: Sri Hari
    Thanks to: Proddy (For RBG to INT function)
               Kektram (For an extra check in req_control function)
]]

if precise_color_changer_loaded then
    menu.notify("Already loaded you dummy! Go to \"Local > Script Features\"", "Precise Color Changer", 6, 0x0000FF)
    return
end
precise_color_changer_loaded = true

local script_parent = {}
script_parent.home = menu.add_feature("Precise Color Changer", "parent", 0).id
script_parent.primary = menu.add_feature("Primary Color", "parent", script_parent.home).id
script_parent.secon = menu.add_feature("Secondary Color", "parent", script_parent.home).id
script_parent.pearl = menu.add_feature("Pearlescent Color", "parent", script_parent.home).id
script_parent.wheel = menu.add_feature("Wheel Color", "parent", script_parent.home).id


local function req_control(ent)
    local check_time = utils.time_ms() + 1000
    network.request_control_of_entity(ent)
    while not network.has_control_of_entity(ent) and entity.is_an_entity(ent) and check_time > utils.time_ms() do
        system.yield(0)
    end
    return network.has_control_of_entity(ent)
end

local function get_input(title, def)
    title = title or ""
    def = def or ""
    local status, msg
    repeat
        system.yield(0)
        status, msg = input.get(title, def, 3, 3)
        if status == 2 then
            menu.notify("Input cancelled", "Precise Color Changer", 5, 0x000000)
            return HANDLER_POP
        end
    until status == 0
    return msg
end

-- Credits to Proddy
local function RGBAToInt(R, G, B, A)
	A = A or 255
	return ((R&0x0ff)<<0x00)|((G&0x0ff)<<0x08)|((B&0x0ff)<<0x10)|((A&0x0ff)<<0x18)
end

local v = {}
v.p = {}
v.p.r = 0
v.p.g = 0
v.p.b = 0
v.s = {}
v.s.r = 0
v.s.g = 0
v.s.b = 0
v.pearl = {}
v.pearl.r = 0
v.pearl.g = 0
v.pearl.b = 0
v.w = {}
v.w.r = 0
v.w.g = 0
v.w.b = 0

local mypid = player.player_id

-- Primary Color
menu.add_feature("Display current primary values", "action", script_parent.primary, function()
    local txt = "Primary R: "..v.p.r.." | Primary G: "..v.p.g.." | Primary B: "..v.p.b
    menu.notify(txt, "Precise Color Changer", 8, 0x00E8FF)
end)

menu.add_feature("Set R value", "action", script_parent.primary, function()
    local val = get_input("Change R value", v.p.r)
    menu.notify("Set Primary R to "..val, "Precise Color Changer", 5, 0x00CC00)
    v.p.r = tonumber(val)
end)
menu.add_feature("Set G value", "action", script_parent.primary, function()
    local val = get_input("Change G value", v.p.g)
    menu.notify("Set Primary G to "..val, "Precise Color Changer", 5, 0x00CC00)
    v.p.g = tonumber(val)
end)
menu.add_feature("Set B value", "action", script_parent.primary, function()
    local val = get_input("Change B value", v.p.b)
    menu.notify("Set Primary B to "..val, "Precise Color Changer", 5, 0x00CC00)
    v.p.b = tonumber(val)
end)

menu.add_feature("Change Primary Color", "action", script_parent.primary, function()
    if not player.is_player_in_any_vehicle(mypid()) then
        menu.notify("Get in a vehicle first!", "Precise Color Changer", 6, 0x0000FF)
        return
    end

    local cur_veh = player.get_player_vehicle(mypid())
    if not network.has_control_of_entity(cur_veh) then
        req_control(cur_veh)
    end

    vehicle.set_vehicle_custom_primary_colour(cur_veh, RGBAToInt(v.p.b, v.p.g, v.p.r))
    local txt = "Changed primary color to: "..v.p.r..", "..v.p.g..", "..v.p.b
    menu.notify(txt, "Precise Color Changer", 6, 0x00CC00)
end)

-- Secondary Color
menu.add_feature("Display current secondary values", "action", script_parent.secon, function()
    local txt = "Secondary R: "..v.s.r.." | Secondary G: "..v.s.g.." | Secondary B: "..v.s.b
    menu.notify(txt, "Precise Color Changer", 8, 0x00E8FF)
end)

menu.add_feature("Set R value", "action", script_parent.secon, function()
    local val = get_input("Change R value", v.s.r)
    menu.notify("Set Secondary R to "..val, "Precise Color Changer", 5, 0x00CC00)
    v.s.r = tonumber(val)
end)
menu.add_feature("Set G value", "action", script_parent.secon, function()
    local val = get_input("Change G value", v.s.g)
    menu.notify("Set Secondary G to "..val, "Precise Color Changer", 5, 0x00CC00)
    v.s.g = tonumber(val)
end)
menu.add_feature("Set B value", "action", script_parent.secon, function()
    local val = get_input("Change B value", v.s.b)
    menu.notify("Set Secondary B to "..val, "Precise Color Changer", 5, 0x00CC00)
    v.s.b = tonumber(val)
end)

menu.add_feature("Change Secondary Color", "action", script_parent.secon, function()
    if not player.is_player_in_any_vehicle(mypid()) then
        menu.notify("Get in a vehicle first!", "Precise Color Changer", 6, 0x0000FF)
        return
    end

    local cur_veh = player.get_player_vehicle(mypid())
    if not network.has_control_of_entity(cur_veh) then
        req_control(cur_veh)
    end

    vehicle.set_vehicle_custom_secondary_colour(cur_veh, RGBAToInt(v.s.b, v.s.g, v.s.r))
    local txt = "Changed secondary color to: "..v.s.r..", "..v.s.g..", "..v.s.b
    menu.notify(txt, "Precise Color Changer", 6, 0x00CC00)
end)

-- Pearlescent Color
menu.add_feature("Display current Pearlescent values", "action", script_parent.pearl, function()
    local txt = "Pearlescent R: "..v.pearl.r.." | Pearlescent G: "..v.pearl.g.." | Pearlescent B: "..v.pearl.b
    menu.notify(txt, "Precise Color Changer", 8, 0x00E8FF)
end)

menu.add_feature("Set R value", "action", script_parent.pearl, function()
    local val = get_input("Change R value", v.pearl.r)
    menu.notify("Set Pearlescent R to "..val, "Precise Color Changer", 5, 0x00CC00)
    v.pearl.r = tonumber(val)
end)
menu.add_feature("Set G value", "action", script_parent.pearl, function()
    local val = get_input("Change G value", v.pearl.g)
    menu.notify("Set Pearlescent G to "..val, "Precise Color Changer", 5, 0x00CC00)
    v.pearl.g = tonumber(val)
end)
menu.add_feature("Set B value", "action", script_parent.pearl, function()
    local val = get_input("Change B value", v.pearl.b)
    menu.notify("Set Pearlescent B to "..val, "Precise Color Changer", 5, 0x00CC00)
    v.pearl.b = tonumber(val)
end)

menu.add_feature("Change Pearlescent Color", "action", script_parent.pearl, function()
    if not player.is_player_in_any_vehicle(mypid()) then
        menu.notify("Get in a vehicle first!", "Precise Color Changer", 6, 0x0000FF)
        return
    end

    local cur_veh = player.get_player_vehicle(mypid())
    if not network.has_control_of_entity(cur_veh) then
        req_control(cur_veh)
    end
    
    vehicle.set_vehicle_custom_pearlescent_colour(cur_veh, RGBAToInt(v.pearl.b, v.pearl.g, v.pearl.r))
    local txt = "Changed pearlescent color to: "..v.pearl.r..", "..v.pearl.g..", "..v.pearl.b
    menu.notify(txt, "Precise Color Changer", 6, 0x00CC00)
end)

-- Wheel Color
menu.add_feature("Display current Wheel Color values", "action", script_parent.wheel, function()
    local txt = "Wheel R: "..v.w.r.." | Wheel G: "..v.w.g.." | Wheel B: "..v.w.b
    menu.notify(txt, "Precise Color Changer", 8, 0x00E8FF)
end)

menu.add_feature("Set R value", "action", script_parent.wheel, function()
    local val = get_input("Change R value", v.w.r)
    menu.notify("Set Wheel R to "..val, "Precise Color Changer", 5, 0x00CC00)
    v.w.r = tonumber(val)
end)
menu.add_feature("Set G value", "action", script_parent.wheel, function()
    local val = get_input("Change G value", v.w.g)
    menu.notify("Set Wheel G to "..val, "Precise Color Changer", 5, 0x00CC00)
    v.w.g = tonumber(val)
end)
menu.add_feature("Set B value", "action", script_parent.wheel, function()
    local val = get_input("Change B value", v.w.b)
    menu.notify("Set Wheel B to "..val, "Precise Color Changer", 5, 0x00CC00)
    v.w.b = tonumber(val)
end)

menu.add_feature("Change Wheel Color (WIP)", "action", script_parent.wheel, function()
    if not player.is_player_in_any_vehicle(mypid()) then
        menu.notify("Get in a vehicle first!", "Precise Color Changer", 6, 0x0000FF)
        return
    end

    local cur_veh = player.get_player_vehicle(mypid())
    if not network.has_control_of_entity(cur_veh) then
        req_control(cur_veh)
    end
    
    vehicle.set_vehicle_custom_wheel_colour(cur_veh, RGBAToInt(v.w.b, v.w.g, v.w.r))
    local txt = "Changed pearlescent color to: "..v.w.r..", "..v.w.g..", "..v.w.b
    menu.notify(txt, "Precise Color Changer", 6, 0x00CC00)
end)

menu.notify("Loaded Precise Color Changer | By Sri Hari", "Precise Color Changer", 6, 0x00CC00)