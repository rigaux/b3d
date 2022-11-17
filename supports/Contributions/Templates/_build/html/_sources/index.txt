.. 

##################
Chapitre Neo4J 
##################

Contents:

.. toctree::
   :maxdepth: 2


Ce document est un modèle pour chapitre à inclure dans le support en ligne b3d.bdpedia.fr
Il doit être inclus dans un projet Sphinx: http://www.sphinx-doc.org/en/stable/, et
formatté en RST.

Quelques règles typographiques.
   
Tous les exemples de code doivent être inclus dans un ``code-block``, comme
dans l'exemple ci-dessous.

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
        "name":"Paris"
    }

Toute mention à du code informatique dans le texte doit être en  ``police
à chasse fixe``, obtenue avec \`\`texte\`\`.

Tous les mots étrangers sont *en italiques*, obtenues avec \*texte\*.

Utiliser les *admonitions* de RST. Par exemple:

.. note:: Ceci est une note ou un commentaire.

Les figures doivent être en PNG, avec une référence et une légende. Le fichier
doit être dans le répertoire ``../figures``.

.. _cloud:
.. figure:: ../figures/cloud.png       
        :width: 90%
        :align: center
   
        Perspective générale sur les systèmes distribués dans un *cloud*
    
Titre niveau 2
==============


Titre niveau 3
--------------


