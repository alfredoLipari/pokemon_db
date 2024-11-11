-- Simple pokemon locations query showing where a Pokémon can be found
SELECT 
    r.identifier as region,
    v.identifier as version,
    l.name as location,
    la.identifier as area,
    pl.min_level,
    pl.max_level,
    em.identifier as encounter_method,
    es.rarity || '%' as rarity
FROM pokemon_info pi
-- Join with pokemon_location to get where the pokemon appears
JOIN pokemon_location pl ON pi.pokemon_id = pl.pokemon_id
-- Join with location tables to get the full hierarchy
JOIN location_areas la ON pl.location_area_id = la.id
JOIN location l ON la.location_id = l.location_id
JOIN regions r ON l.region_id = r.id
-- Join with version table to know in which game
JOIN version v ON pl.version_id = v.id
-- Join with encounter tables to get encounter details
JOIN encounter_slot es ON pl.encounter_slot_id = es.id
JOIN encounter_method em ON es.encounter_method_id = em.id
WHERE pi.name = 'raticate'
ORDER BY 
    region,    -- First group by region
    version,   -- Then by version
    location,  -- Then by location
    area;      -- Finally by area