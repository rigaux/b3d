.. _chap-cassandra_tp:
   
#############################
Cassandra - Travaux Pratiques
#############################

Les exercices qui suivent sont à effectuer sur machine, avec Cassandra.

Après avoir lancé votre machine Cassandra (avec docker, voir chapitre
:ref:`chap-docstruct`), vous aurez besoin d'une interface cliente pour y
accéder. Pour cela, nous utiliserons **DbVisualizer**,
voir le chapitre :ref:`chap-docstruct` pour des détails.


Si vous êtes à l'aise en ligne de commande, vous pourrez également accéder à Cassandra 
avec ``cqlsh`` qui se lance avec la commande suivante :

.. code-block:: bash

   sudo docker exec -it mon-cassandra cqlsh
   # ceci suppose que mon-cassandra est le nom de votre container
   # Option -it pour disposer d'un terminal interactif persistant
   # cqlsh pour lancer cette commande au démarrage

Le sujet des travaux pratiques est la mise en place d'une base de données représentant
des restaurants, et des inspections de ces restaurants. Un échantillon  de données
est disponible ici:

  * `La base Restaurants au format csv (archive ZIP)  <http://b3d.bdpedia.fr/files/restaurants.zip>`_

.. admonition:: Note

   Avant de vous lancer dans le travail proprement dit, vous êtes invités
   fortement à prendre le temps d'ouvrir cette archive zip et d'en examiner
   le contenu (au moins les en-têtes, pour avoir une première idée de la structure
   des données initiales).

Bien entendu,  on supppose qu'à terme cette base contiendra tous les restaurants du monde,
et toutes les inspections, ce qui justifie d'utiliser un système apte à gérer de grosses
volumétries.


********************************
Partie 1: Approche relationnelle
********************************

Nous allons étudier ici la création d'une base de données (appelée **Keyspace**), puis 
son interrogation. Cette première phase du TP consiste à créer la base comme si elle 
était relationnelle, et à effectuer des requêtes simples. Une fois les limites atteintes, nous 
utiliserons les spécificités de Cassandra
pour aller plus loin.

Création de la base de données
==============================

Avant d'interroger la base de données, il nous la créer. Pour commencer :

  .. code-block:: sql

    CREATE KEYSPACE IF NOT EXISTS resto_NY 
       WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor': 1};

Nous créons ainsi une base de données *resto_NY* pour laquelle le facteur de réplication 
est mis à 1, ce qui suffit dans un cadre centralisé. 

Sous ``csqlsh``, vous pouvez maintenant sélectionner la base 
de données pour vos prochaines requêtes. 

  .. code-block:: sql

      USE resto_NY;

Bien entendu vous 
pouvez exécuter ces commandes via DbVisualizer.

Tables
------

Nous pouvons maintenant créer les tables (*Column Family*
pour Cassandra) *Restaurant* et *Inspection* à partir du schéma suivant :

  .. code-block:: sql

    CREATE TABLE Restaurant (
      id INT, Name VARCHAR, borough VARCHAR, BuildingNum VARCHAR, Street VARCHAR,
      ZipCode INT, Phone text, CuisineType VARCHAR,
      PRIMARY KEY ( id )
    ) ;

    CREATE INDEX fk_Restaurant_cuisine ON Restaurant ( CuisineType ) ;

    CREATE TABLE Inspection (
      idRestaurant INT, InspectionDate date, ViolationCode VARCHAR,
      ViolationDescription VARCHAR, CriticalFlag VARCHAR, Score INT, GRADE VARCHAR,
      PRIMARY KEY ( idRestaurant, InspectionDate )
    ) ;	

   CREATE INDEX fk_Inspection_Restaurant ON Inspection ( Grade ) ;

Nous pouvons remarquer que chaque inspection est liée à un  restaurant via 
l'identifiant de ce dernier. 

Pour vérifier si les tables ont bien été créées (sous ``cqlsh``).

  .. code-block:: sql

      DESC Restaurant;
      DESC Inspection;

Nous pouvons voir le schéma des deux tables mais également des informations 
relatives au stockage dans la base *Cassandra*.

------------------
Import des données
------------------

Maintenant, nous pouvons importer les fichiers CSV pour remplir les *Column Family* :

  #. Décompresser le fichier 'restaurants.zip' (il contient le fichier 'restaurants.csv' et 'restaurants_inspections.csv')

        .. note:: En mode console, sur le répertoire de téléchargement du fichier *restaurants.zip*, il suffit de mettre la commande : 

           .. code-block:: bash

               unzip restaurants.zip

  #. Importer un fichier CSV :

    * Dans votre console (machine locale, pas docker), copier les fichiers sous "**Docker**" (container 'Cassandra')

        .. code-block:: bash

           docker cp path-to-file/restaurants.csv    docker-container-ID:/
           docker cp path-to-file/restaurants_inspections.csv    docker-container-ID:/

        .. note:: 
            Le chemin "*path-to-file*" correspond à l'endroit où a été décompressé le fichier restaurants.zip
            
            le docker-container-ID peut être récupéré grâce à la commande "*docker ps*". 
            
            .. code-block:: bash

               CONTAINER ID        IMAGE                     COMMAND              CREATED             STATUS              PORTS                                                                                                                                                                                                   NAMES
               b1fa2c7c255d        poklet/cassandra:latest   "/bin/sh -c start"   6 minutes ago       Up 6 minutes        0.0.0.0:32787->22/tcp, 0.0.0.0:32786->7000/tcp, 0.0.0.0:32785->7001/tcp, 0.0.0.0:32784->7199/tcp, 0.0.0.0:32783->8012/tcp, 0.0.0.0:32782->9042/tcp, 0.0.0.0:32781->9160/tcp, 0.0.0.0:32780->61621/tcp   cassandra
            
            le container-ID est : *b1fa2c7c255d* 

  3. Dans la console *cqlsh*, importer les fichiers '**restaurants.csv**' et '**restaurants_inspections.csv**'

        .. code-block:: sql

            use resto_NY ;
            COPY Restaurant (id, name, borough, buildingnum, street, 
                                zipcode, phone, cuisinetype)
               FROM '/restaurants.csv' WITH DELIMITER=',';
            COPY Inspection (idrestaurant, inspectiondate, violationcode,
                                violationdescription, criticalflag, score, grade)
               FROM '/restaurants_inspections.csv' WITH DELIMITER=',';
            
        .. note:: les fichiers sont copiés à la racine du container. Si vous changez le dossier de stockage, il faut bien sûr  l'indiquer dans l'instruction précédente.

          Vous pouvez vérifier l'existence des fichiers dans le container avec : 

           .. code-block:: bash

               ls /*.csv

Pour vérifier le contenu des tables:

  .. code-block:: sql

      SELECT count(*) FROM Restaurant;
      SELECT count(*) FROM Inspection;

Ce qui devrait vous indiquer environ 25 000 restaurants et 150 000 inspections. Nous
sommes prêts!

Interrogation
=============

Les requêtes qui suivent sont à exprimer avec **CQL** (pour *Cassandra Query Language*) 
qui est fortement inspirée de SQL.
Vous trouverez la syntaxe complète ici : 

<https://cassandra.apache.org/doc/latest/cql/dml.html#select>).

Requêtes CQL simples
--------------------

Pour la suite des exercices, exprimer en *CQL* les requêtes suivantes :

   #. Liste de tous les restaurants
   #. Liste des noms de restaurants
   #. Nom et quartier (*borough*) du restaurant dont l'id est 41569764
   #. Dates et grades des inspections de ce restaurant
   #. Noms des restaurants de cuisine Française (*French*)
   #. Noms des restaurants situés dans *BROOKLYN* (attribut *borough*; si vous recevez une erreur en retour notez-la bien) 
   #. Grades et scores donnés pour une inspection pour le restaurant n° 41569764 avec un score d'au moins 10
   #. Grades (non nuls) des inspections dont le score est supérieur à 30
   #. Nombre de lignes retournées par la requête précédente

.. ifconfig:: cassandratp in ('public')

   .. admonition:: Correction

    #. .. code-block:: sql
    
         SELECT * FROM Restaurant;
         
       .. note:: Sous ``cqlsh``, faire Ctrl+C pour annuler l'affichage de toutes les lignes 
       
       .. code-block:: sql
    
         SELECT * FROM Restaurant LIMIT 10;
         
       .. note:: Il est possible de ne montrer que 10 tuples 

    #. .. code-block:: sql
    
         SELECT Name FROM Restaurant;

    #. .. code-block:: sql
    
         SELECT Name, Borough FROM Restaurant WHERE id=41569764;
      
    #. .. code-block:: sql
    
         SELECT InspectionDate, Grade FROM Inspection WHERE idRestaurant=41569764 ;
      
    #. .. code-block:: sql

         SELECT Name FROM Restaurant WHERE cuisineType = 'French' ;

    #. .. code-block:: sql

         SELECT Name FROM Restaurant WHERE borough='BROOKLYN' ;

      L'erreur suivante apparaît :

      .. code-block:: sql
      
         Error from server: code=2200 [Invalid query] message="Cannot execute this query
          as it might involve data filtering and thus may have unpredictable performance.
          If you want to execute this query despite the performance unpredictability,
           use ALLOW FILTERING"
      
      Il suffit d'ajouter *ALLOW FILTERING* à la fin de la requête pour pouvoir l'exécuter.
      La requête précédente fonctionnait grâce à l'index qui 
      a été créé sur ``cuisineType`` et qui permet d'exécuter cette requête simplement.
      
      .. note:: Attention, dans le cadre de notre TP, cette requête est peu coûteuse. 
         Ce n'est pas toujours le cas.

      .. code-block:: sql

         SELECT Name FROM Restaurant WHERE borough='BROOKLYN' ALLOW FILTERING ;
      
    7. .. code-block:: sql

         SELECT Grade, Score FROM Inspection WHERE idRestaurant=41569764 AND score >= 10 ;
         
      Du fait de la présence de 2 critères dans la requête, dont un est indexé, 
      Cassandra ne peut prédire la taille du résultat et envoi un message d'alerte :

      .. code-block:: sql
      
         InvalidRequest: code=2200 [Invalid query] message=
            "Cannot execute this query as it might involve data filtering and thus may have 
            unpredictable performance. If you want to execute this query despite the 
            performance unpredictability, use ALLOW FILTERING"
      
      Il suffit d'ajouter *ALLOW FILTERING* à la fin de la requête pour pouvoir l'exécuter.
      
      .. note:: Attention, dans le cadre de notre TP, cette requête est peu coûteuse. Ce n'est 
         pas toujours le cas.

      .. code-block:: sql

         SELECT Grade, Score FROM Inspection WHERE idRestaurant=41569764 
         AND score >= 10 ALLOW FILTERING ;

    8. .. code-block:: sql

         SELECT Grade FROM Inspection WHERE score > 30 AND Grade > '' ALLOW FILTERING ;
      
       .. note:: L'opération "!=" n'existe pas en CQL, ni la valeur 'nulle'. De fait, 
          la valeur nulle pour un nombre est 0, et '' pour un texte.
          Ainsi, pour filtrer la valeur nulle, il faut faire "> ''".

    9. .. code-block:: sql

         SELECT COUNT(*) FROM Inspection WHERE score > 30 AND Grade > '' ALLOW FILTERING ;
      
       .. note:: L'opération affiche le résultat. Toutefois, des messages sont affichés pour montrer que de nombreuses lignes sont parcourues lors du traitement. Un message pour chaque 'bucket' stocké dans la base Cassandra.

CQL Avancé
----------

   #. Pour la requête ci-dessous faites en sorte qu'elle soit exécutable sans *ALLOW FILTERING*.

      .. code-block:: sql

         SELECT Name FROM Restaurant WHERE borough='BROOKLYN' ;

   #. Utilisons les deux indexes sur *Restaurant* (*borough* et *cuisineType*). Trouvez tous 
      les noms de restaurants français de Brooklyn.

   #. Utiliser la commande *TRACING ON* avant la d'exécuter à nouveau la requête pour 
      identifier quel index a été utilisé.

   #. On veut les noms des restaurants ayant au moins un grade 'A' dans leurs inspections. Est-ce
      possible en CQL?

.. ifconfig:: cassandratp in ('public')

   .. admonition:: Correction

    #. Il faut pour cela créer un index sur 'status' :    

      .. code-block:: sql

         CREATE INDEX Restaurant_borough ON Restaurant ( borough ) ;

      .. note:: Attention à ne pas exécuter la requête trop tôt après la 
         création de l'index, le résultat ne sera pas cohérent (message d'erreur). 
         Après quelques secondes la requête peut s'exécuter. 

    2. .. code-block:: sql

           SELECT Name FROM Restaurant WHERE borough = 'BROOKLYN' 
           AND cuisinType = 'French' ALLOW FILTERING ;

      .. note:: Les deux indexes ne peuvent être utilisés conjointement, 
        il faut donc filtrer normalement.

    3. En utilisant la commande *TRACING ON*, nous pouvons constater l'ensemble 
       de la *trace* de la requête (ou log d'exécution). Parmi toute la trace, 
       la ligne suivante est disponible au début :
    
      .. code-block:: text

            Index mean cardinalities are fk_restaurant_cuisine:1,restaurant_borough:1. 
            Scanning with fk_restaurant_cuisine.
      
      Cela nous permet de voir que l'index *fk_restaurant_cuisine* a été utilisé en priorité. 

    4. Naturellement, nous voudrions faire cela :

      .. code-block:: sql

         SELECT Name FROM Restaurant, Inspection 
         WHERE id = idRestaurant and Grade='A';
         
      ou
         
      .. code-block:: sql

           SELECT Name FROM Restaurant 
           WHERE id IN (SELECT idRestaurant FROM Inspection WHERE Grade='A');

      Sauf qu'il n'est pas possible de faire de jointures en CQL. 
      Le langage ne donnera aucune possibilité à cette requête.
      Nous allons étudier la solution par la suite.

***************************************
Partie 2: modélisation spécifique NoSQL
***************************************

La jointure n'est pas possible avec CQL, mais ce manque est partiellement compensé
par la possibilité d'imbriquer les données pour créer des documents qui
représentent, d'une certaine manière, le résultat pré-calculé de la jointure.

Cela suppose au préalable la détermination des requêtes à soumettre à la base
puisque les données ne sont plus symétriques, et privilégient de fait
certains types d'accès (cf. le cours sur la modélisation dans le chapitre
:ref:`chap-bddoc`). Plusieurs possibilités s'offrent à vous :

      * Type imbriqué
      * Utilisation d'un *map*.

Les exercices suivants vous proposent des besoins (requêtes). 
À vous de définir la bonne modélisation en utilisant l'une des possibilités
ci-desssus, et de vérifier qu'elle permet de satisfaire
ce type de recherche.

.. note:: Pour importer un gros fichier de documents JSon, nous avons 
   implémenté une application permettant de lire le document et de 
   l'importer dans une base (présent dans le fichier ``restaurants.zip``) ; 
     
   .. code-block:: bash

        java -jar JSonFile2Cassandra [-host <host>] [-port <port>] 
                    [-keyspace <keyspace>] [-columnFamily <columnFamily>] [file]
         
   Exemple : 
     
   .. code-block:: bash

          java -jar JSonFile2Cassandra.jar -host 192.168.99.100 -port 32783 
              -keyspace resto_NY -columnFamily InspectionRestaurant 
              -file InspectionsRestaurant.json

Premier besoin
==============

Notre besoin ici est de pouvoir sélectionner les restaurants en fonction de leur grade. On
voudrait par exemple répondre à la question::
    
     noms des restaurants ayant au moins un grade 'A' dans leurs inspections

Voici les étapes à suivre.

  #. Définir le modèle de document associant les restaurants et leurs inspections,
     en utilisant les types imbriqués,
     et créer la table.
      
     .. ifconfig:: cassandratp in ('public')

        .. admonition:: Correction
      
           #. Il faut imbriquer les restaurants dans les inspections.
              on crée un type et on l'intégre à la table 
              comme ceci :
    
           .. code-block:: sql
   
                CREATE TYPE Restaurant (
                    Name VARCHAR, borough VARCHAR, BuildingNum VARCHAR, Street VARCHAR,
                   ZipCode INT, Phone VARCHAR, CuisineType VARCHAR);
                CREATE TABLE InspectionRestaurant (
                   idRestaurant INT, InspectionDate date, ViolationCode VARCHAR,
                   ViolationDescription VARCHAR, CriticalFlag VARCHAR, Score INT, 
                   GRADE VARCHAR, Restaurant frozen<Restaurant>,
                  PRIMARY KEY ( idRestaurant, InspectionDate )
                 ) ;

  #. Insérer un document dans la table.
 
     .. ifconfig:: cassandratp in ('public')

        .. admonition:: Correction

           Voici un exemple.
           
           .. code-block:: sql

               INSERT INTO InspectionRestaurant JSON ' {"idRestaurant":40373938, 
                  "restaurant": {"name":"IHOP", "borough":"BRONX", "buildingnum":"5655",
                                 "street":"BROADWAY", "zipcode":"10463", 
                                 "phone":"7185494565", "cuisineType":"American"},
                 "inspectionDate":"2016-08-16", 
                 "violationCode":"04L", 
                 "violationDescription": "On voit des sourtis!.", 
                 "criticalFlag": "Critical", 
                 "score":15, 
                 "grade":"A"}';

  #. Faire l'import avec l'utilitaire d'insertion de documents JSON.
  
  #. Créer un index sur le *Grade* de la table **InspectionRestaurant**, 
     puis trouver les restaurants ayant reçu le grade 'A' au moins une fois.
      
     .. ifconfig:: cassandratp in ('public')

        .. admonition:: Correction
     
           .. code-block:: sql
   
              create index InspectionRestaurant_grade ON InspectionRestaurant ( Grade ) ;

              select Restaurant from InspectionRestaurant where grade = 'A';

      Malheureusement, les *types* imbriqués, *map*, *set* et *list* ne peuvent être 
      dissociés dans la clause *SELECT*. Il faut donc projeter l'ensemble des informations 
      du restaurant. On pourra constater que le nom du restaurant apparaît autant de fois 
      qu'il y a d'inspections. Ce qui rend cette requête un peu 
      moins efficace car elle demande d'interroger plus de ressources. Aucun ``distinct`` ne 
      peut être exécuté en dehors de la clé primaire. Bref, ce n'est pas vraiment satisfaisant.
      

Second besoin
=============
      
.. admonition:: Note

   Il semble qu'il y ait quelques corrections à effectuer dans les ...
   corrections que nous proposons ci-dessous. Ce sera fait prochainement.

Maintenant, on veut pouvoir rechercher les restaurants par leur quartier (*borough*). 

  #. Est-ce possible sur le schéma précédent?
  
     .. ifconfig:: cassandratp in ('public')

        .. admonition:: Correction

           Les types figés (``frozen``) sont traités comme des *blob*. De fait, 
           lorsque l'on souhaite les interroger, il faut filtrer sur l'ensemble du document 
           imbriqué (l'ensemble des 
           informations du restaurant), ce qui n'est pas gérable dans notre cas.

  #. Proposer un modélisation adaptée, et créer la table. Utiliser cette fois la solution
     du ``map`` avec la date d'insertion comme clé.
  
     .. ifconfig:: cassandratp in ('public')
    
        .. admonition:: Correction

         .. code-block:: sql

             CREATE TYPE Inspection (
               ViolationCode VARCHAR,
               ViolationDescription VARCHAR, CriticalFlag VARCHAR, Score INT, GRADE VARCHAR,
             ) ;
             CREATE TABLE RestaurantInspections (
                id INT, Name VARCHAR, borough VARCHAR, BuildingNum VARCHAR, Street VARCHAR,
                ZipCode INT, Phone VARCHAR, CuisineType VARCHAR,
                Inspections map<text, frozen<Inspection>>,
                PRIMARY KEY (id)
             );

  #. Insérer des données dans la nouvelle table, soit directement, soit avec l'utilitaire d'import.
  
     .. ifconfig:: cassandratp in ('public')

        .. admonition:: Correction

          .. code-block:: sql
        
              INSERT INTO RestaurantInspections JSON ' {"id":40373938, 
               "name":"IHOP", "borough":"BRONX", "buildingnum":"5655", "street":"BROADWAY",
               "zipcode":"10463", "phone":"7185494565", "cuisineType":"American",
               "inspections":{
                  "2016-08-16":{"violationCode":"04L", "violationDescription":
                    "Evidence of mice.", 
                    "criticalFlag":"Critical", "score":15, "grade":""},
                  "2014-02-20":{"violationCode":"08C", "violationDescription":
                    "Pesticide used!",
                    "criticalFlag":"Not Critical", "score":7, "grade":""},
                  "2014-03-11":{"violationCode":"10B", "violationDescription":
                    "Plumbing not properly installed.",
                    "criticalFlag":"Not Critical", "score":12, "grade":"A"}
                }}';

  #. Trouver tous les restaurants du Bronx.
  
     .. ifconfig:: cassandratp in ('public')

        .. admonition:: Correction

          .. code-block:: sql

               select * from inspectionRestaurant 
               where restaurant['borough'] = 'BRONX' allow filtering;

  #. Maintenant, on veut, sur cette second table, trouver tous les 
     restaurants ayant reçu une note 'A'. Est-ce possible? Chercher une
     solution permise par le fait que nous avons utilisé le type ``map``.

     .. ifconfig:: cassandratp in ('public')

        .. admonition:: Correction

          C'est de fait possible avec le type ``map``. On crée 
          un index sur le Grade de *RestaurantInspections* ;

          .. code-block:: sql
      
             CREATE INDEX RestaurantInspections_Grade ON RestaurantInspections ( Inspections.grade ) ;
   
          On peut alors écrire la requête en fonction du nouveau schéma :

          .. code-block:: sql
    
               SELECT Name FROM RestaurantInspections 
               WHERE Inspections.Grade='A' ALLOW FILTERING;

Bonus
=====

Pour pouvoir développer une application au dessus de Cassandra, il est nécessaire 
d'avoir un pilote ou *Driver*. Vous pourrez les trouver sur la page de **DataStaX** : 
<https://academy.datastax.com/all-downloads>

