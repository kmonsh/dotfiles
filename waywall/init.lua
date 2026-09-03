-- ==== IMPORTS ====
local waywall = require("waywall")
local helpers = require("waywall.helpers")
local custom_layout_enabled = true

-- ==== KEYS ====
local thin = "*-X"
local tall = "H"
local wide = "*-Y"
local preemptive = "Shift-H"

local toggle_ninbot = "*-apostrophe"
local launch_paceman = "Shift-P"
local fullscreen = "Shift-O"

local remapped_kb = {
    ["MB4"] = "F3",
    ["MB5"] = "Home",
    ["Q"] = "0",
    --["RIGHTSHIFT"] = "LEFTMETA", (handled in keyd)
    --["LEFTMETA"] = "RIGHTSHIFT",
}

local remapped_kb_menu = {
    ["MB4"] = "Backspace",
    ["MB5"] = "Home",
    ["Q"] = "0",
}

-- ==== SENSITIVITIES ====
local normal_sens = 3.3913485
local tall_sens = 0.1


-- ==== PATHS ====
local home_path = os.getenv("HOME") .. "/.config/waywall/"
local pacem_path = home_path .. "paceman-tracker-0.7.0.jar"
local nb_path = home_path .. "Ninjabrain-Bot-1.5.2.jar"
local overlay_path = home_path .. "measuring_overlay.png"
local bg_path = home_path .. "background.png"

-- ==== HELPERS ====
local is_ninb_running = function()
    local handle = io.popen("pgrep -f 'Ninjabrain.*jar'")
    local result = handle:read("*l")
    handle:close()
    return result ~= nil
end
local is_pacem_running = function()
    local handle = io.popen("pgrep -f 'paceman..*'")
    local result = handle:read("*l")
    handle:close()
    return result ~= nil
end


-- ==== MIRRORS ====
local make_mirror = function(options)
    local this = nil

    return function(enable)
        if enable and not this then
            this = waywall.mirror(options)
        elseif this and not enable then
            this:close()
            this = nil
        end
    end
end

local mirrors = {
    thin_e = make_mirror({
        src = { x = 13, y = 37, w = 37, h = 9 },
        dst = { x = 960, y = 618, w = 4 * 37, h = 4 * 9 },
    }),

    thin_percent = make_mirror({
        src = { x = 247, y = 859, w = 27, h = 25 },
        dst = { x = 1000, y = 700, w = 4 * 27, h = 4 * 25 },
    }),    

    tall_e = make_mirror({
        src = { x = 13, y = 37, w = 37, h = 9 },
        dst = { x = 960, y = 618, w = 4 * 37, h = 4 * 9 },
    }),

    tall_pie = make_mirror({
        src = { x = 0, y = 15958, w = 340, h = 250 },
        dst = { x = 790, y = 654, w = 340, h = 250 },
    }),

    tall_percent = make_mirror({
        src = { x = 247, y = 16163, w = 27, h = 25 },
        dst = { x = 1000, y = 700, w = 4 * 27, h = 4 * 25 },
    }),

    eye_measure = make_mirror({
        src = { x = 155, y = 7902, w = 30, h = 580 },
        dst = { x = 0, y = 370, w = 790, h = 340 },
    }),
}

local make_image = function(path, dst)
    local this = nil

    return function(enable)
        if enable and not this then
            this = waywall.image(path, dst)
        elseif this and not enable then
            this:close()
            this = nil
        end
    end
end

local images = {
    measuring_overlay = make_image(overlay_path, {
        dst = { x = 0, y = 370, w = 790, h = 340 },
    }),
}

local show_mirrors = function(thin, tall, preemptive, wide)
    mirrors.thin_e(thin)
    mirrors.thin_percent(thin)

    mirrors.tall_e(preemptive)
    mirrors.tall_percent(preemptive)
    mirrors.tall_pie(preemptive)

    mirrors.eye_measure(tall)
    images.measuring_overlay(thin or tall)
end

local thin_enable = function()
    show_mirrors(true, false, false, false)
    waywall.set_sensitivity(normal_sens)
end

local tall_enable = function()
    show_mirrors(false, true, false, false)
    waywall.set_sensitivity(tall_sens)
end

local preemptive_enable = function()
    show_mirrors(false, false, true, false)
    waywall.set_sensitivity(normal_sens)
end

local wide_enable = function()
    show_mirrors(false, false, false, true)
    waywall.set_sensitivity(normal_sens)
end

local res_disable = function()
    show_mirrors(false, false, false, false)
    waywall.set_sensitivity(normal_sens)
end


-- ==== RESOLUTIONS ====
local make_res = function(width, height, enable, disable)
    return function()
        local active_width, active_height = waywall.active_res()

        if active_width == width and active_height == height then
            waywall.set_resolution(0, 0)
            disable()
        else
            waywall.set_resolution(width, height)
            enable()
        end
    end
end

local resolutions = {
    thin = make_res(340, 1080, thin_enable, res_disable),
    tall = make_res(340, 16384, tall_enable, res_disable),
    preemptive = make_res(340, 16384, preemptive_enable, res_disable),
    wide = make_res(1920, 340, wide_enable, res_disable),
}


-- ==== CONFIG ====
local config = {
    input = {
        layout = "somali",
        repeat_rate = 40,
        repeat_delay = 300,
        remaps = remapped_kb,
        sensitivity = normal_sens,
        confine_pointer = false,
    },
    theme = {
        background = "#00000000",
        ninb_anchor = "topright",
        ninb_opacity = 1,
        cursor_theme = "woofdoggo",
        background_png = bg_path,
    },
}

config.actions = {
    
    [thin] = helpers.ingame_only(resolutions.thin),
    [tall] = helpers.ingame_only(resolutions.tall),
    [preemptive] = helpers.ingame_only(resolutions.preemptive),
    [wide] = helpers.ingame_only(resolutions.wide),

    [toggle_ninbot] = function()
        if not is_ninb_running() then
            waywall.exec("java -Dawt.useSystemAAFontSettings=on -jar " .. nb_path)
            waywall.show_floating(true)
        else
            helpers.toggle_floating()
        end
    end,

    ["*-C"] = function()
        if waywall.get_key("F3") then
            waywall.press_key("C")
            
            if not is_ninb_running() then
                waywall.exec("java -Dawt.useSystemAAFontSettings=on -jar " .. nb_path)
            end
            waywall.show_floating(true)
        else
            return false
        end
    end,

    [launch_paceman] = function()
        if not is_pacem_running() then
            waywall.exec("java -jar " .. pacem_path .. " --nogui")
        end
    end,

    [fullscreen] = waywall.toggle_fullscreen,

    -- ==== TOGGLE LAYOUT ON / OFF ====
    ["Shift-L"] = function()
        if custom_layout_enabled then
            -- Turn custom layout OFF (Fall back to default native system layout)
            waywall.set_keymap({
                layout = nil,
            })
            custom_layout_enabled = false
            print("Keyboard Layout: DEFAULT SYSTEM")
        else
            -- Turn custom layout back ON
            waywall.set_keymap({
                layout = "somali",
            })
            custom_layout_enabled = true
            print("Keyboard Layout: CUSTOM (NEW)")
        end
    end,
}

--==ONESHOT CROSSHAIR==

local crosshair_image = nil
local crosshair_active = nil

local cfg = {
    resx = 1920,
    resy = 1080,
    size = 200,
    key = "Shift-I",
    path = os.getenv("HOME") .. "/.config/waywall/crosshair.png",
}
config.actions[cfg.key] = function()
    if crosshair_image then
        crosshair_image:close(); crosshair_image = nil
    end
    if crosshair_active then
        crosshair_active = false
    else
        crosshair_active = true
        crosshair_image = waywall.image(cfg.path, {
            dst = {
                x = (cfg.resx - cfg.size) / 2,
                y = (cfg.resy - cfg.size) / 2,
                w = cfg.size,
                h = cfg.size,
            }
        })
    end
end

-- ==== DYNAMIC KEYBIND LISTENER ====
local state_listener = waywall.listen("state", function()
    -- pcall safely catches errors during startup so the listener doesn't break
    local success, state = pcall(waywall.state)
    if not success then return end
    
    local in_menu = not (state.screen == "inworld" and state.inworld == "unpaused")
    
    if in_menu then
        waywall.set_remaps(remapped_kb_menu)
    else
        waywall.set_remaps(remapped_kb)
    end
end)

helpers.res_mirror( -- difficulty
    {
        src = { x = 336, y = 691, w = 76, h = 29 },
        dst = { x = 925, y = 885, w = 76 * 1, h = 29 * 1 },
        depth = 3,
        color_key = { input = "#DDDDDD", output = "#00FFFFFF" } --mr white #FFFFFF
    },
    0, 0
    )

for i = 0, 3, 1 do
    helpers.res_mirror( -- mob_spawner
        {
            src = { x = 1827, y = 859 + 8 * i, w = 33, h = 9 },
            dst = { x = 1618, y = 720, w = 33 * 8, h = 9 * 8 },
            depth = 3,
            color_key = { input = "#4de1ca", output = "#FFFFFF" }
        },
        0, 0
    )
    helpers.res_mirror( -- mob_spawner
        {
            src = { x = 1827, y = 859 + 8 * i, w = 33, h = 9 },
            dst = { x = 1618 + 8, y = 720 + 8, w = 33 * 8, h = 9 * 8 },
            depth = 2,
            color_key = { input = "#4de1ca", output = "#000000" }
        },
        0, 0
    )
end
    
return config
