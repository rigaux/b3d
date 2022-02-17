.. _chap-intro:

Tout le matériel proposé ici sert de support au cours "Bases de données documentaires et distribuées" 
proposé par le département d'informatique du Cnam. Le code du cours est 
NFE204 (voir le site http://deptinfo.cnam.fr/new/spip.php?rubrique146 pour des informations pratiques). Il est donné en

  -  Cours présentiel (premier semestre, mardi soir)
  -  Cours à distance (second semestre, avec supports audiovisuels)
  
Par ailleurs, le document que vous commencez à lire  fait partie de l'ensemble des 
supports d'apprentissage proposés sur le site http://www.bdpedia.fr. Reportez-vous
à ce site pour plus d'explications.

Ce cours fait partie d'un ensemble d'enseignements consacrés à l'analyse de données massives, permettant
éventuellement d'obtenir un Certificat de Spécialisation au Cnam. Vous êtes invités à consulter:

   - Le site du certificat: http://donneesmassives.cnam.fr/
   - La fiche du certificat: http://formation.cnam.fr/rechercher-par-discipline/certificat-de-specialisation-analyste-de-donnees-massives-669531.kjsp
   - La présentation du cours RCP216 sur la fouille de données distribuée http://cedric.cnam.fr/vertigo/Cours/RCP216/preambule.html 
   - La présentation du projet de synthèse (UASB03) qui conclut le Certificat de données massives,  http://cedric.cnam.fr/vertigo/Cours/UASB03/uasb03.html

############
Introduction
############


.. admonition::  Supports complémentaires:

    * `Diapositives: Présentation du cours <http://b3d.bdpedia.fr/files/slprescours.pdf>`_
    * `Vidéo de présentation du cours <https://mediaserver.cnam.fr/permalink/v1263e2af2a06w21nl9t/>`_
    
Les bases relationnelles sont adaptées à des informations bien structurées, 
décomposables en unités simples (chaînes de caractères, numériques), et représentables sous 
forme de tableaux. Beaucoup de données ne satisfont pas ces critères: leur structure est complexe, variable, 
et elles ne se décomposent par aisément en attributs élémentaires. Comment représenter le contenu d'un 
livre par exemple? d'une image ou d'une vidéo? d'une partition musicale?

Les bases relationnelles répondent à cette question en multipliant le nombre de tables,
et de lignes dans ces tables, pour représenter ce qui constitue conceptuellement
une même "entité". Cette décomposition en fragment "plats" (les lignes)
est la fameuse *normalisation* (relationnelle) qui impose, pour reconstituer
l'information complète, d'effectuer une ou plusieurs jointures assemblant les lignes stockées
indépendamment les unes des autres. 

.. note:: Ce cours suppose une connaissance solide des bases de données relationnelles. Si
   ce n'est pas le cas, vous risquez d'avoir des lacunes et des difficultés à assimiler
   les nouvelles connaissances présentées. Je vous recommande au préalable de consulter
   les cours suivants:
   
      - le cours `Bases relationnelles, modèles et langages <http://sql.bdpedia.fr>`_, pour tout
        savoir sur la conception d'une base relationnelle et le langage SQL.
      - le cours `Systèmes relationnels <http://sys.bdpedia.fr>`_, pour les aspects systèmes: indexation,
        optimisation, concurrence d'accès.
      
   
Cette approche, qui a fait ses preuves, ne convient cependant pas dans certains cas. Les
données de nature essentiellement textuelle par exemple (livre, documentation) se représentent mal en relationnel;
c'est vrai aussi de certains objets dont la stucture est très flexible; enfin, *l'échange de données*
dans un environnement distribué se prête mal à une représentation éclatée en plusieurs constituants
élémentaires  qu'il
faut ré-assembler pour qu'ils prennent sens. Toutes ces raisons mènent à des modes de représentation
plus riches permettant la réunion, en une seule structure, de toutes les informations relatives 
à un même objet conceptuel. C'est ce que nous appellerons *document*, dans une acception
élargie un peu abusive mais bien pratique.

**************
Sujet du cours
**************

Dans tout ce qui suit nous désignons donc par le terme générique de *document* toute 
paire *(i, v)* où *i* est l'identifiant du document et *v* 
une *valeur structurée*  contenant les informations caractérisant le document. Nous
reviendrons plus précisément sur ces notions dans le cours.

La gestion d'ensembles de documents selon les principes des bases de données, 
avec notamment des outils de recherche avancés, relève des *bases documentaires*. Le volume important 
de ces bases amène souvent à les gérer dans un système distribué constitué de 
fermes de serveurs allouées à la demande dans une infrastructure de type "cloud". L'usage
est maintenant établi d'appeler ces systèmes "NoSQL" pour souligner leurs différences avec
les systèmes relationnels. Le fait qu'ils ne suivent pas le modèle relationnel 
est d'ailleurs à peu près leur seul point commun. De manière générale, et avec de grandes
variantes quand on se penche sur les détails, ils partagent également:

  - la représentation des données sous forme d'unités d'information indépendantes les unes des unes, 
    (ce que nous appelons justement *document*) organisées en *collections*;
  - des méthodes d'accès aux collections basées soit sur des primitives assez
    simplistes, soit sur des recherches par similarité qui relèvent de la *recherche d'information*;
  - la capacité à *passer à l'échelle* (expression énigmatique que nous essaierons de clarifier)
    par ajout de ressources matérielles, donnant ces fameux environnements distribués et extensibles,
  - et enfin des techniques de distribution de calculs permettant de traiter des collections
    massives dans des délais raisonnables.
    
    
Tous ces aspects, centrés sur les 
documents de nature textuelle (ce qui exclut les documents multimédia comme les images ou vidéos),
constituent le cœur de notre sujet.   Il couvre en particulier:

  -  les modèles de données pour documents structurés (XML et JSON), conception, 
     bases de documents structurés (MongoDb, CouchDb, Cassandra, etc.).
  -  l'ndexation et la recherche: extraction de descripteurs, moteurs de recherche, techniques de classement.
  -  la gestion de grandes collections dans des environnements distribués: les systèmes NoSQL (MongoDB, Cassandra, CouchBase, ...)
  -  les traitements à grande échelle: Hadoop, MapReduce, Spark, Flink.

La *représentation* des données s'appuie sur un *modèle*. Dans le cas du relationnel, ce sont des tables
(pour le dire simplement), et nous supposerons que vous connaissez l'essentiel. Dans le cas des documents,
les structures sont plus complexes: tableaux, ensembles, agrégats, imbrication, références. Nous étudions essentiellement
la notion de *document structuré* et son  format de représentation le plus courant, JSON.

Disposer de données, mêmes correctement représentées, sans pouvoir rien en faire n'a que peu d'intérêt. Les 
*opérations* sur les données sont les créations, mises à jour, destruction, et surtout *recherche*, selon
des critères plus ou moins complexes. Les bases relationnelles ont SQL, nous verrons que la recherche dans
des grandes bases documentaires obéit souvent à des principes assez différents, illustrés par exemple
par les moteurs de recherche.

Enfin, à tort ou à raison, les nouveaux systèmes de gestion de données, orientés vers ce que nous appelons,
au sens large, des "documents", sont maintenant considérés comme des outils de choix pour passer à l'échelle
de très grandes masses de données (le "Big data"). Ces nouveaux systèmes, collectivement (et vaguement)
désignés par le mot-valise "NoSQL" ont essentiellement en commun de pouvoir constituer à peu de frais
des systèmes distribués, scalables, aptes à stocker et traiter des collections à très grande échelle. 
Une partie significative du cours est consacrée à ces systèmes,  à leurs principes, et à l'inspection
en détail de quelques exemples représentatifs.

*****************************
Contenu et objectifs du cours
*****************************

Le cours vise à vous transmettre, *dans un contexte pratique*, deux types
de connaissances.

 - Connaissances fondamentales:  
    #. *Modélisation de documents structurés*: structures, sérialisation, formats (JSON, XML); 
       les schémas de bases documentaires; les
       échanges de documents sur le Web et notamment *l'Open Data*.
    #. *Moteurs de recherche pour bases documentaires*: principes, techniques, moteurs de recherche, index, algorithmes.
    #. *Stockage, gestion, et passage à l'échelle par distribution*. L'essentiel sur les systèmes distribués, le
       partitionnement, la réplication, la reprise sur panne; le cas
       des systèmes NoSQL. 
    #. *Traitement de données massives*: Hadoop et MapReduce, et les systèmes modernes, Spark et Flink.

 - Connaissances pratiques:
    #. Des systèmes "NoSQL" orientés "documents"; (MongoDB, CouchDB, Cassandra) 
    #. Des moteurs de recherche (ElasticSearch) basés sur un index inversé (Lucene).
    #. L'étude, en pratique, de quelques systèmes NoSQL distribués: MongoDB (temps réel), 
       ElasticSearch (indexation),  Cassandra encore.
    #. La combinaison des moteurs de stockage et des moteurs de traitement distribué: Hadoop, Spark et Flink.

Les connaissances  préalables  pour bien suivre ce cours sont essentiellement une bonne
compréhension des bases relationnelles, soit au moins la conception d'un schéma, 
SQL, ce qu'est un index et des notions de base sur les transactions. 

Pour les aspects pratiques, il est souhaitable
également d'avoir une aisance minimale dans un environnement de développement. Il s'agit
d'éditer un fichier, de lancer une commande, de ne pas paniquer devant un nouvel outil,
de savoir résoudre un problème avec un minimum de tenacité. Aucun développement
n'est à effectuer, mais des exemples de code sont fournis et doivent être mis en œuvre
pour une bonne compréhension.

Le cours vise à vous transmettre des connaissances génériques, indépendantes
d'un système particulier. Il s'appuie cependant sur la mise en pratique. Vous avez donc besoin d'un ordinateur pour travailler. 
Si vous êtes au Cnam tout est fourni, sinon un ordinateur portable raisonnablement récent et puissant
(8 GOs en mémoire RAM au minimum) suffit. Tous les logiciels utilisés sont libres de droits, et leur
installation est brièvement décrite quand c'est nécessaire.

************
Organisation
************


Le cours est découpé en *chapitres*, couvrant un sujet bien déterminé, et en *sessions*.
J'essaie  de structurer les sessions pour qu'elles
demandent environ 2 heures de travail personnel (bien sûr, cela dépend également de vous).
Pour assimiler une session vous pouvez combiner les ressources suivantes:

  * La lecture du support en ligne: celui que vous avez sous les yeux, également disponible 
    en `PDF <http://b3d.bdpedia.fr/files/b3d.pdf>`_  ou en 
    `ePub <http://b3d.bdpedia.fr/files/b3d.epub>`_. 
  * Le suivi du cours, en vidéo ou en présentiel.
  * La réponse au quiz pour valider votre compréhension
  * La réalisation des exercices proposés en fin de session.
  * Enfin, **optionnellement**, la reproduction des manipulations vues  dans chaque session. N'y passez
    pas des heures:il vaut mieux comprendre les principes que de résoudre des problèmes techniques 
    peu instructifs.
   
La réalisation des exercices en revanche est essentielle pour vérifier que vous maîtrisez le
contenu. Pour les inscrits au cours, ils sont proposés sous forme de devoirs à rendre et à faire
évaluer avant de poursuivre.

Vous devez assimiler le contenu des sessions *dans l'ordre
où elles sont proposées*. Commencez par lire le support, jusqu'à ce que les principes vous paraissent clairs.
Répondez alors au quiz de la session. Essayez de 
reproduire les exemples de code: ils sont testés et doivent donc fonctionner, sous 
réserve d'un changement de version introduisant une incompatibilité.
Le cas échéant, cherchez
à résoudre les problèmes par vous-mêmes: c'est le meilleur moyen de comprendre, mais n'y passez pas
tout votre temps.
Finissez enfin par les exercices. Les solutions sont dévoilées au fur et à mesure de l'avancement
du cours, mais si vous ne savez pas faire un exercice, c'est sans doute que le cours est mal assimilé
et il est plus profitable d'approfondir en relisant à nouveau que de simplement copier une solution.

Enfin, vous êtes totalement encouragés à explorer par vous-mêmes de nouvelles pistes. Certaines
sont proposées dans les exercices.


