   
.. |nbsp| unicode:: 0xA0 
   :trim:

.. _chap-bddoc:

################
Recherche exacte
################

Dans ce chapitre nous commençons à étudier la gestion de grands ensembles de documents
organisés en bases de données.  Nous commençons par le Web: ce n'est pas vraiment
une base de données (même si beaucoup  rêvent d'aller en ce sens) mais c'est un système distribué 
de documents, et un cas-type de *Big Data* s'il en est. 
De plus, il s'agit d'une source d'information essentielle pour collecter
des données, les agréger et les analyser. 

Le Web s'appuie sur des protocoles bien connus
(HTTP) qui ont été repris pour la définition de services (Web) dits REST. Un premier
système NoSQL (CouchDB) est introduit pour illustrer l'organisation et la manipulation
de documents basées sur  REST.

Nous continuons ensuite notre exploration de Cassandra et de  MongoDB.

**************************
S1: HTTP, REST, et CouchDB
**************************

.. admonition:: Supports complémentaires

      * `Présentation: le Web, REST, illustration avec CouchDB <http://b3d.bdpedia.fr/files/slcouchdb.pdf>`_
      * `Vidéo de la session REST + CouchDB <https://mediaserver.lecnam.net/permalink/v125f35952fc0c9ntg9j/>`_  
      
Le Web est la plus grande base de documents ayant jamais existé! Même s'il
est essentiellement constitué de documents très peu structurés et donc
difficilement exploitables par une application informatique, les méthodes utilisées sont très  
instructives et se retrouvent dans des systèmes plus organisés.
Dans cette section, l'accent est mis sur le protocole REST que nous retrouverons 
très fréquemment en étudiant les systèmes NoSQL. L'un de ces systèmes (CouchDB) 
qui s'appuie entièrement sur REST, est d'ailleurs brièvement introduit en fin de section.

Web = ressources + URL + HTTP
============================= 

Rappelons les principales caractéristiques du Web, vu
comme un gigantesque système d'information orienté documents. Distinguons
d'abord l'Internet, réseau connectant des machines, et le Web qui constitue
une collection distribuée de *ressources* hébergés sur ces machines.

Le Web est (techniquement) essentiellement caractérisé par trois choses:
la notion de *ressource*, l'adressage par des *URL* et le protocole HTTP.

Ressources
----------

La notion de  ressource est assez générale/générique. Elle désigne toute entité 
disposant d'une adresse sur le réseau, et fournissant des services. Un
document est une forme de ressource: le service est dans ce cas le contenu du document lui-même. 
D'autres ressources fournissent des services au sens plus calculatoire du terme
en effectuant sur demande des opérations. 

Il faut essentiellement voir une ressource comme un point adressable sur l'Internet
avec lequel on peut échanger des messages. L'adressage se fait par une URL, l'échange
par HTTP.


URLs
----

L'adresse d'une ressource est une URL, pour *Universal Resource Location*. C'est une chaîne de caractères
qui encode toute
l'information nécessaire pour trouver la ressource et lui envoyer des messages.

.. note:: Certaines ressources n'ont pas d'adresse sur le réseau, mais sont quand même identifiables
   par des URI (*Universal Resource identifier*). 

Cet encodage prend la forme d'une chaîne de caractères
formée selon des règles précises illustrées par l'URL fictive suivante:

.. code-block:: bash

    https://www.example.com:443/chemin/vers/doc?nom=b3d&type=json#fragment

Ici, ``https`` est le *protocole* qui indique la méthode d'accès à la ressource. 
Le seul protocole que nous verrons est HTTP (le ``s`` indique une variante 
de HTTP comprenant un encryptage des échanges). *L'hôte* (*hostname*)
est ``www.example.com``. Un des services du Web (le DNS) va convertir ce nom
d'hôte en adresse IP, ce qui permettra d'identifier la machine serveur qui
héberge la ressource.

.. note:: Quand on développe une application, on la teste
   souvent localement en utilisant sa propre machine de développement
   comme serveur. Le nom de l'hôte est alors ``localhost``, qui
   correspond à l'IP ``127.0.0.1``.

La machine serveur communique avec le réseau sur un ensemble de *ports*,
chacun correspondant à l'un des services gérés par le serveur. Pour
le service HTTP, le port est par défaut 80, mais on peut le préciser,
comme sur l'exemple précédent, où il vaut 443. 
On trouve ensuite le *chemin d'accès à la ressource*, qui suit la syntaxe
d'un chemin d'accès à un fichier dans un système de fichiers. Dans
les sites simples, "statiques", ce chemin correspond de fait
à un emplacement physique vers le fichier contenant la ressource. 
Dans des applications plus sophistiquées, 
les chemins sont virtuels et conçus pour refléter l'organisation logique
des ressources offertes par l'application. 

Après le point d'interrogation, on trouve la liste
des paramètres (*query string*) éventuellement transmis
à la ressource. Enfin, le fragment désigne une sous-partie
du contenu de la ressource. Ces éléments sont optionnels.

Le protocole HTTP
-----------------

HTTP, pour
*HyperText Transfer Protocol*, est un protocole extrêmement
simple, basé sur TCP/IP, initialement conçu pour échanger des
documents hypertextes. HTTP définit le format des requêtes
et des réponses. Voici par exemple une requête
envoyée à un serveur Web:

.. code-block:: http

   GET /myResource HTTP/1.1
   Host: www.example.com

Elle demande une ressource nommée ``myResource`` au serveur ``www.example.com``.
Voici une possible réponse à cette requête:


.. code-block:: http

    HTTP/1.1 200 OK
    Content-Type: text/html; charset=UTF-8

    <html>
      <head><title>myResource</title></head>
      <body><p>Bonjour à tous!</p></body>
    </html>

Un message HTTP est constitué de deux parties: l'entête et le corps,
séparées par une ligne blanche. La
réponse  montre que l'entête contient des informations 
qualifiant le message. La première ligne par exemple indique 
qu'il s'agit d'un message codé selon la norme 1.1 de HTTP, 
et que le serveur a pu correctement répondre à la requête
(code de retour 200). La seconde ligne de l'entête 
indique que le corps du message est un document HTML encodé en UTF-8.

Le programme client qui reçoit cette réponse traite le
corps du message en fonction des informations contenues dans l'entête.
Si le code HTTP est 200 par exemple, il procède à l'affichage. 
Un code 404 indique une ressource manquante, une code 500 indique
une erreur sévère au niveau du serveur. Voir http://en.wikipedia.org/wiki/List_of_HTTP_status_codes
pour une liste complète.

Le Web est initialement conçu comme un système d'échange de documents hypertextes
se référençant les uns les autres, codés avec le langage HTML (ou XHTML dans le meilleur des cas).  
Ces documents s'affichent
dans des navigateurs et sont donc conçus pour des utilisateurs humains. En revanche,
ils sont très difficiles à traiter par des applications en raison de leur manque de structure
et de l'abondance d'instructions relatives à *l'affichage* et pas à la description du *contenu*.
Examinez une page HTML provenant de n'importe quel site un peu soigné et
vous verrez que la part du contenu est négligeable par rapport à tous les CSS, javascript, images et
instructions de mise en forme.

Une évolution importante du Web a donc consisté à étendre la notion de ressource à
des *services* recevant et émettant des documents structurés transmis
dans le corps du message HTTP. Vous connaissez déjà
les formats utilisés pour représenter cette structure: JSON et XML, 
ce dernier étant clairement de moins en moins apprécié.

C'est cet aspect sur lequel nous allons nous concentrer:  le Web 
des services est véritablement une forme de très grande base de documents structurés,
présentant quelques fonctionnalités (rudimentaires) de gestion de données comparable aux
opérations d'un SGBD classique. Les services basés sur l'architecture REST, présentée ci-dessous, 
sont la forme la plus courante rencontrée dans ce contexte.

L'architecture REST
===================

REST est une forme de service Web 
dont le parti pris est de s'appuyer sur HTTP, ses opérations, la notion de ressource
et l'adressage par URL. REST est donc très proche du Web, la principale distinction 
étant que REST est orienté vers l'appel à des services à base d'échanges par documents structurés,
et se prête donc à des échanges de données entre applications. La  :numref:`REST` donne
une vision des éléments essentiels d'une architecture REST.


.. _REST:
.. figure:: ../figures/REST.png
      :width: 80%
      :align: center
   
      Architecture REST: client, serveur, ressources, URL (domaine + chemin)
      
      
Avec HTTP, il est possible d'envoyer quatre types de messages, ou *méthodes*, à une ressource web:

  - ``GET`` est une *lecture* de la ressource (ou plus précisément de sa représentation publique);
  - ``PUT`` est la *création* d'une ressource;
  - ``POST`` est l'envoi d'un message à une ressource *existante*;
  - ``DELETE`` la destruction d'une ressource.
  
REST s'appuie sur un usage strict (le plus possible) de ces quatre méthodes. Ceux qui
ont déjà pratiqué la programmation Web admettront par exemple qu'un développeur ne se pose pas toujours
nettement la question, en créant un formulaire,  de la méthode ``GET`` ou ``POST`` à employer.
De plus le ``PUT`` (qui n'est pas connu des formulaires Web) est ignoré et le ``DELETE`` jamais utilisé.

La définition d'un service REST se doit d'être plus rigoureuse.  

 - le ``GET``, en tant que lecture, ne doit *jamais* modifier l'état de la ressource (pas "d'effet de bord");
   autrement dit, en l'absence d'autres opérations, des messages ``GET`` envoyés répétitivement
   à une même ressource ramèneront toujours le même document, et n'auront aucun effet sur l'environnement
   de la ressource ;
 - le ``PUT`` est une création, et l'URL a laquelle un message ``PUT`` est transmis ne doit
   pas exister au préalable; dans une interprétation un peu plus souple, le ``PUT``  crée ou
   *remplace* la ressource éventuellement existante par la nouvelle ressource transmise par le message;
 - inversement, ``POST`` doit s'adresser à une ressource existante associée à l'URL désignée par le message; 
   cette méthode correspond à l'envoi d'un message à la ressource (vue comme un service) pour exécuter une action, avec
   potentiellement un changement d'état (par exemple la création d'une nouvelle ressource).   
 
Les messages sont transmis en HTTP (voir ci-dessus) ce qui offre, entre autres avantages, de
ne pas avoir à redéfinir un nouveau protocole. Le contenu du message est une information codée en XML ou
en JSON (le plus souvent), soit ce que nous avons appelé jusqu'à présent un *document*.

  * quand le client émet une requête REST, le document contient les paramètres d'accès
    au service (par exemple les valeurs de la ressource à créer);
  * quand la ressource répond au client, le document contient l'information 
    constituant le résultat du service; en cas d'erreur ou d'anomalie (droit
    d'accès insuffisant par exemple) un code d'erreur HTTP peut être utilisé.

.. important:: En toute rigueur, il faut bien distinguer la ressource et le document
   qui représente une information produite par la ressource.
   

On peut faire appel à un service REST avec n'importe
quel client HTTP, et notamment avec votre navigateur préféré: copiez l'URL
dans la fenêtre de navigation et consultez le résultat. Le navigateur a cependant l'inconvénient,
avec cette méthode, de ne transmettre que des messages ``GET``. Un outil plus général, s'utilisant
en ligne de commande, est cURL. S'il n'est pas déjà installé dans votre environnement, il est fortement conseillé
de le faire dès maintenant: le site de référence est http://curl.haxx.se/.
   
Voici quelques exemples d'utilisation de cURL pour parler le HTTP avec un service REST.
Notre base de films est obtenue par appel à l'API REST de *themoviedb.org*. Voici
la requête qui cherche le film ``tt10404944``. 


.. code-block:: bash

    https://api.themoviedb.org/3/find/tt10404944?api_key=8f479aa1cb024ffe0d95da8c4ee56fe7&external_source=imdb_id

Ce qui retourne le document suivant.

.. code-block:: javascript

	{
	"adult": false,
	"backdrop_path": "/vkIJ2QgcKMJRvi6pBW4Tr2kgLdy.jpg",
	"id": 637534,
	"title": "The Stronghold",
	"original_language": "fr",
	"original_title": "BAC Nord",
	"overview": "A police brigade works in the dangerous northern neighborhoods of Marseille, where the level of crime is higher than anywhere else in France.",
	"poster_path": "/nLanxl7Xhfbd5s8FxPy8jWZw4rv.jpg",
	"media_type": "movie",
	"genre_ids": [53, 28, 80],
	"popularity": 21.929,
	"release_date": "2021-08-18",
	"video": false,
	"vote_average": 7.426,
	"vote_count": 1147
	}

Notez le placement de paramètres dans l'URL, et notamment une clé
d'accès, souvent requise pour utiliser des services. Autre exemple, 
l'API REST de *Open Weather Map*, un service fournissant
des informations météorologiques (créez une clé API et ajoutez-la 
à l'URL pour obtenir une réponse complète).

.. code-block:: bash

     curl -X GET api.openweathermap.org/data/2.5/weather?q=Paris

Et on obtient la réponse suivante (qui varie en fonction de la météo, évidemment).

.. code-block:: javascript

    {
       "coord":{
         "lon":2.35,
         "lat":48.85
       },
       "weather":[
         {
          "id":800,
          "main":"Clear",
          "description":"Sky is Clear",
          "icon":"01d"
         }
       ],
       "base":"cmc stations",
       "main":{
        "temp":271.139,
        "temp_min":271.139,
        "temp_max":271.139,
        "pressure":1021.17,
        "sea_level":1034.14,
        "grnd_level":1021.17,
        "humidity":87
       },
       "name":"Paris"
    }

Même chose, mais en demandant une réponse codée en XML. Notez l'option ``-v`` qui permet d'afficher le détail des échanges
de messages HTTP gérés par cURL.

.. code-block:: bash

    curl -X GET -v api.openweathermap.org/data/2.5/weather?q=Paris&mode=xml 

Nous verrons ultérieurement des exemples de ``PUT`` et de ``POST``  pour créer des ressources et leur envoyer des messages
avec cURL.

.. note:: La méthode ``GET``  est utilisée par défaut par cURL, on peut donc l'omettre.

Nous nous en tenons là pour les principes essentiels de REST, qu'il faudrait compléter de nombreux 
détails mais
qui nous suffiront à comprendre les interfaces (ou API) REST que nous allons rencontrer. 

.. important:: Les méthodes d'accès aux documents sont représentatives des opérations de 
   type *dictionnaire*: toutes les données ont une adresse, 
   on peut accéder à la donnée par son adresse (``get``), insérer une donnée à une adresse (``put``), 
   détruire la donnée à une adresse  (``delete``). De nombreux systèmes
   NoSQL se contentent de ces opérations qui peuvent s'implanter très simplement et efficacement. 
    
Pour être concret et rentrer au plus vite dans le cœur du sujet, nous présentons 
l'API de CouchDB qui est conçu comme un serveur de documents (JSON) basé sur REST.


L'API REST de  CouchDB
=======================

Faisons connaissance avec CouchDB, un système NoSQL qui gère des collections de documents JSON. Les quelques
manipulations ci-dessous sont centrées sur l'utilisation de CouchDB via son interface REST, mais
rien ne vous empêche d'explorer le système en profondeur pour en comprendre le fonctionnement. 

CouchDB
est essentiellement un serveur Web étendu à la gestion de documents JSON. Comme tout
serveur Web, il parle le HTTP et manipule des ressources (:numref:`CouchDB`).


.. _CouchDB:
.. figure:: ../figures/CouchDB.png
      :width: 80%
      :align: center
   
      Architecture (simplifiée) de CouchDB


Vous pouvez installer CouchDB sur votre machine avec Docker, en exposant le port 5984 sur
la machine hôte. Voici la commande d'installation.

.. code-block:: bash

      docker run  -d --name my-couchdb -e COUCHDB_USER=admin \
          -e COUCHDB_PASSWORD=admin -p 5984:5984 couchdb:latest

Dans ce qui suit, on suppose que le serveur est accessible 
à l'adresse http://localhost:5984. Une première requête REST
permet de vérifier la disponibilité de ce serveur.

.. code-block:: bash 

     curl -X GET http://admin:admin@localhost:5984
     
CouchDB devrit vous répondre par un message JSON:

.. code-block:: json

	{
	"couchdb": "Welcome",
	"version": "3.3.3",
	"git_sha": "40afbcfc7",
	"uuid": "0f4f4743bf65f3c4cd61caf3e789c559",
	"vendor": {"name": "The Apache Software Foundation"}
	}

.. note:: Vous noterez qu'il faut indiquer dans l'URL le compte
   d'accès (admin/admin) juste avant le nom du serveur. 

Bien entendu, dans ce qui suit, utilisez l'adresse de votre propre serveur.  
Même si nous utilisons REST pour communiquer avec CouchDB par la suite, 
rien ne vous empêche de consulter en parallèle l'interface graphique
qui est disponible à l'URL relative ``_utils`` (donc à l'adresse
complète http://localhost:5984/_utils dans notre cas). La 
:numref:`couch-fauxton` montre l'aspect de cette interface graphique, très pratique.

.. _couch-fauxton:
.. figure:: ../figures/fauxton.png
      :width: 80%
      :align: center
   
      L'interface graphique (Fauxton) de CouchDB
      
     
CouchDB adopte délibérément les principes et protocoles du Web. Une base
de données et ses documents sont vus comme des *ressources* et on dialogue
avec eux en HTTP, conformément au protocole REST.
 
Un serveur CouchDB gère un ensemble de bases de données. Créer une nouvelle base se traduit,
avec l'interface REST, par la création d'une nouvelle ressource. Voici  donc la commande
avec cURL pour créer une base ``films`` (notez la méthode ``PUT`` pour créer une ressource).

.. code-block:: bash

    curl -X PUT http://admin:admin@localhost:5984/films
    {"ok":true}

Maintenant que la ressource est créée, et on peut obtenir sa représentation avec une requête ``GET``.

.. code-block:: bash

    curl -X GET http://admin:admin@localhost:5984/films

Cette requête renvoie un document JSON décrivant la nouvelle base.

.. code-block:: javascript

    {"update_seq":"0-g1AAAADfeJz6t",
     "db_name":"films",
     "sizes": {"file":17028,"external":0,"active":0},
     "purge_seq":0,
     "other":{"data_size":0},
     "doc_del_count":0,
     "doc_count":0,
     "disk_size":17028,
     "disk_format_version":6,
     "compact_running":false,
     "instance_start_time":"0"
    }

Vous commencez sans doute  à saisir la logique des interactions. Les entités gérées par le serveur
(des bases de données, des documents, voire des fonctions) sont transposées sous forme
de ressources Web auxquelles sont associées des URLs correspondant, autant que  possible, à l'organisation
logique de ces entités. 

Pour insérer un nouveau document dans la base ``films``, on 
envoie donc un message ``PUT`` à l'URL qui va représenter le document. Cette URL
est de la forme ``http://localhost:5984/films/idDoc``, où ``idDoc`` désigne l'identifiant
de la nouvelle ressource.

.. code-block:: javascript

    curl -X PUT http://admin:admin@localhost:5984/films/doc1 -d '{"key": "value"}'
    
      {"ok":true,"id":"doc1","rev":"1-25eca"}

Que faire si on veut insérer des documents placés dans des fichiers?
Vous avez dû récupérer dans nos jeux de données des documents représentant 
des films en JSON. Le
document ``film629.json`` par exemple représente le film *Usual Suspects*. Voici comment
on l'insère dans la base en lui attribuant l'identifiant ``us``.

.. code-block:: bash
 
    curl -X PUT http://admin:admin@localhost:5984/films/us -d @film629.json -H "Content-Type: application/json" 

Cette commande cURL est un peu plus compliquée 
car il faut créer un message HTTP
plus complexe que pour une simple lecture. On passe dans le corps du message HTTP le contenu
du fichier ``film629.json`` avec l'option ``-d`` et le préfixe @, et on indique que le 
format du message est JSON
avec l'option ``-H``. Voici la réponse de CouchDB.

.. code-block:: javascript

    {
     "ok":true,
     "id":"us",
     "rev":"1-68d58b7e3904f702a75e0538d1c3015d"
    }
    
Le nouveau document a un identifiant (celui que nous attribué par l'URL de la ressource)
et un numéro de *révision*. L'identifiant doit être unique (pour une même base), et le numéro
de révision indique le nombre de modifications apportées à la ressource depuis sa création. 

Si vous essayez d'exécuter une seconde fois la création de la ressource, CouchDB proteste
et renvoie un message d'erreur:

.. code-block:: javascript

    {
      "error":"conflict",
     "reason":"Document update conflict."
    }     

Un document existe déjà à cette URL.

Une autre façon d'insérer, intéressante pour illustrer les principes d'une API REST, et d'envoyer
non pas un ``PUT`` pour créer une nouvelle ressource (ce qui impose de choisir l'identifiant)
mais un ``POST`` à une ressource existante, ici la base de données, qui se charge alors de créer
la nouvelle ressource représentant le film, et de lui attribuer un identifiant.

Voici cette seconde option à l'œuvre pour créer un nouveau document en déléguant
la charge de la création à la ressource ``films``.


.. code-block:: bash
       
      curl -X POST http://admin:admin@localhost:5984/films -d @film629.json -H "Content-Type: application/json"
      
Voici la réponse de CouchDB:

.. code-block:: javascript

     {
      "ok":true,
      "id":"movie:629",
      "rev":"1-68d58b7e3904f702a75e0538d1c3015d"
     }
 
CouchDB a trouvé l'identifiant (conventionnellement nommé ``id``) dans le document JSON et l'utilise. 
Si aucun identifiant n'est trouvé, 
une valeur arbitraire (une longue et obscure chaîne de caractère) est engendrée.

CouchDB est un système multi-versions: une nouvelle version du document est créée à chaque insertion. 
Chaque document
est donc identifié par une paire (id, revision): notez l'attribut ``rev`` 
dans le document ci-dessus.  Dans certains cas, la version la plus récente est 
implicitement concernée par une requête. C'est le cas quand on veut obtenir la ressource avec un simple ``GET``.

.. code-block:: bash

    curl -X GET http://admin:admin@localhost:5984/films/us
    
En revanche, pour supprimer un document, il faut indiquer explicitement 
quelle est la version à détruire en précisant le numéro de révision.

.. code-block:: bash

     curl -X DELETE http://localhost:5984/films/us?rev=1-68d58b7e3904f702a75e0538d1c3015d

Nous en restons là pour l'instant. Cette courte session illustre assez bien 
l'utilisation d'une API REST pour gérer
une collection de document à l'aide de quelques opérations basiques: 
création, recherche, mise à jour, et destruction,
implantées par l'une des 4 méthodes HTTP. La notion de ressource, existante (et on lui envoie des messages avec
``GET`` ou ``POST``) ou à créer (avec un message ``PUT``), associée à une URL correspondant à la logique de l'organisation
des données, est aussi à retenir.



Quiz
====

.. eqt:: bddocA-1

    Parmi les définitions suivantes, laquelle vous semble le mieux
    correspondre à la notion de ressource Web. 
    
    
    A) :eqt:`I`  C'est un document qui peut être téléchargé à une URL donnée
    #) :eqt:`I`  C'est un point de communication référencé par une URL
    #) :eqt:`C` C'est une entité qui fournit des services à une URL donnée

.. eqt:: bddocA-2

    Quelle est la bonne affirmation
    
    
    A) :eqt:`I`  HTTP est un protocole qui sert à  échanger des documents HTML
    #) :eqt:`C`  HTTP est un protocole qui sert à échanger  tout type de documents
    #) :eqt:`I`  HTTP ne peut être utilisé que dans le contexte du Web.

.. eqt:: bddocA-3

    Parmi les affirmations suivantes sur REST, l'une est vraie: laquelle
    
    
    A) :eqt:`I`  Si on envoie un POST à une ressource inexistante, elle est créée
    #) :eqt:`I`  POST est idempotent: deux appels successifs donnent le même résultat
    #) :eqt:`C`  GET est idempotent: deux appels successifs à la même ressource donnent le même résultat
    #) :eqt:`I`  On peut faire plusieurs appels PUT à une même ressource
    #) :eqt:`I`  Un appel GET à une ressource renvoie toujours le même document

.. eqt:: bddocA-4

    Quelle est la bonne affirmation
    
    A) :eqt:`I`  CouchDB est un serveur Web qui gère des données statiques codés en JSON
    #) :eqt:`C`  CouchDB est un système NoSQL basé sur les principes REST et le codage JSON
    #) :eqt:`I`  On ne peut communiquer avec CouchDB que via un navigateur ou cUrl

Mise en pratique
================

Les propositions suivantes vous permettent de mettre en pratique 
les connaissances précédentes.

.. _MEP-S1-2:       
.. admonition:: MEP  `MEP-S1-2`_: Documents et services Web

   Soyons concret: vous construisez une application qui, pour une raison X ou Y, a besoin
   de données météo sur une région ou une ville donnée. Comment faire? la réponse
   est simple: trouver le service Web qui fournit ces données, et appeler ces services.
   Pour la première question, on peut par exemple prendrele site OpenweatherMap, 
   dont les services sont décrits ici: http://openweathermap.org/api.
   Pour appeler ce service, comme vous pouvez le deviner, on passe par le protocole HTTP.
   
   Application: utilisez les services de OpenWeatherMap pour récupérer
   les données météo pour Paris, Marseille, Lyon, ou toute ville de votre choix. Testez les formats JSON et XML.    
 
.. _MEP-S1-3:    
.. admonition:: MEP `MEP-S1-3`_: comprendre les services géographiques de Google.

   Google fournit (librement, jusqu'à une certaine limite) des services dits de géolocalisation:
   récupérer une carte, calculer un itinéraire, etc. Vous devriez être en mesure
   de comprendre les explications données ici: https://developers.google.com/maps/documentation/webservices/?hl=FR
   (regardez en particulier les instructions pour traiter les documents JSON et XML retournés).
   
   Pour vérifier que vous avez bien compris: créez un formulaire HTML avec deux champs
   dans lesquels on peut saisir les points de départ et d'arrivée d'un itinéraire (par exemple, 
   Paris - Lyon). Quand on valide ce formulaire, afficher le JSON ou XML (mieux, donner
   le choix du format à l'utilisateur) retourné par le service Google (aide: il s'agit
   du service ``directions``).
     
.. _MEP-S1-4:    
.. admonition:: MEP `MEP-S1-4`_: explorer les services Web et l'Open data.

   Le Web est une source immense de données structurées représentées en JSON ou en XML. 
   Vous
   voulez connaître le programme d'une station de radio, accéder à une entre Wikipedia
   sous forme structurée, gérer des calendriers? On trouve à peu près tout sous forme
   de services.
   
   Explorez ces API pour commencer à vous faire une idée du type de projet qui vous intéresse.
   Récupérez des données et regardez leur format.
   
   Autre source de données: les données publiques. Allez voir par exemple sur
   
     - https://www.data.gouv.fr/fr/
     - http://data.iledefrance.fr/page/accueil/
     - http ://data.enseignementsup-recherche.gouv.fr/
     - http://www.data.gov/ (Open data USA)
     - La société OpendatSoft (http://www.opendatasoft.fr) propose non seulement des jeux
       de données, mais de nombreux outils d'analyse et de visualisation.
     
   Essayer d'imaginer une application qui combine plusieurs sources de données.

**********************
S2: requêtes Cassandra
**********************

Cassandra propose un langage, nommé CQL, inspiré de SQL, mais fortement restreint par l'absence de jointure. 
De plus, d'autres types de restrictions s'appliquent, motivées par l'hypothèse qu'une
base Cassandra est nécessairement une base à très grande échelle, et que les
seules requêtes raisonnables sont celles pour lequelles la structuration des données
permet des temps de réponse acceptables. 

.. note:: Cette session est une démonstration pratique ces capacités d'interrogation
   de Cassandra. Si vous souhaitewz reproduire les manipulations, il vous
   faut un environnement constitué d'un serveur Cassandra,
   d'un client et de la base de données des films. Les instructions pour installer
   tout cela ont été données
   dans le chapitre :ref:`chap-docstruct`. En résumé, vous devriez avoir:
   
     - une table ``artists`` avec la liste des artistes;
     - une table ``movies`` où chaque film contient des données imbriquées représentant
       le réalisateur du film et les acteurs.

CQL, un sous-ensemble de SQL
============================

CQL ne permet d'interroger qu'une seule table. Cette (*très* forte) restriction  
mise à part (!), le
langage est délibérement conçu comme un sous-ensemble de SQL et de sa construction 
``select from where``. 

.. note:: Toute requête CQL doit se terminer par un ';'

Commençons par quelques exemples.


Sélectionnons tous les artistes.

.. code-block:: sql

      select  * from artists;

Selon l'utilitaire que vous utilisez, vous devriez obtenir l'affichage des premiers artistes
sous une forme ou sous une autre. Cassandra étant supposé gérer de très grandes bases de données, 
ces utilitaires vont souvent ajouter automatiquement une clause limitant le nombre
de lignes retournées. Vous pouvez ajouter cette clause explicitement.

.. code-block:: sql

      select  * from artists limit 20;

On peut obtenir le résultat encodé en JSON en ajoutant simplement le mot-clé ``JSON``.

.. code-block:: sql

      select JSON * from artists;

Bien entendu, le ``*`` peut être remplacé par la liste des attributs à conserver (projeter).

.. code-block:: sql

      select title from movies;

Si une valeur *v* est un dictionnaire (objet en JSON), on peut accéder à l'un 
de ses composants *c* avec  la notation *v.c*. Exemple pour le réalisateur du film.

.. code-block:: sql

       select title, director.last_name from movies;


En revanche, quand la valeur est un ensemble ou une liste, on ne sait pas avec CQL accéder
à son contenu. La tentative d'exécuter la requête:

.. code-block:: sql

      select title, actors.last_name from movies;

devrait retourner une erreur. Il est vrai que l'on ne sait pas très bien à quoi devrait ressembler 
le résultat. D'autres langages (notamment XQuery, mais également le langage de script Pig que nous
étudierons en fin de cours) proposent des solutions au problème
d'interrogation de collections imbriquées. Il se peut que CQL évolue
un jour pour proposer quelque chose de semblable.

On peut, dans la clause ``select``, appliquer des fonctions. Cassandra permet la définition de fonctions
utilisateur, et leur application aux données grâce à CQL. Quelques fonctions prédéfinies sont
également disponibles. Voici un exemple (sans intérêt autre qu'illustratif) 
de conversion de l'année du film
en texte (c'est un entier à l'origine).

.. code-block:: sql

      select cast(year as text) as yearText from movies ; 
      
Notez le renommage de la colonne avec le mot-clé ``as``. Tout cela est directement
emprunté à SQL. On peut également compter le nombre de lignes dans la table.

.. code-block:: sql

     select count(*) from movies ; 
     
On peut effectuer des filtrages avec la clause ``where``. Par exemple:

.. code-block:: sql

       select  *  from movies where id='movie:33';


Remarque importante: le critère de sélection porte ici sur la *clé*. On peut 
généraliser à plusieurs valeurs avec la clause ``in``.

.. code-block:: sql

 	select  * from movies 
    where id in ('movie:33', 'movie:44214', 'movie:29845');
      
Tentons maintenant une recherche sur un attribut non-clé.

.. code-block:: sql

     select  * from movies 
     where title='Elle' ;
     
*Vous devriez obtenir un rejet de cette requête avec le message suivant*:

.. code-block:: text

     Unable to execute CQL script. Cannot execute this query as it might involve data
     filtering and thus may have unpredictable performance. If you want
     to execute this query despite the performance unpredictability,
     use ALLOW FILTERING.

En revanche, en ajoutant l'option ALLOW FILTERING, on obtient 
le résultat.

.. code-block:: sql

     select  * from movies 
     where title='Elle' 
     ALLOW FILTERING;

Nous avons atteint les limites de CQL en tant que clône de SQL. 

Pourquoi CQL n'est pas SQL
==========================

Pourquoi un ``where`` sur un attribut non-clé est-il rejeté? Pour une raison qui tient
à l'organisation des données:

  - Cassandra organise une table selon une structure (que nous étudierons ultérieurement)
    qui permet très rapidement de trouver un document par sa clé. La recherche par clé
    est donc autorisée.
  - Cette structure n'existe que pour la clé. *Toute recherche sur un autre attribut n'a d'autre
    solution que de parcourir séquentiellement toute la table en effectuant le test sur
    le critère de recherche à chaque fois*.
    
Comme déjà indiqué, Cassandra est conçu pour de très grandes bases de données, et le rejet 
de ces requêtes est une précaution. Le message indique clairement à l'utilisateur que
sa requête est susceptible de prendre beaucoup de temps à s'exécuter. 

À l'usage on décrouvre tout un ensemble de restrictions (par rapport à SQL) qui s'expliquent
par cette volonté d'éviter l'exécution d'une requête qui impliquerait un parcours de tout
ou partie de la table. Voyons quelques exemples, avec explications.

.. note:: Certaines des explications qui suivent sont volontairement brèves car elles
   impliquent une compréhension de la structure interne des données dans Cassandra ainsi que
   de la méthode de répartition dans un environnement distribué.
   Nous présenterons tout cela plus tard. 
  
Tentons une requête sur la clé primaire, mais avec un critère *d'inégalité*.

.. code-block:: sql

     select  * from movies 
     where id > '000000';
     
On obtient un rejet avec un message indiquant que seule l'égalité est autorisée sur la clé
(et d'autres détails à éclaircir ultérieurement).

Peut-on trier les données avec la clause ``order by``? Essayons.

.. code-block:: sql

    select  * from movies order by title;

Les deux requêtes sont rejetées. Le message nous dit (à peu près)
que le tri est autorisé seulement quand on est assuré que les données à 
trier proviennent
d'une seule partition. En (un peu plus) clair: Cassandra ne veut pas avoir à trier des données
provenant de plusieurs serveurs, dans un environnement distribué avec répartition d'une table
sur plusieurs nœuds. 

Et voilà. Cassandra interdit tout usage de CQL qui amènerait à parcourir toute la base ou
une partie non prédictible de la base pour constituer le résultat. Cette interdiction
n'est cependant pas totale. Dans le cas de la clause ``where``, l'utilisateur 
peut prendre explicitement ses responsabilités en ajoutant la clause ``allow filtering``,
comme nous l'avons montré ci-dessus.

Si la table contient des milliards de ligne (bon, c'est peu probable ici), il faudra certainement
attendre longtemps et exploiter intensivement les ressources du système pour un résultat
limité. À utiliser
à bon escient donc.

Il faut penser que le coût d'évaluation de cette requête est proportionnel à la taille 
de la base. Cassandra
tente de limiter les requêtes à celles dont le coût est proportionnel à la 
taille du résultat.

.. note:: Cette remarque explique pourquoi la requête ``select * from movies;``, qui
   parcourt toute la base, est autorisée.

À partir du moment où on autorise explicitement le filtrage, on peut combiner plusieurs
critères de recherche, comme en SQL.

.. code-block:: sql

     select  * from movies 
     where country='US' and year=2020 allow filtering;

*Mais*, si c'est pour faire du SQL, autant choisir une base relationnelle. Les restrictions
de Cassandra doivent s'interpréter dans un contexte *Big Data* où l'accès aux données
doit prendre en compte leur volumétrie (et notamment le fait que cette volumétrie
impose une répartition des données dans un système distribué).

Une autre possibilité est de créer un index secondaire sur les attributs auxquels on souhaite
appliquer des critères de recherche.

.. code-block:: sql

      create index on movies(year);
 
Cassandra autorise alors de requêtes avec la clause ``where`` portant sur les attributs indexés.

.. code-block:: sql
     
    select * from movies where year = 2020;

En présence d'un index, il n'est plus nécessaire de parcourir toute la collection. Cette option
est cependant à utiliser avec prudence. En premier lieu, un index peut être coûteux à maintenir.
Mais surtout sa sélectivité n'est pas toujours assurée. Ici, par exemple, un index sur l'année est
probablement une très mauvaise idée. On peut estimer qu'un film sur 100 a été tourné en 1992, et
à l'échelle du *Big Data*, ça laisse beaucoup de films à trouver, même avec l'index, et une requête
qui peut ne pas être performante du tout.

Mise en pratique
================

Voici quelques manipulations et suggestions de recherches complémentaires.

.. _MEP-S2-1:
.. admonition:: Exercice `MEP-S2-1`_: expérimentez CQL

   À vous de jouer: reproduisez les requêtes ci-dessus sur votre base Cassandra. 

.. _MEP-S2-2:
.. admonition:: Exercice `MEP-S2-2`_: données imbriquées

   Peut-on exprimer des critères sur les données imbriquées? Peut-on
   par exemple trouver tous les films mis en scène par Tarantino? À vous de chercher
   la solution (si elle existe) dans la documentation Cassandra.

.. _MEP-S2-3:
.. admonition:: Exercice `MEP-S2-3`_: sujet d'étude, les vues matérialisées

   Depuis la version 3, Cassandra propose un mécanisme de *vue matérialisé*. Etudiez
   la documentation à ce sujet, et montrez comment ce mécanisme peut permettre
   de répondre à des requêtes comme celle de l'exercice précédent.

*************************
S3: requêtes avec MongoDB
*************************

.. admonition:: Supports complémentaires

    * `Présentation: requêtes MongoDB  <http://b3d.bdpedia.fr/files/slmongodb.pdf>`_
    * `Vidéo de démonstration du langage d'interrogation MongoDB <https://mediaserver.lecnam.net/permalink/v125f35a35e91obhxvm8/>`_
  
  
Précisons tout d'abord que le langage de requête sur des collections est spécifique à MongoDB. Essentiellement,
c'est un langage de recherche dit "par motif" (*pattern*). 
Il consiste à interroger *une* collection en donnant un  objet (le "motif/*pattern*", en JSON) dont chaque 
attribut est interprété comme une contrainte sur la
structure des objets à rechercher. 
Voici des exemples, plus parlants que de longues explications. Nous travaillons sur la
base contenant les films complets, sans référence (donc, celle nommée ``movies`` 
si vous avez suivi les instructions du chapitrte précédent).

L'apprentissage de ce langage n'est pas le sujet de cette session. Ce qui suit ne vise
qu'à illustrer une approche délibérement différente de SQL pour tenter d'adapter
l'interrogation de bases de données aux documents structurés. Une courte discussion
est consacrée à l'opération de jointure, qui n'existe en pas en MongoDB mais qui 
peut être obtenue en programmant nous-mêmes l'algorithme.

Sélections
==========

Commençons par la base: on veut parcourir toute une collection. On utilise
alors ``find()``  dans argument.

.. code-block:: javascript

    db.movies.find ()

S'il y a des millions de documents, cela risque de prendre du temps... D'ailleurs,
comment savoir combien de documents comprend le résultat?

.. code-block:: javascript

    db.movies.countDocuments ()

Comme en SQL (étendu),
les options ``skip`` et ``limit`` permettent de "paginer" le résultat. La requête
suivante affiche 12 documents à partir du dixième inclus.

.. code-block:: javascript

    db.movies.find ().skip(9).limit(12)

Implicitement, cela suppose qu'il existe un ordre sur le parcours des documents. Par défaut,
cet ordre est dicté par le stockage physique: MongoDB fournit les documents dans l'ordre
où il les trouve (dans les fichiers). On peut trier explicitement, ce qui rend
le résultat plus déterministe. La requête suivante trie les documents sur le titre du film,
puis pagine le résultat.

.. code-block:: javascript

    db.movies.find ().sort({"title": 1}).skip(9).limit(12)

La spécification du tri repose sur un objet JSON, et ne prend en compte que les
noms d'attribut sur lesquels s'effectue le tri.  La valeur (ici, celle du titre)
ne sert qu'à indiquer si on trie de manière ascendante (valeur 1) ou descendante (valeur -1).

Attention, trier n'est pas anodin. En particulier, tout tri implique que le
système constitue l'intégralité du résultat au préalable, ce qui induit
une latence (temps de réponse) potentiellement élevée. Sans tri, le système
peut délivrer les documents au fur et à mesure qu'il les trouve. 

Critères de recherche
---------------------

Si on connaît l'identifiant, on effectue la recherche ainsi.

.. code-block:: javascript

    db.movies.find ({"_id": "movie:33"})

Une requête sur l'identifiant ramène (au plus) un seul document. Dans un tel cas, on
peut utiliser ``findOne``.

.. code-block:: javascript

    db.movies.findOne ({"_id": "movie:33"})

Cette fonction renvoie toujours *un* document (au plus), alors que la fonction ``find`` renvoie
un *curseur* sur un ensemble de documents (même si c'est un singleton). La différence est
surtout importante quand on utilise une API pour accéder à MongoDB avec un
langage de programmation.

Sur le même modèle, on peut interroger n'importe quel attribut.

.. code-block:: javascript

    db.movies.find ({"title": "Alien"})
    
Ca marche bien pour des attributs atomiques (une seule valeur), mais comment faire pour interroger
des objets ou des tableaux imbriqués? On utilise dans ce cas des chemins, un peu à la XPath,
mais avec une syntaxe plus "orienté-objet". Voici comment on recherche les films
de Quentin Tarantino.

.. code-block:: javascript

     db.movies.find ({"director.last_name": "Tarantino"})
     
Et pour les acteurs, qui sont eux-mêmes dans un tableau? Ca fonctionne de la même manière.

.. code-block:: javascript

     db.movies.find ({"actors.last_name": "Tarantino"})
     
La requête s'interprète donc comme: "Tous les films dont *l'un* des acteurs se nomme Tarantino".

Conformément aux principes du semi-structuré, on accepte sans 
protester la référence à des attributs
ou des chemins qui n'existent pas. En fait, dire "ce chemin n'existe pas" 
n'a pas grand sens 
puisqu'il n'y a pas de schéma, pas de contrainte sur la structure des objets, 
et que donc
tout chemin existe potentiellement: il suffit de le créer. 
La requête suivante ne ramène rien,
mais ne génére pas d'erreur.

.. code-block:: javascript

     db.movies.find ({"actor.last_name": "Tarantino"})

.. important:: 
     Contrairement à une base relationnelle, une base semi-structurée ne proteste pas quand
     on fait une faute de frappe sur des noms d'attributs.
     
Quelques raffinements permettent de dépasser la limite sur le prédicat *d'égalité*  implicitement
utilisé ici pour comparer les critères donnés et les objets de la base. Pour les chaînes
de caractères, on peut introduire des expressions régulières. Tous les films dont
le titre commence par ``Re``? Voici:

.. code-block:: javascript

    db.movies.find ({"title": /^Re/})
    
Pas d'apostrophes autour de l'expression régulière. On peut aussi effectuer des recherches par intervalle.

.. code-block:: javascript

    db.movies.find( {"year": { $gte: 2000, $lte: 2005 } })

.. important: Il n'y a pas de schéma, et donc les attributs ne sont pas *typés*. Ici,
   l'année des films est représentée par un entier dans nos objets JSON,
   et il faut donc faire la comparaison avec des entiers. Rien ne nous l'indique,
   et aucun contrôle n'est (et ne peut) être effectué.   
   
Projections
-----------

Jusqu'à présent, les requêtes ramènent l'intégralité des objets satisfaisant les critères de recherche. On
peut aussi faire des *projections*, en passant un second argument à la fonction *find()*.

.. code-block:: javascript

     db.movies.find ({"director.last_name": "Tarantino"}, {"title": true, "actors": 'j'} )

Le second argument est un objet JSON dont les attributs sont ceux à conserver dans le résultat. 
Notez que seules les clés du document JSON sont prises en compte (et correspondent 
aux attributs à conserver). La valeur ne compte pas, pourvu qu'elle soit différente de 0 ou ``null``.

Opérateurs ensemblistes
-----------------------

Les opérateurs du langage SQL ``in``, ``not in``, ``any`` et ``all`` se retrouvent
dans le langage d'interrogation. La différence, notable, est que SQL applique
ces opérateurs à des *relations* (elles-mêmes obtenues par des requêtes)
alors que dans le cas de MongoDB, ce sont des tableaux JSON. MongoDB ne
permet pas d'imbriquer des requêtes.

Voici un premier exemple: on cherche les films dans
lesquels joue au moins un des artistes 
dans une liste (on suppose que l'on connaît l'identifiant).

.. code-block:: javascript

    db.movies.find({"actors._id": {$in: ["artist:34","artist:98","artist:1"]}})

Gardez cette recherche en mémoire: elle s'avèrera utile pour contourner
l'absence de jointure en MongoDB. Le ``in`` exprime le fait que *l'une*
des valeurs du premier tableau (``actors._id``) 
doit être égale à l'une des valeurs de l'autre. Il correspond
implicitement, en SQL, à la clause ``ANY``. Pour exprimer le fait que 
*toutes* les valeurs de premier tableau se retrouvent dans le second
(en d'autres termes, une inclusion), on utilise la clause ``all``.

.. code-block:: javascript

    db.movies.find({"director._id": {$all: ["artist:23","artist:147"]}})

Le ``not in`` correspond à l'opérateur ``$nin``. 

.. code-block:: javascript

    db.movies.find({"director._id": {$nin: ["artist:34","artist:98","artist:1"]}})

Comment trouver les films qui n'ont pas d'attribut ``summary``? 

.. code-block:: javascript

    db.movies.find({"summary": {$exists: false}}, {"title": 1})

Opérateurs Booléens
-------------------

Par défaut, quand on exprime plusieurs critères, c'est une conjonction (``and``)
qui est appliquée. On peut l'indiquer explicitement. Voici la syntaxe
(les films tournés avec Leonardo DiCaprio en 1997):

.. code-block:: javascript

    db.movies.find({$and : [{"year": 1997}, {"actors.last_name": "DiCaprio"}]} )
    
L'opérateur ``and`` s'applique à un tableau de conditions. Bien entendu il
existe un opérateur ``or``  avec la même syntaxe. Les films
parus en 1997 *ou* avec Leonardo DiCaprio.

.. code-block:: javascript

    db.movies.find({$or : [{"year": 1997}, {"actors.last_name": "DiCaprio"}]} )

Voici pour l'essentiel en ce qui concerne les recherches portant sur *une* collection
et consistant à sélectionner des documents. Grosso modo, on obtient
la même expressivité que pour SQL dans ce cas. Que faire quand on
doit croiser des informations présentes dans *plusieurs* collections? En relationnel,
on effectue des jointures. Avec Mongo, il faut bricoler.
    
Jointures
=========

La jointure, au sens de: associer des objets *distincts*, provenant en général de *plusieurs*
collections, pour appliquer des critères de recherche croisés, 
n'existe pas en MongoDB. C'est une limitation
importante du point de vue de la gestion de données. On peut considérer qu'elle est cohérente
avec une approche documentaire dans laquelle les documents s'appuient
sur la dénormalisation et sont supposés 
indépendants les uns des autres. Cela étant, on peut imaginer toutes sortes de situations où
une jointure est *quand même* nécessaire dans une aplication de traitement de données. 

Voyons
comment nous pouvons contourner le problème. Nous allons supposer pour les besoins
de la cause que la collection des films ne contient que les identifiants des artistes 
impliquées, et qu'une seconde collection contient les informations sur ces artistes
(vous pouvez charger cette dernière collection à partir d'un fichier disponible sur le site).


Une première approche est de créer une *vue* qui assemble deux collections dans 
une troisième, virtuel. Cela suppose qu'on accepte de créer une vue pour chaque 
jointure...

La création de vue est la suivante:

.. code-block:: javascript

	db.createView( "full_movies", "movies", [
   	{
    	  $lookup:
        	 {
            	from: "artists",
            	localField: "director._id",
            	foreignField: "_id",
            	as: "metteur_en_scene"
         	}
   	}] 
   )

On crée une collection-vue ``full_movies`` qui étend chaque document de la collection 
``movies``en y intégrant un champ ``metteur_en_scene``, lequel contient 
le document de la collection ``artists`` correspondant à l'identifiant 
``director._id``` (relisez encore une fois si ce n'est pas clair...).

On peut alors interroger la collection ``full_movies``, qui implante à peu près
l'équivalent d'une jointure externe en relationnel.

.. code-block:: javascript 

	db.full_movies.find()


L'autre approche consiste à effectuer la jointure  côté client,
comme illustré sur la :numref:`jointure-serveur-client`. Cela
revient essentiellement à appliquer l'algorithme de jointures par boucle imbriquées en stockant
des données temporaires dans des structures de données sur le client, et en effectuant des échanges
réseaux entre le client et le serveur, ce qui dans l'ensemble est très inefficace. 


.. _jointure-serveur-client:
.. figure:: ../figures/jointure-serveur-client.png
      :width: 80%
      :align: center
   
      Jointure côté serveur et côté client
      
Comme l'interpréteur ``mongo`` permet de programmer en Javascript, nous pouvons en fait
illustrer la méthode assez simplement. Considérons la requête: "Donnez tous les films dont
le directeur est Clint Eastwood". 


La première étape dans la jointure côté client consiste à chercher l'artiste Clint Eastwood
et à le stocker dans l'espace mémoire du client (dans une variable, pour dire les choses simplement).

.. code-block:: javascript

    eastwood = db.artists.findOne({"first_name": "Clint", "last_name": "Eastwood"})

On dispose maintenant d'un objet ``eastwood``. Une seconde requête va récupérer les films
dirigés par cet artiste.

.. code-block:: javascript

    db.movies.find({"director._id": eastwood['_id']}, {"title": 1})

Voilà le principe. Voyons maintenant plus généralement comment on effectue
l'équivalent des jointures en SQL. Prenons la requête suivante:

.. code-block:: sql

   select m.titre, a.*  from Movie m, Artist a
   where m.id_director = a.id
   
On veut donc les titres des films et le réalisateur. On va devoir coder, *du côté
client*, un algorithme de jointure par boucles imbriquées. Le voici, sous
le shell de MongoDB (et donc en programmation javascript).

.. code-block:: javascript

    var lesFilms = db.movies.find()
    while (lesFilms.hasNext()) {
      var film = lesFilms.next();
      var mes = db.artists.findOne({"_id": film.director._id});
      printjson(film.title);
      printjson(mes);
    }

On a donc une boucle, et une requête imbriquée, exécutée autant de fois qu'il y a de films.
C'est exactement la méthode qui serait utilisée
*par le serveur* si ce dernier implantait les jointures. L'exécuter du côté
client induit un surcoût en programmation, et en échanges réseau entre le client
et le serveur.

Mise en pratique
================

Voici quelques propositions d'exercices si vous souhaitez vous frotter 
concrètement à l'interrogation MongoDB.

.. _MEP-S3-1:
.. admonition:: Exercice `MEP-S3-1`_: requêtes sur la base des films. 

   Sur votre base ``movies``, 
  
            * tous les titres;
            * tous les titres des films parus après 2000;
            * le résumé de Spider-Man;                       
            * qui est le metteur en scène de *Gladiator*?
            * titre des films avec Kirsten Dunst;
            * quels films ont un résumé?
            * les films qui ne sont ni des drames ni des comédies.
            * affichez les titres des films et les noms des acteurs.
            * dans quels films Clint Eastwood est-il acteur mais pas réalisateur (aide: utilisez
              l'opérateur de comparaison ``$ne``).
            * **Difficile**: Comment chercher les films dont le metteur en scène est *aussi* un acteur?            
              Pas sûr que ce soit possible sans recourir à une auto-jointure, côté client... 
                       
   .. ifconfig:: mongoquery in ('public')

      .. admonition:: Correction
           
            * ``db.movies.find({}, {"title": 1})``
            * ``db.movies.find({"year": {$gt: "2000"}}, {"title": 1, "year": 1})``
            * ``db.movies.find({"title": "Spider-Man"}, {"summary": 1})``
            * ``db.movies.find({"title": "Gladiator"}, {"director": 1})``
            * ``db.movies.find({"actors.last_name": "Dunst"}, {"title": 1})``
            * ``db.movies.find({"summary": {$exists: true}}, {"title": 1})``
            
                NB: cette fonction regarde si le champ existe, pas s'il est vide ou non.
                Dans la base, il existe des films avec un résumé ayant pour valeur null. Afin 
                de ne récupérer que les films ayant réellement un résumé, on peut ajouter ``$ne:null``

                  ``db.movies.find({"summary": {$exists: true, $ne:null}}, {"title": 1})``
                
                donne les films dont le champ résumé existe et dont la valeur du champ est différente de null.
            
            * ``db.movies.find({"genre": {$nin: ["Drame", "Comédie"]}}, {"title": 1, "genre": 1})``
            * ``db.movies.find({}, {"title": 1, "actors.first_name": 1, "actors.last_name": 1})``
            * ``db.movies.find({"actors.last_name": "Eastwood", "director.last_name": {$ne: "Eastwood"}}, {"title": 1})``
    

********************************
S3: Introduction à ElasticSearch
********************************

.. admonition:: Supports complémentaires

   * `Diaporama sur le couplage BD documentaire / moteur de recherche <http://b3d.bdpedia.fr/files/slri-intro-debuterES.pdf>`_
   * `Vidéo de la session Bases documentaires et moteur de recherche <https://mediaserver.lecnam.net/permalink/v125f5947d4bf7inn4n4/>`_  
   * `Présentation: Requêtes booléennes <http://b3d.bdpedia.fr/files/slri-intro-lucene-query.pdf>`_
   * `Vidéo de la session requêtes booléennes <https://mediaserver.lecnam.net/permalink/v125f5947d4bf62u4nbc/>`_  

Dans cette section, nous allons passer au concret en introduisant les moteurs de
recherche. Nous allons utiliser ici `Elastic Search <http://elastic.co>`_, un
moteur de recherche qui s'installe et s'initialise très facilement. Nous
indexerons nos premiers documents, et commencerons à faire nos premières
requêtes.

.. admonition:: ElasticSearch ou Solr

  ElasticSearch est un moteur de recherche disponible sous licence libre
  (Apache). Il repose sur Lucene (nous verrons plus bas ce que cela signifie).
  Il a été développé à partir de 2004 et est aujourd'hui adossé à une
  entreprise, `Elastic.co <https://www.elastic.co/fr/>`_. Un autre moteur de
  recherche libre existe: `Solr <http://lucene.apache.org/solr/>`_ (prononcé
  "Solar"), lui aussi reposant sur Lucene. Bien que leurs configurations soient
  différentes, les fonctionnalités de ces deux moteurs sont comparables
  (cela n'a pas toujours été le cas). Nous choisissons ElasticSearch pour ce
  cours, mais vous ne devriez pas avoir beaucoup de difficultés à passer à Solr.

Nous allons nous appuyer entièrement sur les choix par défaut d'ElasticSearch
pour nous concentrer sur son utilisation. La construction d'un moteur de
recherche en production demande un peu plus de soin, nous en verrons au chapitre
suivant les étapes nécessaires.

Architecture du système d'information avec un moteur de recherche
=================================================================

Un moteur de recherche comme ElasticSearch est une application spécialisée dans
la recherche, qui s'appuie sur un index *open source* écrit en Java, Lucene.
C'est-à-dire que l'implémentation des structures de données et les algorithmes
de parcours vus dans la section précédente sont déléguées à Lucene (qui profite
régulièrement des avancées des techniques de Recherche d'Information issues du
monde académique).

Une question qui vient naturellement à l'esprit est alors: *mais pourquoi ne pas
utiliser directement le moteur de recherche comme gestionnaire des documents ?*
En effet, pourquoi s'embarrasser de MongoDB alors qu'ElasticSearch permet des
recherches puissantes, efficaces, ainsi que le stockage et l'accès aux
documents.

La réponse est qu'un système comme ElasticSearch est entièrement consacré à la
recherche (donc à la *lecture*) la plus efficace possible de documents. Il
s'appuie pour cela sur des structures compactes, compressées, optimisées (les
index inversés) dont nous avons donné un aperçu. En revanche, ce n'est pas 
nécessairement un
très bon outil pour les autres fonctionnalités d'une base de données. Le
stockage par exemple n'est ni aussi robuste ni aussi stable, et il faut parfois
*reconstruire* l'index à partir de la base originale (on parlera de *réindexer
les documents*).

Un système comme ElasticSearch (ou Solr, ou un autre s'appuyant sur des index
inversés) n'est pas non plus très bon pour des données souvent modifiées. Pour
des raisons qui tiennent à la structure de ces index, les mises à jour sont
coûteuses et s'effectuent difficilement en temps réel. La notion de mise à jour
vaut ici aussi bien pour le *contenu* des documents (modification de la valeur
d'un champ) que pour leur *structure* (ajout ou suppression d'un champ par exemple).

La pratique la plus courante consiste donc à utiliser un système de recherche
comme un *complément* d'un serveur de base de données (relationnelle ou
documentaire) et à lui confier les tâches de recherche que le serveur BD ne sait
pas accomplir (soit, en gros, les recherches non structurées). Dans le cas des
bases NoSQL, l'absence fréquente de tout langage de requête fait du moteur de
recherche associé un outil indispensable. 

Même en cas de présence d'un langage d'interrogation  fourni par le système
NoSQL, le moteur de recherche est un candidat tout à fait valide pour satisfaire
les recherches plein texte *et* les recherches structurées. En résumé, à part
les deux inconvénients (reconstruction depuis une source extérieure, support
faible des mises à jour), les moteurs de recherche sont des composants puissants
aptes à satisfaire efficacement les besoins d'un système documentaire.

.. note:: Les paragraphes ci-dessus sont à prendre avec réserve, car l'évolution
   d'un système comme Elastic Search montre qu'il tend à devenir également
   un gestionnaire robuste pour le stockage de documents.
   Il n'est pas exclu qu'Elastic Search devienne à terme une option tout à fait 
   valable pour l'indexation *et* le stockage ce qui simplifierait l'architecture.

.. _archi-ri:
.. figure:: ../figures/archi-ri.png
      :width: 100%
      :align: center
   
      Architecture d'une application avec moteur de recherche.

La  :numref:`archi-ri` montre une architecture typique, en prenant pour
exemple une base de données MongoDB. Les *documents (applicatifs)* sont donc
dans la base MongoDB qui fournit des fonctionnalités de recherche structurées.
On peut indexer la collection des documents applicatifs en extrayant des
"champs" formant des *documents (au sens d'ElasticSearch, Solr)* fournis à l'index qui
se charge de les organiser pour satisfaire efficacement des requêtes.
L'application peut alors soit s'adresser au serveur MongoDB, soit au moteur de
recherche.

Un scénario typique est celui d'une recherche par mot-clé dans un site. Les
données du site sont périodiquement extraites de la base et indexées dans
Elasticsearch. Ce dernier se charge alors de répondre à la fonctionnalité
``Search`` que l'on trouve couramment sur tous les types de site. 

.. note:: On pourrait se demander s'il n'est pas inefficace de *dupliquer* les
  documents de la base de données vers le moteur de recherche. En fait, c'est un
  inconvénient, mais assez mineur car on *filtre* généralement les documents de
  la base pour n'indexer que les champs soumis à des recherches plein texte
  comme le résumé du film. De plus, les données fournies ne sont pas stockées
  telles-quelles mais compressées et réorganisées dans des listes inversées.
  Le contenu de la base de données n'est donc pas 
  un miroir de l'index géré par le moteur de recherche.


Interrogation
=============

Nous reverrons plus longuement les méthodes d'interrogation après 
avoir expliqué, dans le prochain chapitre, les techniques
de classement. En attendant voici un premier aperçu qui vous
permettra de vérifier que vos données sont bien là. 

Une première méthode pour transmettre des recherches est de passer une
expression en paramètre à l'URL à laquelle répond votre serveur ElasticSearch.
La forme la plus simple d'expression est une liste de mots-clés.
Voici quelques exemples d'URLs de recherche:


.. code-block:: html

     https://localhost:9200/nfe204/_search?q=alien
     https://localhost:9200/nfe204/_search?q=alien,coppola
     https://localhost:9200/nfe204/_search?q=alien,coppola,1994

Les dernières versions (à partir de la 8)
d'ElasticSearch ont introduit des mesures de sécurité qui compliquent 
fortement l'accès direct au serveur en HTTPS. Mieux vaut donc utiliser
ElasticVue avec la fenêtre ``SEARCH``  qui se charge se constituer l'URL 
de requête.

Une seconde méthode est de transmettre un document JSON décrivant la recherche. L'envoi
d'un document suppose que l'on utilise la méthode ``POST``. Voici
par exemple un document avec une recherche sur trois mots-clé.

.. code-block:: json

   {
    "query": {
       "query_string" : {
          "query" : "alien,coppola,1994"
       }
     }
   }
   
La 
:numref:`es-search` montre l'exécution avec l'interface ElasticVue.

.. _es-search:
.. figure:: ../figures/es-search.png
      :width: 100%
      :align: center
   
      L'interface ElasticVue avec recherches structurées
      
On voit clairement (mais partiellement) le résultat, produit sous la forme d'un
document JSON énumérant les documents trouvés dans un tableau ``hits``. Notez
que le  document indexé lui-même est présent, dans le champ ``_source``,
correspondant à un comportement par défaut d'ElasticSearch: *la totalité des documents sont dupliqués dans ElasticSearch*:  la
question de l'utilisation de *deux* systèmes qui semblent partiellement
redondants se pose. Nous revenons sur cette question plus loin. 

Exprimer une recherche revient donc à envoyer à ElasticSearch 
(utiliser la méthode ``POST``) un document encodant la requête.
Le langage de recherche proposé par ElasticSearch, dit "DSL" pour *Domain
Specific Language*,  est très riche.  Pour vous donner juste un exemple,
voici comme on prend les 5 premiers documents d'une requête, en excluant la
source du résultat.

.. code-block:: json

   { 
    "from": 0,
    "size": 5,
    "_source": false,
    "query": {
       "query_string" : {
           "query" : "matrix,2000,jamais"
       }
     } 
   }


Nous allons pour l'instant nous contenter d'une variante du language, 
dite *Query String*, qui
correspond, essentiellement, au langage de base de Lucene.  Toutes les
expressions données ci-dessous peuvent être entrées comme valeur du champ
``query`` dans le document-recherche passé à l'interface ``REST``.

Termes
------

La notion de base est celle de *terme*. Un terme est soit un mot, soit une
séquence de mots (une *phrase*) placée entre apostrophes. La recherche:

.. code-block:: sql

   Princess Leia

retourne tous les documents contenant soit "Princess", soit "Leia". La recherche

.. code-block:: sql

  "Princess Leia"
  
ramène les documents contenant les deux mots côte à côte (vous devez utiliser
\\" pour intégrer un guillemet double dans une requête). 

.. code-block:: json

   { 
    "query": {
       "query_string" : {
           "query" : "\"Princess Leia\""
       }
     } 
   }

Par défaut, la recherche  s'effectue toujours sur tous les champs d'un document
indexé (ou , plus précisément, sur un champ ``_all`` dans lequel ElasticSearch
concatène toutes les chaînes de caractères). La syntaxe complète pour associer
le champ et le terme est:

.. code-block:: sql

  champ:terme

Par exemple, pour ne chercher le mot-clé ``Alien`` que dans les titres des films, on peut
utiliser la syntaxe suivante :

.. code-block:: json

   { 
    "query": {
       "query_string" : {
           "query" : "title:alien"
       }
     } 
   }

Revenez au fichier JSON  et à la structure de ses documents pour
voir que les données de chaque film sont imbriquées sous un champ ``fields``.
Nous l'omettons dans la suite, pensez à l'ajouter.

Si on ne précise pas le champ, c'est celui par défaut qui est pris en compte. 
Les requêtes précédentes sont donc équivalentes à:

.. code-block:: sql

   _all:"Princess Leia"
  
Les valeurs des termes (dans la requête) et le texte indexé sont tous deux
soumis à des transformations que nous étudierons dans le chapitre suivant. Une
transformation simple est de tout transcrire en minuscules. La requête:

.. code-block:: sql

   _all:"PRINCESS LEIA"

devrait donc donner le même résultat, les majuscules étant converties en
minuscules. La conception d'un index doit soigneusement indiquer les
transformations à appliquer, car elles déterminent le résultat des recherches.
   
.. important: Les transformations appliquées à la requête ET au texte indexé doivent être 
   cohérentes. Si les termes sont transformés en majuscules, et le texte indexé en minuscules,
   on n'aura jamais de résultat!

On peut spécifier un terme simple (pas une phrase) de manière incomplète

  * le '?' indique un caractère inconnue: ``opti?al`` désigne ``optimal``, ``optical``, etc.
  * le '\*' indique n'importe quelle séquence de caractères (``opti*`` pour toute chaîne commençant par ``opti``). 
      
La valeur d'un terme peut-être indiquée de manière approximative en ajoutant le suffixe '-', si l'on n'est pas sûr de l'orthographe par
exemple.  Essayez de rechercher ``optimal``, puis ``optimal-``. La proximité des termes est établie par
une distance dite "distance d'édition" (nombre d'opérations d'éditions permettant de passer d'une valeur - optimal -
à une autre - optical).

Des recherches *par intervalle* sont possibles. Les crochets [] expriment des
intervalles *bornes comprises*, les accolades {} des intervalles bornes non
comprises. Voici comment on recherche tous les documents pour une année comprise
entre 1990 et 2005:

.. code-block:: sql

    year:[1990 TO 2005]
   
Connecteurs booléens
--------------------

Les critères de recherche peuvent être combinés avec les connecteurs Booléens 
``AND``, ``OR`` et ``NOT``. Quelques exemples.

.. code-block:: sql

   year:[1990 TO 2005] OR title:M*
   year:[1990 TO 2005] AND NOT title:M*
   
.. important:: Attention à bien utiliser des majuscules pour les connecteurs Booléens.

Par défaut, un ``OR`` est appliqué, de sorte qu'une recherche sur plusieurs critères ramène l'union
des résultats sur chaque critère pris individuellement. 

Venons-en maintenant à l'opérateur "+". Utilisé comme préfixe d'un nom
de champ, il indique que la valeur du champ *doit* être égale au terme.
La recherche suivante:

.. code-block:: sql

    +year:2000  title:matrix

recherche les documents dont l'année est 2000 (obligatoire) **ou** dont le titre
est ``matrix`` ou n'importe quel titre. 

Quelle est alors la différence avec ``+year:2000``?  La réponse tient
dans le *classement* effectué par le moteur de recherche: les documents dont
le titre est ``matrix`` seront mieux classés que les autres. C'est une illustration,
parmi d'autres, de la différence entre "recherche d'information" et "interrogation
de bases de données". Dans le premier cas, on cherche les documents les plus "proches",
les plus "pertinents", et on classe par pertinence.



Mise en pratique
================

.. _MEP-S2-1:
.. admonition:: Exercice  `MEP-S2-1`_: mise en route ElasticSearch

   Installez ElasticSearch sur votre machine selon les instruction précédentes. 
   Insérez le fichier des films. Vous pouvez alors en 
   profiter pour explorer les options de l'interface ElasticVue, ce qui vous facilitera les choses
   par la suite.

Quiz
====

.. eqt:: ri-se-1

    Parmi les arguments ci-dessous, lequel vous semble faux pour
    distinguer un moteur de stockage NoSQL d'un moteur de recherche comme Elastic Search?
   
    A) :eqt:`I`  Les mises à jour du contenu ou du schéma
       sont plus difficiles avec un moteur de recherche à cause 
       de la compression des  listes inversées
    #) :eqt:`C`  On ne peut pas faire de recherche structurée avec un moteur de recherche
    #) :eqt:`I` Un moteur de recherche étant conçu comme une structure secondaire, il n'offre pas la même sécurité de stockage.

.. eqt:: ri-se-2

    Quelles sont les conséquences techniques d'une architecture comme celle de la :numref:`archi-ri`
   
    A) :eqt:`I`  Il faut reconstruire l'index du moteur de recherche tous les soirs
    #) :eqt:`C`  Il faut synchroniser toute mise à jour du moteur de stockage vers l'index
    #) :eqt:`I` Il faut synchroniser toute mise à jour de l'index vers le  moteur de stockage

.. eqt:: ri-se-3

    Quel est le protocole d'échange avec Elastic Search
   
    A) :eqt:`C`  HTTP
    #) :eqt:`I`  Swift
    #) :eqt:`I` Un protocole propriétaire


.. eqt:: ri-bool-1

    Avec une requête de type "Query string", Elastic Search effectue la recherche
   
    A) :eqt:`I`  Dans le premier champ de type texte des documents indexés
    #) :eqt:`I`  Dans un champ de type texte défini par défaut
    #) :eqt:`C` Dans un champ constitué de la concaténation de tous les textes d'un document


.. eqt:: ri-bool-2

    La recherche booléenne  dans cette session est-elle identique
    à celle présentée en début de chapitre et basée sur les vecteurs d'incidence?
   
    A) :eqt:`I`  Oui, car l'exécution repose sur les OR et AND binaires 
    #) :eqt:`C`  Non, car Elastic Search peut ramener des documents même si une partie seulement 
       des termes recherchés est présente.


.. eqt:: ri-bool-3

    Est-il possible de demander les documents dans lesquels un mot ne figure pas (par exemple
    les textes avec "loup", "cochon" mais pas "bergerie")?
   
    A) :eqt:`C`  Oui
    #) :eqt:`I`  Non

