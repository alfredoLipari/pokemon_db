-- Moves for a specific Pokemon and generation
SELECT 
    m.identifier as move,
    m.type_name as type,
    m.damage_class_id as damage_class,
    v.identifier as game,
    pmm.identifier as method,
    m.power,
    m.accuracy,
    m.pp,
    m.priority
FROM pokemon_info pi
JOIN pokemon_moves pm ON pi.pokemon_id = pm.pokemon_id
JOIN moves m ON pm.move_id = m.id
JOIN pokemon_move_method pmm ON pm.pokemon_move_method_id = pmm.id
JOIN version v ON pm.version_id = v.id
WHERE pi.name = 'raticate'  -- DICE operation: specific Pokemon
  AND v.generation = 'generation_7'  -- DICE operation: specific generation
ORDER BY 
    move,
    game;