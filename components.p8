pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

function new_position(x,y,w,h)
    local p = {}
    p.x = x
    p.y = y
    p.w = w
    p.h = h
    return p
end

function new_rect(xoff,yoff,w,h)
    local r = {}
    r.xoff = xoff
    r.yoff = yoff
    r.w = w
    r.h = h
    return r
end

function new_grid(x, y)
    local g = {}
    g.x = x
    g.y = y
    return g
end

function new_wall()
    local w = {}
    w.directions = {
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        true
    }
    return w
end

function new_animation(f)
    local a = {}
    a.frames = f
    a.current_frames = 0
    return a
end

-- function new_control(left, right, up, down, o, x) 
--     local c = {}
--     c.left = left
--     c.right = right
--     c.up = up
--     c.down = down
--     c.o = o
--     c.x = x
--     return c
-- end

-- function new_intention()
--     local i = {}
--     i.left = false
--     i.right = false
--     i.up = false
--     i.down = false
--     i.o = false
--     i.x = false
--     return i
-- end

-- function new_window()

-- end