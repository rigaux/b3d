.. _chap-projet:
   
##############
Projets NFE204
##############

Le cours NFE204 est validé par la réalisation 

  - d'un mini-projet accompagné d'un rapport, portant sur les sujets 
    vus en cours, 
  - ainsi que par un examen de contrôle. 

Le projet est mené seul ou en binôme et comprend deux parties:
  
   - *Pratique/utilisation*: constituer une base de données documentaire avec un 
     des nombreux systèmes NoSQL disponibles, autres que ceux vus en cours;
   - *Etude*:  approfondir un des aspects du système NoSQL choisi, et 
     notamment ses capacités de passage à l'échelle.

Attention, **il ne s'agit pas d'écrire une application** mais de comprendre et d'expliquer
le fonctionnement d'un système dédié à la gestion de données massives. Inutile de vous lancer
dans des développements En revanche, l'exercice doit vous permettre de démontrer:

 - votre  esprit critique: ne recrachez pas aveuglément les présentations marketing que vous trouverez en abondance.
 - analyse basée sur vos connaissances: utilisez ce que vous avez appris pour argumenter des avantages et 
   inconvénients du système étudié de manière raisonnée.
 - capacité d'expression: voir "le rapport" ci-dessous.
 
Pour ceux/celles qui suivent NFE204 dans l'optique d'obtenir le Certificat de Spécialisation *Analyste de Données Massives*,
il peut être judicieux que les données choisies soient associées à une 
*problématique d’analyse* qui sera ensuite expérimentée, sur la base constituée, dans l'une des
UE consacrée à la fouille de données (STA211/RCP216). Cette base servira également de support
pour effectuer un développement et une étude significatifs,  
notamment en termes de volume et de passage à l’échelle, pendant l’UA du certificat.
 
**********
Les étapes
**********

La préparation du projet se fait par étapes

   * *Trois mois après le début du cours*: remise d'un résumé de deux pages
     résumant le contenu du projet, à savoir:
     
      * noms des membres du binôme;
      * court descriptif du projet dans son ensemble;
      * processus de collecte des données: sources, format et contenu, fréquence, volumétrie envisagée;
      * problématique d'analyse (pour ceux qui suivent le Certificat de Spécialisation)
      * système NoSQL choisi pour le stockage, et choix d'un des aspects étudiés pour ce système
        (NB: le système *utilisé* peut être MongoDB, mais dans ce cas *l'étude* doit porter sur un autre système).      
  
    **Important**: ce document doit être validé par les enseignants de NFE204, *ainsi que par
    ceux des UE de fouille de données pour les auditeurs suivant le Certificat de Spécialisation*.
     
  * *Un mois après l'examen*: remise d'un rapport expliquant le processus de collecte des données,  d'insertion
    dans la base NoSQL, et développement ) sur l'aspect du système NoSQL que vous avez choisi d'étudier.

Ces documents sont à soumettre dans votre espace numérique Moodle. Deux liens sont proposés, le premier
pour la proposition, le second pour le rapport final. Informez les enseignants du dépôt
des projets pour qu'ils répondent sous forme de commentaire. N'hésitez pas à les relancer après quelques 
jours si vous n'avez pas de nouvelles. Après approbation,
le rapport complet peut être transmis de la même manière.

Ce schéma peut accepter diverses variations: si vous avez déjà une source de données dans
une entreprise, une association ou autre, vous pouvez bien entendu y consacrer votre projet. Si la
mise en œuvre d'un système NoSQL est en cours dans le cadre de votre activité professionnelle, cela peut faire 
l'objet du rapport. Parlez-en à votre enseignant, sachant que les constantes
suivantes doivent être respectées:

  * le projet doit être en relation avec le sujet du cours: documents semi-structurés, bases
    documentaires et NoSQL, moteur de recherche et indexation plein-texte, systèmes distribués;
  * vous devez y participer activement;
  * vous devez faire une étude du système NoSQL choisi, au moins sous l'un de ses aspects;
    *si vous choisissez d'utiliser MongoDB* pour le projet, alors votre étude doit
    porter sur un autre système NoSQL. 

Exemple: 

  *  vous avez décidé de constituer une base pour étudier les déplacements à vélo dans Paris. 
  * la collecte des données se fera à partir du service Web de Vélib:
    https://developer.jcdecaux.com/#/opendata/vls; vous allez réaliser un petit script
    dans le langage de votre choix qui va récupérer quotidiennement les trajets effectués
    en Vélib, sous la forme de documents JSON;
  * (problématique d'analyse): vous voulez produire des graphiques montrant, pour une station Vélib donnée,
    le volume d'emprunt et de retour des vélos, et la disponibilité par période du jour
    pour les emprunts et les retours; si possible vous aimeriez mettre en œuvre un algorithme
    de prédiction pour indiquer aux utilisateurs quels sont les stations qui ont le plus de chance
    de proposer une disponibilité en emprunt/retour, à un horaire donné;
  * vous avez choisi d'utiliser MongoDB, mais vous menez
    en complément une étude comparative sur Riak, un système NoSQL de stockage clé-valeur, 
    en vous concentrant sur l'aspect "traitement distribué des requêtes".

J'insiste sur le fait que le projet doit être **précis** sur l'aspect technique étudié. 
Je veux une présentation détaillée qui explique VRAIMENT comment ça marche, et pas un assemblage de documents
piochés sur le web, que vous avez considérés comme corrects sans vérifier.
Ca suppose que vous passiez du temps pour expérimenter et approfondir. Ne faites pas de survol!

***********
Les données 
***********

Les données peuvent provenir de toutes sortes de sources. Voici quelques suggestions:

  * **Données publiques**. De nombreuses données d'institutions publiques sont maintenant
    disponibles, voir par exemple; https://www.data.gouv.fr/fr/, http://opendatafrance.net/,
    http://www.data-publica.com/.
  * **Services Web**. Voir les réseaux sociaux (Twitter par exemple), les service météos, de traffic,
    de géolocalisation, etc.
  * **Données privées**. Si vous diposez de vos propres sources de données (les mails de votre entreprise,
    les données de votre association), vous pouvez les utiliser: le projet ne nécessite pas de les dévoiler.
  * **Les flux RSS** des sites de *news*, des journaux en ligne, de tous les types de média, etc.
  * et autres, soyez imaginatifs...

Etudiez bien votre source de données, pour savoir quelle volumétrie vous pouvez attendre, et quelle
utilisation vous pouvez en faire.

****************
Le système NoSQL
****************

Vous devez *utiliser* un système NoSQL pour stocker vos données, et *étudier* un des aspects de ce système.
Attention: dans la mesure où MongoDB est étudié en cours, vous pouvez l'utiliser, mais l'étude doit
alors porter sur un autre système.

Voici quelques suggestions, mais regardez les sites http://nosql-database.org/
et http://db-engines.com  pour une liste plus complète.

  * `CouchDB <http://couchdb.apache.org/>`_, un système dont l'originalité est de proposer une interface
    entièrement basée sur HTTP.
  * `RethinkDB <http://www.rethinkdb.com/>`_, un petit nouveau qui semble avoir du succès.
  * `CouchBase <http://http://www.couchbase.com//>`_, une branche de CouchDB qui a bien profité.
  
Mais aussi, Cassandra, MonetDB (sans doute très intéressant), Hadoop/HBase, BerkeleyDB, et Voldemort, et 
tant d'autres.
Pensez à regarder aussi du côté des moteurs de recherche: ElasticSearch, Sphinx, ou à élargir
un peu la problématique pour étudier les systèmes de gestion électronique de document, etc.
  
Quelques exemples d'aspect à étudier particulièrement: langage de recherche, indexation interne, support
de la concurrence d'accès, architecture, technique de distribution, reprise sur panne, etc.


**********
Le rapport
**********

Je n'ai pas besoin d'un rapport *long* (surtout s'il ne contient que des copies d'écran) mais
je demande un rapport de qualité. Essentiellement, il faut que le rapport
représente un travail *personnel*, et que vous exposiez dans vos propres termes ce que 
vous avez appris et compris.

  - Tout le texte doit provenir de vous, tout copié/collé à partir d'une source extérieure
    est *éliminatoire*; attention, je dispose d'un outil qui détecte les plagiats.
  - Vous devez aussi faire vos propres figures, et les commenter.
  - La forme est importante: donnez une table des matières (3 niveaux de titre max), une
    table des figures; numérotez les sections; utilisez des styles cohérents; adoptez
    une présentation distincte pour le code; soigner la rédaction (phrase avec sujet et verbe,
    peu de fautes d'orthographe).
  - Une introduction avec les objectifs, la démarche, le contenu; une conclusion résumant ce
    que vous avez appris.
  - Donnez votre opinion **personnelle**, ne recopiez pas sans réfléchir les idioties
    que beaucoup (y compris des professeurs renommés!) diffusent. Ne donnez une affirmation
    que si vous l'avez comprise et vérifiée.
  - Adoptez un vocabulaire cohérent, définissez-le au début si c'est nécessaire.

C'est aussi le moment d'apprendre à rédiger des documents cohérents et lisibles, en respectant
notamment les règles de base de la typographie française. Cela peut vous sembler anecdotique mais
vous ferez bien meilleure impression en soignant la forme de votre rédaction qu'en présentant un texte baclé,
mal structuré et formellement laid. Je vous conseille le petit livre suivant: 
"*Lexique des règles typographiques en usage à l'Imprimerie nationale*" (à acheter chez un libraire français
de préférence). Pour un quinzaine d'Euros
et un petit effort d'apprentissage, de grands progrès en perspective! À défaut, beaucoup de sites
énoncent les règles principales. Dans tous les cas, relisez-vous avant de soumettre!
 
Quelques exemples de rapports. Il n'est pas *indispensable* de faire aussi bien, mais j'en serais ravi.

  * `Rapport de Guillaume Payen sur Cassandra, 2016 <http://b3d.bdpedia.fr/files/Payen-Cassandra-2016.pdf>`_
  * `Rapport de Rodolphe Chazelle sur RethinkDB, 2016 <http://b3d.bdpedia.fr/files/Chazelle-ReThinkDB-2016.pdf>`_
 
