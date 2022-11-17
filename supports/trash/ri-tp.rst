.. _chap-ritp_tp:
   
###############################################
Recherche d'Information - Travaux Pratiques
###############################################

Les exercices suivants sont à effectuer pour partie sur feuille et pour partie avec Solr.

****************************
Modèles d'indexation textuel
****************************

Modèle Booléen
==============

Nous utiliserons ici l'ensemble suivant de documents (défini par un ``docId``) que nous allons résumer
par des mots-clés qui les caractérisent. Vous pouvez charger ces documents dans un
index Solr pour effectuer cet exercice.

 =========   =============================================
 **docId**   **terms**
 =========   =============================================
 1           France, Récession, Ralentie, INSEE
 2           USA, Finance, Paulson, Ralentie, Crise
 3           Crise, Gouvernement, Ralentie, INSEE
 4           PIB, France, Crise, Ralentie
 =========   =============================================

 #. Créer la matrice d'incidence.
 #. Proposer une transformation des requêtes suivantes sous forme de requêtes booléennes :
      * "la crise ralentie"
      * "En France, selon l'Insee, le PIB"
      * "Aux USA, Paulson" mais sans le mot "crise"
 #. Evaluer les requêtes.

.. ifconfig:: ritp in ('public')

   .. admonition:: Correction
   
      #. ========= ========== ========== ========== ========== ========== ========== ========== ========== ============ ==========
         **docId** France     Récession  Ralentie   INSEE      USA        Finance    Paulson    Crise      Gouvernement PIB
         ========= ========== ========== ========== ========== ========== ========== ========== ========== ============ ==========
         1         1          1          1          1          0          0          0          0          0            0
         2         0          0          1          0          1          1          1          1          0            0
         3         0          0          1          1          0          0          0          1          1            0
         4         1          0          1          0          0          0          0          1          0            1
         ========= ========== ========== ========== ========== ========== ========== ========== ========== ============ ==========
      #.
       * crise ``and`` ralentie
       * France ``and`` INSEE ``and`` PIB
       * USA ``and`` Paulson ``and not`` Crise
      #.
       * 2, 3, 4
       * aucun document
       * aucun document

Modèle vecteur
==============

 #. Créer, à partir des documents précédents, des fichiers inverses *(posting lists)*.
 #. Evaluer les requêtes précédentes.
 #. Dans quel ordre doit-on choisir les mots de la requête pour l'évaluation ?

.. ifconfig:: ritp in ('public')

   .. admonition:: Correction
   
      #.
       ============ ============
       **Term**     **docIds**
       ============ ============
       France       1, 4
       Récession    1
       Ralentie     1, 2, 3, 4
       INSEE        1, 3
       USA          2
       Finance      2
       Paulson      2
       Crise        2, 3, 4
       Gouvernement 3
       PIB          4
       ============ ============
      #. Même résultat, la méthode est différente.
      #. En choisissant les termes par ordre de fréquence croissante, nous pourrons 
         être plus sélectifs sur le terme le plus fréquent.    

*******************
Création d'un index
*******************

Cet exercice a pour but de créer un index Solr sur quelques textes 
extraits du web et parlant d'un même sujet. Vous devez effectuer
les étapes standard, à savoir:

  * Un peu de réflexion préalable sur le contenu, les mots à supprimer,
    les traitements divers à effectuer.
  * La création d'un nouvel index ("core") dans Solr avec ses fichiers de configuration.
  * Un formatage des documents de manière à pouvoir insérer dans l'index
  * L'ajustement de la chaîne de traitement textuelle (tokenisation, normalisation, mots vides)
    et son application aux documents
  * Des recherches et analyses pour vérifier que tout va bien.

 * docID 1 (66 mots) :
   ``On ne parle plus de ralentissement de la croissance, mais de recession véritable. En France, selon l'Insee, le PIB va diminuer de 0,8 points.  Il en est de même au niveau de l'ensemble des pays industrialisés : pour la première fois depuis 1945, leurs PIB diminueront sur toute une année. Quant aux économies du Sud, si elles vont continuer à croître c'est de façon ralentie.``
 * docID 2 (68 mots) :
   ``Devant ces mauvais chiffres de la croissance, le gouvernement ne mesure pas ce que cela signifie pour des dizaines de millions de Français en terme de difficultés pour vivre. Pas de récession mais une croissance ralentie, disent-ils... Le gouvernement refuse d'engager un plan de relance de l'économie et veut s'en prendre aux déficits publics en réduisant les dépenses. Pour le gouffre des financiers, les sommes elles sont débloquées !``
 * docID 3 (97 mots) :
   ``Le gouvernement a revu en nette baisse ses prévisions. De son côté, l'INSEE prend acte du fait que "la croissance cale en zone euro" et que la France n'est pas épargnée par la crise. Même si l'INSEE juge pour l'instant prématuré d'employer le terme de "récession", le PIB de la France devrait continuer à diminuer, perdant 0,1 point aux troisième et quatrième trimestres après une baisse de 0,3 point au deuxième trimestre. La récession est le plus souvent définie par au moins deux trimestres consécutifs de recul du PIB.``
 * docID 4 (93 mots) :
   ``Il n'est pas encore certain que la crise immobilière et financière provoque une récession, c'est-à-dire un recul de la production durant au moins deux semestres consécutifs et pas seulement un ralentissement de sa croissance. Selon le secrétaire d'Etat américain aux finances, Henri Paulson, même si les USA connaissent une récession, celle-ci sera faible dans son ampleur et sa durée, suivie d'une reprise qui ne serait lente que pendant un an ou deux. C'est le temps qu'il faudra pour absorber le choc et réaliser les ajustements nécessaires.``

Voici le vocabulaire de ces textes:

``On, Il, ils, elles, un, une, ne, parle, plus, pas, Pas, à, de, De, des, du, n', c', C', d', l', s', qu', le, Le, la, ce, ces, ses, son, leurs, en, au, aux, est-à-dire, celle-ci, et, que, qui, mais, si, même, Même, Devant, après, pour, Pour, Quant, sur, depuis, a, est, sera, serait, sont, va, vont, faudra, dans, devrait, encore, durant, pendant, selon, Selon, toute, certain, souvent, moins, seulement, lente, ralentie, ralentissement, croissance, recession, récession, véritable, France, Français, Insee, INSEE, PIB, diminuer, diminueront, point, points, niveau, ensemble, pays, industrialisés, première, fois, an, année, économie, économies, Sud, continuer, croître, façon, mauvais, chiffres, gouvernement, mesure, signifie, dizaines, millions, terme, difficultés, vivre, disent, refuse, engager, plan, relance, veut, prendre, prend, déficits, publics, réduisant, dépenses, gouffre, finances, financiers, sommes, débloquées, revu, nette, baisse, prévisions, côté, acte, fait, cale, zone, euro, épargnée, crise, juge, instant, prématuré, employer, perdant, deux, deuxième, troisième, quatrième, trimestre, trimestres, semestres, définie, consécutifs, recul, immobilière, provoque, production, secrétaire, Etat, américain, Henri, Paulson, USA, connaissent, faible, ampleur, durée, suivie, reprise, temps, absorber, choc, réaliser, ajustements, nécessaires``
   
La taille de ce vocabulaire est de 176 termes (tous les mots sont pris).

La conception de l'index
========================

Sans machine, réflechissez à l'organisation de votre index en vous posant les
questions suivantes:

 #. Quelles sont les conséquences de la non prise en compte de 
    la casse et de la suppression des accents et caractères spéciaux ? 
 #. Proposer une liste de "*stop words*" et évaluer 
    la taille du vocabulaire après suppression des mots vides.
 #. Quelles sont les conséquences d'une lemmatisation des mots du vocabulaire ?
    Donner plusieurs exemples dans les documents proposés.
 #. Estimer la nouvelle taille du vocabulaire après élimination des mots vides
    et lemmatisation.
 #. Prendre quelques termes et donner leur liste inversée. Vous pouvez par exemple
    traiter les mots suivants:
    *crise, croissance, finance, france, insee, lent, gouvernement, pib.*
    Vous y associerez les valeurs de TF et DF.

.. ifconfig:: ritp in ('public')

   .. admonition:: Correction
   
      #. Les mots tels que Insee et INSEE seront alors reconnus comme un seul et même mot. De même 
         pour tous les mots de début de phrases : De/de, Même/même.
         De plus, les erreurs d'accents comme "récession/recession" seront alors supprimées.
         En revanche, un des problèmes qui peut arriver est de transformer le $USA$ en $usa$ qui 
         devient alors un verbe en français.
      #. Attention, dans la liste de *stop words*, doit-on prendre des termes comme 
         'un' qui correspond aussi à un nombre ?
         **116 termes**, avec une liste de *stop words* :
         on, il, ils, elles, une, ne, plus, pas, à, de, des, du, n', c', d', l', s', qu', le, la, ce, ces, ses, son, leurs, en, au, aux, est-à-dire, celle-ci, et, que, qui, mais, si, même, devant, apres, pour, quant, sur, depuis, a, est, sera, serait, sont, va, vont, dans, encore, durant, pendant, selon, toute, certain, souvent, moins, seulement
      #. Grâce à la lemmatisation, nous allons pouvoir mettre tous les verbes à l'infinitif, toutes
         les déclinaisons des mots vont revenir à leur racine.
         Exemple de 'lente/ralentie/ralentissement'
         En revanche, certains mots vont être dénaturés alors qu'ils ne le devraient pas: 
         insee (si le lemmatiseur est mauvais, il considérera que c'est le verbe inser 
         au passé simple féminin.). En effet, les noms de famille et d'organisations 
         ne sont plus reconnus.
      #. **103 termes**
         ``parler, avoir, etre, aller, falloir, devoir, plus, moins, seul, lent, croissance, recession, vrai, france, inser, pib, diminuer, point, point, niveau, ensemble, pays, industrialiser, premier, fois, an, annee, economie, sud, continuer, croitre, facon, mauvais, chiffre, gouvernement, mesurer, signifier, dizaine, million, terme, difficulte, vivre, dire, refuser, engager, plan, relance, vouloir, prendre, deficit, public, reduire, depense, gouffre, finance, somme, débloquer, revu, net, baisse, prevision, cote, act, faire, cale, zone, euro, epargner, crise, juge, instant, prematurer, employer, perdre, deux, trois, quatre, trimestre, semestre, definir, consecutif, recul, immobilier, provoquer, production, secretaire, Etat, amerique, henri, paulson, usa, connaitre, faible, ampleur, durer, suivre, repris, temps, absorber, choc, realiser, ajustement, necessaire``
      #. ============== ======= ======================================
         **Term**       **IDF** **docIds + TF**
         ============== ======= ======================================
         crise          2/4     3 (1/97) , 4 (1/93)
         croissance     4/4     1 (1/66), 2 (2/68), 3 (1/97), 4 (1/93)
         finance        2/4     2 (1/68), 4 (2/93)
         france         3/4     1 (1/66), 2 (1/68), 3 (2/97)
         insee          2/4     1 (3/66), 3 (2/97)
         lent           3/4     1 (2/66), 2 (1/68), 4 (2/93)
         gouvernement   2/4     2 (2/68), 3 (2/97)
         pib            2/4     1 (2/66), 3 (2/97)
         ============== ======= ======================================


Création du *core* Solr
=======================

Créez l'index Solr, exactement comme nous l'avons fait pour l'index sur le films. Nous vous donnons
le `fichier de paramétrage du schéma <http://b3d.bdpedia.fr/files/schema-solr-tp.xml>`_ avec
une partie des spécifications en commentaires. À vous de décommenter les différentes
parties et de vérifier leur impact. 

.. note:: Reportez-vous au chapitre sur Solr pour la manière de recharger un schéma et un index
          après modifications.
   
Procédez par étapes, comme suggéré ci-dessous:

  #. Créez un document au format JSON pour chacun des textes. Chaque document doit
     être au format ``{"_id":"1", "contenu":"le texte"}``; 
  #. Chargez ces documents dans votre index, soit avec ``curl``, 
     soit directement avec l'interface Web de Solr.
  #. Modifez le fichier de schéma pour ajouter ou supprimer une des étapes du traitement, et vérifiez
     l'effet de la modification. Pour cela:
    
      - avec l'analyseur de Solr intégré à l'interface Web, entrez un fragment de texte et 
        regardez comment il est transformé;
      - avec le *Schema browser*, consulter le champ ``contenu``, et regardez les principaux
        termes indexés avec *Load info*.
  #. Maintenant ajoutez la liste des mots-clé. Nous vous fournissons un 
     `exemple de fichier <http://b3d.bdpedia.fr/files/stopwords.txt>`_
     mais vous êtes invités à entrer votre propre liste. Vérifiez à nouveau.

Interrogation
=============

Et pour finir, bien sûr, effectuez des interrogations sur l'index avec vos différents
réglages. Vérifiez l'impact des majuscules, des accents, de la lemmatisation, de
la racinisation, des mots vides, etc. Construire un index plein texte, c'est un réglage
délicat destiné à obtenir un comportement intuitif et un bon compromis
entre précision et rappel.

************************
Recherche par similarité
************************

Nous reprendrons les listes inverses créées dans la 
question précédente.

Produit Scalaire
================

 #. Calculer le produit scalaire de la requête suivante : ``France Ralentie PIB``
 #. Trier le résultat par ordre de pertinence décroissante

.. ifconfig:: ritp in ('public')

   .. admonition:: Correction
   
      #. En tenant compte de l'ordre des termes de l'exercice précédent, le vecteur du document 1 est :

         :math:`( 0 ; \frac{1}{66} \times \log{\frac{4}{4}} ; 0 ; \frac{1}{66} \times \log{\frac{4}{3}} ; \frac{1}{66} \times \log{\frac{4}{2}} ; \frac{2}{66} \times \log{\frac{4}{3}} ; 0 ; \frac{2}{66} \times \log{\frac{4}{2}})`

         (on n'a ici pas simplifié, mais :math:`\log{\frac{4}{4}}=0`). 

         Le vecteur de la requête est le suivant :

         :math:`(0 ; 0 ; 0; 1/3 ; 0 ; 1/3 ; 0 ; 1/3)`
         
         On prend ici un log en base 10, mais d'autres bases seraient possibles
         (puisque ce qui nous intéresse avant tout est un classement des
         documents, pas la valeur absolue de leurs scores).

         Voici les valeurs du produit scalaire pour les 4 documents :
      
         :math:`doc_1 = \frac{1}{66} \times \log{\frac{4}{3}} \times \frac{1}{3} + \frac{2}{66} \times \log{\frac{4}{3}} \times \frac{1}{3} + \frac{2}{66} \times \log{\frac{4}{2}} \times \frac{1}{3} = 4,934\times 10^{-3}`
         :math:`doc_2 = \frac{1}{68} \times \log{\frac{4}{3}} \times \frac{1}{3} + \frac{1}{68} \times \log{\frac{4}{3}} \times \frac{1}{3} + \frac{0}{68} \times \log{\frac{4}{2}} \times \frac{1}{3} = 1,225\times 10^{-3}`
         :math:`doc_3 = \frac{2}{97} \times \log{\frac{4}{3}} \times \frac{1}{3} + \frac{0}{97} \times \log{\frac{4}{3}} \times \frac{1}{3} + \frac{2}{97} \times \log{\frac{4}{2}} \times \frac{1}{3} = 2,928\times 10^{-3}`
         :math:`doc_4 = \frac{0}{93} \times \log{\frac{4}{3}} \times \frac{1}{3} + \frac{2}{93} \times \log{\frac{4}{3}} \times \frac{1}{3} + \frac{0}{93} \times \log{\frac{4}{2}} \times \frac{1}{3} = 0,895\times 10^{-3}`
      #. .. math:: doc_1, doc_3, doc_2, doc_4


Cosinus
-------

 #. Donner le calcul de la norme d'un document et de la requête
 
 #. Les normes des documents (tout les termes sont pris en compte) sont
    respectivement : ``0.0392, 0.0336, 0.0310, 0.0421``. Calculer le cosinus de
    la requête suivante : ``France Ralentie PIB``.
 #. Trier le résultat par ordre de pertinence décroissante

.. ifconfig:: ritp in ('public')

   .. admonition:: Correction
   
       #. .. math:: \sqrt{\sum tf_i^2}
       #. .. math:: doc_1 = \frac{4,934\times 10^{-3}}{0.0392} = 0,126
          .. math:: doc_2 = \frac{1,225\times 10^{-3}}{0.0336} = 0,036
          .. math:: doc_3 = \frac{2,928\times 10^{-3}}{0.0310} = 0,094
          .. math:: doc_4 = \frac{0,895\times 10^{-3}}{0.0421} = 0,021
       #. .. math:: R_1 : doc_1, doc_3, doc_2, doc_4

Précision / Rappel
------------------

Nous nous attendions à l'ensemble résultat suivant : :math:`R_2 : doc_1, doc_4`

 #. Donner la précision et le rappel du résultat obtenu par similarité cosinus
 #. Donner le précision et le rappel du résultat obtenu par similarité cosinus 
    avec un score supérieur à 0,03

.. ifconfig:: ritp in ('public')

   .. admonition:: Correction
   
       #. .. math:: \frac{R_1 \cap R_2}{R_1} = \frac{2}{4}
          .. math:: \frac{R_1 \cap R_2}{R_2} = \frac{2}{2}
       #. .. math:: \frac{R_1 \cap R_2}{R_1} = \frac{1}{3}
          .. math:: \frac{R_1 \cap R_2}{R_2} = \frac{1}{2}

********
PageRank
********

Chaîne de Markov
================

Voici un graphe représentant les hyperliens entre les pages d'un site web :

   .. figure:: ../figures/PageRank1.jpg
      :width: 40%
      :align: center

      Graphe d'hyperliens entre des pages

 #. Rappeler la loi de probabilité correspondant au passage d'une page *i* à une page *j*.
 #. Construire la matrice NxN de probabilités de passages d'une page à une autre, avec

    .. math:: \alpha = \frac{1}{2}
  
 #. Calculer le PageRank de la matrice à l'aide du vecteur (1 0 0 0). Vous arrondirez 
    chaque calcul avec 3 chiffres après la virgule.

.. ifconfig:: ritp in ('public')

   .. admonition:: Correction
   
       #. :math:`P_{ij} = \frac{\alpha}{N} + \frac{I (1 - \alpha)}{K}`
       
	      où *N* est le nombre de pages, *K* le nombre d'hyperliens de la page *i*.
		  *I* est égal 1 si *j* est une des cibles des hyperliens, 0 sinon.
		  
	   #. Nous avons :math:`N=4, K_A=2, K_B=2, K_C=2, K_D=1`
	   
	      .. csv-table:: 
	         :widths: 10, 10, 10, 10
	         
	         1/8, 3/8, 1/8 3/8
		     1/8, 1/8, 3/8, 3/8
		     1/8, 3/8, 1/8, 3/8
		     5/8, 1/8, 1/8, 1/8
		     		  
	  #. Etapes :
	  
	      .. csv-table:: 
	         :widths: 10, 10, 10, 10, 10
	         
	         1, 1, 0, 0, 0 
	         1,	"0.125",	"0.375",	"0.125", "0.375"
	         2,	0.313,	0.188,	0.219,	0.281
	         3,	0.266,	0.258,	0.172,	0.305
	         4,	0.278,	0.235,	0.190,	0.299
	         5,	0.275,	0.242,	0.184,	0.301
	         6,	0.276,	0.240,	0.186,	0.301
	         7,	0.276,	0.241,	0.185,	0.301
	         8,	0.276,	0.241,	0.186,	0.301
	         9,	0.276,	0.241,	0.186,	0.301

Pertinence du contenu d'une page Web
====================================

 #. En reprenant le résultat de la recherche par cosinus sur les documents :
    :math:`doc_1 (site A), doc_2 (site B), doc_3 (site C), doc_4 (site D)`
    et en multipliant le score de cosinus par le pageRank du site hébergeant ce texte,
    donner le classement final de votre recherche.

.. ifconfig:: ritp in ('public')

   .. admonition:: Correction
   
       #. .. math:: doc_1 : 0,276 \times 0,126 = 0,035
          .. math:: doc_3 : 0,186 \times 0,094 = 0,018
          .. math:: doc_2 : 0,241 \times 0,036 = 0,009
          .. math:: doc_4 : 0,301 \times 0,021 = 0,006
