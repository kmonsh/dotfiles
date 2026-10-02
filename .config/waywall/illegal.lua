local waywall = require("waywall")
local helpers = require("waywall.helpers")

return function(config)
    -- This code runs automatically when the file is called!
    
    local pie_dst_2 = { x = 1811, y = 1013, w = 98, h = 53 }
    local pie_dst_2_sh = { x = 1803, y = 1005, w = 113, h = 68 }
    local pie_dst_1 = { x = 1698, y = 1013, w = 98, h = 53 }
    local pie_dst_1_sh = { x = 1691, y = 1005, w = 113, h = 68 }
    local yMultConstant = 8

    -- tick
    for i = 0, 6, 1 do
        helpers.res_mirror({
            src = { x = 1590, y = 860 + yMultConstant * i, w = 13, h = 7 },
            dst = pie_dst_2,
            depth = 3,
            color_key = { input = "#6543CA", output = "#6543CA" },
        }, 0, 0)
        helpers.res_mirror({
            src = { x = 1590, y = 860 + yMultConstant * i, w = 1, h = 1 },
            dst = pie_dst_2_sh,
            depth = 2,
            color_key = { input = "#6543CA", output = "#000000" },
        }, 0, 0)
    end
    -- level
    for i = 0, 6, 1 do
        helpers.res_mirror({
            src = { x = 1590, y = 860 + yMultConstant * i, w = 13, h = 7 },
            dst = pie_dst_2,
            depth = 3,
            color_key = { input = "#63cbc2", output = "#63cbc2" },
        }, 0, 0)
        helpers.res_mirror({
            src = { x = 1590, y = 860 + yMultConstant * i, w = 1, h = 1 },
            dst = pie_dst_2_sh,
            depth = 2,
            color_key = { input = "#63cbc2", output = "#000000" },
        }, 0, 0)
    end
    -- entities
    for i = 0, 6, 1 do
        helpers.res_mirror({
            src = { x = 1590, y = 860 + yMultConstant * i, w = 13, h = 7 },
            dst = pie_dst_2,
            depth = 5,
            color_key = { input = "#e145c2", output = "#e145c2" },
        }, 0, 0)
        helpers.res_mirror({
            src = { x = 1590, y = 860 + yMultConstant * i, w = 1, h = 1 },
            dst = pie_dst_2_sh,
            depth = 4,
            color_key = { input = "#e145c2", output = "#000000" },
        }, 0, 0)
    end
    -- blockEntities
    for i = 0, 6, 1 do
        helpers.res_mirror({
            src = { x = 1590, y = 860 + yMultConstant * i, w = 13, h = 7 },
            dst = pie_dst_2,
            depth = 5,
            color_key = { input = "#c4c46d", output = "#c4c46d" },
        }, 0, 0)
        helpers.res_mirror({
            src = { x = 1590, y = 860 + yMultConstant * i, w = 1, h = 1 },
            dst = pie_dst_2_sh,
            depth = 4,
            color_key = { input = "#c4c46d", output = "#000000" },
        }, 0, 0)
    end

    -- gameRenderer
    for i = 0, 6, 1 do
        helpers.res_mirror({
            src = { x = 1590, y = 860 + yMultConstant * i, w = 13, h = 7 },
            dst = pie_dst_1,
            depth = 5,
            color_key = { input = "#c2cbc2", output = "#c2cbc2" },
        }, 0, 0)
        helpers.res_mirror({
            src = { x = 1590, y = 860 + yMultConstant * i, w = 1, h = 1 },
            dst = pie_dst_1_sh,
            depth = 4,
            color_key = { input = "#c2cbc2", output = "#000000" },
        }, 0, 0)
    end
    -- gameRenderer level
    for i = 0, 6, 1 do
        helpers.res_mirror({
            src = { x = 1590, y = 860 + yMultConstant * i, w = 13, h = 7 },
            dst = pie_dst_1,
            depth = 3,
            color_key = { input = "#63cbc2", output = "#63cbc2" },
        }, 0, 0)
        helpers.res_mirror({
            src = { x = 1590, y = 860 + yMultConstant * i, w = 1, h = 1 },
            dst = pie_dst_1_sh,
            depth = 2,
            color_key = { input = "#63cbc2", output = "#000000" },
        }, 0, 0)
    end
    -- gameRenderer entities
    for i = 0, 6, 1 do
        helpers.res_mirror({
            src = { x = 1590, y = 860 + yMultConstant * i, w = 13, h = 7 },
            dst = pie_dst_1,
            depth = 5,
            color_key = { input = "#e145c2", output = "#e145c2" },
        }, 0, 0)
        helpers.res_mirror({
            src = { x = 1590, y = 860 + yMultConstant * i, w = 1, h = 1 },
            dst = pie_dst_1_sh,
            depth = 4,
            color_key = { input = "#e145c2", output = "#000000" },
        }, 0, 0)
    end
end