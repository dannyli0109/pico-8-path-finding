pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
function new_entity(component_table)
    local e = {}
    e.position = component_table.position or nil
    e.rect = component_table.rect or nil
    e.grid = component_table.grid or nil
    e.wall = component_table.wall or nil
    e.animation = component_table.animation or nil
    return e
end