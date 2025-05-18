local my_utility = require("my_utility/my_utility");

local menu_elements = 
{
    tree_tab              = tree_node:new(1),
    main_boolean          = checkbox:new(true, get_hash(my_utility.plugin_label .. "main_boolean_ball_lightning")),
}

local function menu()
    
    if menu_elements.tree_tab:push("Lightning Ball") then
       menu_elements.main_boolean:render("Enable Spell", "")

       menu_elements.tree_tab:pop()
    end
end

local spell_id_ball = 514030

local ball_spell_data = spell_data:new(
    0.6,           -- radius
    12.0,          -- range
    0.3,           -- cast_delay
    2.5,           -- projectile_speed
    true,          -- has_collision
    spell_id_ball, -- spell_id
    spell_geometry.rectangular, -- geometry_type
    targeting_type.skillshot    -- targeting_type
)

local next_time_allowed_cast = 0.0;
local function get_priority_target(target_selector_data)
    if target_selector_data.has_boss then
        return target_selector_data.closest_boss
    elseif target_selector_data.has_champion then
        return target_selector_data.closest_champion
    elseif target_selector_data.has_elite then
        return target_selector_data.closest_elite
    elseif target_selector_data.closest_unit then
        return target_selector_data.closest_unit
    end
    return nil
end

local function logics(target_selector_data)
    local menu_boolean = menu_elements.main_boolean:get();
    local is_logic_allowed = my_utility.is_spell_allowed(
        menu_boolean,
        next_time_allowed_cast,
        spell_id_ball);

    if not is_logic_allowed then
        return false;
    end;

    local target = get_priority_target(target_selector_data)
    if not target then
        return false;
    end
    local player_position = get_player_position();
    local target_position = target:get_position();

    if cast_spell.target(target, ball_spell_data, false) then
        local current_time = get_time_since_inject();
        next_time_allowed_cast = current_time + 0.01;
        console.print("Sorcerer Plugin, Casted Ball");
        return true;
    end;

    return false;
end

return 
{
    menu = menu,
    logics = logics,   
}