pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function map_val(_val, start1, stop1, start2, stop2)
	return (_val - start1) * (stop2 - start2) / (stop1 - start1) + start2
end

function filter2d(arr, func)
    local output = {}
    for i=1,#arr do
        for j=1,#arr[i] do
            if func(arr[i][j]) then
                add(output, arr[i][j])
            end
        end
    end
    return output
end

function get_rnd(arr)
	return arr[1+flr(rnd(#arr))]
end

function get_unvisited_neighbour(current)

    local current_x = current.entity.grid.x
    local current_y = current.entity.grid.y
    local unvisited = {}

    for i=1,4 do
        local neighbour_x = current_x + dir_x[i]
        local neighbour_y = current_y + dir_y[i]

        if grids[neighbour_x] then
            if grids[neighbour_x][neighbour_y] then
                if grids[neighbour_x][neighbour_y].visited == false then
                    grids[neighbour_x][neighbour_y].direction = i
                    add(unvisited, grids[neighbour_x][neighbour_y])
                end
            end
        end
    end

    return unvisited
end


function get_neighbour(current)
    local current_x = current.entity.grid.x
    local current_y = current.entity.grid.y
    local n = {}

    for i=1,4 do
        local neighbour_x = current_x + dir_x[i]
        local neighbour_y = current_y + dir_y[i]
        if neighbour_x > 0 and neighbour_x <= col and neighbour_y > 0 and neighbour_y <= row and not current.entity.wall.directions[i] then
            add(n, grids[neighbour_x][neighbour_y])
        else 
            add(n, false)
        end
    end

    return n
end