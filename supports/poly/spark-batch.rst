.. _chap-spark:
   
################################################
Traitement de données massives avec Apache Spark
################################################

Avec le système Spark, nous abordons un premier exemple (sans doute le plus en
vogue au moment où ces lignes sont écrites)  d'environnements dédiés au calcul
distribué à grande échelle qui proposent des fonctionnalités bien plus
puissantes que le simple MapReduce des origines, toujours disponible dans
l'écosystème Hadoop.

Ces fonctionnalités consistent notamment en un ensemble d'opérateurs de second
ordre (voir cette notion dans le chapitre :ref:`chap-calcdistr`) qui étendent
considérablement la simple paire constituée du Map et du Reduce. Nous avons eu
un aperçu de ces opérateurs avec Pig, qui reste cependant lié  à un contexte
d'exécution MapReduce (un programme Pig est compilé et exécuté comme une
séquence de *jobs* MapReduce). 

Entre autres limitations, cela ne couvre pas une classe importante
d'algorithmes: ceux qui procèdent par *itérations*        sur un résultat
progressivement affiné à chaque exécution. Ce type d'algorithme est très
fréquent dans le domaine général de la fouille de données: PageRank, *kMeans*,
calculs de composantes connexes dans les graphes, etc.

Ce chapitre propose une introduction au système Spark.

*************************************************************
S3: Traitement de données structurées avec Cassandra et Spark
*************************************************************

.. admonition:: Supports complémentaires

    * `Vidéo  Spark: de Cassandra aux Datasets <https://mediaserver.lecnam.net/permalink/v125f5947d595jlokr2c/>`_  

Voyons maintenant les outils de traitement proposés par Spark sur des données
structurées issues, par exemple, d'une base de données, ou de collections de
documents JSON. On interagit dans ce cas évidemment de façon privilégiée avec
les *DataFrames* et les *Datasets*. On l'a dit, les deux structures sont
semblables à des tables relationnelles, mais la seconde est, de plus, fortement
typée puisqu'on connaît le type de chaque colonne. Cela simplifie
considérablement les traitements, aussi bien du point de vue du concepteur des
traitements que de celui du système.

  - Pour le concepteur, la possibilité de référencer des champs et de leur
    appliquer des opérations standard en fonction de leur type évite d'avoir à
    écrire une fonction spécifique pour la moindre opération, rend le code
    beaucoup lisible et concis.

  - Pour le système, la connaissance du schéma facilite les contrôles *avant*
    exécution (*compile-time checking*, par opposition au *run-time checking*),
    et permet une sérialisation très rapide, indépendante de la sérialisation
    Java, grâce à une couche composée d' *encoders*.
    

Nous allons en profiter pour instancier un début d'architecture réaliste en associant Spark à Cassandra
comme source de données. Dans une telle organisation, le stockage et le partitionnement sont assurés 
par Cassandra, et le calcul distribué par Spark. Idéalement, chaque nœud Spark traite un ou plusieurs
fragments d'une collection partitionnée Cassandra, et communique donc avec un des nœuds de la
grappe Cassandra. On obtient alors un système complètement distribué et donc *scalable*.

Préliminaires
=============

La base Cassandra que nous prenons comme support est celle des restaurants
New-Yorkais. Reportez-vous au chapitre :ref:`chap-cassandra_tp` pour la création
de cette base. Dans ce qui suit, on suppose que le serveur Cassandra est en
écoute sur la machine 192.168.99.100, port 32769 (si vous utilisez Cassandra
avec Docker, reportez-vous aussi aux manipulations vues en TP pour trouver les
bonnes valeurs d'IP et de port, qui sont probablement différentes de celles-ci).

Pour associer Spark et Cassandra, il faut récupérer le connecteur  sur la page
https://spark-packages.org/package/datastax/spark-cassandra-connector. Prenez la
version la plus récente, en tout cas celle correspondant à votre version de
Spark.

Vous obtenez un fichier jar. Pour qu'il soit pris en compte, le plus simple est
de le copier dans le répertoire ``jars`` de Spark. Lancez alors le *shell*
Spark. Il ne reste plus qu'à se connecter au serveur Cassandra en ajoutant la
configuration (machine et port) dans le contexte Spark. Exécutez donc au
préalable les commandes suivantes (en remplaçant la machine et le port par vos
propres valeurs, bien sûr).

.. code-block:: scala

   import org.apache.spark.sql.cassandra._
   import com.datastax.spark.connector.cql.CassandraConnectorConf
   import com.datastax.spark.connector.rdd.ReadConf

   // Paramètres de connexion
   spark.setCassandraConf("default", 
                      CassandraConnectorConf.ConnectionHostParam.option("192.168.99.100") 
                   ++ CassandraConnectorConf.ConnectionPortParam.option(32769))

.. admonition:: Pour les machines du CNAM

  On peut mettre en place rapidement la base Cassandra avec les données et un
  spark connecté à Cassandra en suivant les quelques lignes ci-dessous :

  1. On lance la machine Cassandra en tapant :

    .. code-block:: bash

      docker run --name mon-cassandra -p3000:9042 -d cassandra:latest

  2. On télécharge les données sur les restaurants et on décompresse le fichier :

    .. code-block:: bash

      wget b3d.bdpedia.fr/files/restaurants.zip
      unzip restaurants.zip

  3. On récupère l'id de notre container Cassandra :

    .. code-block:: bash

      docker ps

  4. On copie les fichiers sur la "machine" Cassandra

    .. code-block:: bash

      docker cp ./restaurants.csv <CONTAINER-ID>:/
      docker cp ./restaurants_inspections.csv <CONTAINER-ID>:/

  5. On ouvre un terminal cqlsh

    .. code-block:: bash

      docker exec -it mon-cassandra cqlsh

  6. On lance les commandes de création de la base de données, puis celles des
     tables, et enfin le remplissage des tables : voir
     http://b3d.bdpedia.fr/cassandra_tp.html#creation-de-la-base-de-donnees

  7. On télécharge dans un autre terminal le connecteur spark-cassandra :

    .. code-block:: bash

      wget https://b3d.bdpedia.fr/files/spark-cassandra-connector_2.11-2.3.0.jar

  8. On lance spark avec le jar obtenu :

    .. code-block:: bash

      spark-shell --jars ./spark-cassandra-connector_2.11-2.3.0.jar

  9. On utilise les options de connexion suivantes :

    .. code-block:: scala

       import org.apache.spark.sql.cassandra._
       import com.datastax.spark.connector.cql.CassandraConnectorConf
       import com.datastax.spark.connector.rdd.ReadConf

       // Paramètres de connexion
       spark.setCassandraConf("default", 
                          CassandraConnectorConf.ConnectionHostParam.option("127.0.0.1") 
                       ++ CassandraConnectorConf.ConnectionPortParam.option(3000))


Vous devriez pouvoir vérifier que la connexion fonctionne en interrogeant la table des restaurants.

.. code-block:: scala

   val restaurants_df = spark.read.cassandraFormat("restaurant", "resto_ny").load()
   restaurants_df.printSchema()
   restaurants_df.show()
 
.. note:: Il semble que le nom du *Keyspace* et de la table doivent être mis en minuscules.

Nous voici en présence d'un *DataFrame* Spark, dont le schéma (noms des colonnes) a été directement
obtenu depuis Cassandra. En revanche, les colonnes ne sont pas typées (on pourrait espérer
que le type est récupéré et transcrit depuis le schéma de Cassandra, mais ce n'est malheureusement
pas le cas). 

Pour obtenir un *Dataset* dont les colonnes sont typées, avec tous les avantages qui en
résultent, il faut définir une classe dans le langage de programmation (ici, Scala)
et demander la conversion, comme suit:

.. code-block:: scala

      case class Restaurant(id: Integer, Name: String, borough: String, 
                             BuildingNum: String, Street: String,
                             ZipCode: Integer, Phone: String, CuisineType: String)
   
      val restaurants_ds = restaurants_df.as[Restaurant]
      
Nous avons donc maintenant un *DataFrame* ``restaurant_df`` et un *Dataset* ``restaurant_ds``.
Le premier est une collection d'objets de type ``Row``, le second une collection d'objets de
type ``Restaurant``. On peut donc exprimer des opérations plus précises sur le second. 
Notons que tout cela
constitue une illustration pratique du compromis que nous étudions depuis le début de ce
cours sur la notion de document: vaut-il mieux des données au schéma très contraint, mais
offrant plus de sécurité, ou des données au schéma très flexible, mais beaucoup
plus difficile à manipuler?

Nous aurons également besoin des données sur les inspections de ces restaurants.

.. code-block:: scala

      case class Inspection (idRestaurant: Integer, InspectionDate: String, ViolationCode: String,
            ViolationDescription: String, CriticalFlag: String, Score: Integer, Grade: String)
   
      val inspections_ds = spark.read.cassandraFormat("inspection", "resto_ny").load().as[Inspection]

.. note:: Pour celles/ceux qui veulent expérimenter directement l'interface SQL de Spark,
   il existe une troisième option, celle de créer une "vue" sur les restaurants Cassandra avec la commande suivante:
   
    .. code-block:: scala

        val createDDL = """CREATE TEMPORARY VIEW restaurants_sql
                    USING org.apache.spark.sql.cassandra
                    OPTIONS (
                     table "restaurant",
                     keyspace "resto_ny")"""
        spark.sql(createDDL) 

        spark.sql("SELECT * FROM restaurants_sql").show



Traitements basés sur les *Datasets*
====================================


Nous allons illustrer l'interface de manipulation des  *Datasets* (elle
s'applique aussi au *DataFrames*, à ceci près qu'on ne peut pas exploiter
le typage précis donné par la classe des objets contenus dans la collection). 
Pour bien saisir la puissance
de cette interface, vous êtes invités à réfléchir à ce qu'il faudrait faire pour 
obtenir un résultat équivalent si on avait affaire 
à un simple RDD, sans schéma, avec donc la nécessité d'écrire une fonction à chaque
étape.

Commençons par les *projections* (malencontreusement référencées par la mot-clé
``select`` depuis les débuts de SQL) consistant à ne conserver que certaines colonnes.
La commande suivante ne conserve que trois colonnes.

.. code-block:: scala

    val restaus_simples = restaurants_ds.select("name", "phone", "cuisinetype")

    restaus_simples.show()
    
Voici maintenant comment
on effectue une sélection (avec le mot-clé ``filter``, correspondant au ``where`` de SQL).

.. code-block:: scala

    val manhattan = restaurants_df.filter("borough =  'MANHATTAN'")
    
    manhattan.show()

Par la suite, nous omettons l'appel à *show()* que vous pouvez ajouter si vous souhaitez
consulter le résultat.

L'interface *Dataset* offre une syntaxe légèrement différente qui permet de tirer parti du fait
que l'on a affaire à une collection d'objets de type ``Restaurant``. On peut donc passer 
en paramètre une expression booléenne Scala qui prend un object ``Restaurant``
en entrée et renvoie un Booléen.

.. code-block:: scala

       val r = restaurants_ds.filter(r => r.borough == "MANHATTAN")

Ce type de construction permet un typage statique (au moment de la compilation)
qui garantit qu'il n'y aura pas de problème au moment de l'exécution.

On peut effectuer des agrégats, comme par exemple le regroupement des
restaurants par arrondissement (*borough*):

.. code-block:: scala

    val comptage_par_borough = restaurants_ds.groupBy("borough").count()

Tout cela aurait aussi bien pu s'exprimer en CQL (voir exercices). Mais Spark
va définitivement plus loin en termes de capacité de traitements,
et propose notamment la fameuse opération de jointure qui nous a tant manqué 
jusqu'ici. 

.. code-block:: scala

     val restaus_inspections = restaurants_ds
            .join(inspections_ds, restaurants_ds("id") === inspections_ds("idRestaurant"))
   
  
Le traitement suivant effectue la moyenne des votes pour les restaurants de Tapas.

.. code-block:: scala

     val restaus_stats = restaurants_ds.filter("cuisinetype > 'Tapas'")
           .join(inspections_ds, restaurants_ds("id") === inspections_ds("idRestaurant"))
           .groupBy(restaurants_ds("name"))
          .agg(avg(inspections_ds("score")))
  

Mise en pratique
================


.. _MEP-SPark-3: 
.. admonition:: Exercice `MEP-SPark-3`_: à vous de jouer

   La mise en pratique de cette session est plus complexe. Si vous choisissez de vous y lancer, 
   vous aurez un système quasi complet (à toute petite échelle) de stockage et de calcul distribué.


*********
Exercices
*********

.. _Ex-Spark-1:
.. admonition:: Exercice `Ex-Spark-1`_: Réfléchissons aux traitements  itératifs
 
   Le  but de cet exercice est de modéliser le calcul d'un algorithme itératif
   avec Spark. Nous allons prendre comme exemple celui que nous connaissons déjà: PageRank.
   On prend comme point de départ un ensemble de pages Web contenant des liens, stockés
   dans un système comme, par exemple, Elastic Search.
   
   Pour l'instant il ne vous est pas demandé de produire du code, mais de réfléchir et d'exposer
   les principes, et notamment la gestion des RDD.
   
     - Partant d'un stockage distribué de pages Web, 
       quelle chaîne de traitement permet de produire la représentation matricielle du graphe de PageRank ?
       Quelles opérations sont nécessaires et où stocker le résultat?
     - Quelle chaîne de traitement permet de calculer, à partir du graphe, 
       le vecteur des PageRank? Vous pouvez fixer un nombre d'itérations (100, 200) 
       ou déterminer une condition d'arrêt (beaucoup plus difficile).
       Indiquez les RDD le long de la chaîne complète.
     - Indiquez finalement quels RDD  devraient être marqués persistants. Vous 
       devez prendre en considération deux critères: amélioration des performances et 
       diminution du temps de reprise sur panne.

    .. ifconfig:: spark1 in ('public')

       .. admonition:: Correction
        
            - Pour chaque document (une page web),  il faut
              extraire la liste des liens *sortants* (donc, dans le cas du HTML,
              toutes les balises ``<a href='lien' .../>``. Il s'agit typiquement d'une
              opération de *Map*, sans *Reduce*! La clé d'émission est l'URL de la page analysée,
              la valeur est la liste des URL sortantes. 
              
              Possibilité plus paresseure: on émet chaque lien au fur et à mesure de leur
              rencontre, et on ajoute après le *Map* une opération de regroupement par clé. Cela semble cependant
              un peu idiot de disperser les liens pour les regrouper ensuite. Dans tous les cas
              on obtient un RDD ``Matrix`` avec tous les vecteurs de la matrice PageRank. Chaque
              unité d'information (chaque "document") dans ce RDD est donc de la forme
              
              .. math::
              
                   (u, V_u[u_i, u_j, \cdots])
              
              où chaque :math:`u^x` est un lien sortant de :math:u`. NB: on ne représente
              pas une matrice avec des 0 et des 1, à l'échelle du Web ce serait 
              
            - Deuxième étape: on dispose de la matrice. Il faut 
              évaluer la probabilité d'aboutir à une page :math:`u'`. 
              Initialement, on suppose que l'on part de n'importe que page :math:`u` et on simule un processus
              aléatoire de déplacement qui nous donne la probablité d'arriver 
              à :math:`u'`.  À chaque étape :math:`i`, ces probabilités sont représentés par un RDD dit 
              "des rangs",  :math:`Rank_i`, dont chaque
              unité d'information (chaque "document") est de la forme
              
              .. math::
              
                 (u, p_u)
              
              Où :math:`p_u` est la probablité d'être arrivé en :math:`u`. Initialement cette probabilité
              dans :math:`Rank_0` est égale à 1: on suppose que l'on part de :math:`u`.
              
              Effectuons une **jointure** (sur l'URL)
              entre ``Matrix`` et ``Rank``. On obtient, pour chaque URL ``u``, des unités
              d'information de la forme
              
              .. math::
              
                  (u, V_u[u_i, u_j, \cdots, u_k, \dots], p_u)
                  
              On effectue alors un calcul simulant le choix aléatoire et équiprobable de suivre
              un des liens sortants de ``u``. La probabilité de suivre chacun des  liens sortants 
              est :math:`p_u / |V_u|`. On doit donc produire:
              
              .. math::
              
                  (u_i, p_u / |V_u|) \\
                  (u_j, p_u / |V_u|)\\
                    \cdots\\
                  (u_k, p_u / |V_u|)\\
                  
            
              Chacune de ces paires :math:`(u', p^{u'}_u)`
              est la probabilité :math:`p^{u'}_u` d'arriver sur l'URL *en provenance de u*. Il reste
              à cumuler toutes ces probabilités pour toutes les provenances possibles. **Ces paires
              sont produites par une opération de Map**.
               
              Et finalement il faut obtenir la probabilité de se retrouver sur 
              un lien ``u'`` en cumulant les probabilités d'arriver sur ``u'`` en provenance
              de toutes les  URLs ``u`` dont ``u'`` est un lien sortant. **C'est une opération
              de Reduce** (ou de regroupement par clé, ce qui revient au même).
              
              Il faut itérer un certain nombre de fois (10 ou 20 fois). À chaque itération 
              on obtient les rangs dans nouveau RDD qui sert d'entrée à la prochaine itération.
              
              En résumé, à chaque étape *i*:
              
                - On effectue la jointure entre ``Matrix`` et :math:`Rank_i`
                - On applique un *Map* qui émet des paires :math:`(u', p^{u'}_u)`
                - On applique un *Reduce* qui regroupe sur la clé :math:`u'` et 
                  cumule les probabilités :math:`p^{u'}_u` pour toutes les provenances :math:`u`
                     
            - Quels RDD marquer comme persistants? Il faut évidemment ne pas 
              recalculer ``Matrix`` à chaque itération, et le conserver en RAM pour ne 
              pas dégrader les calculs. 
              
              Si on fait beaucoup d'itérations, il faut envisager la situation en cas de panne:
              sans persistance intermédiaire il faudra recommencer les calculs à zéro. On peut
              donc rendre pesistants les RDD stockant les calculs intermédiaires, au moins quelques-uns
              (1 sur 5?).

              https://github.com/abbas-taher/pagerank-example-spark2.0-deep-dive



.. _Ex-Spark-2: 
.. admonition:: Exercice: `Ex-Spark-2`_ qu'est-il arrivé à CQL?

   Vous avez sans doute noté que Spark  surpasse CQL. On peut donc envisager
   de se passer de ce dernier, ce qui soulève quand même un inconvénient majeur (lequel?).
   Le connecteur Spark/Cassandra permet de déléguer les transformations Spark
   compatibles avec CQL grâce à un paramètre *pushdown* qui est activé par défaut.
   
     - Enoncez clairement l'inconvénient d'utiliser Spark en remplacement de CQL.
     - Etudiez le rôle et fonctionnement de l'option  *pushdown* dans la documentation
       du connecteur.
     - Quelles sont les requêtes parmi celles vues ci-dessus qui peuvent être
       transmises à CQL?

   .. ifconfig:: flink2 in ('public')

      .. admonition:: Correction
  
         L'inconvénient majeur est que l'on va effectuer un transfert entre Cassandra et Spark
         de données qui vont ensuite être immédiatement filtrées. Il serait bien préférable
         d'effectuer ce filtre dès l'origine avec une requête CQL.
         
         La fonction "pushdown" a justement pour but de transférer les clauses qui peuvent l'être
         de Spark vers CQL.

Et pour aller plus loin
=======================

.. _Ex-Spark-3: 
.. admonition:: Exercice `Ex-Spark-3`_: plans d'exécution

   Avec l'interface de Spark vous pouvez consulter le graphe d'exécution de chaque
   traitement. Comme nous sommes passés avec l'API des *DataFrame* à un niveau beaucoup
   plus *déclaratif*, cela vaut la peine de regarder, pour chaque traitement 
   effectué (et notamment la jointure) comment Spark évalue le résultat avec des
   opérateurs distribués.
   
 
.. _Ex-Spark-4: 
.. admonition:: Exercice `Ex-Spark-4`_: exploration de l'interface *Dataset*

   L'API des *Datasets* est présentée ici:
     
     https://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.sql.Dataset
     
   Etudiez et expérimentez les transformations et actions décrites.

 
 
.. _Ex-Spark-5: 
.. admonition:: Exercice `Ex-Spark-5`_: Cassandra et Spark, système distribué complet

   En associant Cassandra et Spark, on obtient un environnement distribué complet, Cassandra
   pour le stockage, Spark pour le calcul. La question à étudier (qui peut faire l'objet
   d'un projet), c'est la bonne intégration de ces deux systèmes, et notamment la correspondance
   entre le partitionnement du stockage  Cassandra et le partitionnement des calculs Spark. 
   Idéalement, chaque fragment d'une collection Cassandra devrait devenir un fragment
   RDD dans Spark, et l'ensemble des fragments traités en parallèle. À approfondir !
