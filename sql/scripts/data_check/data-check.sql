-------------------------------------------------------------
-------------------------------------------------------------
-- Trouver et localiser des invalidités géométriques
-- Justifier ces invalidités au sein d'une vue
-------------------------------------------------------------
-------------------------------------------------------------
CREATE OR REPLACE
VIEW wrong_geom AS
SELECT
	fid,
	ST_IsValid(geom) AS valid_geom,
	-- CHECK GEOMETRY VALIDITY
	ST_IsValidReason(geom) AS valid_details,
	-- JUSTIFY WHY IS THE GEOMETRY INVALID
	LOCATION(st_isvaliddetail(geom)) AS LOCATION
	-- LOCATE THE INVALID GEOMETRY
FROM
	pertuis_mauvais
WHERE
	ST_IsValid(geom) IS FALSE;

SELECT
	*
FROM
	wrong_geom;




-------------------------------------------------------------
-------------------------------------------------------------
-- Trouver et localiser des doublons géométriques
-------------------------------------------------------------
-------------------------------------------------------------
WITH unique_geom (id,
geom) AS(
SELECT
		ROW_NUMBER() OVER (PARTITION BY ST_asbinary(geom)) AS id,
	geom
FROM
	pertuis_mauvais
)
SELECT
	geom
FROM
	unique_geom
WHERE
	id <> 1;




-------------------------------------------------------------
-------------------------------------------------------------
-- Trouver et localiser des surfaces vides
-------------------------------------------------------------
-------------------------------------------------------------
SELECT
	*
FROM
	pertuis_mauvais
WHERE
	ST_area(geom) = 0;




-------------------------------------------------------------
-------------------------------------------------------------
-- Rechercher des différences de tables
-------------------------------------------------------------
-------------------------------------------------------------
SELECT
	typezone ,
	'not in zone_urba_ref' AS note
FROM
	pertuis_mauvais
EXCEPT
SELECT
	typezone ,
	'not in pertuis_mauvais' AS note
FROM
	zone_urba;




-------------------------------------------------------------
-------------------------------------------------------------
-- Rechercher des différences de tables et vice-versa
-------------------------------------------------------------
-------------------------------------------------------------
SELECT
	libelle AS typezone,
	'not in zone_urba_ref' AS comparison
FROM
	pertuis_mauvais
EXCEPT
	SELECT
	libelle AS typezone,
	'not in zone_urba_ref' AS comparison
FROM
	zone_urba
UNION
SELECT
	libelle AS typezone,
	'not in pertuis_mauvais' AS comparison
FROM
	zone_urba
EXCEPT
	SELECT
	libelle AS typezone,
	'not in pertuis_mauvais' AS comparison
FROM
	pertuis_mauvais;




-------------------------------------------------------------
-------------------------------------------------------------
-- Calcul du taux d'exhaustivité
-- X = 1 - (nb_excédents + nb_ommissions) / nb_référentiel
-------------------------------------------------------------
-------------------------------------------------------------
WITH comparison AS (
SELECT
	CASE
		WHEN REF IS NULL THEN 'EXCEEDING'
		-- VALUES IN DATA NOT IN REF
		WHEN DATA IS NULL THEN 'OMISSION'
		-- VALUES IN REF NOT IN DATA 
		ELSE 'OK'
	END AS statut,
	*
FROM
	pertuis_mauvais DATA
FULL JOIN zone_urba REF
	-- IMPORTANT JOIN OTHERWISE WON'T WORK
    ON
	REF.libelle = DATA.libelle
)
SELECT
	nb_exceed.value AS "Exceeding",
	nb_omission.value AS "Omission",
	nb_ref.value AS "Reference Value",
	1 - (nb_exceed.value + nb_omission.value)::NUMERIC / nb_ref.value AS "Completeness Index"
FROM
	(
	SELECT
		COUNT(*) AS value
	FROM
		zone_urba) nb_ref
CROSS JOIN (
	SELECT
		COUNT(*) AS value
	FROM
		comparison
	WHERE
		statut = 'EXCEEDING') AS nb_exceed
CROSS JOIN (
	SELECT
		COUNT(*) AS value
	FROM
		comparison
	WHERE
		statut = 'OMISSION') AS nb_omission;