pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

dir_x = {-1,1,0,0}
dir_y = {0,0,-1,1}
opp = {2,1,4,3}
row = 15
col = 15
state = "playing"
debug = ""
path_find_selections = {"unidirection", "bidirection"}
path_finding_selected = 1
path_finder = {unidir_path_finding, bidir_path_finding}
path_link = {uni_link, bi_link}

function create_grid(w,h,cell_w,cell_h,border_w,border_h)
    grids = {}
    for x=1,w do
        grids[x] = {}
        for y=1,h do
            local grid =  new_entity({
                position = new_position(
                    (128 - (cell_w - 1)* w)/2 + (x - 1) * (cell_w - 1), 
                    (128 - (cell_h - 1)* h)/2 + (y - 1) * (cell_h - 1), 
                    cell_w, 
                    cell_h
                ),
                rect = new_rect(
                    border_w, 
                    border_h, 
                    cell_w - border_w * 2,
                    cell_h - border_h * 2
                ),
                grid = new_grid(
                    x, y
                ),
                wall = new_wall(),
                animation = new_animation(60)
            })

            add(
                entities,
                grid
            )

            add(
                grids[x],
                {
                    entity = grid, 
                    visited = false,
                    dist = nil,
                    color = 0,
                    path = false
                }
            )
        end
    end
end


-----
function _init()
    start()
end

function start()
    p1 = nil
    p2 = nil
    m = nil
    generator = backtracker
    path_finder = bidir_path_finding
    link = bi_link
    cor = cocreate(function()
        entities = {}
        create_grid(
            col, row, 9, 9, 1, 1
        )
        generator()
        path_finding()
        link()
        for i=1,20 do
            yield()
        end

    end)
end

function _update60()
    if state == "playing" then
        if btnp(4) then
            state = "pause"
        end
    elseif state == "pause" then
        if btnp(4) then
            state = "playing"
        end

    end

    if state == "playing" then
        for i=1,1 do
            coresume(cor)
        end
        if(costatus(cor) == "dead") then
            start()
        end
    end
end

function _draw()
    cls(0)
    graphics_system.update()
end


function backtracker()
    local stack = {}
    local rand_x = flr(rnd(col)) + 1
    local rand_y = flr(rnd(row)) + 1
    local current_cell = grids[rand_x][rand_y]
    current_cell.visited = true
    unvisited = filter2d(grids, function(grid) return not grid.visited end)

    while(#unvisited > 0) do
        local unvisited_neighbour = get_unvisited_neighbour(current_cell)
        if #unvisited_neighbour > 0 then
            add(stack, current_cell)
            local rnd_cell = get_rnd(unvisited_neighbour)
            current_cell.entity.wall.directions[rnd_cell.direction] = false
            rnd_cell.entity.wall.directions[opp[rnd_cell.direction]] = false
            rnd_cell.visited = true
            current_cell = rnd_cell
            unvisited = filter2d(grids, function(grid) return not grid.visited end)
           yield()
        else 
            if #stack > 0 then
                local c = stack[#stack]
                current_cell = c
                del(stack, c)
            else
                break
            end
        end
    end
end

function path_finding()
    local rand_x = flr(rnd(col)) + 1
    local rand_y = flr(rnd(row)) + 1
    p1 = grids[rand_x][rand_y]
    local new_rand_x = flr(rnd(col)) + 1
    local new_rand_y = flr(rnd(row)) + 1
    p2 = grids[new_rand_x][new_rand_y]

    --debug = p1.entity.grid.x


    local neighbour = get_neighbour(p1)
    local current = p1

    path_finder(current, p2)
end

function unidir_path_finding(current, target)
    local cand = {}
    local step = 0
    add(cand, current)
    current.dist = 0
    local found_target = false

    repeat
        step += 1
        local cand_new = {}
        for c in all (cand) do
            for i=1,4 do
                local current_x = c.entity.grid.x
                local current_y = c.entity.grid.y
                local neighbour_x = current_x + dir_x[i]
                local neighbour_y = current_y + dir_y[i]
                if neighbour_x > 0 and neighbour_x <= col and neighbour_y > 0 and neighbour_y <= row and not c.entity.wall.directions[i] then
                    if not grids[neighbour_x][neighbour_y].dist then
                        grids[neighbour_x][neighbour_y].dist = step
                        add(cand_new, grids[neighbour_x][neighbour_y])

                        if grids[neighbour_x][neighbour_y] == target then
                            found_target = true
                        end
                    elseif grids[neighbour_x][neighbour_y].dist > step then
                        grids[neighbour_x][neighbour_y].dist = step
                        add(cand_new, grids[neighbour_x][neighbour_y])
                    end
                end
            end
            yield()
        end
        cand=cand_new
    until #cand <= 0 or found_target == true
end

function uni_link(target) 
    local current = target
    --debug = current.dist
    while (current.dist != 0) do
        local best = 9999
        local best_grid = nil
        for i=1,4 do
            local current_x = current.entity.grid.x
            local current_y = current.entity.grid.y
            local neighbour_x = current_x + dir_x[i]
            local neighbour_y = current_y + dir_y[i]
            if 
                neighbour_x > 0 and 
                neighbour_x <= col and 
                neighbour_y > 0 and 
                neighbour_y <= row and 
                not current.entity.wall.directions[i] 
                then
                    if grids[neighbour_x][neighbour_y].dist and not grids[neighbour_x][neighbour_y].path then
                        if best > grids[neighbour_x][neighbour_y].dist then
                            best = grids[neighbour_x][neighbour_y].dist
                            best_grid = grids[neighbour_x][neighbour_y]
                            yield()
                        end
                    end
                end
            end

        if not best_grid then
            break
        else
            best_grid.path = true
            current = best_grid
        end
    end
end 

function bidir_path_finding(current, target)
    local cand_c = {}
    local cand_t = {}
    local step = 0
    add(cand_c, current)
    add(cand_t, target)
    current.dist = 0
    target.dist = 0
    local found_target = false

    repeat
        step += 1
        local cand_new = {}
        for c in all (cand_c) do
            for i=1,4 do
                local current_x = c.entity.grid.x
                local current_y = c.entity.grid.y
                local neighbour_x = current_x + dir_x[i]
                local neighbour_y = current_y + dir_y[i]
                if neighbour_x > 0 and neighbour_x <= col and neighbour_y > 0 and neighbour_y <= row and not c.entity.wall.directions[i] then
                    if not grids[neighbour_x][neighbour_y].dist then
                        grids[neighbour_x][neighbour_y].dist = step
                        add(cand_new, grids[neighbour_x][neighbour_y])
                    elseif grids[neighbour_x][neighbour_y].dist > step then
                        grids[neighbour_x][neighbour_y].dist = step
                        add(cand_new, grids[neighbour_x][neighbour_y])
                    elseif grids[neighbour_x][neighbour_y].dist == step or grids[neighbour_x][neighbour_y].dist == c.dist then
                        found_target = true
                        m = grids[neighbour_x][neighbour_y]
                    end
                end
            end
            yield()
        end
        cand_c=cand_new

        cand_new = {}
        for c in all (cand_t) do
            for i=1,4 do
                local current_x = c.entity.grid.x
                local current_y = c.entity.grid.y
                local neighbour_x = current_x + dir_x[i]
                local neighbour_y = current_y + dir_y[i]
                if neighbour_x > 0 and neighbour_x <= col and neighbour_y > 0 and neighbour_y <= row and not c.entity.wall.directions[i] then
                    if not grids[neighbour_x][neighbour_y].dist then
                        grids[neighbour_x][neighbour_y].dist = step
                        add(cand_new, grids[neighbour_x][neighbour_y])
                    elseif grids[neighbour_x][neighbour_y].dist > step then
                        grids[neighbour_x][neighbour_y].dist = step
                        add(cand_new, grids[neighbour_x][neighbour_y])
                    elseif grids[neighbour_x][neighbour_y].dist == step or grids[neighbour_x][neighbour_y].dist == c.dist then
                        found_target = true
                        m = grids[neighbour_x][neighbour_y]
                    end
                end
            end
            yield()
        end
        cand_t=cand_new

    until (#cand_c <= 0 and #cand_t <= 0) or found_target
end

function bi_link()
    uni_link(m)
    m.path = true
    yield()
    uni_link(m)
end

