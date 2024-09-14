local static_spawnpoint = minetest.settings:get("static_spawnpoint")
local mod_storage = minetest.get_mod_storage()
local spawn_pos = {x = 0, y = 0, z = 0}

local function load_spawn()
    local pos_string = static_spawnpoint or mod_storage:get_string("spawn_pos")
    local pos = minetest.string_to_pos(pos_string)
    if pos then
        spawn_pos = pos
    end
end

local function save_spawn()
    local pos_string = minetest.pos_to_string(spawn_pos)
    mod_storage:set_string("spawn_pos", pos_string)
    minetest.settings:set("static_spawnpoint", pos_string)
end

load_spawn()

minetest.register_on_joinplayer(function(player)
    local meta = player:get_meta()
    if meta:get_string("spawn") ~= "true" then
        player:set_pos(spawn_pos)
        meta:set_string("spawn", "true")
    end
end)

minetest.register_chatcommand("spawn", {
    description = "Teleport to spawn point",
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            player:set_pos(spawn_pos)
            return true, minetest.colorize("#e2e117", "[-!-] You have been teleported to spawn.")
        else
            return false, minetest.colorize("#e2e117", "[-!-] Invalid player")
        end
    end
})

minetest.register_chatcommand("setspawn", {
    description = "Set the spawn point for all players",
    privs = {server = true},
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            spawn_pos = player:get_pos()
            save_spawn()
            return true, minetest.colorize("#e2e117", "[-!-] Spawn point defined at your coordinates.")
        else
            return false, minetest.colorize("#e2e117", "[-!-] Invalid player")
        end
    end
})
