select * from departementsCSV;
select * from projetsCSV;
select * from employes_projetsCSV;
select * from employesCSV;


/*Exercice 1 : Association Employés-Départements*/

select employesCSV.nom, departementsCSV.nom_departement
from employesCSV
inner join departementsCSV
on employesCSV.id = departementsCSV.id;

/*Exercice 2 : Détails des projets et chefs de projets*/

select employesCSV.nom , projetsCSV.nom_projet
from employesCSV
inner join  projetsCSV
on employesCSV.id = projetsCSV.id; 

/*Exercice 3 : Employés sans projets*/

select employesCSV.nom , employes_projetsCSV.id_projet
from employesCSV
left join employes_projetsCSV
on employesCSV.id = employes_projetsCSV.id_employe
where id_projet is NULL ;

/*  Exercice 4 : Tous les employés et leurs projets */

select employesCSV.nom , employes_projetsCSV.id_projet , projetsCSV.nom_projet
from employesCSV
left join employes_projetsCSV
on  employesCSV.id =employes_projetsCSV.id_employe
left join projetsCSV
on employesCSV.id =projetsCSV.id;

/*Exercice 5 : Calcul du salaire moyen par département*/
select departementsCSV.nom_departement , avg(employesCSV.salaire) as  Salaire_moyen
from departementsCSV
left join employesCSV
on departementsCSV.id = employesCSV.id_departement
group by  departementsCSV.nom_departement;

/*Exercice 6 : Budget total des projets par chef de projet*/

select employesCSV.nom, sum(projetsCSV.budget)
from employesCSV
left join projetsCSV
on employesCSV.id =projetsCSV.id
group by employesCSV.nom;

/*Exercice 7 : Analyse de la masse salariale par département*/
 select departementsCSV.nom_departement, sum(employesCSV.salaire) as Masse_salariale
 from departementsCSV
 left join employesCSV
 on departementsCSV.id =employesCSV.id_departement
 group by departementsCSV.nom_departement;

 /* Exercice 8 : Allocation des ressources aux projets*/
 select  projetsCSV.nom_projet,count(employesCSV.nom) as Total_Employes
 from employesCSV 
 left join projetsCSV
 on projetsCSV.id_chef = employesCSV.id
 group by  projetsCSV.nom_projet;

/* Exercice 9 : Performance des départements*/

 SELECT departementsCSV.nom_departement, COUNT(employesCSV.id) AS nombre_employes_impliques
FROM departementsCSV
LEFT JOIN employesCSV  ON departementsCSV.id = employesCSV.id_departement
LEFT JOIN employes_projetsCSV   ON departementsCSV.id = employes_projetsCSV.id_employe
GROUP BY  departementsCSV.nom_departement
ORDER BY nombre_employes_impliques DESC; 

/*Exercice 10 : Projet avec le moins de ressources allouées*/

SELECT projetsCSV.nom_projet , COUNT(employes_projetsCSV.id_employe) AS nombre_employes_affectes
FROM projetsCSV
LEFT JOIN employes_projetsCSV  ON projetsCSV.id = employes_projetsCSV.id_projet
GROUP BY projetsCSV.nom_projet
ORDER BY nombre_employes_affectes ASC;

/*Exercice 11 : Optimisation des coûts des projets*/

select  id , nom_projet
from projetsCSV
where budget > (select AVG(budget) from projetsCSV);


