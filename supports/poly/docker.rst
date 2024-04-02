.. _chap-docker:

#####################
Préliminaires: Docker
#####################


.. admonition:: Supports complémentaires


      * `Diapositives: introduction à Docker <http://b3d.bdpedia.fr/files/sldocker.pdf>`_
      * `Vidéo de la session consacrée à Docker <https://mediaserver.lecnam.net/permalink/v125f359515b1gu2y6e0/>`_  


La plupart des systèmes étudiés dans ce cours peuvent s'installer et s'exécuter
avec l'environnement *Docker* (http://www.docker.com). Docker permet
d'émuler un système distribué de serveurs.

Un *serveur* est une entité
qui fournit un service (!). Concrètement:

  - un *serveur (machine)* est un ordinateur, tournant sous un système d'exploitation,
    et connecté en permanence au réseau via des *ports*; un serveur machine est
    identifiable sur le réseau par son adresse IP.
  - un *serveur (logiciel)*, ou *service*, est un processus exécuté en tâche de fond d'un serveur machine qui
    communique avec des *clients (logiciels)* via un port particulier.
  - un *système distribué* est constitué de plusieurs services qui communiquent les uns
    avec les autres ; ces services peuvent ou non être répartis sur plusieurs serveurs-machine.
  - un *client (logiciel)* est un programme qui communique avec un service;
  - une *machine virtuelle* est un programme qui simule, sur une machine hôte,
    un autre ordinateur.
    
.. admonition:: Exemple. 

   Un serveur web est un processus (Apache par exemple) qui communique sur le
   port 80 d'un serveur machine. Si ce serveur machine a pour IP 163.12.9.10, alors tout
   client web (Firefox par exemple) peut s'adresser au serveur web à l'adresse 163.12.9.10:80.

La  :numref:`Serveurs` illustre ces concepts de base, que nous utiliserons maintenant
intensivement sans plus d'explication. Elle montre dans une machine physique (le
"système hôte") deux machines virtuelles. Chacune de ces machines dispose 
d'une adresse IP qui lui est propre, et propose des services en écoute sur certains ports.
Un serveur MongoDB est présent par exemple sur chacune des deux machines, en écoute
sur le port par défaut 27017, la différentiation  des serveurs se faisant donc dans 
ce cas par l'adresse IP du serveur qui les héberge.

Inversement, on peut avoir deux serveurs identiques sur une
même machine, mais sur des ports différents. C'est ce qu'illustre
la présence de deux serveurs ElasticSearch sur la seconde machine virtuelle,
sur les ports respectifs 9200 et 9201.

.. _Serveurs:
.. figure:: ../figures/Serveurs.jpg   
      :align: center
   
      Un exemple de système distribué, avec serveurs virtuels et clients


Avant de donner
quelques explications plus élaborées, il vous suffit de considérer que Docker permet d'installer
et d'exécuter très facilement, sur votre ordinateur personnel, et avec
une consommation de ressources (mémoire et disque) très faible, ce que nous appellerons
pour l'instant des "pseudos-serveurs" en attendant d'être plus précis.    
Docker offre deux très grands avantages.

  - il propose des pseudo-serveurs pré-configurés, prêts à l'emploi (les "images"), 
    qui s'installent en quelques clics; 
  - il est tout aussi facile d'installer *plusieurs* pseudos-serveurs communiquant
    les uns avec les autres et d'obtenir donc un système distribué complet, sur
    un simple portable (doté d'une puissance raisonnable).
    
Docker permet de transformer un simple ordinateur personnel en *data center*! Bien entendu, il n'en a
pas la puissance mais pour tester et expérimenter, c'est extrêmement pratique.

**Installation**: Docker existe sous tous les systèmes, dont Windows. Pour Windows et Mac OS, un installateur
*Docker Desktop* 
est fourni à https://www.docker.com/products/docker-desktop. Il contient tous les composants nécessaires
à l'utilisation de Docker.

.. note:: Merci de me signaler des compléments qui seraient utiles à intégrer dans le présent
   document, pour les environnements différents de Mac OS X, et notamment Windows.

*********************
Introduction à Docker
*********************

Essayons de comprendre ce qu'est Docker avant d'aller plus loin. Vous connaissez
peut-être déjà la notion de *machine virtuelle* (VM). Elle consiste à simuler
par un composant logiciel, sur une machine physique,  un ordinateur
auquel on alloue une partie des ressources (mémoire, CPU). Partant
d'une machine dotée par exemple de 4 disques et 256 GO de mémoire, on
peut créer 4 VMs indépendantes avec chacune 1 disque et 64 GO de RAM. Ces
VMs peuvent être totalement différentes les unes des autres. On peut en avoir
une sous le système Windows, une autre sous le système Linux, etc. 

L'intérêt des VMs est principalement la souplesse et l'optimisation
de l'utilisation des ressources matérielles. L'organisation en VMs
rend plus facile la réaffectation, le changement du dimensionnement,
et améliore le taux d'utilisation des dispositifs physiques (disque, mémoire, 
réseau, etc.).

Les VMs ont aussi l'inconvénient d'être assez gourmandes en ressource, puisqu'il
faut, à chaque fois, faire tourner un système d'exploitation complet, avec tout 
ce que cela implique, en terme d'emprise mémoire notamment.

Docker propose une solution beaucoup plus légère, basée sur la capacité
du système Linux (généralisée à Mac OS et Windows) à créer des espaces isolés auxquels on affecte une partie
des ressources de la machine-hôte. Ces espaces, ou *containers* partitionnent
en quelque sorte le système-hôte en sous-systèmes étanches, au sein desquels 
le nommage (des processus, des utilisateurs, des ports réseaux) est purement local.
On peut par exemple faire tourner un processus *apache* sur le port 80
dans le conteneur A, un autre processus *apache* sur le port 80 dans le conteneur B,
sans conflit ni confusion. 
Tous les nommages sont en quelque sorte interprétés par rapport à un container donné (notion
*d'espace de nom*). 

*Les conteneurs sont beaucoup plus légers en consommation de ressources que 
les VMs, puisqu'ils s'exécutent au sein d'un unique système d'exploitation*. Docker
exploite cette spécificité pour proposer un mode de virtualisation
(que nous avons appelé "pseudo-serveur" en préambule) léger et flexible.

Docker et ses conteneurs
========================

Docker (ou, très précisément, le *docker engine*) est un 
programme qui va nous permettre de créer des conteneurs  et d'y installer
des environnements prêts à l'emploi, les *images*.
Un peu de vocabulaire: dans tout ce qui suit, 

  - Le *système hôte* est le système d'exploitation principal gérant votre machine ;
    c'est par exemple Windows, ou Mac OS.
  - *Docker engine* ou *moteur docker*  est le programme qui gère les conteneurs.
  - Un *conteneur* est une partie autonome du système hôte, se comportant comme une
    machine indépendante.
  - Le *client Docker* est l'utilitaire  grâce auquel on transmet au moteur 
    les commandes de gestion de ces conteneurs. 
    Il peut s'agir soit de la ligne de commande (*Docker CLI*) ou du *dashboard*
    intégré au *Docker desktop*.
  

.. _schema-docker:
.. figure:: ../figures/schema-docker.png   
      :align: center
   
      Le système hôte, le *docker engine* et les conteneurs


Les images Docker
=================

Un conteneur Docker peut donc être vu comme un sous-système  autonome, mobilisant
très peu de ressources car l'essentiel des tâches système est délégué au système
dans lequel il est instancié. On dispose donc virtuellement d'un moyen
de multiplier à peu de frais des pseudo-machines dans lesquelles on pourait installer
"à la main" des logiciels divers et variés.

Docker va un peu plus loin en proposant des installations pré-configurées, empaquetées
de manière à pouvoir être placées très facilement dans un conteneur. On les appelle
des *images*. On peut ainsi trouver des images avec pré-configuration de serveurs de
données (Oracle, Postgres, MySQL), serveurs Web (Apache, njinx), serveurs NoSQL
(mongodb, cassandra), moteurs de recherche (ElasticSearch, Solr). L'installation
d'une image se fait très simplement, et soulage considérablement des tâches parfois
pénibles d'installation directe.

.. _images-docker:
.. figure:: ../figures/images-docker.png   
      :align: center
   
      Les images docker, constituant un pseudo système distribué

Une image se place dans un conteneur. On peut placer la même image dans plusieurs
conteneurs et obtenir ainsi un système distribué. Examinons la 
:numref:`images-docker` montrant une configuration complète. 
Nous avons tous les composants à l'œuvre, essayons de bien comprendre.

 - Le système hôte exécute le *Docker Engine*, un processus qui gère les images
   et instancie les conteneurs.
 - Docker a téléchargé (nous verrons comment plus tard) les images
   de plusieurs systèmes de gestion de données: MySQL, MongoDB (un système
   NoSQL que nous étudierons), et Cassandra.
 - Ces images ont été *instanciées* dans des conteneurs A, B et C. L'instanciation
   consiste à installer l'image dans le conteneur et à l'exécuter. Nous avons
   donc deux conteneurs avec l'image MySQL, et un troisième avec l'image Cassandra.
  
Chacun de ces conteneurs dispose de sa propre adresse IP. En supposant que
les ports par défaut sont utilisés, le premier serveur MySQL
est donc accessible à l'adresse IPb, sur le port 3306, le second
à l'adresse IPc, sur le même port. 
 
.. important:: Le *docker engine* implante un système automatique
   de "renvoi" qui "publie" le service d'un conteneur sur 
   le port correspondant du système hôte. Le premier
   conteneur MySQL par exemple est *aussi* accessible sur le port 3306
   de la machine hôte. Pour le second, ce n'est pas possible car le port
   est déjà occupé, et il faut donc configurer manuellement ce renvoi:
   nous verrons comment le faire.
   
L'ensemble constitue donc un système distribué virtuel, le tout s'exécutant 
sur la machine-hôte
et gérable très facilement grâce aux utilitaires Docker. Nous avons par exemple dans
chaque conteneur un serveur MySQL. Maintenant, on peut se connecter à ces serveurs
à partir de la machine-hôte avec une application cliente (par exemple phpMyAdmin)
et tester le système distribué, ce que nous ferons tout au long du cours.

On peut instancier l'image de MongoDB dans 4 conteneurs et obtenir un *cluster* MongoDB
en quelques minutes.  Evidemment, les performances globales ne dépasseront pas celle
de l'unique machine hébergeant Docker. Mais pour du développement ou de l'expérimentation,
c'est suffisant, et le gain en temps d'installation est considérable.

En résumé: avec Docker, on dispose d'une boîte à outils pour émuler des environnements
complexes avec une très grande facilité.

***************************
Docker en ligne de commande
***************************

Dans ce qui suit, je vais illustrer les commandes avec l'utilitaire de commandes en ligne
en prenant l'exemple de ma machine Mac OS X. Ce
ne doit pas être fondamentalement différent sous les autres environnements. 


.. note:: Vous préférerez sans doute à juste titre utiliser un outil graphique comme le
   *Docker desktop*, décrit dans la prochaine section, mais avoir un aperçu de commandes transmises par ce dernier est toujours utile 
   pour comprendre ce qui se passe. 

Lancement du Docker Desktop (Mac OS, Windows)
=============================================

Sous Mac OS ou Windows, vous disposez du *Docker Desktop* qui vous permet de 
lancer la machine virtuelle et
d'obtenir une interface graphique pour gérer votre *docker engine*. 
La :numref:`docker-desktop` montre
la fenêtre des paramètres.


.. _docker-desktop:
.. figure:: ../figures/docker-desktop.png   
      :width: 70%
      :align: center
   
      Le site d'hébergement des images Docker.

Pour communiquer avec le moteur Docker, on peut 
utiliser un programme client en ligne de commande nommé simplement ``docker``.
L'image la plus simple est un *Hello world*, on l'instancie avec la commande suivante:

.. code-block:: bash

    docker run hello-world
    
Le ``run`` est la commande d'instanciation d'une nouvelle image dans un conteneur Docker. Voici
ce que vous devriez obtenir à la première exécution.

.. code-block:: bash

     docker run hello-world

        Unable to find image 'hello-world:latest' locally
        latest: Pulling from library/hello-world
        4276590986f6: Pull complete 
        Status: Downloaded newer image for hello-world:latest

        Hello from Docker!

Décryptons à nouveau. La machine Docker a cherché dans son répertoire local pour savoir si l'image
``hello-world`` était déjà téléchargée. Ici, comme c'est notre première exécution, ce n'est pas le
cas (message ``Unable to find image locally``). Docker va donc télécharger l'image et l'instancier.
Le message ``Hello from Docker.`` s'affiche, et c'est tout. 

L'utilité est plus que limitée, mais cela montre à toute petite
échelle le fonctionnement général: on choisit une image, on applique ``run`` et Docker se charge du reste.

La liste des images est disponible avec la commande:

.. code-block:: bash
   
     docker images

Voici le type d'affichage obtenu:

.. code-block:: text

        REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
        docker101tutorial        latest              be967614122c        4 days ago          27.3MB
        mysql                    latest              e1d7dc9731da        12 days ago         544MB
        python                   alpine              0f03316d4a27        13 days ago         42.7MB
        nginx                    alpine              6f715d38cfe0        5 weeks ago         22.1MB
        docker/getting-started   latest              1f32459ef038        2 months ago        26.8MB
        hello-world              latest              bf756fb1ae65        8 months ago        13.3kB

Une image est instanciée dans un conteneur avec la commande ``run``.

.. code-block:: bash
   
     docker run --name 'nom-conteneur' <options>
     
Les options dépendent de l'image: voir les sections suivantes pour des exemples.
La liste des conteneurs est disponible avec la commande:

.. code-block:: bash
   
     docker ps -a
     
L'option ``-a``  permet de voir tous les conteneurs, quel que soit leur statut (en arrêt, ou
en cours d'exécution). On obtient l'affichage suivant:

.. code-block:: text

    CONTAINER ID  IMAGE         COMMAND                  CREATED         STATUS                      PORTS  NAMES
    d1c2291dc9f9  mysql:latest  "docker-entrypoint.s…"   16 minutes ago  Exited (1) 9 minutes ago           mysql
    ec5215871db3  hello-world   "/hello"                 19 minutes ago  Exited (0) 19 minutes ago          relaxed_mendeleev

Notez le premier champ, ``CONTAINER ID`` qui nous indique l'identifiant par 
lequel on peut transmettre des 
instructions au conteneur. Voici les plus utiles, en supposant que le conteneur est ``d1c2291dc9f9``.
Tout d'abord on peut
l'arrêter  avec la commande ``stop``.

.. code-block:: bash
   
     docker stop d1c2291dc9f9
     
Arrêter un conteneur ne signifie pas qu'il n'existe plus, mais qu'il n'est plus actif. 
On peut le relancer avec la commande ``start``.

.. code-block:: bash
   
     docker start mon-conteneur
     
Pour le supprimer, c'est la commande ``docker rm``. Pour inspecter la configuration système/réseau d'un conteneur, 
Docker fournit la 
commande ``inspect``.

.. code-block:: bash
   
     docker inspect mon-conteneur

On obtient un large document JSON. Parmi toutes les informations données,
l'adresse IP du coneneur est particulièrement intéressante. On l'obtient avec

.. code-block:: text

       docker inspect <container id> | grep "IPAddress"

Installons un serveur Web
=========================

Testons Docker avec un des services les plus simples qui soient: un serveur web,
Apache. 
La démarche générale pour une installation
consiste à chercher l'image qui vous convient sur le site https://hub.docker.com qui donne
accès au catalogue des images Docker fournies par la communauté des utilisateurs. 
   

Faites une recherche avec le mot-clé "httpd" (correspondant aux images
du serveur web Apache). Comme on pouvait s'y attendre, de nombreuses images 
sont disponibles.
La plus standard s'appelle tout simplement ``httpd`` (:numref:`docker-httpd`).

.. _docker-httpd:
.. figure:: ../figures/docker-httpd.png   
      :width: 70%
      :align: center
   
      Les images de serveurs Apache.


Choisissez une image, et cliquez sur le bouton ``Details``  pour 
connaître les options d'installation. En prenant
l'image standard, on obtient la page de documentation illustrée par 
la  :numref:`docker-httpd-install`


.. _docker-httpd-install:
.. figure:: ../figures/docker-httpd-install.png   
      :width: 70%
      :align: center
   
      Documentation d'installation de l'image ``httpd``

Vous avez deviné ce qui reste à faire. Installez l'image dans un conteneur sur votre machine avec
la commande suivante:

.. code-block:: bash
    
      docker run --name serveur-web1 --detach httpd:latest
 
Voici les options choisies:

   - ``name`` est le nom du conteneur: il peut remplacer l'id du conteneur quand on veut l'arrêter / le relancer, etc.
   - ``--detach``  (ou ``-d``) indique que le conteneur
     est lancé en tâche de fond, ce qui évite de bloquer le terminal
   - on indique enfin l'image à utiliser, ainsi que la version: prenez ``latest`` (ou ne précisez rien)
     sauf si  vous avez de bonnes raisons de faire autrement.

La première fois, l'image doit être téléchargée, ce qui peut prendre un certain temps. Par la suite, le
lancement du conteneur instanciant l'image est quasi instantané.

C'est tout! Vous avez installé et lancé un serveur web. Vous pouvez le vérifier avec
la commande suivante qui donne la liste des conteneurs en cours d'exécution.

.. code-block:: bash

    docker ps
    
Vous devriez obtenir le résultat suivant. Notez le port via lequel on 
peut accéder au serveur, et le nom
du conteneur.

.. code-block:: text

    CONTAINER ID  IMAGE        COMMAND            CREATED        STATUS        PORTS   NAMES
    d02a690e0253  httpd:latest "httpd-foreground" 3 minutes ago  Up 3 minutes  80/tcp  serveur-web1


Notez que le serveur web est accessible sur le port 80 de la machine sur laquelle 
le *Docker Desktop*
a été lancée, soit ``localhost``. Comment est-ce possible alors que nous avons dit 
que chaque conteneur était une petite machine indépendante et disposait donc 
de sa propre adresse IP? La réponse est que le Docker Desktop se charge 
automatiquement de *renvoyer* le port du conteneur
vers ``localhost``.

Si on veut créer un système distribué constitué de plusieurs serveurs web,
ce renvoi par défaut n'est plus possible puisque tous les serveurs se disputeraient
l'accès au port 80 de la machine hôte. 

Installons plusieurs serveurs web
=================================

Docker fournit un mécanisme dit *de publication* pour indiquer sur quel  
port se met en écoute un conteneur. On spécifie simplement avec l'option
``--publish`` (ou ``-p``) comment on associe un port du conteneur à un port du
système hôte. Exemple:

.. code-block:: bash
    
      docker run --name serveur-web2 --publish 81:80 --detach httpd:latest

Ou plus simplement

.. code-block:: bash

     docker run --name serveur-web2 -p 81:80  -d httpd

L'option ``-p`` indique que le port 80 du conteneur est renvoyé sur le port 81
de la machine hôte. 



Pour accéder aux serveurs, il faut un client
============================================

Une fois que l'on a installé des services dans des conteneurs, il faut
disposer de programmes clients pour pouvoir dialoguer avec eux. Ces programmes
clients sont en général à installer directement sur la machine hôte.

Dans le cas d'un serveur web, ou en général de tout service qui communique 
selon le protocole HTTP, un navigateur web fait parfaitement l'affaire.  
Avec votre navigateur préféré, essayer d'accéder aux adresses http://localhost:80
et http://localhost:81: les services web Docker que vous venez d'installer 
devraient répondre par un message basique mais réconfortant.


.. _docker-httpd-client:
.. figure:: ../figures/docker-httpd-client.png   
      :width: 70%
      :align: center
   
      Accès au service avec le nom du serveur et le port



Ouf! Prenez le temps de bien comprendre, car une fois ces mécanismes assimilés,
nous serons libérés de tout souci pour créer nos systèmes distribués et 
les expérimenter par la suite. Et je vous rassure: l'ensemble est 
géré de manière plus conviviale avec le *dashboard* (ce qui ne dispense pas de comprendre
ce qui se passe).


******************************
Le tableau de bord (dashboard)
******************************

Plusieurs environnements graphiques existent pour interagir avec Docker. 
Dans ce qui suit nous présentons le tableau  de bord
(*dashboard*), l'interface "officielle" fournie avec l'outil *Docker desktop*,
mais vous pouvez en tester d'autre si vous le souhaitez.
En voici deux qui semblent intéressants.

   - Portainer disponible à https://www.portainer.io/
   - DockStation disponible https://dockstation.io/

Le *dashboard*  facilite la gestion des conteneurs
et des images et fournit un tableau de bord sur le système 
distribué virtuel
(:numref:`dashboard`).

.. _dashboard:
.. figure:: ../figures/docker-dashboard.jpg   
      :width: 70%
      :align: center
   
      Le tableau de bord Docker

En cliquant sur le nom de l'un des conteneurs disponibles, on dispose de toutes les options
associées.
Un paramètre important est le renvoi du port de l'image instanciée dans le conteneur
vers un port  de la machine Docker. Ce renvoi permet 
d'accéder avec une application de la machine-hôte à l'instance de l'image comme
si elle s'exécutait directement dans la machine Docker. Reportez-vous à
la section précédente pour des explications complémentaires sur l'option ``--publish``.

Quiz
====


   Quelles phrases suivantes sont exactes à propos de la notion de serveur :

   A) Un serveur est lancé à chaque fois qu'on fait appel à lui
   #) Un serveur est nécessairement connecté à un port réseau
   #) Il ne peut y avoir qu'un seul serveur d'un type donné (par exemple
      un serveur Web) sur une machine

   Quelles phrases suivantes sont exactes à propos de Docker :

   A) La machine Docker est un serveur
   #) La machine Docker est un client
   #) La machine Docker s'exécute dans un conteneur
   #) La machine Docker s'exécute dans un système hôte

   Après avoir installé un serveur dans un conteneur Docker, que reste-t-il à faire:

   A) Il faut configurer le serveur
   #) Il faut lancer le serveur
   #) Il faut installer au moins un programme client dans le conteneur Docker
   #) Il faut installer au moins un programme client sur la machine hôte



Exercices
=========

Dans ces exercices vous devez mettre en action les principes de Docker vus ci-dessus, et vous
êtes également invités à découvrir l'outil ``docker compose`` qui nous permet de configurer
une fois pour toutes un environnement distribué constitué de plusieurs serveurs.

.. _Ex-S1-1:
.. admonition:: Exercice `Ex-S1-1`_: testons notre compréhension

   Savez-vous répondre aux questions suivantes?
   
    - Qu'est-ce qu'une machine Docker, où se trouve-t-elle, quel est son rôle?
    - À quoi sert le terminal Docker, et qu'est-ce qui caractérise un tel terminal?
    - Qu'est-ce que la machine hôte? Doit-elle forcément tourner sous Linux?
    - Une instance d'image est-elle placée dans un conteneur, dans la machine hôte ou
      dans la machine Docker?
    - Peut-on instancier une image dans plusieurs conteneurs?

   Si vous ne savez pas répondre, cela vaut la peine de relire ce qui précède, ou des ressources
   complémentaires sur le Web. Vous serez plus à l'aise par la suite si vous avez une
   idée claire de l'architecture et de ses concepts-clé.

.. _Ex-S1-2:
.. admonition:: Exercice `Ex-S1-2`_: premiers pas Docker

  Maintenant, effectuez les opérations ci-dessus sur *votre* machine. Installez Docker,
  lancez le conteneur ``hello-world``, affichez la liste des conteneurs, supprimez
  le conteneur ``hello-world``.


.. _Ex-S2-1:
.. admonition:: Exercice `Ex-S2-1`_: installez MySQL

    - Après installation de Docker, créez un conteneur avec la dernière version de MySQL. Vous pouvez
      utiliser la ligne de commande ou le *dashboard*.
      
      Installez également un client MySQL sur votre machine (par exemple le
      *MySQL Workbench* accessible à https://www.mysql.com/products/workbench/)
      et connectez-vous à votre conteneur Docker.
      
    - Au lieu de lancer toujours la même ligne de commande, on peut créer un fichier de configuration
      (dans un format qui s'appelle YAML) et l'exécuter avec l'utilitaire ``docker-compose``. Voici un
      exemple de base: sauvegardez-le dans un fichier ``mysql-compose.yml``. 
    
      .. code-block:: yaml
      
			services:
			  mysql1:
			    image: mysql:latest
			    ports:
			      - "6603:3306"
			    environment:
			      - "MYSQL_ALLOW_EMPTY_PASSWORD=1"
      
      Vous pouvez alors lancer la création de votre conteneur avec la commande:
      
      .. code-block:: bash
      
           docker compose -f mysql-compose.yml up
           
      Voici quelques exercices à faire:
      
         - Testez que vous pouvez bien accéder à votre conteneur avec le client MySQL (quel est le port d'accès
           défini dans la configuration Yaml?)
         - Configurez votre conteneur MySQL pour définir un compte d'accès ``root`` avec un mot
           de passe et donnez à la base le nom ``nfe204`` (aide: lisez 
           la documentation associée au conteneur MySQL, laquelle
           se trouve ici: https://hub.docker.com/_/mysql)
         - Configurez un ensemble de trois conteneurs MySQL. Vérifiez que vous pouvez vous connecter à chacun.
         - Arrêtez/redémarrez le conteneur (cherchez la commande ``docker-compose``), enfin supprimez-le.
  
.. _Ex-S2-2:
.. admonition:: Exercice `Ex-S2-1`_: installez MongoDB

   Même exercice, mais cette fois avec MongoDB, un système NoSQL très utilisé.
   Les principes sont les mêmes: vous récupérez une image de MongoDB après voir
   fouillé sur http://hub.docker.com, vous l'instanciez,
   vous configurez le port d'accès, et vous testez l'accès avec un client à partir
   de la machine-hôte. 
   
   Pour MongoDB, voici les deux principaux  clients disponibles gratuitement: 
   
     - Studio 3T (*free edition*), un des plus anciens, disponible à https://studio3t.com/
     - Compass, disponible à https://www.mongodb.com/products/tools/compass,
       le client graphique "officiel" de MongoDB
   
   Créez un fichier de configuration pour ``docker-compose``  également, afin d'instancier
   trois conteneurs.
   
