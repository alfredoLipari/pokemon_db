-- type_stats.sql

-- Drill Across operation: combining types with Pokémon info
WITH pokemon_types AS (
    -- Get type 1 distributions
    SELECT 
        pokemon_id,
        type_1_name AS type_name,
        species_id
    FROM pokemon_info
    WHERE type_1_name IS NOT NULL
    
    UNION ALL
    
)
SELECT 
    type_name,
    COUNT(CASE WHEN NOT s.is_legendary AND NOT s.is_mythical THEN 1 END) as normal_count,
    COUNT(CASE WHEN s.is_legendary THEN 1 END) as legendary_count,
    COUNT(CASE WHEN s.is_mythical THEN 1 END) as mythical_count
FROM pokemon_types pt
JOIN species s ON pt.species_id = s.pokedex_id
GROUP BY type_name
ORDER BY type_name;