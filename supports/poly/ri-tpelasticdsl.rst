.. _chap-ritp_tpelasticdsl:
  
##########################################
Recherche d'information - TP ElasticSearch
##########################################

Cette séance de travaux pratiques a pour but de comprendre l'interrogation
d'une base Elasticsearch, en utilisant le DSL (Domain Specific Language) dédié à
ce moteur de recherche et qui permet des requêtes plus complexes que celles
proposées par Lucene (vues en cours).

Mise en place d'ElasticSearch
-----------------------------

Comme dans le chapitre :ref:`chap-introri`, on se repose sur Docker. Voici une
commande qui devrait fonctionner sous tous les systèmes et lancer un serveur
ElasticSearch en attente sur le port 9200.     

.. code-block:: bash                                                            

	docker network create ElasticNetwork
	docker run --name es1 --net ElasticNetwork -p 9200:9200 
          \ -p 9300:9300 -e "discovery.type=single-node" elasticsearch:7.8.1

Attention, la 2e commande affichera beaucoup de texte (les *logs* d'activité du
serveur) : vous pouvez souhaiter le mettre en arrière plan en ajoutant :code:`-d`
après :code:`run` (:code:`docker run -d --name ...`)

On prépare aussi l'utilisation d'une interface Web, plus conviviale que la seule
API REST dans une console :

.. code-block:: bash

  wget https://github.com/lmenezes/cerebro/releases/download/v0.9.2/cerebro-0.9.2.tgz
  tar -xvzf cerebro-0.9.2.tgz; cd cerebro-0.9.2;
  ./bin/cerebro

Testez que tout fonctionne en visitant (avec un navigateur de votre machine)
l'adresse http://localhost:9000/#/connect, en saisissant l'adresse du serveur
Elasticsearch dans la première fenêtre (:code:`http://localhost:9200/`).

------------------------------
Installation du jeu de données
------------------------------

Nous allons utiliser une  base de films plus large que celle que l'on a vu en cours. 
Récupérez un fichier contenant environ 5000 films, au format JSON :
http://b3d.bdpedia.fr/files/big-movies-elastic.json.

Dans le dossier où vous avez récupéré le fichier, lancez la commande de
chargement dans ElasticSearch suivante :

.. code-block:: bash

		curl -s -XPOST http://localhost:9200/_bulk/ --data-binary @big-movies-elastic.json

Dans l'interface Cerebro, vous devriez voir apparaître un index appelé `movies` 
contenant 4850 films.

-------------
Les documents
-------------

Les documents ont la structure suivante :

.. code-block:: json

  {
    "fields": {
      "directors": [
        "Joseph Gordon-Levitt"
      ],
      "release_date": "2013-01-18T00:00:00Z",
      "rating": 7.4,
      "genres": [
        "Comedy",
        "Drama"
      ],
      "image_url": "http://ia.media-imdb.com/images/M/MVNTQ3OQ@@._V1_SX400_.jpg",
      "plot": "A New Jersey guy dedicated to his family, friends, and church,
        develops unrealistic expectations from watching porn and works to find
        happ iness and intimacy with his potential true love.",
      "title": "Don Jon",
      "rank": 1,
      "running_time_secs": 5400,
      "actors": [
        "Joseph Gordon-Levitt",
        "Scarlett Johansson",
        "Julianne Moore"
      ],
      "year": 2013
    },
    "id": "tt2229499",
    "type": "add"
  }

Interrogation
-------------

L'interface Web Cerebro permet d'exécuter des requêtes
textuelles. Pour ce faire, allez sur l'onglet 'Rest'. Tapez
``movies/movie/_search`` dans le premier champ, pour indiquer que vous allez
travailler avec l'interface ``_search`` sur les documents de type ``movie`` de
l'index ``movies``.

Vous allez saisir des requêtes en mode ``POST``, qui seront sous la forme de
documents JSON.

Par exemple, votre première requête consiste à trouver les films "Star Wars" de
la base. Pour cela vous pourrez saisir la requête suivante :

.. code-block:: json

    {
        "query": {
            "match": {
                "fields.title": "Star Wars"
            }
        }
    }

Elle est équivalente à la requête curl : ``_search?q=fields.title:Star+Wars``

Que remarquez-vous pour les résultats ? Proposez une variante.

.. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
  
      On remarque que l'on ramène aussi Bride Wars et Dark Wars, ce qui diffère
      sensiblement du comportement obtenu en BDD. 

      Variante :

      .. code-block:: json

        {
            "query": {
                "match_phrase": {
                    "fields.title": "Star Wars"
                }
            }
        }

      2e variante 

      .. code-block:: json

        {
          "query": {
            "match": {
              "fields.title": {
                "query": "Star Wars",
                "operator": "and"
              }
            }
          }
        }


La documentation complète sur le DSL d'Elasticsearch se trouve en ligne à
l'adresse :
https://www.elastic.co/guide/en/elasticsearch/guide/current/full-text-search.html

Vous pouvez limiter la quantité d'informations qui se trouvent dans le champ
``_source`` de chacun des résultats comme ceci :

      .. code-block:: json

        {
          "_source": {
            "includes": [
              "*.title",
              "*.directors"
            ],
            "excludes": [
              "*.actors*",
              "*.genres"
            ]
          },
          "query": {
            "match": {
              "fields.title": "Star Wars"
            }
          }
        }

Maintenant, proposez des requêtes pour les besoins d'informations suivants (vous
pouvez aussi proposer des variantes "exactes", comme pour la requête ci-dessus):

- Films 'Star Wars' dont le réalisateur (directors) est 'George Lucas' (requête
  booléenne)

  .. ifconfig:: rielastic in ('public')

     .. admonition:: Correction
    
        .. code-block:: json

           {
             "query": {
               "bool": {
                 "should": [
                   {
                     "match": {
                       "fields.title": "Star Wars"
                     }
                   },
                   {
                     "match": {
                       "fields.directors": "George Lucas"
                     }
                   }
                 ]
               }
             }
           }

      Pour une recherche exacte : 

          .. code-block:: json

            {
              "query": {
                "bool": {
                  "should": [
                    {
                      "match_phrase": {
                        "fields.title": "Star Wars"
                      }
                    },
                    {
                      "match": {
                        "fields.directors": "George Lucas"
                      }
                    }
                  ]
                }
              }
            }

      Variante : 

      .. code-block:: json

        {
          "_source": {
            "includes": [ "*.title" ],
            "excludes": [ "*.actors*", "*.genres", "*.directors" ]
          },
          "query": {
            "bool": {
              "should": [
                {
                  "match": {
                    "fields.title": {
                      "query": "Star Wars",
                      "operator": "and"
                    }
                  }
                },
                {
                  "match": {
                    "fields.directors": {
                      "query": "Georges Lucas",
                      "operator": "and"
                    }
                  }
                }
              ]
            }
          }
        }

      ou ``_search?q=fields.title:Star+Wars directors:George+Lucas``

- Films dans lesquels 'Harrison Ford' a joué

  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {
          "query": {
            "match": {
              "fields.actors": "Harrison Ford"
            }
          }
        }

    ou  ``_search?q=fields.actors:Harrison+Ford``

- Films dans lesquels 'Harrison Ford' a joué dont le résumé (plot) contient
  'Jones'.

  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {"query":{
          "bool": {
            "should": [
              { "match": { "fields.actors": "Harrison Ford" }},
              { "match": { "fields.plot": "Jones" }}
            ]
        }}}

      ``_search?q=fields.actors=Harrison+Ford fields.plot:Jones``

- Films dans lesquels 'Harrison Ford' a joué dont le résumé (plot) contient
  'Jones' mais sans le mot 'Nazis'

  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {"query":{
          "bool": {
            "should": [
              { "match": { "fields.actors": "Harrison Ford" }},
              { "match": { "fields.plot": "Jones" }}
            ],
            "must_not" : { "match" : {"fields.plot":"Nazis"}}
        }}}

      ``_search?q=actors=Harrison+Ford plot:Jones -plot:Nazis``

- Films de 'James Cameron' dont le rang devrait être inférieur à 1000 (boolean +
  range query).

  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {"query":{
          "bool": {
            "should": [
              { "match": { "fields.directors": "James Cameron" }},
              { "range": { "fields.rank": {"lt":1000 }}}
            ]
        }}}

- Films de 'James Cameron' dont le rang **doit** être inférieur à 400 (réponse
  exacte : 2)

  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {
          "query": {
            "bool": {
              "must": [{
                  "match_phrase": {
                    "fields.directors": "James Cameron"
                  }
                },
                {
                  "range": {
                    "fields.rank": {
                      "lt": 400
                    }
                  }
                }
              ]
            }
          }
        }



- Films de 'Quentin Tarantino' dont la note (rating) doit être supérieure à 5,
  sans être un film d'action ni un drame.

  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {
          "_source": {
            "includes": [
              "*.title"
            ],
            "excludes": [
              "*.actors*"
            ]
          },
          "query": {
            "bool": {
              "must": [
                {
                  "match_phrase": {
                    "fields.directors": "Quentin Tarantino"
                  }
                },
                {
                  "range": {
                    "fields.rating": {
                      "gte": 5
                    }
                  }
                }
              ],
              "must_not": [
                {
                  "match": {
                    "fields.genres": "Action"
                  }
                },
                {
                  "match": {
                    "fields.genres": "Drama"
                  }
                }
              ]
            }
          }
        }

- Films de 'J.J. Abrams' sortis (released) entre 2010 et 2015

  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {
          "query": {
            "bool":{
              "must": {"match": {"fields.directors": "J.J. Abrams"}},
              "filter": {
                "range": {
                  "fields.release_date": { "from": "2010-01-01", "to": "2015-12-31"}
                }
              }
            }
          }
        }

Agrégats
--------

Nous souhaiterions maintenant réaliser quelques agrégats sur la base de films.
C'est-à-dire que l'on va commencer à utiliser Elasticsearch pour calculer des
statistiques sur nos documents.

Les agrégats fonctionnent avec deux concepts, les `buckets` (seaux, en français)
qui sont les catégories que vous allez créer, et les `metrics` (indicateurs, en
français), qui sont les statistiques que vous allez calculer sur les `buckets`.

Si l'on compare à une requête SQL très simple : 

      .. code-block:: sql

        SELECT COUNT(color)
        FROM table
        GROUP BY color

``COUNT(color)`` est la métrique, ``GROUP BY color`` crée les groupes
(`buckets`).

Une agrégation est la combinaison d'un `bucket` (au moins) et d'une `metric` (au
moins). On peut, pour des requêtes complexes, imbriquer des `buckets` dans
d'autres `buckets`. La syntaxe est, comme précédemment, très modulaire. 

Un exemple, avec le nombre de films par année : 

.. code-block:: json

    {
      "size": 0,
      "aggs" : { "nb_par_annee" : {
        "terms" : {"field" : "fields.year"}
          }
      }
    }

Le paramètre ``aggs`` permet à Elasticsearch de savoir qu'on travaille sur des
agrégations (on peut utiliser ``aggregations``). ``size:0`` retire les
résultats de recherche de la requête, pour que ``hits`` soit vide.
``nb_par_annee`` est le nom que l'on donne à notre agrégat. Les buckets sont
créés avec le ``terms`` qui ici indique que l'on va créer un groupe par valeur
différente du champ ``fields.year``. La métrique sera automatique ici, ce sera
simplement la somme de chaque catégorie.

Proposez maintenant les requêtes permettant d'obtenir les statistiques
suivantes:

- Donner la note (rating) moyenne des films. 

  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {"size":0,
        "aggs" : {
            "note_moyenne" : {
              "avg" : {"field" : "fields.rating"}
            }}}

- Donner la note (rating) moyenne, et le rang moyen des films de George Lucas
  (cliquer sur (-) à côté de "hits" dans l'interface pour masquer les résultats
  et consulter les valeurs calculées)
  
  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {"query" :{
            "match" : {"fields.directors": {"query": "George Lucas", "operator": "and"}}
          }
         ,"aggs" : {
            "note_moyenne" : {
              "avg" : {"field" : "fields.rating"}
            },
            "rang_moyen" : {
              "avg" : {"field" : "fields.rank"}
            }
        }}

- Donnez la note (rating) moyenne des films par année. Attention, il y a ici une
  imbrication d'agrégats (on obtient par exemple 456 films en 2013 avec un
  *rating* moyen de 5.97).
 
  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {"aggs" : {
            "group_year" : {
              "terms" : {
                "field" : "fields.year"
              },
              "aggs" : {
                "note_moyenne" : {
                  "avg" : {"field" : "fields.rating"}
                }}
            }}}

- Donner la note (rating) minimum, maximum et moyenne des films par année.

  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {"aggs" : {
            "group_year" : {
              "terms" : {
                "field" : "fields.year"
              },
              "aggs" : {
                "note_moyenne" : {"avg" : {"field" : "fields.rating"}},
                "note_min" : {"min" : {"field" : "fields.rating"}},
                "note_max" : {"max" : {"field" : "fields.rating"}}
              }
            }}}

- Donner le rang (rank) moyen des films par année et trier par ordre
  décroissant. 

  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {"aggs" : {
            "group_year" : {
              "terms" : {
                "field" : "fields.year",
                "order" : { "rating_moyen" : "desc" }
              },
              "aggs" : {
                "rating_moyen" : {
                  "avg" : {"field" : "fields.rating"}
              }}
        }}}

- Compter le nombre de films par tranche de note (0-1.9, 2-3.9, 4-5.9...).
  Indice : ``group_range``.

  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {"aggs" : {
            "group_range" : {
              "range" : {
                "field" : "fields.rating",
                "ranges" : [
                  {"to" : 1.9},
                  {"from" : 2, "to" : 3.9},
                  {"from" : 4, "to" : 5.9},
                  {"from" : 6, "to" : 7.9},
                  {"from" : 8}
                ]
              }
            }}}


- Donner le nombre d'occurrences de chaque genre de film.

  .. ifconfig:: rielastic in ('public')

     .. admonition:: Correction
       
      Cette opération n'est pas possible car "genres" est une liste de
      valeur. Il faudrait pour cela créer un mapping particulier sur les
      données (autre que automatique) pour pouvoir faire l'agrégation. (Nous
      ferons cela dans la section suivante). Même chose si l'on cherchait à
      connaître les occurrences des termes utilisés.

Bonus : Agrégats via mapping spécifique
---------------------------------------

Certaines requêtes d'agrégats ne peuvent marcher car elasticsearch ne souhaite
pas (par défaut) effectuer des agrégats sur des chaînes spécifiques (array,
noms, etc.). Pour ce faire, il faut définir un mapping différent pour les
données, en créant un sous-champ associé au champ original, et en spécifiant que
ce sous-champ ne doit pas être analysé. Nous l'appelons ci-dessous *raw* (brut).
On ne pourra pas effectuer toutes les requêtes possibles sur ce sous-champ, mais
il sera précieux pour les agrégations.

Vous pourrez consulter le mapping par défaut généré pour notre jeu de données :
http://localhost:9200/movies/?pretty

Pour pouvoir importer les données avec un mapping approprié, nous allons créer
une nouvelle base "movies2" (toutes les requêtes devront être faites sur
``/movies2/movie/_search``).

Suivez les instructions suivantes :

  - À l'adresse http://b3d.bdpedia.fr/files/elastictp/mapping.es7.json, vous pourrez
    trouver un fichier de mapping différent, correspondant à notre nouveau
    besoin. Le jeu de données associé est à télécharger à l'adresse :
    http://b3d.bdpedia.fr/files/elastictp/movies_elastic2.json.

  - Importez le mapping sur elasticsearch : 

  .. code-block:: bash                                                            

      curl -XPUT "localhost:9200/movies2?pretty" -H 'Content-Type: application/json' -d @mapping.es7.json

  - Importez le nouveau fichier de données (dans l'index "movies2"): 

  .. code-block:: bash                                                            

      curl -s -XPOST http://localhost:9200/movies2/_bulk/ -H 'Content-Type: application/json' --data-binary @movies_elastic2.json

Vous pourrez retrouver le mapping ici : http://localhost:9200/movies2/?pretty
Et interroger les données ici : http://localhost:9200/movies2/movie/_search?pretty

Par exemple, nous pouvons grouper par "genre" de film, et donner leurs
occurrences :

.. code-block:: json

  {"aggs" : {
      "nb_per_genres" : {
        "terms" : {"field" : "fields.genres.raw"}
  }}}

La clé "raw" est utilisée pour aller récupérer la donnée associée. Ceci n'est
possible que sur les données dont le mapping est de type "raw". Attention, il
n'est alors plus possible de faire des recherches par similarité (requêtes
textuelles), seulement des recherches exactes.

Proposez des requêtes pour pouvoir :

- Donner le nombre d'occurrences de chaque réalisateur ou réalisatrice.

  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {"aggs" : {
            "nb_per_director" : {
              "terms" : {
                "field" : "fields.directors.raw",
                "size" : 25,
                }
        }}}

- Donner le nombre d'occurrences de chaque mot dans les titres des films.

  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {"aggs" : {
            "nb_par_mot_des_titres" : {
              "terms" : {"field" : "fields.title.raw"}
        }}}

  Vous constaterez que l'agrégation se fait sur les mots, et non sur le titre.
  Ainsi, les mots récurrents sont : "the", "of", "a", "in", "and", "2"...
  
  Nous pouvons ainsi vérifier que les données textuelles sont bien segmentées
  par mots et que le regroupement se fait par mot. Cela est également dû à la
  clé ``terms`` présente dans la requête.

- Donner la note (rating) moyenne, le rang min et max, des films par acteur.
  Bonus : triez par note moyenne. Qu'observez-vous ? Que proposez-vous ?

  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {"aggs" : {
            "group_actors" : {
              "terms" : {
                "field" : "fields.actors.raw",
                "order": {
                  "rating_moyen": "desc"
                }
              },
              "aggs" : {
                "rating_moyen" : {"avg" : {"field" : "fields.rating"}},
                "rang_min" : {"min" : {"field" : "fields.rank"}},
                "rang_max" : {"max" : {"field" : "fields.rank"}}
              }
        }}}

- Nombre de réalisateurs distincts pour les films d'aventure.

  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {"query":{
            "match" : {"fields.genres" : "Adventure"}
          },
          "aggs" : {
            "nb_distinct" : {
              "cardinality" : {"field" : "fields.directors"}
            }
          }
        }

- Termes les plus utilisés (agrégat : ``significant_terms``) dans les
  descriptions des films de George Lucas.

  .. ifconfig:: rielastic in ('public')

   .. admonition:: Correction
     
      .. code-block:: json

        {"query" :{
            "match" : {"fields.directors" : "George Lucas"}
          },
          "aggs" : {
            "terms_significatifs" : {
              "significant_terms" : {"field" : "fields.plot", "size":6}
        }}}

