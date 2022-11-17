.. _chap-bddoc_tp:
   
###############################################
MongoDB - Travaux Pratiques
###############################################

Les exercices qui suivent sont à effectuer sur machine, avec MongoDB.


Supports complémentaires:

  * `La base bibliographique DBLP au format JSON  <http://b3d.bdpedia.fr/files/dblp.json.zip>`_
  * `La base des villes au format CSV  <http://b3d.bdpedia.fr/files/cities15000.csv.zip>`_
  
  
********************
Manipulation de base
********************

Comme vu en cours, il s'agit de créer une base, une collection, d'y insérer des données et de l'interroger.
Les documents fournis correspondent à un extrait d'une base de publications scientifiques, 
`The DBLP Computer Science Bibliography <http://dblp.org>`_.

Gestion de collection
=====================

Voici le résumé des commandes à effectuer.

  * Se connecter à la base DBLP : ``use DBLP;``
  * Créer une collection "publis" : ``db.createCollection('publis');``
  * Créer le document suivant (astuce pour le client ``mongo``: le mettre sur une ligne; 
    c'est plus facile avec un client graphique type RoboMongo): 
  
    .. code-block:: javascript
    
      { 
        "type": "Book",
        "title": "Modern Database Systems: The Object Model, Interoperability, and Beyond.",
        "year": 1995,
        "publisher": "ACM Press and Addison-Wesley", 
        "authors": ["Won Kim"], 
        "source": "DBLP"
      }
      
  * Insérer le document dans la collection ``publis`` avec ``db.publis.save(...);``
  * Créer et insérer deux autres publications à partir de cette page de conférence type "*Article*" (Vue "BibTeX") :
  	http://www.informatik.uni-trier.de/~ley/db/journals/vldb/vldb23.html
  * Consulter le contenu de la collection : ``db.publis.find();``
  * Importer les données du TP dans MongoDB :

    1. Télécharger le fichier contenant les données : `DBLP.json.zip <http://b3d.bdpedia.fr/files/dblp.json.zip>`_

    2. Décompresser le fichier ``dblp.json.zip``

    3. Dans le même répertoire, lancer l'importation du fichier :

       .. code-block:: bash
 
         mongoimport --host localhost:27017 --db DBLP --collection publis  --jsonArray --type json --file dblp.json

   .. note:: Le chemin vers l'exécutable ``mongoimport`` est nécessaire, ou la variable d'environnement ``PATH`` 
      contenant le chemin vers ``mongo/bin``.
      L'opération peut prendre quelques secondes (118000 items à insérer)
   
  * Dans la console ``mongo`` vérifier que les données ont été insérées : ``db.publis.count();``


Interrogation simple
====================

Exprimez des requêtes simples (pas de MapReduce) pour les recherches suivantes :

  #. Liste de tous les livres (type "Book") ;
  #. Liste des publications depuis 2011 ;
  #. Liste des livres depuis 2014 ;
  #. Liste des publications de l'auteur "Toru Ishida" ;
  #. Liste de tous les éditeurs (type "publisher"), distincts ;
  #. Liste de tous les auteurs distincts ;
  #. Trier les publications de "Toru Ishida" par titre de livre et par page de début ;
  #. Projeter le résultat sur le titre de la publication, et les pages ;
  #. Compter le nombre de ses publications ;
  #. Compter le nombre de publications depuis 2011 et par type ;
  #. Compter le nombre de publications par auteur et trier le résultat par ordre croissant ;

.. ifconfig:: mongodbtp in ('public')

   .. admonition:: Correction

    #. ``db.publis.find({"type" : "Book"});``
    #. ``db.publis.find({year : {$gte : 2011}});``
    #. ``db.publis.find({"type" : "Book", year : {$gte : 2014}});``
    #. ``db.publis.find({authors : "Toru Ishida"});``
    #. ``db.publis.distinct("publisher");``
    #. ``db.publis.distinct("authors");``
    #. ``db.publis.aggregate([{$match:{authors : "Toru Ishida"}}, { $sort : { booktitle : 1, "pages.start" : 1 } }]);``
    #. ``db.publis.aggregate([{$match:{authors : "Toru Ishida"}}, {$sort : { booktitle : 1, "pages.start" : 1 }}, {$project : {title : 1, pages : 1}}]);``
    #. ``db.publis.aggregate([{$match:{authors : "Toru Ishida"}}, {$group:{_id:null, total : { $sum : 1}}}]);``
    #. ``db.publis.aggregate([{$match:{year : {$gte : 2011}}}, {$group:{_id:"$type", total : { $sum : 1}}}]);``
    #. ``db.publis.aggregate([{ $unwind : "$authors" }, { $group : { _id : "$authors", number : { $sum : 1 } }}, {$sort : {number : -1}}] );``


**********************
Pratique de Map/Reduce
**********************

Commandes pour retrouver l'environnement de travail complet
===========================================================

Sur les machines du CNAM, le serveur ``mongod`` tourne déjà : en ouvrant une
console puis en saisissant successivement les commandes ci-dessous, vous
devriez retrouver un robo3T fonctionnel.

.. code-block:: bash

   wget http://b3d.bdpedia.fr/files/dblp.json.zip
   unzip dblp.json.zip
   mongoimport -d dblp -c publis --file dblp.json --jsonArray

   wget https://download.robomongo.org/1.2.1/linux/robo3t-1.2.1-linux-x86_64-3e50a65.tar.gz
   tar -xvzf robo3t-1.2.1-linux-x86_64-3e50a65.tar.gz
   cd robo3t-1.2.1-linux-x86_64-3e50a65/bin/
   ./robo3t

Sur une machine personnelle, il sera peut-être nécessaire de lancer le serveur
MongoDB et de modifier éventuellement les paramètres du ``mongoimport``.

Quelques rappels
================

Pour exprimer une requête MapReduce, il faut définir une fonction de *map*,
une fonction de *reduce*, un filtre (optionnel), lancer le tout 
avec l'opérateur ``mapReduce`` et consulter le résultat (optionnel!). Soit:

============  ============================================================================
**map**       ``var mapFunction = function () {emit(this.year, 1);};``
------------  ----------------------------------------------------------------------------
**reduce**    ``var reduceFunction = function (key, values) {return Array.sum(values);};``
------------  ----------------------------------------------------------------------------
**filtre**    ``var queryParam = {query : {}, out : "result_set"}``
------------  ----------------------------------------------------------------------------
**requête**   ``db.publis.mapReduce(mapFunction, reduceFunction, queryParam);``
------------  ----------------------------------------------------------------------------
**résultat**  ``db.result_set.find();``
============  ============================================================================


En cas de doute, revoir le chapitre :ref:`chap-docstruct`. 

Mappez et réducez
=================

Pour les recherches suivantes, donnez la requête MapReduce sur la base en changeant la requête Map et/ou Reduce

  #. Pour chaque document de type livre, émettre le document avec pour clé "title"
  #. Pour chacun de ces livres, donner le nombre de ses auteurs
  #. Pour chaque livre publié par Springer et composé de chapitres (ayant
       l'attribut "booktitle"), donner le nombre des chapitres.

   .. attention:: la fonction de *reduce* n'est évaluée que lorsqu'il y a au moins 2 documents pour une même clé. Il est donc nécessaire d'appliquer un filtre *après* génération du résultat.

  4. Pour l'éditeur "Springer", donner le nombre de publications par année
  #. Pour chaque couple "publisher & année" (il faut que publisher soit présent), donner le nombre de publications.

   .. important:: la clé du ``emit()`` doit être un document. 

  6. Pour l'auteur "Toru Ishida", donner le nombre de publications par année
  #. Pour l'auteur "Toru Ishida", donner le nombre moyen de pages pour ses articles (type Article)
  #. Pour chaque auteur, lister les titres de ses publications

    .. attention:: la sortie du *map* et du *reduce* doit être un document (pas un tableau)

  9. Pour chaque auteur, lister le nombre de publications associé à chaque année
  #. Pour l'éditeur "Springer", donner le nombre d'auteurs par année
  #. Compter les publications de plus de 3 auteurs 
  #. Pour chaque éditeur, donner le nombre moyen de pages par publication 
  #. Pour chaque auteur, donner le minimum et le maximum des années avec des publications, ainsi que le nombre total de publications


.. ifconfig:: mongodbtp2 in ('public')

   .. admonition:: Correction

       #. .. code-block:: javascript
    
             var mapFunction = function () {
               if (this.type == "Book") 
                  emit(this.title, this);
              };

              var reduceFunction = function (key, values) {
                 return {articles : values};
               };

              var queryParam = {query:{}, out:"result_set"};
       
          ou

          .. code-block:: javascript
       
              var mapFunction = function () {emit(this.title, this);};

              var reduceFunction = function (key, values) {
                return {articles : values};
              };

              var queryParam = {query:{type : "Book"}, out:"result_set"};

          .. note:: Peut être plus efficace si un index est présent sur le type

       #. .. code-block:: javascript

             var mapFunction = function () {
               if(this.type == "Book")
                 emit(this.title, this.authors.length);
               };

              var reduceFunction = function (key, values) {
                return {articles : values};
              };

              var queryParam = {query:{}, out:"result_set"};
           
       #. .. code-block:: javascript
       
              var mapFunction = function () {
                 if(this.publisher=="Springer" && this.booktitle)
   	               emit(this.booktitle, 1);
   	             };

              var reduceFunction = function (key, values) {
                 return Array.sum(values);
               };

              var queryParam = {query:{}, out:"result_set"};

              db.publis.mapReduce(mapFunction, 
                 reduceFunction, queryParam);

              db.result_set.find({value:{$gte:2}});
              
       #. .. code-block:: javascript
       
              var mapFunction = function () {
                if(this.publisher == "Springer")emit(this.year, 1);
              };

             var reduceFunction = function (key, values) {
               return Array.sum(values);
             };

       #. .. code-block:: javascript
       
             var mapFunction = function () {
               if(this.publisher)
                   emit({publisher:this.publisher, year:this.year}, 1);
                };
 
             var reduceFunction = function (key, values) {
                 return Array.sum(values);
              };
              
       #. .. code-block:: javascript
       
              var mapFunction = function () {
                if(Array.contains(this.authors, "Toru Ishida"))
                  emit(this.year, 1);
               };

              var reduceFunction = function (key, values) {
                 return Array.sum(values);
              };

              var queryParam = {query:{}, out:"result_set"};

           ou

           .. code-block:: javascript
             
                 var mapFunction = function () {emit(this.year, 1);};

                 var reduceFunction = function (key, values) {
                   return Array.sum(values);
                 };

                 var queryParam = {
                    query:{authors:"Toru Ishida"}, out:"result_set"};
       
       #. .. code-block:: javascript
       
              var mapFunction = function () {
                 emit(null, this.pages.end - this.pages.start);
              };

              var reduceFunction = function (key, values) {
                return Array.avg(values);
              };

              var queryParam = {query:{authors:"Toru Ishida"}, out:"result_set"};

       #.  .. code-block:: javascript
       
               var mapFunction = function () {
                for(var i=0;i<this.authors.length;i++)
                  emit(this.authors[i], this.title);};

               var reduceFunction = function (key, values) {
                 return {titles : values};
               };
       
       #. .. code-block:: javascript 
       
              var mapFunction = function () {
                for(var i=0;i<this.authors.length;i++)
                   emit({author : this.authors[i], year : this.year}, 1);};

              var reduceFunction = function (key, values) {
                return Array.sum(values);
              };
              
       
       #. .. code-block:: javascript 
       
             var mapFunction = function () {
               for(var i=0;i<this.authors.length;i++)
                 emit(this.year, this.authors[i]);};

             var reduceFunction = function (key, values) {
               var distinct = 0;var authors = new Array();

               for(var i=0;i<values.length;i++)
                 if(!Array.contains(authors, values[i]))
                 {
                      distinct++;
                      authors[authors.length] = values[i];
                  }

               return distinct;};
        
       #. .. code-block:: javascript 
        
               var mapFunction = function () {
                 if(this.authors.length >3)emit(null, 1);
               };

              var reduceFunction = function (key, values) {
                return Array.sum(values);
              };
       
       #. .. code-block:: javascript 
        
               var mapFunction = function () {
                if(this.pages && this.pages.end)
                  emit(this.publisher, this.pages.end - this.pages.start);
                };

               var reduceFunction = function (key, values) {
                 return Array.avg(values);
               };

              var queryParam = {query:{}, out:"result_set"};

       #. .. code-block:: javascript 
       
              var mapFunction = function () {
                for(var i=0;i<this.authors.length;i++)
                  emit(this.authors[i], {min : this.year,
                                         max : this.year, number : 1});};

              var reduceFunction = function (key, values) {

                var v_min = 1000000;var v_max = 0;var v_number = 0;

                for(var i=0;i<values.length;i++){
                 if(values[i].min < v_min)v_min = values[i].min;
                 if(values[i].max > v_max)v_max = values[i].max;
                 v_number++;
                }
               return {min:v_min, max:v_max, number:v_number};
             };

*****************************
Bonus / Pour aller plus loin
*****************************

Les exercices qui suivent impliquent des commandes non vues en cours, et
nécessitent donc un peu de recherche de votre part. Si vous êtes motivés par
MongoDB, allez-y ! Ces exercices ne seront pas corrigés.


Mises à jour
============

  * **Modification** : ``db.media.update ({"Title" : "Database"}, {$set:{Genre : "Science"}});``

  .. note:: Premier JSon : Mapping, Second JSon : Update ($set, $unset)

  * **Suppression** : ``db.media.remove({"Title" : "Database"})``
  * **Fonction itérative** :

  .. code-block:: javascript
  
	db.publis.find().forEach(
  		function(pub){
    		pub.pp = pub.pages;
    		db.publis.save(pub);
  	});
 

Pour les mises à jour suivantes, vérifier le contenu des données avant et après la mise à jour.

  #. Mettre à jour tous les livres contenant "database" en ajoutant l'attribut "Genre" : "Database"
  #. Supprimer le champ "number" de tous articles
  #. Supprimer tous les articles n'ayant aucun auteur
  #. Modifier toutes les publications ayant des pages pour ajouter le champ "pp" avec pour valeur le motif suivant : ``pages.start--pages.end``

Indexation 2Dsphere
===================

Nous pouvons indexer les données avec 2DSphere qui permet de faire des recherches en 2 dimensions.

Documentation : http://docs.mongodb.org/manual/applications/geospatial-indexes/

Pour ce faire, télécharger le fichier `cities15000.csv.zip <http://b3d.dbpedia.fr/data/cities15000.csv.zip>`_. Décompressez le.
Créer une collection ``cities`` dans la base de données, et importer les données à l'aide d'un programme de lecture CSV (à vous de le créer). Le schéma de sortie doit contenir pour les coordonnées les informations suivantes :

	``"coordinate" : [XXXXX, YYYYY]``

L'attribut ``coordinate`` sera alors indexé :
  .. code-block:: javascript

	db.publis.ensureIndex( { coordinate : "2d" } );

Pour interroger l'index, il faut utiliser un opérateur 2D et l'utiliser sur ``coordinate``

Documentation : http://docs.mongodb.org/manual/tutorial/query-a-2d-index/

  #. Récupérer les coordonnées de la ville de Paris, Lyon et Bordeaux
  #. Trouver les villes autour de Paris dans un rayon de 100km (*Opérateur $near*).
  #. Calculer la somme des populations de cette zone.
  #. Trouver les villes comprises dans le triangle Paris-Lyon-Bordeaux (*Opérateur $geoWithin*)
  #. Vérifier s'il y a des villes qui ne sont pas en France dans ce résultat
