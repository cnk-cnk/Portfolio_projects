# SQL_Analyses_Accidents_FRANCE_2021

/*

Le projet se décompose en deux parties, l'exploration des données avec SQL et la visualisation des données avec Tableau desktop.

A: Exploration des données avec SQL:

- Nettoyer les données (valeurs nulles, doublons)
- Vérifier que les types des colonnes n'ont pas changés lors de l'importation des données vers Microsoft SQL SERVER;
- Effectuer plusieurs requêtes d'analyses.

B: Visualisation des données avec Tableau:

- Créer un time intelligent tableau de bord qui nous permet de suivre par mois les accidents & accidentés, et le % de variation de ces derniers en fonction du mois en cours et mois précédent;
- Répartition des accidentés en fonction du sexe et la catégorie d'usager;
- Les accidents et accidentés tout au long de l'année 2021.
- Les top 08 départements accidentés;
- Les top 05 type de véhicules accidentés.

Décrivons les tables:

- La table Caracteristique décrit l'accident et elle contient la colonne "Num_Acc" qui sert comme clé primaire car elle est unique et ne contient pas de valeurs nulles;

- La table Lieux contient elle aussi la colonne "Num_Acc", ne contient aucun doublon et correspond exactement à la colonne Num_Acc de la table Caracteristique;

- La table véhicule a pour clé primaire Id_Véhicule et elle a  la colonne  "Num_Acc" qui agit comme clé secondaire, ses valeurs ne sont plus uniques mais toutes ses valeurs viennent bien de la colonne "Num_Acc" de la table Caracteristiques;
- Note: dans ce contexte.. que tu sois piéton, passager, Conducteur tu as un Id_Véhicule;

- La relation est : Véhicule(1,n) ----- Usager (1,1);

- La table Usager ne contient pas de colonne clé primaire, mais elle a les colonnes  "Num_Acc" et "Id_Véhicule" qui agissent comme clés secondaire, leurs valeurs ne sont plus uniques mais toutes ses valeurs viennent bien de la colonne "Num_Acc" de la table (table père)  Caracteristiques et de la table "Véhicule" (table père).

Comment sont rélier ces tables :

- Caracteristiques (1,1) ---- (1,1)  Lieu  (1,n) ---- (1,1) Véhicules(1,n) ---- (1,1) Usager.

- *Selon les règles de BDR les champs de la table lieu ou Caracteristiques doivent migrer dans l'une des tables.. mais ces données ont été rangés ainsi sur le site data.gouv.fr (en fichier CSV et non comme une BDR);
- *Un lieu est lié à plusieurs accidents (véhicules, piétons) mais un Véhicule fait un accident sur un lieu au minimun et au maximun sur un lieu à un instant;
- *Un véhicule contient un ou plusieurs accidentés (conducteur, passagers, piéton) mais un accidenté occupe au minimun un véhicule et au max un véhicule.

*/
