-- init.sql
-- Complete Pokemon database schema with all tables and constraints

-- Drop all tables if they exist (optional, comment out if not needed)
DROP TABLE IF EXISTS pokemon_moves CASCADE;
DROP TABLE IF EXISTS version_group CASCADE;
DROP TABLE IF EXISTS version CASCADE;
DROP TABLE IF EXISTS encounter_slot CASCADE;
DROP TABLE IF EXISTS pokemon_location CASCADE;
DROP TABLE IF EXISTS encounter_method CASCADE;
DROP TABLE IF EXISTS regions CASCADE;
DROP TABLE IF EXISTS location_areas CASCADE;
DROP TABLE IF EXISTS location CASCADE;
DROP TABLE IF EXISTS pokemon_move_method CASCADE;
DROP TABLE IF EXISTS moves_target CASCADE;
DROP TABLE IF EXISTS moves_effect CASCADE;
DROP TABLE IF EXISTS moves CASCADE;
DROP TABLE IF EXISTS types_efficacy CASCADE;
DROP TABLE IF EXISTS types CASCADE;
DROP TABLE IF EXISTS pokemon_abilities CASCADE;
DROP TABLE IF EXISTS abilities CASCADE;
DROP TABLE IF EXISTS species CASCADE;
DROP TABLE IF EXISTS pokemon_info CASCADE;

-- Create tables in order of dependencies

-- Base tables (no foreign keys)
CREATE TABLE pokemon_info (
    pokemon_id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    species_id INTEGER,
    total_points INTEGER,
    hp INTEGER,
    attack INTEGER,
    defense INTEGER,
    sp_attack INTEGER,
    sp_defense INTEGER,
    speed INTEGER,
    num_of_abilities INTEGER,
    height DECIMAL,
    weight DECIMAL,
    url_image VARCHAR(255),
    pixel_image VARCHAR(255),
    type_1_name VARCHAR(50),
    type_2_name VARCHAR(50)
);

CREATE TABLE species (
    pokedex_id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    is_legendary BOOLEAN,
    is_mythical BOOLEAN,
    egg_group_1 VARCHAR(50),
    egg_group_2 VARCHAR(50),
    catch_rate INTEGER,
    base_friendship INTEGER,
    base_experience INTEGER,
    generation VARCHAR(50)
);

CREATE TABLE abilities (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    flavor_text TEXT,
    short_effect TEXT
);

CREATE TABLE types (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE moves_effect (
    move_effect_id INTEGER PRIMARY KEY,
    short_effect TEXT
);

CREATE TABLE moves_target (
    id INTEGER PRIMARY KEY,
    identifier VARCHAR(100)
);

CREATE TABLE pokemon_move_method (
    id INTEGER PRIMARY KEY,
    identifier VARCHAR(100)
);

CREATE TABLE regions (
    id INTEGER PRIMARY KEY,
    identifier VARCHAR(100)
);

CREATE TABLE encounter_method (
    id INTEGER PRIMARY KEY,
    identifier VARCHAR(100),
    "order" INTEGER
);

CREATE TABLE version (
    id INTEGER PRIMARY KEY,
    identifier VARCHAR(100),
    generation VARCHAR(50)
);

CREATE TABLE version_group (
    id INTEGER PRIMARY KEY,
    identifier VARCHAR(100),
    generation_id INTEGER,
    "order" INTEGER
);

-- Tables with foreign keys
CREATE TABLE pokemon_abilities (
    pokemon_id INTEGER,
    ability_id INTEGER,
    is_hidden INTEGER,
    PRIMARY KEY (pokemon_id, ability_id),
    FOREIGN KEY (pokemon_id) REFERENCES pokemon_info(pokemon_id),
    FOREIGN KEY (ability_id) REFERENCES abilities(id)
);

CREATE TABLE types_efficacy (
    damage_factor INTEGER,
    damage_type_name VARCHAR(50),
    target_type_name VARCHAR(50),
    PRIMARY KEY (damage_type_name, target_type_name)
);

CREATE TABLE moves (
    id INTEGER PRIMARY KEY,
    identifier VARCHAR(100),
    generation_id INTEGER,
    power INTEGER,
    pp INTEGER,
    accuracy INTEGER,
    priority INTEGER,
    target_id INTEGER,
    damage_class_id INTEGER,
    effect_id INTEGER,
    effect_chance INTEGER,
    type_name VARCHAR(50),
    effect TEXT
);

CREATE TABLE location (
    location_id INTEGER PRIMARY KEY,
    name VARCHAR(100),
    region_id INTEGER
);

CREATE TABLE location_areas (
    id INTEGER PRIMARY KEY,
    location_id INTEGER,
    game_index INTEGER,
    identifier VARCHAR(50),
    FOREIGN KEY (location_id) REFERENCES location(location_id)
);

CREATE TABLE pokemon_location (
    id INTEGER PRIMARY KEY,
    version_id INTEGER,
    location_area_id INTEGER,
    encounter_slot_id INTEGER,
    pokemon_id INTEGER,
    min_level INTEGER,
    max_level INTEGER,
    FOREIGN KEY (pokemon_id) REFERENCES pokemon_info(pokemon_id),
    FOREIGN KEY (location_area_id) REFERENCES location_areas(id)
);

CREATE TABLE encounter_slot (
    id INTEGER PRIMARY KEY,
    version_group_id INTEGER,
    encounter_method_id INTEGER,
    slot INTEGER,
    rarity INTEGER,
    FOREIGN KEY (encounter_method_id) REFERENCES encounter_method(id)
);

-- Pokemon Moves table (last because it references multiple tables)
CREATE TABLE pokemon_moves (
    pokemon_id INTEGER,
    version_group_id INTEGER,
    move_id INTEGER,
    pokemon_move_method_id INTEGER,
    level INTEGER,
    FOREIGN KEY (pokemon_id) REFERENCES pokemon_info(pokemon_id),
    FOREIGN KEY (move_id) REFERENCES moves(id),
    FOREIGN KEY (pokemon_move_method_id) REFERENCES pokemon_move_method(id),
    FOREIGN KEY (version_group_id) REFERENCES version_group(id)
);