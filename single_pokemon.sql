-- pokemon_stats_slice.sql

-- SLICE operation: selecting a single Pokémon with all its stats
SELECT 
    pi.name,
    pi.hp as "Hp",
    pi.attack as "Attack",
    pi.defense as "Defense",
    pi.sp_attack as "Sp Attack",
    pi.sp_defense as "Sp Defense",
    pi.speed as "Speed",
    pi.total_points as "Total",
    -- Additional information
    pi.type_1_name as type_1,
    pi.type_2_name as type_2
FROM pokemon_info pi
JOIN species s ON pi.species_id = s.pokedex_id
WHERE pi.name = 'raticate';  -- SLICE operation: selecting specific Pokémon