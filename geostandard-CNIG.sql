--
-- PostgreSQL database dump
--
SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

SELECT pg_catalog.set_config('search_path', '', false);

SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE SCHEMA IF NOT EXISTS geostandard;

COMMENT ON SCHEMA geostandard IS 'standard geostandard schema';

SET search_path TO 'geostandard', 'public';

CREATE TYPE geostandard.enum_cat_erp AS ENUM ( '01', '02', '03', '04', '05' );
CREATE TYPE geostandard.enum_ctrl_acces AS ENUM ( '01', '02', '03', '04', '05' );
CREATE TYPE geostandard.enum_ctrl_bev AS ENUM ( '01', '02', '03', '04', '05', '06', '07' );
CREATE TYPE geostandard.enum_cote AS ENUM ( '01', '02', '03', '04', '05', '06' );
CREATE TYPE geostandard.enum_couvert AS ENUM ( '01', '02', '03' );
CREATE TYPE geostandard.enum_disp_signalisat AS ENUM ( '01', '02', '03', '04', '05', '06', '07', '08' );
CREATE TYPE geostandard.enum_eclairage AS ENUM ( '01', '02', '03' );
CREATE TYPE geostandard.enum_etat AS ENUM ( '01', '02', '03', '04', '05' );
CREATE TYPE geostandard.enum_masqueCovisibilite AS ENUM ( '01', '02', '03', '04', '05', '06' );
CREATE TYPE geostandard.enum_pers_erp AS ENUM ( '01', '02', '03' );
CREATE TYPE geostandard.enum_pos_espace AS ENUM ( '01', '02', '03', '04' );
CREATE TYPE geostandard.enum_pos_hauteur AS ENUM ( '01', '02', '03', '04' );
CREATE TYPE geostandard.enum_pos_obstacle AS ENUM ( '01', '02', '03' );
CREATE TYPE geostandard.enum_rappel_obstacle AS ENUM ( '01', '02', '03' );
CREATE TYPE geostandard.enum_rampe_erp AS ENUM ( '01', '02', '03' );
CREATE TYPE geostandard.enum_relief_bouton AS ENUM ( '01', '02', '03' );
CREATE TYPE geostandard.enum_repere_lineaire AS ENUM ( '01', '02', '03', '04', '05', '06' );
CREATE TYPE geostandard.enum_sens AS ENUM ( '01', '02', '03' );
CREATE TYPE geostandard.enum_statut_voie AS ENUM ( '01', '02', '03', '04', '05', '06' );
CREATE TYPE geostandard.enum_temporalite AS ENUM ( '01', '02', '03' );
CREATE TYPE geostandard.enum_transition AS ENUM ( '01', '02', '03', '04' );
CREATE TYPE geostandard.enum_type_passage AS ENUM ( '01', '02', '03', '04', '05' );
CREATE TYPE geostandard.enum_type_poignee AS ENUM ( '01', '02', '03', '04', '05', '06' );
CREATE TYPE geostandard.enum_type_porte AS ENUM ( '01', '02', '03', '04', '05', '06', '07' );
CREATE TYPE geostandard.enum_type_troncon AS ENUM ( '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21' );
CREATE TYPE geostandard.enum_type_entree AS ENUM ( '01', '02', '03' );
CREATE TYPE geostandard.enum_type_erp AS ENUM ( 'J', 'L', 'M', 'N', 'O', 'P', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'PA', 'SG', 'PS', 'GA', 'OA', 'REF' );
CREATE TYPE geostandard.enum_type_obstacle AS ENUM ( '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '98' );
CREATE TYPE geostandard.enum_type_ouverture AS ENUM ( '01', '02', '03', '04' );
CREATE TYPE geostandard.enum_type_stationnement AS ENUM ( '01', '02', '03' );
CREATE TYPE geostandard.enum_type_sol AS ENUM ( '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '98' );
CREATE TYPE geostandard.enum_voyant_ascenseur AS ENUM ( '01', '02', '03', '04' );

SET default_tablespace = '';
SET default_table_access_method = heap;

-- une fonction pour créer des identifiants
CREATE
OR REPLACE FUNCTION geostandard."cnig_id_insee_classe_code_interne"(
    insee character varying(255),
    classe character varying(255),
    interne character varying(255)
) RETURNS character varying(255) AS $$
SELECT
    format('%s:%s:%s:LOC', $ 1, $ 2, $ 3);

$$ LANGUAGE SQL;

-- une séquence pour créer des identifiants
CREATE SEQUENCE IF NOT EXISTS geostandard."noeud_seq" AS bigint START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

CREATE
OR REPLACE FUNCTION geostandard."cnig_id_noeud"(
    insee character varying(255),
    interne character varying(255)
) RETURNS character varying(255) AS $$
SELECT
    geostandard."cnig_id_insee_classe_code_interne"(insee, 'NOD' :: character varying, interne) $$ LANGUAGE SQL;

-- Classe d’objet                   NOEUD_CHEMINEMENT
-- Définition:                      Extrémités d'un tronçon de cheminement
-- Synonymes:                       Extrémité d’un tronçon de cheminement, correspondant par exemple à un embranchement, un changement de propriété de circulation important sur le tronçon, un lieu d’accès à un site ou un équipement.
-- Critères de sélection:           Tous les nœuds nécessaires à la construction du graphe de cheminement. Tout point marquant une rupture remarquable sur le cheminement
-- Primitive graphique:             Ponctuel 3D recommandé. Ponctuel 2D possible mais non recommandé. Les recommandations au sujet de la géométrie sont traitées au paragraphe "Saisie des données"
CREATE TABLE geostandard."Noeud_Cheminement" (
    "idNoeud" character varying(255) NOT NULL DEFAULT geostandard.cnig_id_insee_classe_code_interne(
        'xxxxx' :: character varying(255),
        'NOD' :: character varying(255),
        'CNIG' :: character varying(255) || nextval('geostandard.noeud_seq') :: character varying
    ),
    "altitude" numeric(8, 2),
    "bandeEveilVigilance" geostandard.enum_etat,
    "hauteurRessaut" numeric(8, 2),
    "abaissePente" integer,
    "abaisseLargeur" numeric(8, 2),
    "controleBEV" geostandard.enum_ctrl_bev,
    "bandeInterception" boolean,
    "geom" geometry(Point, 4326) NOT NULL,
    CONSTRAINT pk_noeud PRIMARY KEY ("idNoeud")
);

-- une séquence pour créer des identifiants
CREATE SEQUENCE IF NOT EXISTS geostandard."troncon_seq" AS bigint START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

CREATE
OR REPLACE FUNCTION geostandard."cnig_id_troncon"(
    insee character varying(255),
    interne character varying(255)
) RETURNS character varying(255) AS $$
SELECT
    geostandard."cnig_id_insee_classe_code_interne"(insee, 'TRC' :: character varying, interne) $$ LANGUAGE SQL;

-- Classe d’objet                   TRONCON_CHEMINEMENT
-- Définition:                      Espace ouvert au public dans lequel la personne se déplace. Le tronçon de cheminement réunit des caractéristiques physiques et liées à la circulation PMR - PSH.
-- Synonymes:                       Portion de cheminement, portion d’itinéraire
-- Regroupement:                    Le tronçon de cheminement est homogène dans ses attributs de circulation pour les PMR - PSH. Inversement, un changement de caractéristique de circulation pour les PMR - PSH entraîne une rupture de tronçon et création d’un nouveau tronçon.
-- Critères de sélection:           Tous les tronçons utiles au cheminement des PMR - PSH entre deux points d'intérêt. Dans le cas d'espaces publics ouverts (place, etc.), le choix des tronçons est à déterminer de façon à prendre en compte la multiplicité des cheminements possibles. Si des aménagements existent pour faciliter le déplacement des PMR - PSH (bande de guidage ou aménagement équivalent, revêtement de sol particulièrement adapté...), des tronçons doivent être définis le long de ces aménagements. Sinon, il importe de définir des tronçons logiques par rapport aux cheminements possibles (au minimum, ceux menant aux traversées piétonnes, aux arrêts de transport en commun - accessibles ou non - et aux entrées d'ERP). Les tronçons de cheminement sont collectés suivant l'itinéraire offrant la meilleure accessibilité, en prenant encompte le milieu du trottoir dans le cas général, et le cheminement optimal dans un espace public indéfini. On pourra se reporter au § "Comment définir les cheminements" du guide méthodologique.
-- Primitive graphique:             Linéaire 3D recommandé. Linéaire 2D possible mais non recommandé. Le tronçon de cheminement est un objet orienté de son nœud initial (ou amont) vers son nœud final (ou aval), tel qu'il a été numérisé. Les recommandations au sujet de la géométrie sont traitées au paragraphe "Saisie des données".
-- Contraintes:                     Un changement de caractéristique de circulation pour les PMR - PSH entraîne une rupture de tronçon et création d’un nouveau tronçon : si la nature du cheminement évolue et que l'on souhaite le renseigner au travers d'un changement des attributs portés par le tronçon (par exemple un changement d'éclairage, un changement de pente, etc.), il convient de le "couper" à l'endroit où l'on souhaite faire apparaître les nouvelles informations. Il n'y a pas de limite minimale à la taille d’un tronçon, mais il est recommandé de ne pas trop les subdiviser (donc de ne pas les faire trop petits) pour éviter de surcharger l'utilisateur en information et pour limiter le volume d'informations à collecter et à gérer. Un guide méthodologique précise ces notions et fournit des conseils concernant la collecte des données.
-- Remarque:                        Les attributs qui dépendent du sens de circulation sont renseignés en considérant le parcours du NOEUD_CHEMINEMENT initial vers le NOEUD_CHEMINEMENT final.
CREATE TABLE geostandard."Troncon_Cheminement" (
    "idTroncon" character varying(255) NOT NULL DEFAULT geostandard.cnig_id_insee_classe_code_interne(
        'xxxxx' :: character varying(255),
        'TRC' :: character varying(255),
        'CNIG' :: character varying(255) || nextval('geostandard.noeud_seq') :: character varying
    ),
    "from" character varying(255),
    "to" character varying(255),
    "longueur" integer,
    "typeTroncon" geostandard.enum_type_troncon,
    "statutVoie" geostandard.enum_statut_voie,
    "pente" integer,
    "devers" integer,
    "geom" geometry(LineString, 4326) NOT NULL,
    CONSTRAINT pk_troncon PRIMARY KEY ("idTroncon"),
    CONSTRAINT from_fk FOREIGN KEY ("from") REFERENCES geostandard."Noeud_Cheminement"("idNoeud"),
    CONSTRAINT to_fk FOREIGN KEY ("to") REFERENCES geostandard."Noeud_Cheminement"("idNoeud")
);

-- Classe d’objet                   CHEMINEMENT
-- Définition:                      Cheminement d’une personne
-- Synonymes:                       Itinéraire entre deux points. Séquence de tronçons. Au sens du présent standard, le cheminement est une séquence de tronçons (soit : PATH LINK IN SEQUENCE dans NeTEx).
-- Primitive graphique:             Aucune
-- Modélisation géométrique:        Sans objet. La géométrie d'un cheminement peut être reconstituée à partir des géométries ordonnées des tronçons le constituant
CREATE TABLE geostandard."Cheminement" (
    "idCheminement" character varying(255) NOT NULL,
    "libelle" character varying(254),
    CONSTRAINT pk_cheminement PRIMARY KEY ("idCheminement")
);

-- Relation:                        Est composé de
-- Définition:                      Relation d’association entre le cheminement et les tronçons qui le composent
-- Cardinalité:                     CHEMINEMENT (0,m) – TRONCON_CHEMINEMENT (1,n). Un cheminement est composé de plusieurs tronçons. Un tronçon de cheminement peut appartenir à aucun, un ou plusieurs cheminements.
-- Remarque:                        Cette relation dresse la liste des tronçons de cheminement concernés par les cheminements
CREATE TABLE geostandard."Cheminement_Troncon_Cheminement" (
    "idTroncon" character varying(255) NOT NULL,
    "idCheminement" character varying(255) NOT NULL,
    CONSTRAINT troncon_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon"),
    CONSTRAINT cheminement_fk FOREIGN KEY ("idCheminement") REFERENCES geostandard."Cheminement"("idCheminement")
);

-- Classe d’objet:                  ASCENSEUR                 
-- Primitive graphique:             Aucune car la géométrie est portée par le(s) nœud(s) superposés
CREATE TABLE geostandard."Ascenceur" (
    "idAscenseur" character varying(255) NOT NULL,
    "largeurUtile" numeric(8,2),
    "diamManoeuvreFauteuil" numeric(8,2),
    "largeurCabine" numeric(8,2),
    "longueurCabine" numeric(8,2),
    "boutonsEnRelief" geostandard.enum_relief_bouton,
    "annonceSonore" boolean,
    "signalEtage" geostandard.enum_disp_signalisat,
    "boucleInducMagnet" boolean,
    "miroir" boolean,
    "eclairage" integer,
    "voyantAlerte" geostandard.enum_voyant_ascenseur,
    "typeOuverture" geostandard.enum_type_ouverture,
    "mainCourante" geostandard.enum_cote,
    "hauteurMainCourante" real,
    "etatRevetement" geostandard.enum_etat,
    "supervision" boolean,
    "autrePorteSortie" geostandard.enum_cote,
    -- Relation     correspond à
    CONSTRAINT pk_ascenseur PRIMARY KEY ("idAscenseur"),
    "idNoeud" character varying(255) NOT NULL,
    CONSTRAINT noeud_fk FOREIGN KEY ("idNoeud") REFERENCES geostandard."Noeud_Cheminement"("idNoeud")
);

-- Classe d’objet:                  ELEVATEUR
-- Définition:                      Système de franchissement d'une dénivellation muni d'une plate-forme ou d'une nacelle.
-- Primitive graphique:             Aucune car la géométrie est portée par le(s) nœud(s)
CREATE TABLE geostandard."Elevateur" (
    "idElevateur" character varying(255) NOT NULL,
    "largeurUtile" real,
    "boutonsEnRelief" geostandard.enum_relief_bouton,
    "typeOuverture" geostandard.enum_type_ouverture,
    "largeurPlateforme" real,
    "longueurPlateforme" real,
    "utilisableAutonomie" boolean,
    "etatRevetement" geostandard.enum_etat,
    "supervision" boolean,
    "autrePorteSortie" geostandard.enum_cote,
    "chargeMaximum" integer,
    "accompagnateur" geostandard.enum_temporalite,
    -- Relation     correspond à
    CONSTRAINT pk_elevateur PRIMARY KEY ("idElevateur"),
    "idNoeud" character varying(255) NOT NULL,
    CONSTRAINT noeud_fk FOREIGN KEY ("idNoeud") REFERENCES geostandard."Noeud_Cheminement"("idNoeud")
);

--Classe d’objet:                   PASSAGE_SELECTIF
--Définition:                       Dispositif permettant le passage des piétons, mais dissuadant celui des cycles et des engins motorisés
--Synonyme:                         Passage sélectif ou "chicane"
--Primitive graphique:              Aucune car la géométrie est portée par le nœud
CREATE TABLE geostandard."Passage_Selectif" (
    "idPassageSelectif" character varying(255) NOT NULL,
    "passageMecanique" boolean,
    "largeurUtile" real,
    "profondeur" real,
    "contrasteVisuel" boolean,
    -- Relation     correspond à
    CONSTRAINT pk_passage_selectif PRIMARY KEY ("idPassageSelectif"),
    "idNoeud" character varying(255) NOT NULL,
    CONSTRAINT noeud_fk FOREIGN KEY ("idNoeud") REFERENCES geostandard."Noeud_Cheminement"("idNoeud")
);

-- Classe d’objet:                  ENTREE
-- Définition:                      Ouverture permettant le passage
-- Sélection:                       Cette classe contient entre autres les entrées de site et les entrées de bâtiments hébergeant un ERP
-- Primitive graphique:             Aucune car la géométrie est portée par le noeud
CREATE TABLE geostandard."Entree" (
    "idEntree" character varying(255) NOT NULL,
    "adresse" text,
    "type" geostandard.enum_type_entree,
    "rampe" geostandard.enum_rampe_erp,
    "rampeSonnette" boolean DEFAULT false,
    "ascenseur" boolean DEFAULT false,
    "escalierNbMarche" integer DEFAULT 0,
    "escalierMainCourante" boolean DEFAULT false,
    "reperabilite" boolean,
    "reperageEltsVitres" boolean,
    "signaletique" boolean,
    "largeurPassage" real,
    "controleAcces" geostandard.enum_ctrl_acces,
    "entreeAccueilVisible" boolean,
    "eclairage" integer,
    "typePorte" geostandard.enum_type_porte,
    "typeOuverture" geostandard.enum_type_ouverture,
    "espaceManoeuvre" geostandard.enum_pos_espace,
    "largManoeuvreExt" real,
    "longManoeuvreExt" real,
    "largManoeuvreInt" real,
    "longManoeuvreInt" real,
    "typePoignee" geostandard.enum_type_poignee,
    "effortOuverture" integer,
    -- Relation     correspond à
    CONSTRAINT pk_entree PRIMARY KEY ("idEntree"),
    "idNoeud" character varying(255) NOT NULL,
    CONSTRAINT noeud_fk FOREIGN KEY ("idNoeud") REFERENCES geostandard."Noeud_Cheminement"("idNoeud")
);

-- Classe d’objet:                  STATIONNEMENT_PMR
-- Définition:                      Place de stationnement de véhicule sur voirie, réservée aux personnes à mobilité réduite
-- Regroupement:                    Aucun. Un objet Stationnement PMR correspond à une place de stationnement et une seule
-- Critères de sélection:           Uniquement les stationnements réservés aux PMR sur voirie. Les parkings en ouvrage ne sont pas concernés.
-- Primitive graphique:             Ponctuelle, en prenant le centre du stationnement comme point de référence.
-- Remarque:                        L'accès du graphe de cheminement à la place de stationnement (et réciproquement) est défini par la relation : NOEUD_CHEMINEMENT permet d'accéder à STATIONNE
CREATE TABLE geostandard."Stationnement_PMR" (
    "idStationnement" character varying(255) NOT NULL,
    "typeStationnement" geostandard.enum_type_stationnement,
    "etatRevetement" geostandard.enum_etat,
    "largeurStat" real,
    "longueurStat" real,
    "bandLatSecurite" boolean,
    "surLongueur" real,
    "signalPMR" boolean,
    "marquageSol" boolean,
    "pente" integer,
    "devers" integer,
    "typeSol" geostandard.enum_type_sol,
    -- Relation:    donne accès à
    -- Définition:                      Relation permettant de lier le nœud de cheminement au stationnement PMR auquel il permet d'accéder.
    -- Cardinalité:                     NOEUD_CHEMINEMENT (1,n) correspond à STATIONNEMENT_PMR (0,n). Un nœud de cheminement permet d'accéder à aucun, un ou plusieurs stationnement(s) PMR. Un stationnement PMR est accessible par un ou plusieurs nœuds de cheminement.
    "idNoeud" character varying(255) NOT NULL,
    CONSTRAINT noeud_fk FOREIGN KEY ("idNoeud") REFERENCES geostandard."Noeud_Cheminement"("idNoeud"),
    CONSTRAINT pk_stationnement PRIMARY KEY ("idStationnement")
);

-- Classe d’objet:                  CIRCULATION
-- Définition:                      Cheminement "standard" sur une surface régulière, sans équipement d'accès. Par exemple un cheminement sur un trottoir, une place, une aire piétonne,etc.
-- Synonymes:                       Circulation "normale" "standard", sur une surface régulière 
-- Critères de sélection:           Cheminement sur un trottoir, sur une place.
-- Primitive graphique:             Aucune car la géométrie est portée par le tronçon
-- Remarque:                        Les attributs qui dépendent du sens de circulation sont renseignés en considérant le parcours du NOEUD_CHEMINEMENT initial vers le NOEUD_CHEMINEMENT final.
CREATE TABLE geostandard."Circulation" (
    "idCirculation" character varying(255) NOT NULL,
    "typeSol" geostandard.enum_type_sol,
    "largeurPassageUtile" real,
    "etatRevetement" geostandard.enum_etat,
    "eclairage" geostandard.enum_eclairage,
    "transition" geostandard.enum_transition,
    "typePassage" geostandard.enum_type_passage,
    "repereLineaire" geostandard.enum_repere_lineaire,
    "couvert" geostandard.enum_couvert,
    -- Relation:    est caractérisé par
    CONSTRAINT pk_circulation PRIMARY KEY ("idCirculation"),
    "idTroncon" character varying(255) NOT NULL,
    CONSTRAINT cheminement_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon")
);

-- Classe d’objet:                  ESCALATOR
-- Définition:                      Escalier mécanique
-- Primitive graphique:             Aucune car la géométrie est portée par le tronçon
CREATE TABLE geostandard."Escalator" (
    "idEscalator" character varying(255) NOT NULL,
    "sens" geostandard.enum_sens,
    "dispositifVigilance" geostandard.enum_etat,
    "largeurUtile" real,
    "detecteur" boolean,
    "supervision" boolean,
    -- Relation:    est
    CONSTRAINT pk_escalator PRIMARY KEY ("idEscalator"),
    "idTroncon" character varying(255) NOT NULL,
    CONSTRAINT cheminement_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon")
);

-- Classe d’objet:                  ESCALIER
-- Définition:                      Ouvrage permettant de monter ou de descendre, constitué d’une succession de marches.
-- Primitive graphique:             Aucune car la géométrie est portée par le tronçon
CREATE TABLE geostandard."Escalier" (
    "idEscalier" character varying(255) NOT NULL,
    "etatRevetement" geostandard.enum_etat,
    "mainCourante" geostandard.enum_cote,
    "dispositifVigilance" geostandard.enum_etat,
    "contrasteVisuel" geostandard.enum_etat,
    "largeurUtile" real,
    "mainCouranteContinue" geostandard.enum_cote,
    "prolongMainCourante" geostandard.enum_cote,
    "nbMarches" integer,
    "nbVoleeMarches" integer,
    "hauteurMarche" real,
    "giron" real,
    -- Relation     est
    CONSTRAINT pk_escalier PRIMARY KEY ("idEscalier"),
    "idTroncon" character varying(255) NOT NULL,
    CONSTRAINT troncon_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon")
);

-- Classe d’objet:                  QUAI
-- Définition:                      Équipement d'un mode de transport permettant un accès au véhicule
-- Primitive graphique:             Aucune car la géométrie est portée par le tronçon
CREATE TABLE geostandard."Quai" (
    "idQuai" character varying(255) NOT NULL,
    "etatRevetement" geostandard.enum_etat,
    "hauteur" real,
    "largeurPassage" real,
    "signalisationPorte" geostandard.enum_disp_signalisat,
    "dispositifVigilance" geostandard.enum_etat,
    "diamZoneManoeuvre" real,
    -- Relation     est
    CONSTRAINT pk_quai PRIMARY KEY ("idQuai"),
    "idTroncon" character varying(255) NOT NULL,
    CONSTRAINT troncon_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon")
);

-- Classe d’objet:                  RAMPE
-- Définition:                      Rampe d'accès. Structure en pente permettant de franchir une dénivellation ou un changement de niveau ou d'étage.
-- Critères de sélection:           On ne retient que les rampes d'accès fixes, pas les rampes amovibles
-- Primitive graphique:             Aucune car la géométrie est portée par le tronçon
CREATE TABLE geostandard."Rampe" (
    "idRampe" character varying(255) NOT NULL,
    "etatRevetement" geostandard.enum_etat,
    "largeurUtile" real,
    "mainCourante" geostandard.enum_cote,
    "distPalierRepos" real,
    "chasseRoue" geostandard.enum_cote,
    "aireRotation" geostandard.enum_pos_hauteur,
    "poidsSupporte" integer,
    -- Relation     est
    CONSTRAINT pk_rampe PRIMARY KEY ("idRampe"),
    "idTroncon" character varying(255) NOT NULL,
    CONSTRAINT troncon_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon")
);

-- Classe d’objet:                  TAPIS_ROULANT
-- Définition:                      Surface plane animée d'un mouvement de translation, servant à transporter des personnes
-- Primitive graphique:             Aucune car la géométrie est portée par le tronçon
CREATE TABLE geostandard."Tapis_Roulant" (
    "idTapis" character varying(255) NOT NULL,
    "sens" geostandard.enum_sens,
    "dispositifVigilance" geostandard.enum_etat,
    "largeurUtile" real,
    "detecteur" boolean,
    -- Relation     est
    CONSTRAINT pk_tapis PRIMARY KEY ("idTapis"),
    "idTroncon" character varying(255) NOT NULL,
    CONSTRAINT troncon_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon")
);

-- Classe d’objet:                  TRAVERSEE
-- Définition:                      Toute zone balisée permettant aux piétons de franchir à niveau les voies réservées à la circulation routière, cycliste ou de transports en commun.
-- Synonymes:                       Passage piéton le plus souvent, mais pas uniquement
-- Critères de sélection:           Passage piéton, traversées suggérées de tramway, de busway, passage ferré, ou traversée de piste cyclable
-- Primitive graphique:             Aucune car la géométrie est portée par le tronçon
-- Remarques:                       Cette classe d’objet comprend notamment les passages piétons
CREATE TABLE geostandard."Traversee" (
    "idTraversee" character varying(255) NOT NULL,
    "etatRevetement" geostandard.enum_etat,
    "marquageSol" geostandard.enum_etat,
    "eclairage" geostandard.enum_eclairage,
    "feuPietons" boolean,
    "aideSonore" geostandard.enum_etat,
    "repereLineaire" geostandard.enum_repere_lineaire,
    "presenceIlot" boolean,
    "chausseeBombee" boolean,
    "covisibilite" geostandard.enum_masqueCovisibilite,
    -- Relation     est
    CONSTRAINT pk_traversee PRIMARY KEY ("idTraversee"),
    "idTroncon" character varying(255) NOT NULL,
    CONSTRAINT troncon_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon")
);

-- Classe d’objet:                  OBSTACLE
-- Définition:                      Élément situé sur le cheminement pouvant gêner voire empêcher la circulation
-- Primitive graphique:             Ponctuel 3D recommandé. Ponctuel 2D possible mais non recommandé. Les recommandations au sujet de la géométrie sont traitées au paragraphe "Saisie des données".
-- Remarque:                        Lorsque la longueur de l'obstacle est supérieure à 3 mètres, on le traitera en tronçon de cheminement circulation en renseignant la largeur de passage utile.
CREATE TABLE geostandard."Obstacle" (
    "idObstacle" character varying(255) NOT NULL,
    "typeObstacle" geostandard.enum_type_obstacle,
    "largeurUtile" real,
    "positionObstacle" geostandard.enum_pos_obstacle,
    "longueurObstacle" real,
    "rappelObstacle" geostandard.enum_rappel_obstacle,
    "reperabiliteVisuelle" boolean,
    "largeurObstacle" real,
    "hauteurObsPoseSol" real,
    "hauteurSousObs" real,
    "geom" geometry(Point, 4326) NOT NULL,
    -- Relation     est
    CONSTRAINT pk_obstacle PRIMARY KEY ("idObstacle"),
    "idTroncon" character varying(255),
    CONSTRAINT troncon_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon")
);

-- Classe d’objet:                  ERP
-- Définition:                      Établissement recevant du public ou installation ouverte au public (IOP)
-- Primitive graphique:             Surfacique
CREATE TABLE geostandard."ERP" (
    "idERP" character varying(255) NOT NULL,
    "nom" text,
    "adresse" text,
    "codePostal" character(20),
    "erpCategorie" geostandard.enum_cat_erp,
    "erpType" geostandard.enum_type_erp,
    "dataMiseAJour" date,
    "sourceMiseAJour" text,
    "stationnementERP" boolean DEFAULT false,
    "stationnementPMR" integer DEFAULT 0,
    "accueilPersonnel" geostandard.enum_pers_erp,
    "accueilBIM" boolean,
    "accueilBIMPortative" boolean,
    "accueilSF" boolean,
    "accueilST" boolean,
    "accueilAideAudition" boolean,
    "accueilPrestations" text,
    "sanitaireERP" boolean DEFAULT false,
    "sanitairesAdaptes" integer DEFAULT 0,
    "telephone" character(20),
    "siteWeb" character varying(255),
    "siret" character(20),
    "latitude" real,
    "longitude" real,
    "erpActivite" character(20),
    "geom" geometry(MultiPolygon, 4326) NOT NULL,
    CONSTRAINT pk_erp PRIMARY KEY ("idERP")
);

-- Classe d’objet:                  CHEMINEMENT_ERP
-- Définition:                      Cheminement piéton à l’intérieur du site d'un ERP, dont le point de départ est une entrée ou une place de stationnement PMR, et le point d'arrivée est une entrée ou l'accueil de l'ERP. Il s'agit de cheminements décrits uniquement par des attributs, c'est à dire sans description géométrique des tronçons de cheminement car le présent standard "s'arrête" à l'entrée des ERP sans décrire géométriquement les cheminements intérieurs au cadre bâti. Des ERP de grande emprise qui disposent de voirie intérieure pourront cependant supporter une description du cheminement identique à celle adoptée dans le domaine voirie / espace public.
-- Critères de sélection:           On sélectionne en particulier le cheminement identifié comme "le plus pratique / le plus facile d'accès". Il peut y avoir plusieurs cheminements : pour un type de handicap, ou pour différents types de handicap.
-- Remarque:                        On ne crée par d'objet "Cheminement_ERP" lorsque l'accueil est juste derrière l'entrée.
-- Primitive graphique:             Aucune. Contrairement à la partie "Voirie", il s'agit d'un cheminement "logique" non porté par des tronçons géométriques. Pour une description détaillée du cheminement à l'intérieur du cadre bâti on se conformera à la modélisation de NeTEx profil accessibilité.
CREATE TABLE geostandard."Cheminement_ERP" (
    "idChemERP" character varying(255) NOT NULL,
    "departChemStat" boolean,
    "arriveeChemAcc" boolean,
    "typeSol" geostandard.enum_type_sol,
    "largeurMini" real,
    "hauteurRessault" real DEFAULT 0,
    "rampe" geostandard.enum_rampe_erp,
    "rampeSonnette" boolean DEFAULT false,
    "ascenceur" boolean DEFAULT false,
    "escalierNbMarche" integer DEFAULT 0,
    "escalierMainCourante" boolean DEFAULT false,
    "escalierDescendant" integer,
    "penteCourte" real,
    "penteMoyenne" real,
    "penteLongue" real,
    "devers" integer,
    "reperageEltsVitres" boolean,
    "sysGuidVisuel" boolean,
    "sysGuidTactile" boolean,
    "sysGuidSonore" boolean,
    "exterieur" boolean,
    -- Relation     chemine dans
    CONSTRAINT pk_cheminement_erp PRIMARY KEY ("idChemERP"),
    "idERP" character varying(255) NOT NULL,
    CONSTRAINT troncon_fk FOREIGN KEY ("idERP") REFERENCES geostandard."ERP"("idERP")
);

-- une entrée peut correspondre à plusieurs ERP, et réciproquement
CREATE TABLE geostandard."Entree_ERP" (
    "idEntree" character varying(255) NOT NULL,
    "idERP" character varying(255) NOT NULL,
    CONSTRAINT erp_fk FOREIGN KEY ("idERP") REFERENCES geostandard."ERP"("idERP"),
    CONSTRAINT entree_fk FOREIGN KEY ("idEntree") REFERENCES geostandard."Entree"("idEntree")
);
