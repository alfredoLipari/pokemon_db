import pandas as pd
from sqlalchemy import create_engine, text

def import_excel(main_excel_path, moves_excel_path):
    # Create database connection
    engine = create_engine('postgresql://pokemon_user:pokemon123@localhost:5432/pokemon_db')
    
    # First, disable triggers to handle foreign key constraints
    with engine.connect() as connection:
        connection.execute(text("SET CONSTRAINTS ALL DEFERRED"))
        
    # Define import order to handle dependencies correctly
    main_tables = [
        'pokemon_info',          # Base table
        'species',               # Base table
        'abilities',             # Base table
        'types',                 # Base table
        'moves_effect',          # Base table
        'moves_target',          # Base table
        'pokemon_move_method',   # Base table
        'regions',               # Base table
        'location',              # Base table
        'version',               # Base table
        'version_group',         # Base table
        'encounter_method',      # Base table
        'types_efficacy',        # Depends on types
        'moves',                 # Depends on moves_effect, moves_target
        'pokemon_abilities',     # Depends on pokemon_info, abilities
        'location_areas',        # Depends on location
        'encounter_slot',        # Depends on encounter_method
        'pokemon_location'       # Depends on pokemon_info, location_areas
    ]
    
    # Read main Excel file
    print(f"Opening main Excel file: {main_excel_path}")
    main_excel_file = pd.ExcelFile(main_excel_path)
    print("Available sheets in main Excel:", main_excel_file.sheet_names)
    
    # First, truncate all tables in reverse order to handle dependencies
    with engine.connect() as connection:
        connection.execute(text("BEGIN"))
        try:
            for table_name in reversed(main_tables + ['pokemon_moves']):
                print(f"Truncating {table_name}...")
                connection.execute(text(f"TRUNCATE TABLE {table_name} CASCADE"))
            connection.execute(text("COMMIT"))
        except Exception as e:
            connection.execute(text("ROLLBACK"))
            print(f"Error during truncate: {str(e)}")
    
    # Import main data
    for table_name in main_tables:
        try:
            if table_name in main_excel_file.sheet_names:
                print(f"Importing {table_name}...")
                df = pd.read_excel(main_excel_file, sheet_name=table_name)
                
                # Special handling for species table
                if table_name == 'species':
                    df['is_legendary'] = df['is_legendary'].astype(bool)
                    df['is_mythical'] = df['is_mythical'].astype(bool)
                
                # Special handling for moves table
                if table_name == 'moves':
                    damage_class_mapping = {'physical': 1, 'special': 2, 'status': 3}
                    if 'damage_class_id' in df.columns:
                        df['damage_class_id'] = df['damage_class_id'].map(damage_class_mapping)
                
                # Convert column names to lowercase
                df.columns = [col.lower() for col in df.columns]
                
                # Import to database
                df.to_sql(table_name, engine, if_exists='append', index=False)
                print(f"Successfully imported {table_name}")
            else:
                print(f"Warning: Sheet '{table_name}' not found in main Excel file")
            
        except Exception as e:
            print(f"Error importing {table_name}: {str(e)}")
    
    # Import pokemon_moves from separate file
    try:
        print(f"\nImporting pokemon_moves from: {moves_excel_path}")
        moves_df = pd.read_excel(moves_excel_path)
        
        # Convert column names to lowercase
        moves_df.columns = [col.lower() for col in moves_df.columns]
        
        # Print column names for verification
        print("Pokemon_moves columns:", moves_df.columns.tolist())
        
        # Import pokemon_moves
        moves_df.to_sql('pokemon_moves', engine, if_exists='append', index=False)
        print("Successfully imported pokemon_moves")
        
    except Exception as e:
        print(f"Error importing pokemon_moves: {str(e)}")
    
    # Re-enable triggers
    with engine.connect() as connection:
        connection.execute(text("SET CONSTRAINTS ALL IMMEDIATE"))

if __name__ == "__main__":
    main_excel_file = "pokemon_info_new.xlsx"  # Your main data file
    moves_excel_file = "pokemon_moves.xlsx"     # Your pokemon moves file
    import_excel(main_excel_file, moves_excel_file)