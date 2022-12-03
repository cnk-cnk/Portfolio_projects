
--- Exploration des données d'accidents corporels de la circulation routière 2021 en France
--- Ces tables : "Caracteristique, Lieu, Vehicule, Usager" viennent du site data.gouv.fr

--------------------------------------------------------------------------------------------------------------------

-- A: cette partie est pour la préparation des données aux requete d'analyses. Nous allons récupérers les données, vérifier les types de colonnes, vérifier les doublons, vérifiers les valeurs nulles.
-- Table carcateristique

--- 1: Récupérer les donnés de la table 
 SELECT * FROM ['carcteristiques-2021$']  

--- 2: Changer le type de la colonne Hrmn 

---Note: après le select, nous nous rendons compte que la colonne Hrmn a un type de donnée "datetime" au lieu de heure:minutes comme dans le fichier EXCEL que nous avons importer, il faut changer le type de la colonne

ALTER TABLE ['carcteristiques-2021$']
ALTER COLUMN Hrmn time 

--- 3: Vérifier les doublons de la table 


---Note: la colonne Num_Acc doit etre unique, car chaque ligne de cette table identifie un accident (deux accidents ne peuvent avoir le meme numéro
SELECT Num_Acc, Count(*) FROM ['carcteristiques-2021$'] GROUP BY Num_Acc
HAVING Count(*)>2

---Conclusion: résultat = 0, cette requete nous donnes la confirmation que nous n'avons aucun doublon dans la table


--- 4: Vérifions les valeurs nulles

SELECT * FROM ['carcteristiques-2021$'] WHERE
Num_Acc is null or Jour is null or Annee is null or Hrmn is null or Agglomeration is null or Nom_de_departement is null or Commune is null or Eclairage is null or Intersection is null or Atmosphère is null or Collision is null

---Conclusion : aucune ligne retournée, toutes les colonnes contiennent au moins un caractère


------------------------------------------------------------------------------------------------------------------------------------------------

-- Table Lieux

--5: Récupérer les donnés de la table 
 SELECT * FROM ['lieux-2021$'] 

--6: vérifions les doublons

SELECT *, COUNT(*) FROM ['lieux-2021$'] GROUP BY
Num_Acc,Catégorie_de_route,Régime_de_circulation,Surface_lieu_acc,Nature_surface
HAVING COUNT(*)>2 

--Conclusion : aucun doublon 

--7: Vérifions les valeurs nulles

 SELECT *  FROM ['lieux-2021$'] WHERE
Num_Acc is null or Catégorie_de_route is null or Régime_de_circulation is null or Surface_lieu_acc is null or Nature_surface is null

--Conclusion : aucune valeur nulle 

-----------------------------------------------------------------------------------------------------------------------------------------

-- Table Véhicules

--8: Récupérer les donnés de la table

SELECT * FROM ['vehicules-2021$']

--9: Vérifier les doublons

SELECT *,COUNT(*) FROM ['vehicules-2021$'] GROUP BY
Num_Acc,Id_vehicule,Num_veh,Catégorie_Véhicule,Point_de_choc,[Manœuvre_principale_avant_accident]
HAVING COUNT(*)>1

--Conclusion: Aucun doublon 

--10: Vérifier les valeurs nulles

SELECT * FROM ['vehicules-2021$'] WHERE
Num_Acc is null or Id_vehicule is null or Num_veh is null or Catégorie_Véhicule is null or Point_de_choc is null or [Manœuvre_principale_avant_accident] is null

--Conclusion: Aucune valeur nulle 

----------------------------------------------------------------------------------------------------------------------------
--Tables Usager

--11: Récupérer les donnés de la table Usager

SELECT * FROM ['usagers-2021$'] 

--12: Vérifier les doublons

SELECT *, COUNT(*) FROM ['usagers-2021$'] GROUP BY
Num_Acc,id_vehicule,num_veh,[Catégorie_d'usager],Usagers_accidentés,Sexe,an_nais,Motif_déplacement,Utilisation_équipement_sécurité_conducteur,Utilisation_équipement_sécurité_passager,Utilisation_équipement_sécurité_piéton,Localisation_piéton,Action_piéton
HAVING  COUNT(*)>1

--Conclusion : Nous n'allons pas supprimer les doublons car, c'est possible d'avoir deux( voir plus) passagers du meme sexe, meme année de naissance, qui se déplace pour le meme motif, .......,Ation_piéton
--En fonction du cas traité.. les doublons peuvent ou non etre supprimés     */

--13: Valeurs nulles

SELECT * FROM ['usagers-2021$'] WHERE
Num_Acc is null or id_vehicule is null or num_veh is null or [Catégorie_d'usager]is null or Usagers_accidentés is null or Sexe is null or an_nais is null or Motif_déplacement is null or Utilisation_équipement_sécurité_conducteur is null or Utilisation_équipement_sécurité_passager is null or Utilisation_équipement_sécurité_piéton is null or Localisation_piéton is null or Action_piéton is null

--- Observation : La colonne an_nais contient des valeurs nulles il faut traiter ce cas...

--- Nous allons ajouter la date 2022 pour que les données de la colonne puissent etre du type date, pour pouvoir facilement manipuler, pour nos analyses nous saurons que c'est une data abbérante
--- Nous ne pouvons pas supprimer ces lignes car nous perdrons des informations sur des mesures ex... le total accidentés pour chaque accident

UPDATE ['usagers-2021$'] SET an_nais = 2022
WHERE an_nais is null

-- Si on refait la select avec le "is null or... " nous n'allons avoir O lignes comme réponse   */



--------------------------------------------------------------------------------------------------------------
-- B: cette partie est lié à l'exploration des données, faire des requetes pour analyser les données sur différents angles.


--14: Le nombre total d'accidents par an
SELECT COUNT(Num_Acc) AS Total_acc_2021 FROM ['carcteristiques-2021$']

--15: Le nombre total d'accidents par jour 


SELECT Annee, Mois, Jour , CONVERT(date,(CONCAT(Jour,'-',Mois,'-',Annee))) as D_DATE, COUNT(*) as Acc_quotidien FROM ['carcteristiques-2021$'] GROUP BY Annee,Mois,Jour
order by Acc_quotidien desc

--16: Le nombre total d'accidents par mois

SELECT Annee, Mois, COUNT(*) as Acc_mensuel FROM ['carcteristiques-2021$'] GROUP BY Annee,Mois
order by Acc_mensuel desc

--17: Accidents moyen par jour
--------Nous avons deux façons de me faire, je trouve la première façon moins lourde

SELECT (COUNT(Num_Acc))/COUNT(DISTINCT(CONCAT(Jour,'-',Mois,'-',Annee))) as Acc_moy_quotidien FROM ['carcteristiques-2021$'] 

SELECT (COUNT(Num_Acc))/COUNT(DISTINCT(CONVERT(date,(CONCAT(Jour,'-',Mois,'-',Annee))))) as Acc_moy_quotidien FROM ['carcteristiques-2021$'] 


--18: % de morts, blessés, non blessés dans l'année
SELECT u.Usagers_accidentés, count(*) as Sous_total_accidentés, SUM(count(*)) OVER () as Grand_total_accidentés,
CAST(100.*count(*)/SUM(count(*)) OVER () as numeric(5,2)) as Pct_accidentés
FROM ['carcteristiques-2021$'] as c
inner join ['usagers-2021$']as u ON c.Num_Acc = u.Num_Acc 
GROUP BY u.Usagers_accidentés
ORDER BY Pct_accidentés desc


-- 19: Total d'accidents en milieu urbain et en milieu rural
SELECT  Agglomeration, COUNT(Num_ACC) as Total_acc FROM ['carcteristiques-2021$']
GROUP BY Agglomeration
ORDER BY Total_acc

-- 20: Nous allons créer des tables temporaires et stocker nos résultats de requête de jointure complexe dans cette dernière, nous ferons des requêtes sur cette table temporaire
DROP TABLE if exists #temp_CLVU 

CREATE TABLE #temp_CLVU (
Num_Acc float Null,D_DATE date, Agglomeration nvarchar(255) NULL ,Nom_de_departement nvarchar(255) NULL,Eclairage nvarchar(255) NULL, Intersection nvarchar(255) NULL,Atmosphère nvarchar(255) NULL,Collision nvarchar(255) NULL,
Id_vehicule nvarchar(255) NULL,Num_veh nvarchar(255) NULL,Catégorie_Véhicule nvarchar(255) NULL,Point_de_choc nvarchar(255) NULL, Manœuvre_principale_avant_accident nvarchar(255) NULL,
Catégorie_de_route nvarchar(255) NULL,Régime_de_circulation nvarchar(255) NULL,Surface_lieu_acc nvarchar(255) NULL,Nature_surface nvarchar(255) NULL,
[Catégorie_d'usager] nvarchar(255) NULL,Usagers_accidentés nvarchar(255) NULL, Sexe nvarchar(255) NULL,Age  int,Localisation_piéton nvarchar(255) NULL,Action_piéton nvarchar(255) NULL
)
 
INSERT INTO #temp_CLVU 
SELECT c.Num_Acc,CONVERT(date,(CONCAT(c.Jour,'-',c.Mois,'-',c.Annee))) as D_DATE,c.Agglomeration,c.Nom_de_departement,c.Eclairage,c.Intersection,c.Atmosphère,c.Collision,
v.Id_vehicule,v.Num_veh,v.Catégorie_Véhicule,v.Point_de_choc, v.Manœuvre_principale_avant_accident,
l.Catégorie_de_route, l.Régime_de_circulation,l.Surface_lieu_acc,l.Nature_surface ,
u.[Catégorie_d'usager],u.Usagers_accidentés, u.Sexe,(2021- DATEPART(year,CONVERT(date,CONVERT(varchar,u.an_nais)))) as Age ,u.Localisation_piéton,u.Action_piéton
FROM ['carcteristiques-2021$'] as c
inner join ['lieux-2021$'] as l on  c.Num_Acc = l.Num_Acc
inner join ['vehicules-2021$'] as v on v.Num_Acc = c.Num_Acc
inner join ['usagers-2021$'] as u on u.id_vehicule = v.Id_vehicule
ORDER BY D_DATE 


-- 21: Tableau des accidents totaux par jour
-- Cette fois nous l'obtenons ç partir des jointures et une table temporaire

SELECT D_Date as D_DAY,COUNT(DISTINCT(Num_Acc)) Total_acc FROM #temp_CLVU GROUP BY D_DATE 
ORDER BY Total_acc desc

-- 22 : % accidents par jour

SELECT D_Date as D_Day, COUNT(DISTINCT(Num_Acc)) Daily_acc, SUM(COUNT(DISTINCT(Num_Acc))) OVER () as Total_yearly_acc,
CAST(100.*COUNT(DISTINCT(Num_Acc))/SUM(COUNT(DISTINCT(Num_Acc))) OVER () AS numeric(5,2)) as Daily_acc_Pct FROM #temp_CLVU
GROUP BY D_DATE
ORDER BY Daily_acc_Pct desc

-- 23: Total des indemnes par jour

SELECT D_Date as D_DAY, COUNT(*) Indemne FROM #temp_CLVU 
WHERE Usagers_accidentés ='Indemne'
GROUP BY D_DATE 
ORDER BY D_DATE

-- 25: Total tué par jour
SELECT D_Date as D_DAY, COUNT(*) Décès FROM #temp_CLVU 
WHERE Usagers_accidentés ='Tué'
GROUP BY D_DATE 
ORDER BY D_DATE

-- 26: Total blessés légers par jour
SELECT D_Date as D_DAY, COUNT(*) Blessé_léger FROM #temp_CLVU 
WHERE Usagers_accidentés ='Blessé léger'
GROUP BY D_DATE 
ORDER BY D_DATE

-- 27: Tableau des blessés hospitalisés par jour
SELECT D_Date as D_DAY, COUNT(*) Blessé_hospitalisé FROM #temp_CLVU 
WHERE Usagers_accidentés ='Blessé hospitalisé'
GROUP BY D_DATE 
ORDER BY D_DATE

-- 28: Total des états des personnes Non renseignée
SELECT D_Date as D_DAY, COUNT(*) Etat_Non_renseignée FROM #temp_CLVU 
WHERE Usagers_accidentés ='Non renseignée'
GROUP BY D_DATE 
ORDER BY D_DATE

-- 29: % accident par Type d'Atmosphère
SELECT Atmosphère,COUNT(DISTINCT(Num_Acc)) as Sub_total_acc,
SUM(COUNT(DISTINCT(Num_Acc))) OVER () as Grand_total_acc,
CAST(100.*COUNT(DISTINCT(Num_Acc))/SUM(COUNT(DISTINCT(Num_Acc))) OVER () AS numeric(5,2)) Pct_sub_total
FROM #temp_CLVU
GROUP BY Atmosphère
ORDER BY  Pct_sub_total desc

--30: % accident par Surface_lieu_acc

SELECT Surface_lieu_acc,COUNT(DISTINCT(Num_Acc)) as Sub_total_acc,
SUM(COUNT(DISTINCT(Num_Acc))) OVER () as Grand_total_acc,
CAST(100.*COUNT(DISTINCT(Num_Acc))/SUM(COUNT(DISTINCT(Num_Acc))) OVER () AS numeric(5,2)) Pct_sub_total
FROM #temp_CLVU
GROUP BY Surface_lieu_acc
ORDER BY  Pct_sub_total desc


-- 31: % d'accident par catégorie d'usager par genre

SELECT  Sexe, [Catégorie_d'usager], COUNT( (Num_Acc)) Sub_total_usager_sexe,Sum(COUNT( (Num_Acc))) OVER (PARTITION BY [Catégorie_d'usager]) Total_usager_Catégorie ,
CAST(100.*COUNT( (Num_Acc))/Sum(COUNT( (Num_Acc))) OVER (PARTITION BY [Catégorie_d'usager]) AS numeric(5,2)) Pct_acc_usager_catégorie_sexe
FROM ['usagers-2021$'] 
GROUP BY Sexe,[Catégorie_d'usager]
ORDER BY [Catégorie_d'usager],Sexe

-- 32: Avons-nous plus d'accidents en semaine ou le week-end?

SELECT COUNT(DISTINCT(Num_Acc)) total_acc, COUNT(DISTINCT(D_Date)) total_weekend FROM #temp_CLVU  WHERE DATENAME(weekday,D_Date) in ('Samedi','Dimance')
SELECT COUNT(DISTINCT(Num_Acc)) total_acc, COUNT(DISTINCT(D_Date)) total_semaine FROM #temp_CLVU  WHERE DATENAME(weekday,D_Date) not in ('Samedi','Dimance')

-- 33: Les départements en fonction des accidentés tués et blessés
SELECT Nom_de_departement,  COUNT(Usagers_accidentés) total_tué_bléssés FROM #temp_CLVU
WHERE Usagers_accidentés in ('Blessé hospitalisé','Tué','Blessé léger')
GROUP BY Nom_de_departement
ORDER BY total_tué_bléssés desc


-- 34: % Usagers tués par type de route 
SELECT Catégorie_de_route, COUNT(Usagers_accidentés) sub_total_tué,
SUM(COUNT(Usagers_accidentés)) OVER() AS Grand_total_tué,
CAST(100.* COUNT(Usagers_accidentés)/SUM(COUNT(Usagers_accidentés)) OVER() AS numeric(5,2)) as Pct_sub_total_tué
FROM #temp_CLVU 
WHERE Usagers_accidentés ='Tué'
GROUP BY Catégorie_de_route
ORDER BY Pct_sub_total_tué desc


-- 35: % accidents par nature de surface lors d l'accident
SELECT  Nature_surface, COUNT(Num_acc),SUM(COUNT(Num_acc)) OVER () total_acc,
(CAST(COUNT(Num_acc) as numeric)/SUM(COUNT(Num_acc)) OVER ())*100 pct_Nature_surface
FROM ['lieux-2021$']
GROUP BY Nature_surface
ORDER BY  pct_Nature_surface desc

--36 : % variation d'accident entre le mois en cours et le mois précédent

SELECT MONTH(D_DATE) Month_acc, COUNT(DISTINCT(Num_Acc)) as total_acc_month_en_cours,
LAG(COUNT(DISTINCT(Num_Acc)),1,0) OVER (ORDER BY MONTH(D_DATE)) mois_précédent,
COUNT(DISTINCT(Num_Acc)) - LAG(COUNT(DISTINCT(Num_Acc)),1,0) OVER (ORDER BY MONTH(D_DATE)) as difference_moisencours_moisprécédent,
CASE 
WHEN LAG(COUNT(DISTINCT(Num_Acc)),1,0) OVER (ORDER BY MONTH(D_DATE)) = 0 THEN COUNT(DISTINCT(Num_Acc))
ELSE LAG(COUNT(DISTINCT(Num_Acc)),1,0) OVER (ORDER BY MONTH(D_DATE))
END as mois_précédents_sans_zéro,
ROUND((CAST((COUNT(DISTINCT(Num_Acc)) - LAG(COUNT(DISTINCT(Num_Acc)),1,0) OVER (ORDER BY MONTH(D_DATE))) as numeric)/(CASE 
WHEN LAG(COUNT(DISTINCT(Num_Acc)),1,0) OVER (ORDER BY MONTH(D_DATE)) = 0 THEN COUNT(DISTINCT(Num_Acc))
ELSE LAG(COUNT(DISTINCT(Num_Acc)),1,0) OVER (ORDER BY MONTH(D_DATE))
END ))*100 , 2) as Pct_variation_de_mort
FROM #temp_CLVU 
GROUP BY MONTH(D_DATE)
ORDER BY MONTH(D_DATE) asc

