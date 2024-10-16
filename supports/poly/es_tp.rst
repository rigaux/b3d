.. _chap-indexation:
  
###############################
Travaux pratiques ElasticSearch
###############################

Ce chapitre est consacré l'interrogation
d'une base Elasticsearch, en utilisant le DSL (Domain Specific Language) dédié à
ce moteur de recherche. Il est conçu dans une optique
de mise en pratique: vous devriez disposer d'un serveur installé avec Docker 
et de l'application ElasticVue (reportez-vous au chapitre :ref:`chap-introri`).


***************************************
S1: Introduction au DSL d'ElasticSearch
***************************************

Le DSL est un langage extrêmement riche. Dans cette introduction
nous nous concentrons sur les recherches exactes, les recherches
plein-texte (avec classement donc) et quelques opérations de combinaison.

	
Les recherches plein-texte
==========================

On s'intéresse ici aux recherches portant sur des champs 
textuels analysés (et ayant donc fait l'objet de transformations,
cf. le chapitre  :ref:`chap-introri`). La correspondance 
entre le texte indexé et celui de la requête est
exprimée par un *score*. La documentation
est ici: https://www.elastic.co/guide/en/elasticsearch/reference/current/full-text-queries.html.


Reprenons la requête qui cherche les occurrences de *Star Wars*,
cette fois avec l'opérateur ``match`` 

.. code-block:: json

  	{
    	"query": {
      		"match": {
        		"title": "Star Wars"
      		}
  		},
  		"fields": [
    		"title", "summary"
  		],
  		"_source": false
   	}

Cette fois, contrairement à ce qui se passait avec ``term``, 
les transformations sont appliquées au document *et* à
la requête, et le résultat correspond aux principes de la recherche plein texte 
avec classement.
Prenez le temps de comprendre (intuitivement) 
le rapport entre le titre du film et son classement. 

Il faut bien réaliser que chaque terme est pris en compte
*individuellement*. Cherchons par exemple les résumés
de film qui contiennent ``Roman Empire``.


.. code-block:: json

	{
    	"query": {
      		"match": {
        		"summary": "Roman Empire"
      		}
  		},
  		"fields": [
    		"title", "summary"
  		],
  		"_source": false
   	}

On obtient des résumés qui contiennent ``Roman`` et ``Empire``,
``Roman`` tout seul et ``Empire`` tout seul: la
différence est reflétée dans le score, et donc dans le classement.

Remplacez ``match`` par  ``match_phrase``, comparez les résultats
et reportez-vous à la documentation pour comprendre.

Enfin il est possible d'effectuer une recherche plein-texte moins 
"structurée" avec l'opérateur ``query_string`` dont  
le paramètre est une liste de mots-clé enrichis de connecteur 
booléens et d'options. Cette liste est l'équivalent (en plus puissant) 
de l'approche habituelle avec les applications de recherche, consistant
à mettre en vrac les termes principaux de la recherche. Voici un 
premier exemple.

.. code-block::

	{
  		"query": {
    		"query_string": {
      			"query": "(DiCaprio) OR (Deneuve)"
    		}
  		},
  		"fields": ["title"],
  		"_source": false
	}

Et un second exemple un peu plus élaboré:

.. code-block::

	{
  		"query": {
  			"query_string": {
    		  "query": "year:[1990 TO 2010] AND director.last_name:Tarantino"
    		}
  		},
  		"fields": ["title"],
  		"_source": false
	}

Reportez-vous à la documentation pour les très nombreuses options (qui
reprennent en fait celles du langage du système d'indexation sous-jacent, Lucene).

Combinaison de recherches
=========================

On peut combiner plusieurs recherches en paramétrant
la manière dont les critères de recherche et les scores se combinent. Nous
allons nous limiter ci-dessus aux combinaisons booléennes. 
La documentation (https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-bool-query.html)
donne des informations plus complètes.

Les recherches booléennes sont  exprimées par des objets (au sens JSON) ``bool``
dans l'object ``query``. Cet objet ``bool``  peut lui-même
avoir plusieurs sous-clauses: ``must``, ``should``, ``must_not``
et ``filter``. Voyons quelques exemples.

La clause ``must``
------------------

L'objet ``must`` est un tableau de recherches plein-texte ou exactes,
et s'interprète comme un ``ET`` logique (ou, en termes ensemblistes,
comme une intersection des résultats). Voici un exemple 
d'une requête des films dont le titre est proche de Star Wars *et*
qui sont parus
entre 1970 et 2000. On combine un ``match`` et un ``range``.

.. code-block:: json

	{
	  "query": {
   		"bool": {
      		"must": [
        		{
          			"match": {"title": "Star Wars"}
        		},
        		{
         			 "range": {"year": {"gte": 1970,"lte": 2000} }
       		    }
     		 ]
  			}
  		}
 	}

Et oui, la syntaxe devient un peu compliquée... Si on
utilise ``should`` à la place de ``must``, on obtient
une interprétation disjonctive ``OR`` (et donc 
une *union* des résultats). À vous de vérifier (vous pouvez aussi
trouver un exemple plus intéressant, comme les films 
tournés soit par Q. Tarantino  soit par J. Woo.). 

Enfin le ``must_not`` correspond au ``NOT``. On peut donc construire
des expressions booléennes complexes, au prix d'un syntaxe
il est vrai assez lourde. Un exemple: les films
avec Bruce Willis, sauf ceux tournés par Q. Tarantino.

.. code-block:: json

	{
  		"query": {
    		"bool": {
      			"must": 
        			{
		          "match": {"actors.last_name": "Willis"}
       				 },
      			"must_not": 
        			{
          			"match": {"director.last_name": "Tarantino"}
        			}
   				 }
  			}
		}

Je vous laisse étudier la clause ``filter`` qui sert principalement
à exclure des documents du résultat sans inflluer sur le score. 

Agrégats
========

Elasticsearch permet également d'effectuer des agrégations, dans l'esprit 
du ``group by`` de SQL. 
Les agrégats fonctionnent avec deux concepts, les `buckets` (seaux, en français)
qui sont les catégories que vous allez créer, et les `metrics` (indicateurs, en
français), qui sont les statistiques que vous allez calculer sur les `buckets`.

Si l'on compare à une requête SQL très simple : 

      .. code-block:: sql

        select count(color)
        from table
        group by color

``count(color)`` est la métrique, ``group by color`` crée les groupes
(`buckets`).

Une agrégation est la combinaison d'un `bucket` (au moins) et d'une `metric` (au
moins). On peut, pour des requêtes complexes, imbriquer des `buckets` dans
d'autres `buckets`. La syntaxe est, comme précédemment, très modulaire. 

Un exemple, avec le nombre de films par année : 

.. code-block:: json

    {
      "size": 0,
      "aggs" : { "nb_par_annee" : {
        "terms" : {"field" : "year"}
          }
      }
    }

Le paramètre ``aggs`` permet à Elasticsearch de savoir qu'on travaille sur des
agrégations. Le paramètre ``size:0`` permet de ne pas afficher
les
résultats de recherche de la requête.
``nb_par_annee`` est le nom que l'on donne à notre agrégat. Les buckets sont
créés avec le ``terms`` qui ici indique que l'on va créer un groupe par valeur
différente du champ ``year``. La métrique sera automatique ici, ce sera
simplement la somme de chaque catégorie.

Le résultat d'une agrégation apparaît dans un champ ``aggregations``
dans le résultat. Voici un extrait de ce dernier. Remarquez
que le tableau ``hits`` est vide
(car ``size:0``). Le tableau ``buckets`` en revanche 
contient ce que nous cherchons (ouf).

.. code-block:: json

	{
   		"hits": {
    		"total": {
      			"value": 326,
      			"relation": "eq"
    		},
    		"max_score": null,
    		"hits": []
  		},
  		"aggregations": {
    		"nb_par_annee": {
       		"buckets": [
        		{"key": 2017,"doc_count": 12},
 	       		{"key": 2019,"doc_count": 11},
       		 	{"key": 2005,"doc_count": 9},
         	]
         }
      }   

.. important:: ElasticVue ne semble pas savoir afficher le champ
   ``aggregation``. Vous pouvez donc effectuer ces requêtes
   avec la fenêtre ``REST`` en transmettant la requête 
   avec un ``POST`` à l'URL ``<index>/_search``.
   
On peut appliquer une agrégation sur le résultat d'une requête, comme
par exemple ci-dessous où on ne prend que les films du genre
"western".

.. code-block:: json

		{
		  "query": {
    		"term": {
      			"genre": {"value": "western"}
    		}
  		},
  		"aggs": {
    		"nb_par_annee": {
      			"terms": {
        			"field": "year"
      			}
   		 }
  		}
	}	
	
	
Voici pour cette présentation de l'essentiel (?) de DSL.
Vous devriez exécuter tous les exemples donnés précédemment (et tenter
des variantes pour bien comprendre la syntaxe) avant
de passer à la prochaine session qui va vous mettre au défi d'entrer
vos propres requêtes.


************************************
S3: Le classement dans Elasticsearch
************************************

Etudions maintenant 
le classement effectué par ElasticSearch et la façon dont
on peut le contrôler voire le modifier.

Le score
========

Le score d'un document est calculé en fonction d'une requête 
au moyen d'une fonction dite *Practical Scoring Function* 
reprise du système d'indexation sous-jacent Lucene. La dernière
trace de documentation de cette fonction semble être
ici (me dire si vous trouvez plus récent): 
https://www.elastic.co/guide/en/elasticsearch/guide/current/practical-scoring-function.html>.
On retrouve les notions de *tf*,  *idf* et *normalisation* 
présentées dans le chapitre :ref:`chap-ranking`, mais avec des formules  
(légèrement) différentes des versions
canoniques: chaque système fait sa petite cuisine
pour essayer d'arriver au meilleur résultat. 

En lisant les explications sur la *Practical Scoring Function*, on constate
donc que pour chaque terme:

 - l'``idf`` est :math:`log (1 + \frac{N-n}{n}`), *N* étant le nombre
   total de documents, *n* le nombre de documents contenant le terme 
 - le ``tf`` est la fréquence normalisée de manière simplifiée 
   par rapport à un calcul cosinus exact, l'idée étant toujours
   de ne pas surestimer les longs documents. 
 - le terme est multiplié par un facteur dite de *boost*
   
Pour étudier cela concrètement, prenons un exemple. 
Nous pouvons observer avec l'API ``_explain`` d'Elasticsearch 
le calcul du score
pour un film donné et pour une requête donnée. 
Prenons, par exemple, dans l'index *movies*,
les films dont le titre contient ``life``, comme
ci-dessous:

.. code-block:: bash

  {
    "query": {
      "match": {
        "fields.title": "life"
      }
    }
  }
  
Chaque film a son propre score, qui dépend de l'index, de la
requête, et de la représentation du film dans le document indexé.
Pour obtenir le détail  de ce score,
on transmet la requête  non pas à l'API ``_search`` mais à l'URL
``movies/_explain/<id_doc>``.
Par exemple, le score du 
film des Monty Python, "Life of Brian" (La vie de Brian, en
français), dont l'identifiant est 2232, est obtenu
avec l'URL ``movies/_explain/2232`` comme le montre 
la :numref:`es-explain`.

.. _es-explain:
.. figure:: ../figures/es-explain.png
      :width: 90%
      :align: center
   
      Obtenir l'explication d'un classement avec ElasticVue

Dans la fenêtre droite, le résultat contient un objet 
``explanation`` qui détaille les paramètres du classement.
Il est notamment indiqué qu'il est obtenu par la formule
:math:`boost \times idf \times tf`, ce qui devrait vous rappeler
la méthode présentée dans le chapitre :ref:`chap-ranking`.
En détaillant, on voit que
Elasticsearch utilise  une fonction
de score  qui  utilise  3
facteurs.

  - *boost* vaut 2,2 (pour le *boosting*, voir ci-dessous)
  - *idf* vaut 5,167, valeur obtenue en considérant que 28 films sur les 4 999
    contiennent le terme *life*, et :math:`ln(1+ (4999-28+0,5)/(28 + 0,5)) = 5,167`.
  - enfin *tf* vaut 0,434, calcul basé sur une fréquence de 1 (*life*
    apparaît une fois dans le titre), la présence de 3 termes dans le titre
    et des facteurs de normalisation dont la taille moyenne d'un
    titre (2,7). Je vous laisse tenter
    d'éclaircir le détail de ces calculs.

Le boosting
============

Quand on effectue des recherches sur plus d'un champ, il peut rapidement devenir
pertinent de donner davantage de poids à l'un ou l'autre de ces champs, de façon
à améliorer les résultats de recherche. Par exemple, il peut être tentant
d'indiquer qu'une correspondance (`match`) dans le titre d'un document vaut 2
fois plus qu'une correspondance dans n'importe quel autre champ. C'est ce que
l'on appelle en anglais le `boosting`, cela autorise la modification du score
calculé par Elasticsearch en vue de rendre les résultats plus pertinents (pour
les utilisateurs d'un système donné). 


La valeur du *boost* peut-être spécifiquement introduite dans la requête. 
Voici comment on *booste* d'un facteur de 2 la requête précédente
(ce qui a peu d'intérêt puisqu'il y a un seul terme, mais nous
verrons ensuite comment *booster* chaque terme individuellement).

.. code-block:: bash

	 {
    	"query": {
      	"match": {
        	"fields.title": {
            	  "query": "life",
              	  "boost": 2 
            	}
      	}
    	}
  	}
  
Le résultat du ``_explain`` montre que le *boost* pris en compte
dans le calcul du score  a doublé par rapport à la version précédente
(où le *boost* était par défaut à 1).

.. note:: Pourquoi ElasticSearch affiche-t-il des valeurs 
   de *boost* qui   semblent supérieures aux valeurs d'entrée? Parce que 
   la valeur affichée tient compte de facteurs de normalisation du terme.
   Il est difficile de détailler les calculs, mais l'important est 
   la valeur relative qui a effectivement doublé.
   

Saisissez la commande suivante et observez la position d'American Graffiti 
(réalisé par G. Lucas) dans
le classement, avec et sans l'option "boost". Que se passe-t-il ?

.. code-block:: json

 	 {
  	"query": {
   	 "bool": {
    	  "should": [
        	{
          		"match": {
            		"fields.title": {
              		"query": "Star Wars",
              		"boost": 4
            		}
          		}
        	},
        	{
          		"match": {
            	"fields.directors": {
              		"query": "George Lucas"
           	 		}
          		}
        	}
 	     ]
    	}
  		},
  		"fields": ["fields.title"],
  		"_source": false
	}

Avec le boosting, American Graffiti est 9e, derrière Bride Wars, mieux classé car
le boosting favorise la correspondance avec (au moins) un des mots du titre.
Sans le boosting, American Graffiti arrive en cinquième position.

Si on peut associer du boosting positif à certaines valeurs de certains
champs, on peut rejeter vers le bas du classement des documents qui
contiennent certaines valeurs pour d'autres champs. On peut combiner boosting
positif et boosting négatif (évidemment pour des champs différents).
