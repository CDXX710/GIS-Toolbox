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

SET search_path TO 'public', 'geostandard';





CREATE TYPE geostandard.charenum AS ENUM (
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18'
);



CREATE TYPE geostandard.enum18 AS ENUM (
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '00',
    '99',
    '88'
);




CREATE TYPE geostandard.enum20 AS ENUM (
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '99',
    '00',
    '88'
);





CREATE TYPE geostandard.enum3 AS ENUM (
    '01',
    '02',
    '03',
    '99',
    '00',
    '88'
);




CREATE TYPE geostandard.enum4 AS ENUM (
    '01',
    '02',
    '03',
    '04',
    '00',
    '99',
    '88'
);




CREATE TYPE geostandard.enum5 AS ENUM (
    '01',
    '02',
    '03',
    '04',
    '05',
    '99',
    '00',
    '77',
    '88'
);



CREATE TYPE geostandard.enum6 AS ENUM (
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '99',
    '00',
    '88'
);




CREATE TYPE geostandard.enum7 AS ENUM (
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '99',
    '00',
    '88'
);





CREATE TYPE geostandard.enum8 AS ENUM (
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '99',
    '00',
    '88'
);





CREATE TYPE geostandard.enum98 AS ENUM (
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '98',
    '99',
    '00',
    '88'
);




CREATE TYPE geostandard.liststatutvoie AS ENUM (
    '01',
    '02',
    '03',
    '04',
    '05',
    '06'
);




CREATE TYPE geostandard.listtypeerp AS ENUM (
    'J',
    'L',
    'M',
    'N',
    'O',
    'P',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'PA',
    'SG',
    'PS',
    'GA',
    'OA',
    'REF',
    '99',
    '00'
);




CREATE TYPE geostandard.listtypetroncon AS ENUM (
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '00',
    '88',
    '99'
);




SET default_tablespace = '';

SET default_table_access_method = heap;

-- une fonction pour créer des identifiants
CREATE OR REPLACE FUNCTION geostandard."cnig_id_insee_classe_code_interne"(insee character varying, classe character varying, interne character varying) 
RETURNS character varying  
AS $$
SELECT  format('%s:%s:%s:LOC', $1, $2, $3);
$$ LANGUAGE SQL;


-- Les noeuds

CREATE SEQUENCE IF NOT  EXISTS geostandard."noeud_seq" AS bigint START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

CREATE OR REPLACE FUNCTION geostandard."cnig_id_noeud"(insee character varying, interne character varying)
RETURNS character varying
AS $$ 
SELECT geostandard."cnig_id_insee_classe_code_interne"(insee, 'NOD'::character varying,  interne)
$$ LANGUAGE SQL;


CREATE TABLE geostandard."Noeud" (
    "idNoeud" character varying NOT NULL DEFAULT geostandard.cnig_id_insee_classe_code_interne('xxxxx'::character varying, 'NOD'::character varying, 'CNIG'::character varying  || nextval('geostandard.noeud_seq')::character varying),
    "altitude" real,
    "bandeEveilVigilance" geostandard.enum5,
    "hauteurRessaut" real,
    "abaissePente" integer,
    "abaisseTrottoir" real,
    "controleBEV" geostandard.enum7,
    "bandeInterception" boolean,
    "geom" geometry(Point,4326) NOT NULL,
    
    CONSTRAINT pk_noeud PRIMARY KEY ("idNoeud")
);

-- Les tronçons

CREATE SEQUENCE IF NOT  EXISTS geostandard."troncon_seq" AS bigint START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;

CREATE OR REPLACE FUNCTION geostandard."cnig_id_troncon"(insee character varying, interne character varying)
RETURNS character varying
AS $$ 
SELECT geostandard."cnig_id_insee_classe_code_interne"(insee, 'TRC'::character varying,  interne)
$$ LANGUAGE SQL;


CREATE TABLE geostandard."Troncon_Cheminement" (
    "idTroncon"  character varying NOT NULL DEFAULT geostandard.cnig_id_insee_classe_code_interne('xxxxx'::character varying, 'TRC'::character varying, 'CNIG'::character varying  || nextval('geostandard.noeud_seq')::character varying),
    "from" character varying(255),
    "to" character varying(255),
    "longueur" integer,
    "typeTroncon" geostandard.listtypetroncon,
    "statutVoie" geostandard.enum6,
    "pente" integer,
    "devers" integer,
    "accessibiliteGlobale" geostandard.enum3,
    "geom" geometry(LineString,4326) NOT NULL,
    
    CONSTRAINT pk_troncon PRIMARY KEY ("idTroncon"),
    CONSTRAINT from_fk FOREIGN KEY ("from") REFERENCES geostandard."Noeud"("idNoeud"),
    CONSTRAINT to_fk FOREIGN KEY ("to") REFERENCES geostandard."Noeud"("idNoeud")
);

-- les cheminements
CREATE TABLE geostandard."Cheminement" (
    "idCheminement" character varying(255) NOT NULL,
    "nom" character varying(254),
    
    CONSTRAINT pk_cheminement PRIMARY KEY ("idCheminement")
);


-- un cheminement est composé de plusieurs tronçons, un tronçon peut être présent dans plusieurs cheminements
CREATE TABLE geostandard."Cheminement_Troncon_Cheminement" (
    "idTroncon" character varying(255) NOT NULL,
    "idCheminement" character varying(255) NOT NULL,
    CONSTRAINT troncon_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon"),
    CONSTRAINT cheminement_fk FOREIGN KEY ("idCheminement") REFERENCES geostandard."Cheminement"("idCheminement")
);




-- les différents types de noeuds

CREATE TABLE geostandard."Ascenceur" (
    "idAscenseur" character varying(255) NOT NULL,
    "largeurUtile" real,
    "diamManoeuvreFauteuil" real,
    "largeurCabine" real,
    "longueurCabine" real,
    "boutonsEnRelief" geostandard.enum3,
    "annonceSonore" boolean,
    "signalEtage" geostandard.enum8,
    "boucleInducMagnet" boolean,
    "miroir" boolean,
    "eclairage" integer,
    "voyantAlerte" geostandard.enum4,
    "typeOuverture" geostandard.enum4,
    "mainCourante" geostandard.enum5,
    "hauteurMainCourante" real,
    "etatRevetement" geostandard.enum5,
    "supervision" boolean,
    "autrePorteSortie" geostandard.enum5,
    
    CONSTRAINT pk_ascenseur PRIMARY KEY ("idAscenseur"),
    -- relation correspond à
    "idNoeud" character varying(255) NOT NULL,
    CONSTRAINT noeud_fk FOREIGN KEY ("idNoeud") REFERENCES geostandard."Noeud"("idNoeud")
);


CREATE TABLE geostandard."Elevateur" (
    "idElevateur" character varying(255) NOT NULL,
    "largeurUtile" real,
    "boutonsEnRelief" geostandard.enum3,
    "typeOuverture" geostandard.enum4,
    "largeurPlateforme" real,
    "longueurPlateforme" real,
    "utilisableAutonomie" boolean,
    "etatRevetement" geostandard.enum5,
    "supervision" boolean,
    "autrePorteSortie" geostandard.enum5,
    "chargeMaximum" integer,
    "accompagnateur" geostandard.enum3,
    
    CONSTRAINT pk_elevateur PRIMARY KEY ("idElevateur"),
    -- relation correspond à
    "idNoeud" character varying(255) NOT NULL,
    CONSTRAINT noeud_fk FOREIGN KEY ("idNoeud") REFERENCES geostandard."Noeud"("idNoeud")
);


CREATE TABLE geostandard."Passage_Selectif" (
    "idPassageSelectif" character varying(255) NOT NULL,
    "passageMecanique" boolean,
    "largeurUtile" real,
    "profondeur" real,
    "contrasteVisuel" boolean,
    
    CONSTRAINT pk_passage_selectif PRIMARY KEY ("idPassageSelectif"),
    -- relation correspond à
    "idNoeud" character varying(255) NOT NULL,
    CONSTRAINT noeud_fk FOREIGN KEY ("idNoeud") REFERENCES geostandard."Noeud"("idNoeud")
);

CREATE TABLE geostandard."Entree" (
    "idEntree" character varying(255) NOT NULL,
    "adresse" text,
    "type" geostandard.enum3,
    "rampe" geostandard.enum3,
    "rampeSonnette" boolean DEFAULT false,
    "ascenseur" boolean DEFAULT false,
    "escalierNbMarche" integer DEFAULT 0,
    "escalierMainCourante" boolean DEFAULT false,
    "reperabilite" boolean,
    "reperageEltsVitres" boolean,
    "signaletique" boolean,
    "largeurPassage" real,
    "controleAcces" geostandard.enum5,
    "entreeAccueilVisible" boolean,
    "eclairage" integer,
    "typePorte" geostandard.enum7,
    "typeOuverture" geostandard.enum4,
    "espaceManoeuvre" geostandard.enum4,
    "largManoeuvreExt" real,
    "longManoeuvreExt" real,
    "largManoeuvreInt" real,
    "longManoeuvreInt" real,
    "typePoignee" geostandard.enum7,
    "effortOuverture" integer,
    
    CONSTRAINT pk_entree PRIMARY KEY ("idEntree"),
    -- relation correspond à
    "idNoeud" character varying(255) NOT NULL,
    CONSTRAINT noeud_fk FOREIGN KEY ("idNoeud") REFERENCES geostandard."Noeud"("idNoeud")
);


CREATE TABLE geostandard."Stationnement_PMR" (
    "idStationnement" character varying(255) NOT NULL,
    "typeStationnement" geostandard.enum3,
    "etatRevetement" geostandard.enum5,
    "largeurStat" real,
    "longueurStat" real,
    "bandLatSecurite" boolean,
    "surLongueur" real,
    "signalPMR" boolean,
    "marquageSol" boolean,
    "pente" integer,
    "devers" integer,
    "typeSol" geostandard.enum18,
    
    "idNoeud" character varying(255) NOT NULL,
    CONSTRAINT noeud_fk FOREIGN KEY ("idNoeud") REFERENCES geostandard."Noeud"("idNoeud"),
    CONSTRAINT pk_stationnement PRIMARY KEY ("idStationnement")
);


-- Les types de tronçons


CREATE TABLE geostandard."Circulation" (
    "idCirculation" character varying(255) NOT NULL,
    "typeSol" geostandard.charenum,
    "largeurPassageUtile" real,
    "etatRevetement" geostandard.enum5,
    "eclairage" geostandard.enum3,
    "transition" geostandard.enum4,
    "typePassage" geostandard.enum5,
    "repereLineaire" geostandard.enum6,
    "couvert" geostandard.enum3,
    
    CONSTRAINT pk_circulation PRIMARY KEY ("idCirculation"),
    -- relation est caractérisé par
    "idTroncon" character varying(255) NOT NULL,
    CONSTRAINT cheminement_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon")
);



CREATE TABLE geostandard."Escalator" (
    "idEscalator" character varying(255) NOT NULL,
    "sens" geostandard.enum4,
    "dispositifVigilance" geostandard.enum5,
    "largeurUtile" real,
    "detecteur" boolean,
    "surpervision" boolean,

    CONSTRAINT pk_escalator PRIMARY KEY ("idEscalator"),
    -- relation est 
    "idTroncon" character varying(255) NOT NULL,
    CONSTRAINT cheminement_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon")
);




CREATE TABLE geostandard."Escalier" (
    "idEscalier" character varying(255) NOT NULL,
    "etatRevetement" geostandard.enum5,
    "mainCourante" geostandard.enum5,
    "dispositifVigilance" geostandard.enum5,
    "contrasteVisuel" geostandard.enum5,
    "largeurUtile" real,
    "mainCouranteContinue" geostandard.enum5,
    "prolongMainCourante" geostandard.enum5,
    "nbMarches" integer,
    "nbVoleeMarches" integer,
    "hauteurMarche" real,
    "giron" real,

    CONSTRAINT pk_escalier PRIMARY KEY ("idEscalier"),
    -- relation est 
    "idTroncon" character varying(255) NOT NULL,
    CONSTRAINT troncon_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon")
);



CREATE TABLE geostandard."Quai" (
    "idQuai" character varying(255) NOT NULL,
    "etatRevetement" geostandard.enum5,
    "hauteur" real,
    "largeurPassage" real,
    "signalisationPorte" geostandard.enum8,
    "dispositifVigilance" geostandard.enum5,
    "diamZoneManoeuvre" real,

    CONSTRAINT pk_quai PRIMARY KEY ("idQuai"),
    -- relation est 
    "idTroncon" character varying(255) NOT NULL,
    CONSTRAINT troncon_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon")
);



CREATE TABLE geostandard."Rampe" (
    "idRampe" character varying(255) NOT NULL,
    "etatRevetement" geostandard.enum5,
    "largeurUtile" real,
    "mainCourante" geostandard.enum5,
    "distPalierRepos" real,
    "chasseRoue" geostandard.enum5,
    "aireRotation" geostandard.enum4,
    "poidsSupporte" integer,

    CONSTRAINT pk_rampe PRIMARY KEY ("idRampe"),
    -- relation est 
    "idTroncon" character varying(255) NOT NULL,
    CONSTRAINT troncon_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon")
);


CREATE TABLE geostandard."Tapis_Roulant" (
    "idTapis" character varying(255) NOT NULL,
    "sens" geostandard.enum3,
    "dispositifVigilance" geostandard.enum5,
    "largeurUtile" real,
    "detecteur" boolean,

    CONSTRAINT pk_tapis PRIMARY KEY ("idTapis"),
    -- relation est 
    "idTroncon" character varying(255) NOT NULL,
    CONSTRAINT troncon_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon")
);


CREATE TABLE geostandard."Traversee" (
    "idTraversee" character varying(255) NOT NULL,
    "etatRevetement" geostandard.enum5,
    "marquageSol" geostandard.enum5,
    "eclairage" geostandard.enum3,
    "feuPietons" boolean,
    "aideSonore" geostandard.enum5,
    "repereLineaire" geostandard.enum6,
    "presenceIlot" boolean,
    "chausseeBombee" boolean,
    "covisibilite" geostandard.enum6,

    CONSTRAINT pk_traversee PRIMARY KEY ("idTraversee"),
    -- relation est 
    "idTroncon" character varying(255) NOT NULL,
    CONSTRAINT troncon_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon")
);











-- Les obstacles

CREATE TABLE geostandard."Obstacle" (
    "idObstacle" character varying(255) NOT NULL,
    "typeObstacle" geostandard.enum98,
    "largeurUtile" real,
    "positionObstacle" geostandard.enum3,
    "longueurObstacle" real,
    "rappelObstacle" geostandard.enum3,
    "reperabiliteVisuelle" boolean,
    "largeurObstacle" real,
    "hauteurObsPoseSol" real,
    "hauteurSousObs" real,
    "geom" geometry(Point,4326) NOT NULL,
    
    CONSTRAINT pk_obstacle PRIMARY KEY ("idObstacle"),
    -- relation comporte
    "idTroncon" character varying(255),
    CONSTRAINT troncon_fk FOREIGN KEY ("idTroncon") REFERENCES geostandard."Troncon_Cheminement"("idTroncon")
);






-- Les ERP

CREATE TABLE geostandard."ERP" (
    "idERP" character varying(255) NOT NULL,
    "nom" text,
    "adresse" text,
    "codePostal" character(20),
    "erpCategorie" geostandard.enum5,
    "dataMiseAJour" date,
    "sourceMiseAJour" text,
    "stationnementERP" boolean DEFAULT false,
    "stationnementPMR" integer DEFAULT 0,
    "accueilPersonnel" geostandard.enum3,
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
    "SIRET" character(20),
    "latitude" real,
    "longitude" real,
    "erpActivite" character(20),
    "geom" geometry(MultiPolygon, 4326) NOT NULL,
    "erptype" geostandard.listtypeerp,
    
    CONSTRAINT pk_erp PRIMARY KEY ("idERP")
);


CREATE TABLE geostandard."Cheminement_ERP" (
    "idChemERP" character varying(255) NOT NULL,
    "departChemStat" boolean,
    "arriveeChemAcc" boolean,
    "typeSol" geostandard.charenum,
    "largeurMini" real,
    "hauteurRessault" real DEFAULT 0,
    "rampe" geostandard.enum3,
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
    
    CONSTRAINT pk_cheminement_erp PRIMARY KEY ("idChemERP"),
    -- relation chemine dans
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


