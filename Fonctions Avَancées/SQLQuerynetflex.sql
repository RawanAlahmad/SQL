select * from netflix_clients_db;

/*Exercice 1 : Utilisation de CONCAT*/

select CONCAT (TypeAbonnement,'_', Pays)
as Concat_pays_typeAbon 
from netflix_clients_db;

/*Exercice 2 : Utilisation de LENGTH*/

select AppareilPrincipal,
len(AppareilPrincipal) as Longueur_Appareil
from netflix_clients_db;

/*Exercice 3 : Utilisation de REPLACE*/

select pays,REPLACE(Pays,'�','e')
as Pays_modification 
from netflix_clients_db;

/*Exercice 4 : Utilisation de SUBSTRING*/

select  DateInscription,
SUBSTRING( convert (varchar, DateInscription,23),1,4) as Ann� 
from netflix_clients_db;

/*Exercice 5 : Utilisation de CONCAT*/
Select CONCAT(TypeAbonnement, '_', AppareilPrincipal,'_', AgeUtilisateur) as Profil_Client
from netflix_clients_db;
/*Exercice 6 : Utilisation de LENGTH
*/
select pays , len(pays) as Pays_plus_que_5
from netflix_clients_db
where len(pays)>5;

/*Exercice 7 : Utilisation de SUBSTRING*/
select SUBSTRING(convert (varchar, DateDernierPaiement,23),1,4)  as Ann�
from netflix_clients_db;

/*Exercice 8 : Arrondir les montants de paiement
*/
select MontantDernierPaiement ,
ROUND(MontantDernierPaiement,2) as Montant_Arrondi
from netflix_clients_db;

/*Exercice 9 : Analyser la dur�e moyenne de visionnage
*/
select AVG(DureeTotaleVisionnage) as Moyen_avant_arrondir,
round(avg(DureeTotaleVisionnage),2) as Moyen_apr�s_arrondir
from netflix_clients_db;
/*Exercice 10 : Nombre moyen de films regard�s par client */
select avg(NombreFilmsRegardes) as Moyen_avant_arrondir,
ROUND(avg(NombreFilmsRegardes),2) as Moyen_apr�s_arrondir
from netflix_clients_db;

/*Exercice 11 : Extraction de l'ann�e d'inscription */
/*le logiciel SSMS que j'utilse n'a pas la fonction Strftime*/
SELECT DateInscription,DATEPART(YEAR,DateInscription)  AS Ann�,
       DATEPART(MONTH, DateInscription) AS Mois,
       DATEPART(DAY, DateInscription) AS Jour
FROM  netflix_clients_db;

/*Exercice 12 : Identifier les clients actifs en semaine
*/
/* DATEPART(WEEKDAY, DateDerniereConnexion) extrait le num�ro du jour de la semaine 
(1 pour dimanche, 2 pour lundi, ..., 7 pour samedi)
� partir de la colonne DateDerniereConnexion.
BETWEEN 2 AND 6 filtre les r�sultats pour inclure uniquement les jours de la semaine du lundi au vendredi.*/
SELECT DateDernierPaiement, 
DATEPART(WEEKDAY,DateDernierPaiement)  as Jour_de_la_semaine
FROM  netflix_clients_db
where  DATEPART(WEEKDAY,DateDernierPaiement) between 2 and 6;
/*Exercice 13 : Trouver les mois de forte activit� */
SELECT  DATEPART(MONTH, DateInscription) AS Mois,
count (*) as NombreInscriptions
 FROM  netflix_clients_db
   group by  DATEPART(MONTH, DateInscription) 
   order by Mois;

 /* Autre Solution*/
 SELECT MONTH(DateInscription) AS Mois, COUNT(*) AS NombreInscriptions
FROM netflix_clients_db
GROUP BY MONTH(DateInscription)
ORDER BY Mois;
/*Exercice 14 : Analyser les tendances de paiement annuelles */

select YEAR(DateDernierPaiement) as Ann�, Round(SUM (MontantDernierPaiement),2) AS TotaleDesPaiement
       from netflix_clients_db
	   group by YEAR(DateDernierPaiement)
	   order by Ann�;


/*Exercice 15 : Analyse des genres pr�f�r�s et du statut d'abonnement*/

SELECT GenrePrefere,
       COUNT(*) AS TotalComptes,
       SUM(CASE WHEN StatutCompte = 'Actif' THEN 1 ELSE 0 END) AS ComptesActifs,
       ROUND((CAST(SUM(CASE WHEN StatutCompte = 'Actif' THEN 1 ELSE 0 END) AS float) / COUNT(*)) * 100, 2) AS PourcentageComptesActifs
FROM netflix_clients_db
GROUP BY GenrePrefere;

/*Exercice 16 :*/
SELECT AppareilPrincipal,
       AVG(CASE WHEN DateInscription < '2022-01-01' THEN NombreConnexionsMois ELSE 0 END) AS MoyenneConnexionsAvant2022,
       AVG(CASE WHEN DateInscription >= '2022-01-01' THEN NombreConnexionsMois ELSE 0 END) AS MoyenneConnexionsApres2022
FROM netflix_clients_db
GROUP BY AppareilPrincipal;
/*Exercice 17 : Analyse des pr�f�rences d'abonnement par �ge*/
SELECT CASE 
           WHEN AgeUtilisateur < 30 THEN 'Moins de 30 ans'
           WHEN AgeUtilisateur >= 30 AND AgeUtilisateur <= 60 THEN '30 � 60 ans'
           ELSE 'Plus de 60 ans'
       END AS Groupe_Age,
       TypeAbonnement AS TypeAbonnementPopulaire,
       COUNT(*) AS NombreClients
FROM netflix_clients_db
GROUP BY 
    CASE 
        WHEN AgeUtilisateur < 30 THEN 'Moins de 30 ans'
        WHEN AgeUtilisateur >= 30 AND AgeUtilisateur <= 60 THEN '30 � 60 ans'
        ELSE 'Plus de 60 ans'
    END,
    TypeAbonnement;

/*Exercice 18 : Analyse des d�penses des clients actifs par genre pr�f�r�
*/

SELECT GenrePrefere,
       LanguePreferee,
       round(SUM(MontantDernierPaiement),2) AS Montant_Total,
       round(AVG(MontantDernierPaiement),2) AS Montant_Moyen
FROM netflix_clients_db
WHERE DateInscription >= '2021-01-01'
  AND StatutCompte = 'Actif'
GROUP BY GenrePrefere, LanguePreferee;

/*Exercice 19 : Tendance de consommation des nouveaux vs anciens clients*/

SELECT CASE WHEN DateInscription > '2020-12-31' 
			  THEN 'Nouveaux clients'	
			  ELSE 'Anciens clients' 
		      END AS Categorie_Client,
		 AVG(CASE WHEN NombreFilmsRegardes > 0
				THEN NombreFilmsRegardes
				ELSE 0 END) AS Moyenne_Films_Regardes,
         AVG(CASE WHEN NombreEpisodesRegardes >0 
				THEN NombreEpisodesRegardes 
				ELSE 0 END) AS Moyenne_Episodes_Regardes
FROM netflix_clients_db
GROUP BY CASE WHEN DateInscription > '2020-12-31'
              THEN 'Nouveaux clients' 
			  ELSE 'Anciens clients'
			  END;

/*Exercice 20 : Optimisation des campagnes marketing par r�gion*/

SELECT Pays,
       COUNT(*) AS Nombre_Nouveaux_Abonnes,
       AVG(NombreConnexionsMois) AS Moyenne_Connexions
FROM netflix_clients_db
WHERE YEAR(DateInscription) = 2021
GROUP BY Pays
ORDER BY Nombre_Nouveaux_Abonnes DESC;

/*Exercice 21 : Calcul du taux d'attrition des clients par type d'abonnement et analyse duvisionnage*/
SELECT TypeAbonnement,
       COUNT(CASE WHEN StatutCompte = 'Annul�'
	      THEN 1 END) AS Nombre_Clients_Annules,
       SUM(CASE WHEN StatutCompte = 'Annul�' 
	      THEN DureeTotaleVisionnage ELSE 0 END) AS Total_Hrs_Visionnees_Avant_Annulation,
       AVG(CASE WHEN StatutCompte = 'Annul�' 
	      THEN DureeTotaleVisionnage ELSE 0 END) AS Moyenne_Hrs_Visionnees_Avant_Annulation
FROM netflix_clients_db
WHERE YEAR(DateInscription) = 2021
GROUP BY TypeAbonnement;