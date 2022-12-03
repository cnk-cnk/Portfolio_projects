
-- Read me

/*

Le projet se d�compose en deux parties, l'exploration des donn�es avec SQL et la visualisation des donn�es avec Tableau desktop.

A: Exploration des donn�es avec SQL:

- Nettoyer les donn�es (valeurs nulles, doublons)
- V�rifier que les types des colonnes n'ont pas chang�s lors de l'importation des donn�es vers Microsoft SQL SERVER;
- Effectuer plusieurs requ�tes d'analyses.

B: Visualisation des donn�es avec Tableau:

- Cr�er un time intelligent tableau de bord qui nous permet de suivre par mois les accidents & accident�s, et le % de variation de ces derniers en fonction du mois en cours et mois pr�c�dent;
- R�partition des accident�s en fonction du sexe et la cat�gorie d'usager;
- Les accidents et accident�s tout au long de l'ann�e 2021.
- Les top 08 d�partements accident�s;
- Les top 05 type de v�hicules accident�s.

D�crivons les tables:

- La table Caracteristique d�crit l'accident et elle contient la colonne "Num_Acc" qui sert comme cl� primaire car elle est unique et ne contient pas de valeurs nulles;

- La table Lieux contient elle aussi la colonne "Num_Acc", ne contient aucun doublon et correspond exactement � la colonne Num_Acc de la table Caracteristique;

- La table v�hicule a pour cl� primaire Id_V�hicule et elle a  la colonne  "Num_Acc" qui agit comme cl� secondaire, ses valeurs ne sont plus uniques mais toutes ses valeurs viennent bien de la colonne "Num_Acc" de la table Caracteristiques;
- Note: dans ce contexte.. que tu sois pi�ton, passager, Conducteur tu as un Id_V�hicule;

- La relation est : V�hicule(1,n) ----- Usager (1,1);

- La table Usager ne contient pas de colonne cl� primaire, mais elle a les colonnes  "Num_Acc" et "Id_V�hicule" qui agissent comme cl�s secondaire, leurs valeurs ne sont plus uniques mais toutes ses valeurs viennent bien de la colonne "Num_Acc" de la table (table p�re)  Caracteristiques et de la table "V�hicule" (table p�re).

Comment sont r�lier ces tables :

- Caracteristiques (1,1) ---- (1,1)  Lieu  (1,n) ---- (1,1) V�hicules(1,n) ---- (1,1) Usager.

- *Selon les r�gles de BDR les champs de la table lieu ou Caracteristiques doivent migrer dans l'une des tables.. mais ces donn�es ont �t� rang�s ainsi sur le site data.gouv.fr (en fichier CSV et non comme une BDR);
- *Un lieu est li� � plusieurs accidents (v�hicules, pi�tons) mais un V�hicule fait un accident sur un lieu au minimun et au maximun sur un lieu � un instant;
- *Un v�hicule contient un ou plusieurs accident�s (conducteur, passagers, pi�ton) mais un accident� occupe au minimun un v�hicule et au max un v�hicule.

*/