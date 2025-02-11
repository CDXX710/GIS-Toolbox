-------------------------------------------------------------
-------------------------------------------------------------
-- Find and locate invalid geometries
-- Justify these invalid geometries in a view
-------------------------------------------------------------
-------------------------------------------------------------
DO $$
DECLARE 
    table_name TEXT := '[TABLE_NAME]';

BEGIN     
	EXECUTE FORMAT('
        CREATE OR REPLACE VIEW wrong_geom AS
        SELECT
            fid,
            ST_IsValid(geom) AS valid_geom,
            -- CHECK GEOMETRY VALIDITY
            ST_IsValidReason(geom) AS valid_details,
            -- JUSTIFY WHY IS THE GEOMETRY INVALID
            LOCATION(st_isvaliddetail(geom)) AS LOCATION
            -- LOCATE THE INVALID GEOMETRY
        FROM %I
        WHERE ST_IsValid(geom) IS FALSE;',
table_name);

EXECUTE FORMAT('SELECT * FROM wrong_geom;');
END $$;



-------------------------------------------------------------
-------------------------------------------------------------
-- Find and locate duped geometries
-------------------------------------------------------------
-------------------------------------------------------------
DO $$
DECLARE 
    table_name TEXT := '[TABLE_NAME]';

BEGIN 
    EXECUTE FORMAT('
        WITH unique_geom (id, geom) AS (
            SELECT ROW_NUMBER() OVER (PARTITION BY ST_asbinary(geom)) AS id, geom
            FROM %I
        )
        SELECT geom FROM unique_geom WHERE id <> 1;',
table_name);
END $$;



-------------------------------------------------------------
-------------------------------------------------------------
-- Find and locate NULL areas
-------------------------------------------------------------
-------------------------------------------------------------
DO $$
DECLARE 
    table_name TEXT := '[TABLE_NAME]';

BEGIN 
    EXECUTE FORMAT('SELECT * FROM %I WHERE ST_Area(geom) = 0;',
table_name);
END $$;



-------------------------------------------------------------
-------------------------------------------------------------
-- Search for differences between a table and another
-------------------------------------------------------------
-------------------------------------------------------------
DO $$
DECLARE 
    table_name TEXT := '[TABLE_NAME]';

BEGIN 
    EXECUTE FORMAT('
        SELECT typezone, ''not in zone_urba_ref'' AS note FROM %I
        EXCEPT
        SELECT typezone, ''not in pertuis_mauvais'' AS note FROM zone_urba;',
table_name);
END $$;



-------------------------------------------------------------
-------------------------------------------------------------
-- Search for differences between tables, back and forth
-------------------------------------------------------------
-------------------------------------------------------------
DO $$
DECLARE 
    table_name TEXT := '[TABLE_NAME]';

BEGIN 
    EXECUTE FORMAT('
        SELECT libelle AS typezone, ''not in zone_urba_ref'' AS comparison FROM %I
        EXCEPT
        SELECT libelle AS typezone, ''not in zone_urba_ref'' AS comparison FROM zone_urba
        UNION
        SELECT libelle AS typezone, ''not in pertuis_mauvais'' AS comparison FROM zone_urba
        EXCEPT
        SELECT libelle AS typezone, ''not in pertuis_mauvais'' AS comparison FROM %I;',
table_name,
table_name);
END $$;



-------------------------------------------------------------
-------------------------------------------------------------
-- Completeness Index Calculations
-- X = 1 - (nb_exceeds + nb_omissions) / nb_ref
-------------------------------------------------------------
-------------------------------------------------------------
DO $$
DECLARE 
    table_name TEXT := '[TABLE_NAME]';

BEGIN 
    EXECUTE FORMAT('
        WITH comparison AS (
            SELECT CASE
                WHEN REF IS NULL THEN ''EXCEEDING''
                -- VALUES IN DATA NOT IN REF
                WHEN DATA IS NULL THEN ''OMISSION''
                -- VALUES IN REF NOT IN DATA 
                ELSE ''OK''
            END AS statut, *
            FROM %I DATA
            FULL JOIN zone_urba REF ON REF.libelle = DATA.libelle
        )
        SELECT
            nb_exceed.value AS "Exceeding",
            nb_omission.value AS "Omission",
            nb_ref.value AS "Reference Value",
            1 - (nb_exceed.value + nb_omission.value)::NUMERIC / nb_ref.value AS "Completeness Index"
        FROM (SELECT COUNT(*) AS value FROM zone_urba) nb_ref
        CROSS JOIN (SELECT COUNT(*) AS value FROM comparison WHERE statut = ''EXCEEDING'') AS nb_exceed
        CROSS JOIN (SELECT COUNT(*) AS value FROM comparison WHERE statut = ''OMISSION'') AS nb_omission;',
table_name);
END $$;
