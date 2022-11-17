.. _chap-pigtp:
   
#######################
Pig : Travaux pratiques
#######################

Rappel : le cours se trouve là : :ref:`chap-calcdistr`

*******************************************
Première partie : analyse de flux multiples
*******************************************

Cet exercice vise à découvrir Pig de manière
un peu plus approfondie. Nous nos plaçons dans la situation d'un
système recevant deux flux de données distincts et effectuant des
opérations de rapprochement, sélection et agrégation, dans l'optique de
la préparation d'une étude statistique ou analytique.

Le jeu de données proposé est notre base de films, mais il est assez facile de
transposer ce qui suit à d'autres applications. Vous trouverez sur le site
http://deptfod.cnam.fr/bd/tp/datasets/ deux fichiers au format d'import Pig: la liste des
films et la liste des artistes. Le format est JSON, avec la particularité qu'un
fichier contient une liste d'objets, et que chaque objet est stocké sur une
seule ligne. 
    
Voici une ligne du fichier pour les films.

.. code-block:: javascript

   { "_id": "movie:1", "title": "Vertigo", "year": 1958, "genre":
   "drama", "summary": "...", "country": "USA", "director": { "_id": "artist:3"}, 
    "actors": [{ "_id": "artist:15", "role": "John
                Ferguson" }, { "_id": "artist:16", "role": "Madeleine Elster"
        }] 
    }

Et une ligne du fichier pour les artistes.

.. code-block:: javascript

   { "_id": "artist:15", "last_name": "Stewart", "first_name":
   "James", "birth_date": "1908" }

Comme vous le voyez, le metteur en scène est complétement intégré au document des films,
alors que les acteurs ne sont que référencés par leur identifiant.

Nommez les deux fichiers respectivement ``artists-pig.json``  et ``movies-pig.json``. Voici
les commandes de chargement dans l'interpréteur Pig.

.. code-block:: python

   artists = LOAD 'artists-pig.json' 
         USING JsonLoader('id: chararray, firstName:chararray, 
            lastName:chararray, birth:chararray');              

   movies = LOAD 'movies-pig.json' 
     USING JsonLoader('id:chararray, title:chararray, year:chararray,
                       genre:chararray, summary:chararray, country:chararray,
                       director: (id:chararray,lastName:chararray,
                              firstName:chararray,birthDate:chararray),
                       actors: {(id:chararray, role:chararray)}'
                           );

Comme vous le voyez on indique le schéma des données contenues dans le fichier pour que Pig puisse
créer sa collection.

Allons-y pour des programmes Pig traitant ces données.

#. Créez une collection ``mUSA_annee`` groupant les films américains par année (code du pays: US). Vous
   devriez obtenir le format suivant.
   
   .. code-block:: python
   
      (2003, {(The Matrix reloaded),(Lost in Translation),
                (Kill Bill),(The Matrix Revolutions)})       
                
   .. ifconfig:: pigtp in ('public')

      .. admonition:: Correction

         .. code-block:: javascript
      
             moviesUSA = filter movies BY country=='US';        
             mUSA_group = group moviesUSA by year;
             mUSA_annee = foreach mUSA_group generate group, moviesUSA.title;
          
#. Créez une collection ``mUSA_director`` groupant les films américains par metteur en scène. Vous
   devriez obtenir des documents du type suivant:
   
   .. code-block:: python
   
      ((artist:181,Coppola,Francis Ford,1940),
          {(Le parrain III),(Le parrain II),(Le parrain)})
          
   .. ifconfig:: pigtp in ('public')

      .. admonition:: Correction

         .. code-block:: javascript
      
             mUSA_group2 = group moviesUSA by director;
             mUSA_director = foreach mUSA_group2 generate group, moviesUSA.title;

#. Créez une collection ``mUSA_acteurs`` contenant des triplets (idFilm,  idActeur, role). Chaque
   film apparaît donc dans autant de documents qu'il y a d'acteurs. Vous devriez
   obtenir par exemple:

   .. code-block:: python
           
       (movie:54,artist:137,Sonny Corleone)
       (movie:54,artist:176,Michael Corleone)
       (movie:54,artist:182,Don Vito Corleone)   
          
   Aide: il  faut "aplatir" la collection ``actors`` imbriquée dans chaque film.
    
   .. ifconfig:: pigtp in ('public')

      .. admonition:: Correction

         .. code-block:: javascript
      
             mUSA_actors = foreach movies generate id, flatten(actors);
 
#. Maintenant, créez une collection ``moviesActors`` associant l'identifiant
   du film à la description complète de l'acteur. Ce qui devrait donner par exemple:
  
   .. code-block:: python
 
      (movie:54,artist:176,Michael Corleone,artist:176,Pacino,Al,1940)
 
   Aide: c'est une jointure bien sûr. Consultez le schéma de ``mUSA_actors``
   pour connaître le nom des  colonnes.
 
   .. ifconfig:: pigtp in ('public')

      .. admonition:: Correction

         .. code-block:: javascript
      
              moviesActors = join mUSA_actors by actors::id, artists by id;

#. Et pour finir, créez une collection ``fullMovies`` associant la description complète
   du film à la description complète de tous les acteurs. 
  
   Aide: soit une jointure entre ``moviesActors``  et ``movies``, puis un regroupement par film,
   ce qui un contenu correct mais très compliqué (essayez), soit (mieux) un ``cogroup``
   entre ``moviesUSA`` et ``moviesActors``. Voici un exemple du résultat dans le second cas.
 
   .. code-block:: python
      
      (movie:33,{(movie:33,Psychose,1960,Thriller,USA,(artist:3,Hitchcock,Alfred,1899))},
                {(movie:33,artist:90,Marion Crane,artist:90,Leigh,Janet,1927),
                 (movie:33,artist:89,Lila Crane,artist:89,Miles,Vera,1929),
                 (movie:33,artist:88,Bates,artist:88,Perkins,Anthony,1932)})
 
   .. ifconfig:: pigtp in ('public')

      .. admonition:: Correction

         Avec ``join``:
       
         .. code-block:: javascript
      
            joinMovies = join movies by id, moviesActors by mUSA_actors::id;
            fullMovies = group joinMovies by movies::id;

        Avec ``cogroup``:
       
        .. code-block:: javascript
                    
            fullMovies2 = cogroup moviesUSA by id, moviesActors by mUSA_actors::id;
           
#. Créer une collection ``ActeursRealisateurs`` donnant pour  chaque artiste la liste des films où il/elle a joué
   (éventuellement vide), et des films qu'il/elle a dirigé. On peut se contenter 
   d'afficher l'identifiant de l'artiste, ce qui donnerait:
 
   .. code-block:: python
   
        (artist:24,{},{(movie:10,Blade Runner,artist:24,Deckard),
                      (movie:34,Le retour du Jedi,artist:24,Han Solo)})
          
   Ou effectuer une jointure supplémentaire pour obtenir le nom et le  prénom.
   
   .. code-block:: python
   
        (artist:24,Ford,Harrison,1942,artist:24,{},
              {(movie:10,Blade Runner,artist:24,Deckard),
               (movie:34,Le retour du Jedi,artist:24,Han Solo)})
   
   .. ifconfig:: pigtp in ('public')

        .. admonition:: Correction

           .. code-block:: javascript
      
              acteurs = foreach movies generate id, title, flatten(actors);
              IdActeursRealisateurs = cogroup movies by director.id, acteurs by actors::id;
              ActeursRealisateurs = join artists by id, IdActeursRealisateurs by group;


*************************************
Deuxième partie : analyse de requêtes
*************************************

.. Cet exercice est basé sur le tutoriel fourni avec Pig, sur le `site officiel
   <https://pig.apache.org/docs/r0.7.0/tutorial.html>`. 

L'objectif est d'aller significativement plus loin avec Pig, en procédant à de
l'analyse de données. On va utiliser un fichier de logs du moteur de recherche
Excite. C'était un portail de recherche très utilisé avant l'an 2000, beaucoup
moins maintenant. Il est accessible à l'adresse suivante : http://msxml.excite.com/. 
Nos données sont donc les requêtes qui ont été soumises à ce moteur pendant une
journée, en 1997. 

Normalement, vous trouverez deux versions du fichier de log, dans votre dossier
``pigdir/tutorial/data``. Vous pouvez commencer par regarder la version courte,
``excite-small.log``, par exemple avec ``less``. Elle comporte 4501 lignes, la
version longue approche le million. Chaque ligne est au format : ``user time
query`` : un identifiant de l'utilisateur, un horodatage du moment où la
requête a été reçue par le serveur, et les mots-clefs de celle-ci. La version
longue est dans un fichier zippé, elle peut s'extraire avec la commande
suivante :

.. code-block:: bash

    bzip2 -d excite.log.bz2 

Aparté sur l'utilisation de Pig
===============================

L'interprêteur de Pig peut s'utiliser en local ou avec Hadoop comme on l'a vu
en cours. Dans chacun de ces deux cas, vous pouvez utiliser un mode interactif
ou un mode avec script. Dans le cadre de ce TP, je vous conseille de coupler
les deux : dans une fenêtre de terminal, vous utilisez le mode interactif pour
écrire des commandes, les tester, les corriger, etc. À côté, conservez celles
qui fonctionnent dans un fichier de script (par convention donnez lui
l'extension ``.pig``), de façon à pouvoir facilement en copier-coller certaines
en cas de redémarrage de la session avec le mode interactif. 

D'autre part, en mode interactif, vous pouvez écrire dans des fichiers les
sorties de vos commandes, mais il sera souvent plus utile d'employer ``dump``
après avoir exécuté une commande et stocké le résultat. Attention, avec de
grosses collections ce dump peut prendre longtemps (``dump raw`` ci-dessous
afficherait 1 million de lignes…).

Première analyse
================

Dans cette partie, nous allons chercher à obtenir quelles sont les requêtes les
plus fréquentes à certaines heures de la journée.

On va cette fois utiliser des fonctions Java écrites pour l'occasion,
fournies dans quelques fichiers du dossier
``pigdir/tutorial/src/org/apache/pig/tutorial``.

Afin de pouvoir les utiliser, il vous faut le fichier `tutorial.jar <http://b3d.bdpedia.fr/files/tutorial.jar>`_. 

Il est probable qu'il vous faille exécuter la commande suivante pour que Pig puisse démarrer :

.. code-block:: bash

   export JAVA_HOME="/usr"

Vous pouvez ensuite démarrer votre session Pig avec la commande suivante (si
vous êtes dans ``pigdir``):

.. code-block:: bash

  ./bin/pig -x local

Nous devons commencer par une instruction permettant à Pig de savoir qu'on va
utiliser des fonctions Java définies extérieurement :

.. code-block:: javascript

    REGISTER ./tutorial.jar; 

Ensuite, on charge le fichier à utiliser, dans un "bag". Vous pouvez utiliser
``excite`` (1 million de lignes), ou ``excite-small`` (4500). 

.. code-block:: javascript

   raw = LOAD './tutorial/data/excite.log' 
        USING PigStorage('\t') AS (user, time, query);

Nettoyage des données
---------------------

On procède ensuite, en deux étapes, au nettoyage de nos données, étape toujours
importante dans l'analyse de données réelles. L'anonymisation (retrait de
données personnelles), la normalisation des encodages de caractères, le retrait
des requêtes vides sont souvent nécessaires. Ici, on se contente d'enlever les
requêtes vides et celles qui contiennent des URL.

.. code-block:: javascript

     clean1 = FILTER raw BY org.apache.pig.tutorial.NonURLDetector(query);

Regardez le code Java présent dans le fichier ``NonURLDetector.java`` du
dossier ``tutorial/src/org/apache/pig/tutorial/`` :

.. code-block:: java

    public class NonURLDetector extends FilterFunc {

     private Pattern _urlPattern = Pattern.compile("^[\"]?(http[:|;])|(https[:|;])|(www\\.)");

     public Boolean exec(Tuple arg0) throws IOException {
      if (arg0 == null || arg0.size() == 0)
        return false;

       String query; 
       try{
        query = (String)arg0.get(0);
        if(query == null)
          return false;
        query = query.trim();
       } catch(Exception e){
         System.err.println("NonURLDetector: failed to process input; error - " + e.getMessage());
         return false;
       }

       if (query.equals("")) {
        return false;
       }
       Matcher m = _urlPattern.matcher(query);
       if (m.find()) {
        return false;
       }
       return true;
     }
   }

Cette classe reçoit des chaînes de caractères, et renvoie ``false`` si :

  * la requête est vide (``arg0.size() == 0``, ``arg0 == null``, ``query.equals("")``)
  * la requête trouve le motif d'expression régulière qui correspond à une URL :
    ``^[\"]?(http[:|;])|(https[:|;])|(www\\.)``

Vous pouvez voir quelles sont les chaînes ignorées en utilisant l'opérateur ``NOT`` dans la commande précédente :

.. code-block:: javascript

   clean0 = LIMIT (FILTER raw BY NOT org.apache.pig.tutorial.NonURLDetector(query)) 100;
   dump clean0;

Attention, le `dump` va ici écrire beaucoup de lignes si l'on ne le limite pas,
d'où la syntaxe ci-dessus qui permet d'avoir un aperçu, avec seulement 100
lignes. Cependant, ce n'est pas exhaustif, et ne permet pas vraiment de voir si
l'on exclut bien toutes les requêtes que l'on souhaite.

Reprenons et poursuivons le nettoyage des données, en passant toutes les
chaînes de caractères en bas de casse (minuscules).

.. code-block:: javascript

   clean2 = FOREACH clean1 GENERATE user, time, org.apache.pig.tutorial.ToLower(query) as query;

Extraction de l'heure
---------------------

Ensuite, on s'intéresse à l'extraction de l'heure. En effet, nos données ne
concernent qu'une seule journée, on a donc seulement besoin de cette
information (je vous rappelle que l'on cherche à distinguer les mots et groupes
de mots fréquents à certaines heures de la journée).

On va passer à nouveau par du code Java, cette fois dans le fichier
``ExtractHour.java`` du dossier ``tutorial/src/org/apache/pig/tutorial/`` :

.. code-block:: javascript

   houred = FOREACH clean2 GENERATE user, org.apache.pig.tutorial.ExtractHour(time) as hour, query;

La seule partie importante du code java est la suivante :

.. code-block:: java

   return timestamp.substring(6, 8);

L'horodatage utilisé dans notre fichier est de la forme ``AAMMJJHHMMSS`` :
``970916161309`` correspond au 16 septembre 1997, à 16h13m09s. Ainsi, le code
retourne la sous-chaîne de cet horodatage entre les positions 6 et 8 (6 inclus,
8 exclu), c'est-à-dire le ``HH`` recherché.

Récupération des nGrams
-----------------------

Maintenant, on va chercher les n-grams, c'est-à-dire les 
séquences de `n` mots
contenus dans nos requêtes. On va se restreindre à `n=2`. Pour la requête ``une
bien jolie requête``, on va extraire les mots et groupes de mots suivants :

  * une
  * bien
  * jolie
  * requête
  * une bien
  * bien jolie
  * jolie requête

Pour cela, c'est le code Java de ``NGramGenerator.java`` qui se charge du traitement.

.. code-block:: javascript

   ngramed1 = FOREACH houred GENERATE user, hour, 
        flatten(org.apache.pig.tutorial.NGramGenerator(query)) as ngram;

Je vous conseille ici de regarder des ``dump`` sur des ngrams particuliers,
pour bien comprendre ce que font chacune des commandes qui suivent. Exemple,
avec ``demi`` : 

.. code-block:: javascript

   ng = filter ngramed1 by ngram=='demi';
   dump ng;
 
Vous obtenez par exemple :

.. code-block:: javascript

   (BD64F5DBA403D401,18,demi)
   (F18FA4825A88A1E1,10,demi)
   (1DE4083F198B3F0E,22,demi)
   (1DE4083F198B3F0E,22,demi)

On peut ensuite enlever les n-grams utilisés plusieurs fois par le même
utilisateur dans la même heure (ci-dessus, ``1DE4083F198B3F0E`` a utilisé
``demi`` deux fois entre 22h et 22h59) :

.. code-block:: javascript

   ngramed2 = DISTINCT ngramed1;


Agrégation par heure
--------------------

Groupons ensuite pour avoir une collection par n-gram et par heure :

.. code-block:: javascript

   hour_frequency1 = GROUP ngramed2 BY (ngram, hour);

Comptons maintenant le nombre d'occurences de chaque n-gram dans chaque heure :

.. code-block:: javascript

    hour_frequency2 = FOREACH hour_frequency1 GENERATE flatten($0), COUNT($1) as count;

.. ifconfig:: pigtp in ('public')

   .. admonition:: Correction

       hf = filter hour_frequency2 by ngram=='demi'; dump hf;

On regroupe par n-gram :

.. code-block:: javascript

   uniq_frequency1 = GROUP hour_frequency2 BY group::ngram;

.. ifconfig:: pigtp in ('public')

   .. admonition:: Correction

       uf = filter uniq_frequency1 by group=='demi'; dump uf;

Heures anormales pour un mot
----------------------------

On utilise le code Java de ``ScoreGenerator.java`` qui calcule, pour chaque
n-gram, la moyenne (et l'écart-type) des utilisations par heure, et un score
pour chaque heure (un score de ``1.0`` signifie que ce n-gram, dans cette
heure-là, a été utilisé de sa moyenne + 1.0 * l'écart type). La seconde
commande assigne des noms à nos champs :

.. code-block:: javascript

   uniq_frequency2 = FOREACH uniq_frequency1 
         GENERATE flatten($0), flatten(org.apache.pig.tutorial.ScoreGenerator($1));
   uniq_frequency3 = FOREACH uniq_frequency2 
        GENERATE $1 as hour, $0 as ngram, $2 as score, $3 as count, $4 as mean;

On ne garde que les scores supérieurs à ``2.0`` :

.. code-block:: javascript

   filtered_uniq_frequency = FILTER uniq_frequency3 BY score > 2.0;

Enfin, on écrit dans un fichier :

.. code-block:: javascript

   STORE filtered_uniq_frequency INTO './res1' USING PigStorage();

Le résultat de l'analyse se trouve dans le fichier ``./res1/part-r-00000``.

Aller plus loin
===============

Tri
---

On peut trier ce fichier par heure et par n-gram avec la commande suivante (de
façon à voir un peu mieux quelles requêtes apparaissent à quelle heure) :

.. code-block:: bash

   sort -k2,1 -T. -S1G res1/part-r-00000 | column -ts $'\t' | less

Ce tri peut aussi être fait en Pig, avant d'écrire.

Visualisation
-------------

On peut aussi s'intéresser à des résultats intermédiaires et faire un peu de
visualisation. Regardons simplement le nombre d'utilisateur différents qui ont
tapé le mot ``demi`` à chaque heure de la journée :

.. code-block:: bash

    hf = filter hour_frequency2 by ngram=='demi';
    STORE hf INTO './demi' USING PigStorage();
    gnuplot
    plot "demi/part-r-00000" using 2:3 with lines"

Bien sûr, ``gnuplot`` est un outil parmi d'autres, vous pouvez utiliser
``matplotlib`` en python par exemple.

Deuxième analyse
----------------

À titre d'exercice, vous pouvez aussi reprendre les commandes ci-dessus et
essayer de comparer, par exemple, les utilisations de n-grams à 00h et à 12h
(indices : vous n'aurez pas besoin de ScoreGenerator et il faudra utiliser un
join).

.. ifconfig:: pigtp in ('public')

   .. admonition:: Correction
   
    La solution se trouve dans le fichier
    ``pigdir/tutorial/scripts/script1-local.pig``.


