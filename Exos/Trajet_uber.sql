select * from Chauffeurs_Uber;
select * from Clients_Uber;
select * from Trajets_Uber;
/*Exercice 1 : Clients �conomiques et critiques*/

SELECT  Pr�f�rences, AVG(D�pense_Totale) AS Moyenne_D�penses, AVG(Evaluations_Chauffeurs) AS Moyenne_Evaluations
 FROM Clients_Uber
  WHERE Pr�f�rences = 'Eco'
   GROUP BY Pr�f�rences, ID_Client
    HAVING AVG(D�pense_Totale) > 3000 AND AVG(Evaluations_Chauffeurs) < 3;

/*Exercice 2 : Chauffeurs anglophones du matin � haute �valuation*/
Select *
 from Chauffeurs_Uber
  where Langues_Parl�es='Anglais'
   and Evaluation >4 
    and Disponibilit�='Matin';

 /*Exercice 3 : Trajets difficiles en haute congestion*/
 Select  *
  from Trajets_Uber
   where Notes_Client='Mauvais'
    and  Conditions_Traffic='Elev�'
     and Distance >20;

 /*Exercice 4 : Pr�f�rences musicales sur trajets sp�cifiques */

Select a.Pr�f�rences_Musique,
    b.Type_Trajet from Clients_Uber a
     left join   Trajets_Uber b 
      on a.ID_Client=B.ID_Client
       where Type_Trajet='UberBlack';

/*Exercice 5 : Performance des chauffeurs sur trajets en heure de pointe */

Select a.ID_Chauffeur,b.ID_Trajet, a.Evaluation,b.Conditions_Traffic
  from Chauffeurs_Uber a
   left join Trajets_Uber b
    on  a.ID_Chauffeur= b.ID_Chauffeur
     where b.Conditions_Traffic='Elev�';
  
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

/*Exercice 7 : Prix moyen des trajets par langue parl�e des chauffeurs*/
Select a.Langues_Parl�es,
 avg(b.prix) AS Moyen_prix
  from Chauffeurs_Uber a
   left join Trajets_Uber b
    on a.ID_Chauffeur= b.ID_Chauffeur
     group by a.Langues_Parl�es;

/*Exercice 8 : Comptage des clients fid�les et occasionnels*/
Select 
  case 
     when Nombre_Trajets > 30 then 'Clients fid�les'
	 else 'Client occasionnels'
     end as Cat�gorie_Client,
        count(*) as Nombre_Clients
         from Clients_Uber
           group by case    
		    when Nombre_Trajets > 30 then 'Clients fid�les'
	        else 'Client occasionnels'
            end ;

/*Exercice 9 : Cat�gorisation des trajets par Prix*/
select 
	Case  
		When prix < 10 then 'Prix Bas'
		When  Prix between 10 and 30 then 'Prix Moyen'
		Else 'Prix �lev�'
	End As Cat�gorie_Trajet,
	 COUNT(*) as 'Nombre de Trajet'
      From Trajets_Uber
       Group by 
		Case 
			When prix < 10 then 'Prix Bas'
			when  Prix between 10 and 30 then 'Prix Moyen'
		    Else 'Prix �lev�'
	    End;

/*Exercice 10 : Classification des chauffeurs selon le nombre de trajets*/
select 
	case 
	     when Nombre_Trajets > 50 then 'D�butant'
	     when Nombre_Trajets between  50 and 150 then'Exp�riment�'
	     else 'v�t�ran'
    end as 'Cat�gorie Chauffeur',
	     round(avg(Evaluation),2) as 'Evaluation moyenne'
	       from Chauffeurs_Uber
	        group by 
		     case
			     when Nombre_Trajets > 50 then 'D�butant'
		         when Nombre_Trajets between  50 and 150 then'Exp�riment�'
		         else 'v�t�ran'
		     end;

/*Exercice 11 : Analyse des tendances de paiement des clients*/

SELECT Moyen_Paiement, ROUND(AVG(D�pense_Totale),2) AS Montant_Moyen_D�pens�
	FROM Clients_Uber
	 WHERE Nombre_Trajets >= 10 AND D�pense_Totale > 500
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
    End as 'Cat�gorie Chauffeur',
	   COUNT(*) as 'Nombre Total',
	    ROUND(SUM(distance_totale),2) as 'Distance Totale', 
	     ROUND(AVG(evaluation),2) as 'Evaluation moyenne'
          from Chauffeurs_Uber
           Group by 
	        Case 
			      When Nombre_Trajets >100 then  'Plus de 100 Trajets'
	              Else 'Moinsde 100 Trajets'
	        End;

/*Exercice 14 : Profil des clients selon la d�pense totale*/
SELECT
    CASE
        WHEN Nombre_Trajets < 100 THEN 'Moins de 100 trajets'
        ELSE '100 trajets ou plus'
    END AS Cat�gorie_Trajets,
         COUNT(*) AS Nombre_Total_Chauffeurs,
          SUM(Distance_Totale) AS Distance_Totale,
           AVG(Evaluation) AS Evaluation_Moyenne
             FROM Chauffeurs_Uber
               GROUP BY
                 CASE
                     WHEN Nombre_Trajets < 100 THEN 'Moins de 100 trajets'
                     ELSE '100 trajets ou plus'
                  END;
/*Exercice 15 : Analyse d�taill�e des performances des chauffeurs*/
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
		     HAVING COUNT(*) > 10; /*Afficher uniquement les cat�gories avec plus de 10 chauffeurs*/

/*Exercice 16 : Analyse des pr�f�rences musicales des clients et impact sur les �valuations des chauffeurs */
SELECT 
 Pr�f�rences_Musique,
  COUNT(a.ID_Trajet) AS Nombre_Trajets,
   ROUND( AVG(b.Evaluations_Chauffeurs),1) AS Evaluation_Moyenne_Chauffeurs,
    ROUND( AVG(a.Prix / a.Nombre_Passagers),1) AS Revenu_Moyen_Par_Trajet
      FROM Clients_Uber b
       LEFT JOIN Trajets_Uber a ON b.ID_Client = a.ID_Client
        GROUP BY Pr�f�rences_Musique
         ORDER BY Pr�f�rences_Musique;

/*Exercice 17 : Corr�lation entre la formation en s�curit� et la performance des chauffeurs */
SELECT a.ID_Chauffeur,
    CASE 
        WHEN Formation_S�curit� = 1 THEN 'Suivi'
        ELSE 'Non Suivi' 
    END AS Formation_S�curit�,
     COUNT(b.ID_Trajet) AS Nombre_Trajets,
      CASE 
         WHEN AVG(Evaluation) < 3 THEN 'Faible'
         WHEN AVG(Evaluation) >= 3 AND AVG(Evaluation) <= 4 THEN 'Moyenne'
         ELSE 'Haute' 
      END AS Cat�gorie_Evaluation
       FROM Chauffeurs_Uber a
        LEFT JOIN Trajets_Uber b ON a.ID_Chauffeur = b.ID_Chauffeur
         GROUP BY a.ID_Chauffeur, Formation_S�curit�
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
        WHEN DATEPART(HOUR, TU.Date_Heure) BETWEEN 12 AND 17 THEN 'Apr�s-midi'
        WHEN DATEPART(HOUR, TU.Date_Heure) BETWEEN 18 AND 23 THEN 'Soir'
        ELSE 'Nuit' 
    END AS P�riode_Journ�e,
    COUNT(CASE WHEN TU.Conditions_Traffic = 'Faible' THEN TU.ID_Trajet END) AS Nombre_Trajets_Faible_Trafic,
    COUNT(CASE WHEN TU.Conditions_Traffic = 'Moyen' THEN TU.ID_Trajet END) AS Nombre_Trajets_Moyen_Trafic,
    COUNT(CASE WHEN TU.Conditions_Traffic = '�lev�' THEN TU.ID_Trajet END) AS Nombre_Trajets_�lev�_Trafic
FROM Trajets_Uber TU
LEFT JOIN Chauffeurs_Uber CU ON TU.ID_Chauffeur = CU.ID_Chauffeur
WHERE YEAR(TU.Date_Heure) = YEAR(GETDATE()) - 1
GROUP BY TU.Type_Trajet,
    CASE 
        WHEN DATEPART(HOUR, TU.Date_Heure) BETWEEN 6 AND 11 THEN 'Matin'
        WHEN DATEPART(HOUR, TU.Date_Heure) BETWEEN 12 AND 17 THEN 'Apr�s-midi'
        WHEN DATEPART(HOUR, TU.Date_Heure) BETWEEN 18 AND 23 THEN 'Soir'
        ELSE 'Nuit' 
    END;

