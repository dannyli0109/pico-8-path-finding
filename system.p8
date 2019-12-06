pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

graphics_system = {}
graphics_system.update = function()


    for x=1,col do
        for y=1,row do
            if grids then
                local g = grids[x][y]
                local e = g.entity

                if g.dist then

                    rectfill(
                        e.position.x + e.rect.xoff,
                        e.position.y + e.rect.yoff,
                        e.position.x + e.rect.xoff + e.rect.w,
                        e.position.y + e.rect.yoff + e.rect.h,
                        5
                    )
                    --print(g.dist, e.position.x + 1, e.position.y + 2, 10)
                end
            end
        end
    end

     for x=1,col do
        for y=1,row do
            if grids then
                local g = grids[x][y]
                local e = g.entity

                if g.path then

                    rectfill(
                        e.position.x + e.rect.xoff,
                        e.position.y + e.rect.yoff,
                        e.position.x + e.rect.xoff + e.rect.w,
                        e.position.y + e.rect.yoff + e.rect.h,
                        9
                    )
                    --print(g.dist, e.position.x + 1, e.position.y + 2, 10)
                end
            end
        end
    end


    if p1 then
        rectfill(
            p1.entity.position.x,
            p1.entity.position.y,
            p1.entity.position.x + p1.entity.position.w - 1,
            p1.entity.position.y + p1.entity.position.h - 1,
            8
        )
    end

    if p2 then
        rectfill(
            p2.entity.position.x,
            p2.entity.position.y,
            p2.entity.position.x + p2.entity.position.w - 1,
            p2.entity.position.y + p2.entity.position.h - 1,
            12
        )
    end



    for entity in all(entities) do
        if entity.position and entity.rect then

            if entity.wall then
                if entity.wall.directions[1] then
                    line(
                        entity.position.x, 
                        entity.position.y, 
                        entity.position.x, 
                        entity.position.y + entity.position.h-1,
                        7
                    )
                end

                if entity.wall.directions[2] then
                    line(
                        entity.position.x + entity.position.w - 1,
                        entity.position.y, 
                        entity.position.x + entity.position.w - 1, 
                        entity.position.y + entity.position.h - 1,
                        7
                    )
                end

                if entity.wall.directions[3] then
                    line(
                        entity.position.x, 
                        entity.position.y, 
                        entity.position.x + entity.position.w - 1, 
                        entity.position.y,
                        7
                    )
                end

                if entity.wall.directions[4] then
                    line(
                        entity.position.x, 
                        entity.position.y + entity.position.h - 1, 
                        entity.position.x + entity.position.w - 1, 
                        entity.position.y + entity.position.h - 1,
                        7
                    )
                end
            end
        end
    end

    if state == "pause" then
        rectfill(0,0,128-1,64-1,7)
        rectfill(1,1,128-2,64-2,0)
        print("path finding: ", 13, 13, 7) 
        print(path_find_selections[1], 13+ #"path finding: "* 4, 13, 7) 
    end
end
