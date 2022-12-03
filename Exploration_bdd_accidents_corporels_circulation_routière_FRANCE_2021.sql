
--- Exploration des donn�es d'accidents corporels de la circulation routi�re 2021 en France
--- Ces tables : "Caracteristique, Lieu, Vehicule, Usager" viennent du site data.gouv.fr

--------------------------------------------------------------------------------------------------------------------

-- A: cette partie est pour la pr�paration des donn�es aux requete d'analyses. Nous allons r�cup�rers les donn�es, v�rifier les types de colonnes, v�rifier les doublons, v�rifiers les valeurs nulles.
-- Table carcateristique

--- 1: R�cup�rer les donn�s de la table 
 SELECT * FROM ['carcteristiques-2021$']  

--- 2: Changer le type de la colonne Hrmn 

---Note: apr�s le select, nous nous rendons compte que la colonne Hrmn a un type de donn�e "datetime" au lieu de heure:minutes comme dans le fichier EXCEL que nous avons importer, il faut changer le type de la colonne

ALTER TABLE ['carcteristiques-2021$']
ALTER COLUMN Hrmn time 

--- 3: V�rifier les doublons de la table 


---Note: la colonne Num_Acc doit etre unique, car chaque ligne de cette table identifie un accident (deux accidents ne peuvent avoir le meme num�ro
SELECT Num_Acc, Count(*) FROM ['carcteristiques-2021$'] GROUP BY Num_Acc
HAVING Count(*)>2

---Conclusion: r�sultat = 0, cette requete nous donnes la confirmation que nous n'avons aucun doublon dans la table


--- 4: V�rifions les valeurs nulles

SELECT * FROM ['carcteristiques-2021$'] WHERE
Num_Acc is null or Jour is null or Annee is null or Hrmn is null or Agglomeration is null or Nom_de_departement is null or Commune is null or Eclairage is null or Intersection is null or Atmosph�re is null or Collision is null

---Conclusion : aucune ligne retourn�e, toutes les colonnes contiennent au moins un caract�re


------------------------------------------------------------------------------------------------------------------------------------------------

-- Table Lieux

--5: R�cup�rer les donn�s de la table 
 SELECT * FROM ['lieux-2021$'] 

--6: v�rifions les doublons

SELECT *, COUNT(*) FROM ['lieux-2021$'] GROUP BY
Num_Acc,Cat�gorie_de_route,R�gime_de_circulation,Surface_lieu_acc,Nature_surface
HAVING COUNT(*)>2 

--Conclusion : aucun doublon 

--7: V�rifions les valeurs nulles

 SELECT *  FROM ['lieux-2021$'] WHERE
Num_Acc is null or Cat�gorie_de_route is null or R�gime_de_circulation is null or Surface_lieu_acc is null or Nature_surface is null

--Conclusion : aucune valeur nulle 

-----------------------------------------------------------------------------------------------------------------------------------------

-- Table V�hicules

--8: R�cup�rer les donn�s de la table

SELECT * FROM ['vehicules-2021$']

--9: V�rifier les doublons

SELECT *,COUNT(*) FROM ['vehicules-2021$'] GROUP BY
Num_Acc,Id_vehicule,Num_veh,Cat�gorie_V�hicule,Point_de_choc,[Man�uvre_principale_avant_accident]
HAVING COUNT(*)>1

--Conclusion: Aucun doublon 

--10: V�rifier les valeurs nulles

SELECT * FROM ['vehicules-2021$'] WHERE
Num_Acc is null or Id_vehicule is null or Num_veh is null or Cat�gorie_V�hicule is null or Point_de_choc is null or [Man�uvre_principale_avant_accident] is null

--Conclusion: Aucune valeur nulle 

----------------------------------------------------------------------------------------------------------------------------
--Tables Usager

--11: R�cup�rer les donn�s de la table Usager

SELECT * FROM ['usagers-2021$'] 

--12: V�rifier les doublons

SELECT *, COUNT(*) FROM ['usagers-2021$'] GROUP BY
Num_Acc,id_vehicule,num_veh,[Cat�gorie_d'usager],Usagers_accident�s,Sexe,an_nais,Motif_d�placement,Utilisation_�quipement_s�curit�_conducteur,Utilisation_�quipement_s�curit�_passager,Utilisation_�quipement_s�curit�_pi�ton,Localisation_pi�ton,Action_pi�ton
HAVING  COUNT(*)>1

--Conclusion : Nous n'allons pas supprimer les doublons car, c'est possible d'avoir deux( voir plus) passagers du meme sexe, meme ann�e de naissance, qui se d�place pour le meme motif, .......,Ation_pi�ton
--En fonction du cas trait�.. les doublons peuvent ou non etre supprim�s     */

--13: Valeurs nulles

SELECT * FROM ['usagers-2021$'] WHERE
Num_Acc is null or id_vehicule is null or num_veh is null or [Cat�gorie_d'usager]is null or Usagers_accident�s is null or Sexe is null or an_nais is null or Motif_d�placement is null or Utilisation_�quipement_s�curit�_conducteur is null or Utilisation_�quipement_s�curit�_passager is null or Utilisation_�quipement_s�curit�_pi�ton is null or Localisation_pi�ton is null or Action_pi�ton is null

--- Observation : La colonne an_nais contient des valeurs nulles il faut traiter ce cas...

--- Nous allons ajouter la date 2022 pour que les donn�es de la colonne puissent etre du type date, pour pouvoir facilement manipuler, pour nos analyses nous saurons que c'est une data abb�rante
--- Nous ne pouvons pas supprimer ces lignes car nous perdrons des informations sur des mesures ex... le total accident�s pour chaque accident

UPDATE ['usagers-2021$'] SET an_nais = 2022
WHERE an_nais is null

-- Si on refait la select avec le "is null or... " nous n'allons avoir O lignes comme r�ponse   */



--------------------------------------------------------------------------------------------------------------
-- B: cette partie est li� � l'exploration des donn�es, faire des requetes pour analyser les donn�es sur diff�rents angles.


--14: Le nombre total d'accidents par an
SELECT COUNT(Num_Acc) AS Total_acc_2021 FROM ['carcteristiques-2021$']

--15: Le nombre total d'accidents par jour 


SELECT Annee, Mois, Jour , CONVERT(date,(CONCAT(Jour,'-',Mois,'-',Annee))) as D_DATE, COUNT(*) as Acc_quotidien FROM ['carcteristiques-2021$'] GROUP BY Annee,Mois,Jour
order by Acc_quotidien desc

--16: Le nombre total d'accidents par mois

SELECT Annee, Mois, COUNT(*) as Acc_mensuel FROM ['carcteristiques-2021$'] GROUP BY Annee,Mois
order by Acc_mensuel desc

--17: Accidents moyen par jour
--------Nous avons deux fa�ons de me faire, je trouve la premi�re fa�on moins lourde

SELECT (COUNT(Num_Acc))/COUNT(DISTINCT(CONCAT(Jour,'-',Mois,'-',Annee))) as Acc_moy_quotidien FROM ['carcteristiques-2021$'] 

SELECT (COUNT(Num_Acc))/COUNT(DISTINCT(CONVERT(date,(CONCAT(Jour,'-',Mois,'-',Annee))))) as Acc_moy_quotidien FROM ['carcteristiques-2021$'] 


--18: % de morts, bless�s, non bless�s dans l'ann�e
SELECT u.Usagers_accident�s, count(*) as Sous_total_accident�s, SUM(count(*)) OVER () as Grand_total_accident�s,
CAST(100.*count(*)/SUM(count(*)) OVER () as numeric(5,2)) as Pct_accident�s
FROM ['carcteristiques-2021$'] as c
inner join ['usagers-2021$']as u ON c.Num_Acc = u.Num_Acc 
GROUP BY u.Usagers_accident�s
ORDER BY Pct_accident�s desc


-- 19: Total d'accidents en milieu urbain et en milieu rural
SELECT  Agglomeration, COUNT(Num_ACC) as Total_acc FROM ['carcteristiques-2021$']
GROUP BY Agglomeration
ORDER BY Total_acc

-- 20: Nous allons cr�er des tables temporaires et stocker nos r�sultats de requ�te de jointure complexe dans cette derni�re, nous ferons des requ�tes sur cette table temporaire
DROP TABLE if exists #temp_CLVU 

CREATE TABLE #temp_CLVU (
Num_Acc float Null,D_DATE date, Agglomeration nvarchar(255) NULL ,Nom_de_departement nvarchar(255) NULL,Eclairage nvarchar(255) NULL, Intersection nvarchar(255) NULL,Atmosph�re nvarchar(255) NULL,Collision nvarchar(255) NULL,
Id_vehicule nvarchar(255) NULL,Num_veh nvarchar(255) NULL,Cat�gorie_V�hicule nvarchar(255) NULL,Point_de_choc nvarchar(255) NULL, Man�uvre_principale_avant_accident nvarchar(255) NULL,
Cat�gorie_de_route nvarchar(255) NULL,R�gime_de_circulation nvarchar(255) NULL,Surface_lieu_acc nvarchar(255) NULL,Nature_surface nvarchar(255) NULL,
[Cat�gorie_d'usager] nvarchar(255) NULL,Usagers_accident�s nvarchar(255) NULL, Sexe nvarchar(255) NULL,Age  int,Localisation_pi�ton nvarchar(255) NULL,Action_pi�ton nvarchar(255) NULL
)
 
INSERT INTO #temp_CLVU 
SELECT c.Num_Acc,CONVERT(date,(CONCAT(c.Jour,'-',c.Mois,'-',c.Annee))) as D_DATE,c.Agglomeration,c.Nom_de_departement,c.Eclairage,c.Intersection,c.Atmosph�re,c.Collision,
v.Id_vehicule,v.Num_veh,v.Cat�gorie_V�hicule,v.Point_de_choc, v.Man�uvre_principale_avant_accident,
l.Cat�gorie_de_route, l.R�gime_de_circulation,l.Surface_lieu_acc,l.Nature_surface ,
u.[Cat�gorie_d'usager],u.Usagers_accident�s, u.Sexe,(2021- DATEPART(year,CONVERT(date,CONVERT(varchar,u.an_nais)))) as Age ,u.Localisation_pi�ton,u.Action_pi�ton
FROM ['carcteristiques-2021$'] as c
inner join ['lieux-2021$'] as l on  c.Num_Acc = l.Num_Acc
inner join ['vehicules-2021$'] as v on v.Num_Acc = c.Num_Acc
inner join ['usagers-2021$'] as u on u.id_vehicule = v.Id_vehicule
ORDER BY D_DATE 


-- 21: Tableau des accidents totaux par jour
-- Cette fois nous l'obtenons � partir des jointures et une table temporaire

SELECT D_Date as D_DAY,COUNT(DISTINCT(Num_Acc)) Total_acc FROM #temp_CLVU GROUP BY D_DATE 
ORDER BY Total_acc desc

-- 22 : % accidents par jour

SELECT D_Date as D_Day, COUNT(DISTINCT(Num_Acc)) Daily_acc, SUM(COUNT(DISTINCT(Num_Acc))) OVER () as Total_yearly_acc,
CAST(100.*COUNT(DISTINCT(Num_Acc))/SUM(COUNT(DISTINCT(Num_Acc))) OVER () AS numeric(5,2)) as Daily_acc_Pct FROM #temp_CLVU
GROUP BY D_DATE
ORDER BY Daily_acc_Pct desc

-- 23: Total des indemnes par jour

SELECT D_Date as D_DAY, COUNT(*) Indemne FROM #temp_CLVU 
WHERE Usagers_accident�s ='Indemne'
GROUP BY D_DATE 
ORDER BY D_DATE

-- 25: Total tu� par jour
SELECT D_Date as D_DAY, COUNT(*) D�c�s FROM #temp_CLVU 
WHERE Usagers_accident�s ='Tu�'
GROUP BY D_DATE 
ORDER BY D_DATE

-- 26: Total bless�s l�gers par jour
SELECT D_Date as D_DAY, COUNT(*) Bless�_l�ger FROM #temp_CLVU 
WHERE Usagers_accident�s ='Bless� l�ger'
GROUP BY D_DATE 
ORDER BY D_DATE

-- 27: Tableau des bless�s hospitalis�s par jour
SELECT D_Date as D_DAY, COUNT(*) Bless�_hospitalis� FROM #temp_CLVU 
WHERE Usagers_accident�s ='Bless� hospitalis�'
GROUP BY D_DATE 
ORDER BY D_DATE

-- 28: Total des �tats des personnes Non renseign�e
SELECT D_Date as D_DAY, COUNT(*) Etat_Non_renseign�e FROM #temp_CLVU 
WHERE Usagers_accident�s ='Non renseign�e'
GROUP BY D_DATE 
ORDER BY D_DATE

-- 29: % accident par Type d'Atmosph�re
SELECT Atmosph�re,COUNT(DISTINCT(Num_Acc)) as Sub_total_acc,
SUM(COUNT(DISTINCT(Num_Acc))) OVER () as Grand_total_acc,
CAST(100.*COUNT(DISTINCT(Num_Acc))/SUM(COUNT(DISTINCT(Num_Acc))) OVER () AS numeric(5,2)) Pct_sub_total
FROM #temp_CLVU
GROUP BY Atmosph�re
ORDER BY  Pct_sub_total desc

--30: % accident par Surface_lieu_acc

SELECT Surface_lieu_acc,COUNT(DISTINCT(Num_Acc)) as Sub_total_acc,
SUM(COUNT(DISTINCT(Num_Acc))) OVER () as Grand_total_acc,
CAST(100.*COUNT(DISTINCT(Num_Acc))/SUM(COUNT(DISTINCT(Num_Acc))) OVER () AS numeric(5,2)) Pct_sub_total
FROM #temp_CLVU
GROUP BY Surface_lieu_acc
ORDER BY  Pct_sub_total desc


-- 31: % d'accident par cat�gorie d'usager par genre

SELECT  Sexe, [Cat�gorie_d'usager], COUNT( (Num_Acc)) Sub_total_usager_sexe,Sum(COUNT( (Num_Acc))) OVER (PARTITION BY [Cat�gorie_d'usager]) Total_usager_Cat�gorie ,
CAST(100.*COUNT( (Num_Acc))/Sum(COUNT( (Num_Acc))) OVER (PARTITION BY [Cat�gorie_d'usager]) AS numeric(5,2)) Pct_acc_usager_cat�gorie_sexe
FROM ['usagers-2021$'] 
GROUP BY Sexe,[Cat�gorie_d'usager]
ORDER BY [Cat�gorie_d'usager],Sexe

-- 32: Avons-nous plus d'accidents en semaine ou le week-end?

SELECT COUNT(DISTINCT(Num_Acc)) total_acc, COUNT(DISTINCT(D_Date)) total_weekend FROM #temp_CLVU  WHERE DATENAME(weekday,D_Date) in ('Samedi','Dimance')
SELECT COUNT(DISTINCT(Num_Acc)) total_acc, COUNT(DISTINCT(D_Date)) total_semaine FROM #temp_CLVU  WHERE DATENAME(weekday,D_Date) not in ('Samedi','Dimance')

-- 33: Les d�partements en fonction des accident�s tu�s et bless�s
SELECT Nom_de_departement,  COUNT(Usagers_accident�s) total_tu�_bl�ss�s FROM #temp_CLVU
WHERE Usagers_accident�s in ('Bless� hospitalis�','Tu�','Bless� l�ger')
GROUP BY Nom_de_departement
ORDER BY total_tu�_bl�ss�s desc


-- 34: % Usagers tu�s par type de route 
SELECT Cat�gorie_de_route, COUNT(Usagers_accident�s) sub_total_tu�,
SUM(COUNT(Usagers_accident�s)) OVER() AS Grand_total_tu�,
CAST(100.* COUNT(Usagers_accident�s)/SUM(COUNT(Usagers_accident�s)) OVER() AS numeric(5,2)) as Pct_sub_total_tu�
FROM #temp_CLVU 
WHERE Usagers_accident�s ='Tu�'
GROUP BY Cat�gorie_de_route
ORDER BY Pct_sub_total_tu� desc


-- 35: % accidents par nature de surface lors d l'accident
SELECT  Nature_surface, COUNT(Num_acc),SUM(COUNT(Num_acc)) OVER () total_acc,
(CAST(COUNT(Num_acc) as numeric)/SUM(COUNT(Num_acc)) OVER ())*100 pct_Nature_surface
FROM ['lieux-2021$']
GROUP BY Nature_surface
ORDER BY  pct_Nature_surface desc

--36 : % variation d'accident entre le mois en cours et le mois pr�c�dent

SELECT MONTH(D_DATE) Month_acc, COUNT(DISTINCT(Num_Acc)) as total_acc_month_en_cours,
LAG(COUNT(DISTINCT(Num_Acc)),1,0) OVER (ORDER BY MONTH(D_DATE)) mois_pr�c�dent,
COUNT(DISTINCT(Num_Acc)) - LAG(COUNT(DISTINCT(Num_Acc)),1,0) OVER (ORDER BY MONTH(D_DATE)) as difference_moisencours_moispr�c�dent,
CASE 
WHEN LAG(COUNT(DISTINCT(Num_Acc)),1,0) OVER (ORDER BY MONTH(D_DATE)) = 0 THEN COUNT(DISTINCT(Num_Acc))
ELSE LAG(COUNT(DISTINCT(Num_Acc)),1,0) OVER (ORDER BY MONTH(D_DATE))
END as mois_pr�c�dents_sans_z�ro,
ROUND((CAST((COUNT(DISTINCT(Num_Acc)) - LAG(COUNT(DISTINCT(Num_Acc)),1,0) OVER (ORDER BY MONTH(D_DATE))) as numeric)/(CASE 
WHEN LAG(COUNT(DISTINCT(Num_Acc)),1,0) OVER (ORDER BY MONTH(D_DATE)) = 0 THEN COUNT(DISTINCT(Num_Acc))
ELSE LAG(COUNT(DISTINCT(Num_Acc)),1,0) OVER (ORDER BY MONTH(D_DATE))
END ))*100 , 2) as Pct_variation_de_mort
FROM #temp_CLVU 
GROUP BY MONTH(D_DATE)
ORDER BY MONTH(D_DATE) asc

