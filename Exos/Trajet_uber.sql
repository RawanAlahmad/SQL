select * from Chauffeurs_Uber;
select * from Clients_Uber;
select * from Trajets_Uber;
/*Exercice 1 : Clients économiques et critiques*/

SELECT  Préférences, AVG(Dépense_Totale) AS Moyenne_Dépenses, AVG(Evaluations_Chauffeurs) AS Moyenne_Evaluations
 FROM Clients_Uber
  WHERE Préférences = 'Eco'
   GROUP BY Préférences, ID_Client
    HAVING AVG(Dépense_Totale) > 3000 AND AVG(Evaluations_Chauffeurs) < 3;

/*Exercice 2 : Chauffeurs anglophones du matin à haute évaluation*/
Select *
 from Chauffeurs_Uber
  where Langues_Parlées='Anglais'
   and Evaluation >4 
    and Disponibilité='Matin';

 /*Exercice 3 : Trajets difficiles en haute congestion*/
 Select  *
  from Trajets_Uber
   where Notes_Client='Mauvais'
    and  Conditions_Traffic='Elevé'
     and Distance >20;

 /*Exercice 4 : Préférences musicales sur trajets spécifiques */

Select a.Préférences_Musique,
    b.Type_Trajet from Clients_Uber a
     left join   Trajets_Uber b 
      on a.ID_Client=B.ID_Client
       where Type_Trajet='UberBlack';

/*Exercice 5 : Performance des chauffeurs sur trajets en heure de pointe */

Select a.ID_Chauffeur,b.ID_Trajet, a.Evaluation,b.Conditions_Traffic
  from Chauffeurs_Uber a
   left join Trajets_Uber b
    on  a.ID_Chauffeur= b.ID_Chauffeur
     where b.Conditions_Traffic='Elevé';
  
 /*Exercice 6 : Moyenne des distances des trajets par type de jour*/
Select 
    case 
     when datepart(weekday,Date_Heure) in (1,7) then 'WeekEnds'
     else   'Jours_de_semaine'
     end as JourSemaine,
       avg(distance) as Moyenne_distance 
        from Trajets_Uber
         group by case 
          when datepart(weekday,Date_Heure) in (1,7) then 'WeekEnds'
          else   'Jours_de_semaine'
          End;

/*Exercice 7 : Prix moyen des trajets par langue parlée des chauffeurs*/
Select a.Langues_Parlées,
 avg(b.prix) AS Moyen_prix
  from Chauffeurs_Uber a
   left join Trajets_Uber b
    on a.ID_Chauffeur= b.ID_Chauffeur
     group by a.Langues_Parlées;

/*Exercice 8 : Comptage des clients fidèles et occasionnels*/
Select 
  case 
     when Nombre_Trajets > 30 then 'Clients fidèles'
	 else 'Client occasionnels'
     end as Catégorie_Client,
        count(*) as Nombre_Clients
         from Clients_Uber
           group by case    
		    when Nombre_Trajets > 30 then 'Clients fidèles'
	        else 'Client occasionnels'
            end ;

/*Exercice 9 : Catégorisation des trajets par Prix*/
select 
	Case  
		When prix < 10 then 'Prix Bas'
		When  Prix between 10 and 30 then 'Prix Moyen'
		Else 'Prix Élevé'
	End As Catégorie_Trajet,
	 COUNT(*) as 'Nombre de Trajet'
      From Trajets_Uber
       Group by 
		Case 
			When prix < 10 then 'Prix Bas'
			when  Prix between 10 and 30 then 'Prix Moyen'
		    Else 'Prix Élevé'
	    End;

/*Exercice 10 : Classification des chauffeurs selon le nombre de trajets*/
select 
	case 
	     when Nombre_Trajets > 50 then 'Débutant'
	     when Nombre_Trajets between  50 and 150 then'Expérimenté'
	     else 'vétéran'
    end as 'Catégorie Chauffeur',
	     round(avg(Evaluation),2) as 'Evaluation moyenne'
	       from Chauffeurs_Uber
	        group by 
		     case
			     when Nombre_Trajets > 50 then 'Débutant'
		         when Nombre_Trajets between  50 and 150 then'Expérimenté'
		         else 'vétéran'
		     end;

/*Exercice 11 : Analyse des tendances de paiement des clients*/

SELECT Moyen_Paiement, ROUND(AVG(Dépense_Totale),2) AS Montant_Moyen_Dépensé
	FROM Clients_Uber
	 WHERE Nombre_Trajets >= 10 AND Dépense_Totale > 500
      GROUP BY Moyen_Paiement;

/*Exercice 12 : Impact des conditions de trafic sur la distance des trajets*/

Select  Conditions_Traffic,
         round(avg(Distance),2) as 'la distance moyenne'
          from Trajets_Uber
            where prix > 20
              group by Conditions_Traffic;

/*Exercice 13 : Analyse des chauffeurs par nombre de trajets*/
Select 
	Case 
	       When Nombre_Trajets >100 then 'Plus de 100 Trajets'
	       else 'Moinsde 100 Trajets'
    End as 'Catégorie Chauffeur',
	   COUNT(*) as 'Nombre Total',
	    ROUND(SUM(distance_totale),2) as 'Distance Totale', 
	     ROUND(AVG(evaluation),2) as 'Evaluation moyenne'
          from Chauffeurs_Uber
           Group by 
	        Case 
			      When Nombre_Trajets >100 then  'Plus de 100 Trajets'
	              Else 'Moinsde 100 Trajets'
	        End;

/*Exercice 14 : Profil des clients selon la dépense totale*/
SELECT
    CASE
        WHEN Nombre_Trajets < 100 THEN 'Moins de 100 trajets'
        ELSE '100 trajets ou plus'
    END AS Catégorie_Trajets,
         COUNT(*) AS Nombre_Total_Chauffeurs,
          SUM(Distance_Totale) AS Distance_Totale,
           AVG(Evaluation) AS Evaluation_Moyenne
             FROM Chauffeurs_Uber
               GROUP BY
                 CASE
                     WHEN Nombre_Trajets < 100 THEN 'Moins de 100 trajets'
                     ELSE '100 trajets ou plus'
                  END;
/*Exercice 15 : Analyse détaillée des performances des chauffeurs*/
SELECT
 CASE
    when Evaluation <3 then 'Faible' 
    when Evaluation between 3 and 4 then 'Moyenne'
    else 'Haute'
 END AS Performance,
	COUNT(*) AS Nombre_Trajet,
     ROUND(AVG(Revenu_Total / Nombre_Trajets),1) AS Revenu_Moyen_Par_Trajet,
      SUM(Nombre_Trajets) AS Total_Trajets,
       ROUND(SUM(Revenu_Total),1) AS Total_Revenu
		 From Chauffeurs_Uber
		  WHERE Nombre_Trajets > 50/*pour les chauffeurs avec plus de 50 trajets*/
		   GROUP BY
		    CASE WHEN Evaluation <3 THEN 'Faible' 
		         WHEN Evaluation between 3 and 4 THEN 'Moyenne'
		         ELSE 'Haute'
		    End
		     HAVING COUNT(*) > 10; /*Afficher uniquement les catégories avec plus de 10 chauffeurs*/

/*Exercice 16 : Analyse des préférences musicales des clients et impact sur les évaluations des chauffeurs */
SELECT 
 Préférences_Musique,
  COUNT(a.ID_Trajet) AS Nombre_Trajets,
   ROUND( AVG(b.Evaluations_Chauffeurs),1) AS Evaluation_Moyenne_Chauffeurs,
    ROUND( AVG(a.Prix / a.Nombre_Passagers),1) AS Revenu_Moyen_Par_Trajet
      FROM Clients_Uber b
       LEFT JOIN Trajets_Uber a ON b.ID_Client = a.ID_Client
        GROUP BY Préférences_Musique
         ORDER BY Préférences_Musique;

/*Exercice 17 : Corrélation entre la formation en sécurité et la performance des chauffeurs */
SELECT a.ID_Chauffeur,
    CASE 
        WHEN Formation_Sécurité = 1 THEN 'Suivi'
        ELSE 'Non Suivi' 
    END AS Formation_Sécurité,
     COUNT(b.ID_Trajet) AS Nombre_Trajets,
      CASE 
         WHEN AVG(Evaluation) < 3 THEN 'Faible'
         WHEN AVG(Evaluation) >= 3 AND AVG(Evaluation) <= 4 THEN 'Moyenne'
         ELSE 'Haute' 
      END AS Catégorie_Evaluation
       FROM Chauffeurs_Uber a
        LEFT JOIN Trajets_Uber b ON a.ID_Chauffeur = b.ID_Chauffeur
         GROUP BY a.ID_Chauffeur, Formation_Sécurité
          ORDER BY a.ID_Chauffeur;

/*Exercice 18 : Rapport mensuel sur les trajets Uber*/
SELECT 
    TU.Type_Trajet,
    COUNT(TU.ID_Trajet) AS Nombre_Total_Trajets,
    SUM(TU.Prix) AS Revenu_Total,
    AVG(TU.Distance) AS Distance_Moyenne,
    AVG(CU.Evaluation) AS Evaluation_Moyenne,
    CASE 
        WHEN DATEPART(HOUR, TU.Date_Heure) BETWEEN 6 AND 11 THEN 'Matin'
        WHEN DATEPART(HOUR, TU.Date_Heure) BETWEEN 12 AND 17 THEN 'Après-midi'
        WHEN DATEPART(HOUR, TU.Date_Heure) BETWEEN 18 AND 23 THEN 'Soir'
        ELSE 'Nuit' 
    END AS Période_Journée,
    COUNT(CASE WHEN TU.Conditions_Traffic = 'Faible' THEN TU.ID_Trajet END) AS Nombre_Trajets_Faible_Trafic,
    COUNT(CASE WHEN TU.Conditions_Traffic = 'Moyen' THEN TU.ID_Trajet END) AS Nombre_Trajets_Moyen_Trafic,
    COUNT(CASE WHEN TU.Conditions_Traffic = 'Élevé' THEN TU.ID_Trajet END) AS Nombre_Trajets_Élevé_Trafic
FROM Trajets_Uber TU
LEFT JOIN Chauffeurs_Uber CU ON TU.ID_Chauffeur = CU.ID_Chauffeur
WHERE YEAR(TU.Date_Heure) = YEAR(GETDATE()) - 1
GROUP BY TU.Type_Trajet,
    CASE 
        WHEN DATEPART(HOUR, TU.Date_Heure) BETWEEN 6 AND 11 THEN 'Matin'
        WHEN DATEPART(HOUR, TU.Date_Heure) BETWEEN 12 AND 17 THEN 'Après-midi'
        WHEN DATEPART(HOUR, TU.Date_Heure) BETWEEN 18 AND 23 THEN 'Soir'
        ELSE 'Nuit' 
    END;

