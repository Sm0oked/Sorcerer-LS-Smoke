local my_utility = require("my_utility/my_utility")

local menu_elements_familiar =
{
    tree_tab           = tree_node:new(1),
    main_boolean       = checkbox:new(true, get_hash(my_utility.plugin_label .. "main_boolean_familiar")),
}

local function menu()
    
    if menu_elements_familiar.tree_tab:push("Familiar") then
        menu_elements_familiar.main_boolean:render("Enable Spell", "")
 
        menu_elements_familiar.tree_tab:pop()
    end
end

local spell_id_familiar = 1627075
local next_time_allowed_cast = 0.0;

local function logics()
    local menu_boolean = menu_elements_familiar.main_boolean:get();
    local is_logic_allowed = my_utility.is_spell_allowed(
                menu_boolean, 
                next_time_allowed_cast, 
                spell_id_familiar);

    if not is_logic_allowed then
        return false;
    end;

    if cast_spell.self(spell_id_familiar, 0.1) then
        local current_time = get_time_since_inject();
        next_time_allowed_cast = current_time + 0.1;
        console.print("Sorcerer Plugin, Casted Familiar");
        return true;
    end;

    return false;
end

return
{
    menu = menu,
    logics = logics,
} 