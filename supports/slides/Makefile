prescours : 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Introduction du cours}\newcommand\inputFile{prescours}\input{genslides}"
	mv genslides.pdf ../ressources-web/slprescours.pdf
	make clean

docker : 
	pdflatex   -shell-escape "\newcommand\titreDiapos{A propos de Docker}\newcommand\inputFile{docker}\input{genslides}"
	mv genslides.pdf ../ressources-web/sldocker.pdf
	make clean
	
docstruct : 
	pdflatex  -shell-escape "\newcommand\titreDiapos{Documents structur\'es}\newcommand\inputFile{docstruct}\input{genslides}"
	mv genslides.pdf ../ressources-web/sldocstruct.pdf
	make clean
	
modelisation : 
	pdflatex  -shell-escape "\newcommand\titreDiapos{Mod\'elisation}\newcommand\inputFile{modelisation}\input{genslides}"
	mv genslides.pdf ../ressources-web/slmodelisation.pdf
	make clean

json : 
	pdflatex -shell-escape "\newcommand\titreDiapos{Codage JSON}\newcommand\inputFile{json}\input{generic-slides}"
	pdflatex -shell-escape "\newcommand\titreDiapos{Codage JSON}\newcommand\inputFile{json}\input{generic-slides}"
	mv generic-slides.pdf ../ressources-web/sljson.pdf
	make clean

introduction-ES:
	pdflatex   -shell-escape "\newcommand\titreDiapos{BD documentaires et moteurs de recherche: ElasticSearch}\newcommand\inputFile{introduction-ES}\input{genslides}"
	mv genslides.pdf ../ressources-web/slintroduction-ES.pdf
	make clean

cass-model : 
	pdflatex  -shell-escape "\newcommand\titreDiapos{Cassandra: mod\'elisation des donn\'ees}\newcommand\inputFile{cass-model}\input{genslides}"
	mv genslides.pdf ../ressources-web/slcass-model.pdf
	make clean

cass-cql : 
	pdflatex  -shell-escape "\newcommand\titreDiapos{Cassandra: CQL ... et ses limites}\newcommand\inputFile{cass-cql}\input{genslides}"
	mv genslides.pdf ../ressources-web/slcass-cql.pdf
	make clean

cass-etudecas : 
	pdflatex  -shell-escape "\newcommand\titreDiapos{Cassandra: \'etude de cas}\newcommand\inputFile{cass-etudecas}\input{genslides}"
	mv genslides.pdf ../ressources-web/slcass-etudecas.pdf
	make clean
	
couchdb : 
	pdflatex -shell-escape "\newcommand\titreDiapos{Web, REST et CouchDB}\newcommand\inputFile{couchdb}\input{genslides}"
	mv genslides.pdf ../ressources-web/slcouchdb.pdf
	make clean

mongodb : 
	pdflatex  -shell-escape "\newcommand\titreDiapos{Interrogation avec MongoDB}\newcommand\inputFile{mongodb}\input{genslides}"
	mv genslides.pdf ../ressources-web/slmongodb.pdf
	make clean


ri-intro-principes: 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Principes de la Recherche d'Information}\newcommand\inputFile{ri-intro-principesRI}\input{genslides}"
	mv genslides.pdf ../ressources-web/slri-intro-principes.pdf
	make clean

ri-ranking-rankedsearch: 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Recherche avec classement}\newcommand\inputFile{ri-ranking-rankedsearch}\input{genslides}"
	mv genslides.pdf ../ressources-web/slri-ranking-rankedsearch.pdf
	make clean


ri-ranking-fulltextsearch: 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Recherche plein texte}\newcommand\inputFile{ri-ranking-fulltextsearch}\input{genslides}"
	mv genslides.pdf ../ressources-web/slri-ranking-fulltextsearch.pdf
	make clean

ri-intro-lucene-query:
	pdflatex   -shell-escape "\newcommand\titreDiapos{Interrogation avec les requêtes Lucene}\newcommand\inputFile{ri-intro-lucene-query}\input{genslides}"
	mv genslides.pdf ../ressources-web/slri-intro-lucene-query.pdf
	make clean

ri-indexation-analyse:
	pdflatex   -shell-escape "\newcommand\titreDiapos{Analyse de documents pour la Recherche d'Information}\newcommand\inputFile{ri-indexation-analyse}\input{genslides}"
	mv genslides.pdf ../ressources-web/slri-indexation-analyse.pdf
	make clean

ri-indexation-ES:
	pdflatex   -shell-escape "\newcommand\titreDiapos{Indexation avec Elasticsearch}\newcommand\inputFile{ri-indexation-ES}\input{genslides}"
	mv genslides.pdf ../ressources-web/slri-indexation-ES.pdf
	make clean


mapreduce : 
	pdflatex   -shell-escape "\newcommand\titreDiapos{MapReduce d\'emystifi\'e}\newcommand\inputFile{mapreduce}\input{genslides}"
	mv genslides.pdf ../ressources-web/slmapreduce.pdf
	make clean
	
mongo-mr : 
	pdflatex  -shell-escape  "\newcommand\titreDiapos{Frameworks MapReduce: MongoDB}\newcommand\inputFile{mongo-mapreduce}\input{genslides}"
	mv genslides.pdf ../ressources-web/slmongomr.pdf
	make clean


boolsearch: 
	pdflatex   -shell-escape -interaction=nostopmode  "\newcommand\titreDiapos{Requêtes booléennes}\newcommand\inputFile{lucene-query}\input{generic-slides}"
	pdflatex  -shell-escape -interaction=nostopmode  "\newcommand\titreDiapos{Requêtes booléennes}\newcommand\inputFile{lucene-query}\input{generic-slides}"
	mv generic-slides.pdf ../ressources-web/slboolsearch.pdf
	make clean

rankedsearch: 
	pdflatex   -shell-escape -interaction=nostopmode "\newcommand\titreDiapos{Recherche avec classement}\newcommand\inputFile{rankedsearch}\input{generic-slides}"
	pdflatex   -shell-escape -interaction=nostopmode "\newcommand\titreDiapos{Recherche avec classement}\newcommand\inputFile{rankedsearch}\input{generic-slides}"
	mv generic-slides.pdf ../ressources-web/slrankedsearch.pdf
	make clean

fulltextsearch: 
	pdflatex  -shell-escape -interaction=nostopmode  "\newcommand\titreDiapos{Recherche plein texte}\newcommand\inputFile{fulltextsearch}\input{generic-slides}"
	pdflatex  -shell-escape -interaction=nostopmode  "\newcommand\titreDiapos{Recherche plein texte}\newcommand\inputFile{fulltextsearch}\input{generic-slides}"
	mv generic-slides.pdf ../ressources-web/slfulltextsearch.pdf
	make clean

cloud:
	pdflatex   -shell-escape "\newcommand\titreDiapos{Cloud et scalabilit\\'e}\newcommand\inputFile{cloud}\input{genslides}"
	mv genslides.pdf ../ressources-web/slcloud.pdf
	make clean
	
scalable:
	pdflatex   -shell-escape "\newcommand\titreDiapos{Scalabilit\\'e}\newcommand\inputFile{scalable}\input{genslides}"
	mv genslides.pdf ../ressources-web/slscalable.pdf
	make clean

cloudperf:
	pdflatex   -shell-escape "\newcommand\titreDiapos{Anatomie d'un syst\`eme cloud}\newcommand\inputFile{cloudperf}\input{genslides}"
	mv genslides.pdf ../ressources-web/slcloudperf.pdf
	make clean

replication:
	pdflatex   -shell-escape "\newcommand\titreDiapos{R\'eplication et reprise sur panne}\newcommand\inputFile{replication}\input{genslides}"
	mv genslides.pdf ../ressources-web/slreplication.pdf
	make clean

mongosys:
	pdflatex   -shell-escape "\newcommand\titreDiapos{Distribution et r\\'eplication dans MongoDB}\newcommand\inputFile{mongosys}\input{genslides}"
	mv genslides.pdf ../ressources-web/slmongosys.pdf
	make clean
	
cassreplic: 
	pdflatex  -shell-escape  "\newcommand\titreDiapos{Cassandra et la réplication}\newcommand\inputFile{cass-replic}\input{genslides}"
	mv genslides.pdf ../ressources-web/slcassreplic.pdf
	make clean

sharding: 
	pdflatex  -shell-escape  "\newcommand\titreDiapos{Partitionnement}\newcommand\inputFile{sharding}\input{genslides}"
	mv genslides.pdf ../ressources-web/slsharding.pdf
	make clean

rangedistr: 
	pdflatex  -shell-escape  "\newcommand\titreDiapos{Partitionnement par tri}\newcommand\inputFile{rangedistr}\input{genslides}"
	mv genslides.pdf ../ressources-web/slrangedistr.pdf
	make clean

hashdistr: 
	pdflatex  -shell-escape  "\newcommand\titreDiapos{Partitionnement par hachage}\newcommand\inputFile{hashdistr}\input{genslides}"
	mv genslides.pdf ../ressources-web/slhashdistr.pdf
	make clean

cassdistrib: 
	pdflatex  -shell-escape  "\newcommand\titreDiapos{Cassandra en distribué}\newcommand\inputFile{cass-distrib}\input{generic-slides}"
	mv generic-slides.pdf ../ressources-web/slcassdistrib.pdf
	make clean

mapred: 
	pdflatex  -shell-escape  "\newcommand\titreDiapos{Map Reduce}\newcommand\inputFile{mapred}\input{genslides}"
	mv genslides.pdf ../ressources-web/slmapred.pdf
	make clean

pig: 
	pdflatex  -shell-escape  "\newcommand\titreDiapos{Le langage Pig latin}\newcommand\inputFile{pig}\input{genslides}"
	mv genslides.pdf ../ressources-web/slpig.pdf
	make clean

spark: 
	pdflatex  -shell-escape "\newcommand\titreDiapos{Introduction à Spark}\newcommand\inputFile{spark}\input{genslides}"
	mv genslides.pdf ../ressources-web/slspark.pdf
	make clean

cs103-intro: 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Mod\'elisation des donn\'ees}\newcommand\inputFile{cs103-intro}\input{cs103}"
	mv cs103.pdf ../../../CS103/diapos/cs103-intro.pdf
	make clean
cs103-normalisation: 
	pdflatex   -shell-escape "\newcommand\titreDiapos{La normalisation relationnelle}\newcommand\inputFile{cs103-normalisation}\input{cs103}"
	mv cs103.pdf ../../../CS103/diapos/cs103-normalisation.pdf
	make clean
cs103-sql: 
	pdflatex   -shell-escape "\newcommand\titreDiapos{L'interrogation}\newcommand\inputFile{cs103-sql}\input{cs103}"
	mv cs103.pdf ../../../CS103/diapos/cs103-sql.pdf
	make clean
cs103-docstruct: 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Mod\'elisation structur\'ee}\newcommand\inputFile{cs103-docstruct}\input{cs103}"
	mv cs103.pdf ../../../CS103/diapos/cs103-docstruct.pdf
	make clean
cs103-mongodb: 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Introduction \`a MongoDB}\newcommand\inputFile{cs103-mongodb}\input{cs103}"
	mv cs103.pdf ../../../CS103/diapos/cs103-mongodb.pdf
	make clean
cs103-distrib: 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Transactions et r\'eplication}\newcommand\inputFile{cs103-distrib}\input{cs103}"
	mv cs103.pdf ../../../CS103/diapos/cs103-distrib.pdf
	make clean
cs103-cassandra-model: 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Mod\`ele de donn\'ees Cassandra}\newcommand\inputFile{cs103-cassandra-model}\input{cs103}"
	mv cs103.pdf ../../../CS103/diapos/cs103-cassandra-model.pdf
	make clean
cs103-cql: 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Cassandra et le langage CQL}\newcommand\inputFile{cs103-cql}\input{cs103}"
	mv cs103.pdf ../../../CS103/diapos/cs103-cql.pdf
	make clean
cs103cql: 
	pdflatex   -shell-escape cs103cql.tex
	mv cs103cql.pdf ../../../CS103/diapos/cs103cql.pdf
	make clean

cs103-install-ES: 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Elastic Search: installation}\newcommand\inputFile{cs103-install-ES}\input{cs103}"
	mv cs103.pdf  ../../../CS103/diapos/cs103-install-ES.pdf
	make clean
cs103-donnees-ES: 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Elastic Search: chargement de donn\'ees}\newcommand\inputFile{cs103-donnees-ES}\input{cs103}"
	mv cs103.pdf  ../../../CS103/diapos/cs103-donnees-ES.pdf
	make clean
cs103-boolq-ES: 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Elastic Search: recherches bool\'eennes}\newcommand\inputFile{cs103-boolq-ES}\input{cs103}"
	mv cs103.pdf  ../../../CS103/diapos/cs103-boolq-ES.pdf
	make clean

all:	prescours.pdf

%.pdf: %.tex
	pdflatex   -shell-escape "\newcommand\inputFile{$*.tex}\input{genslides}"
	mv genslides.pdf ../ressources-web/sl$*.pdf
	make clean

clean:
	\rm -f *.vrb *.aux *.bbl *.blg *.dvi *.log *.ps *.snm *.out *.nav *.toc *.pyg *~
	\rm -Rf _minted*

ultraclean:
	\rm -f *.vrb *.aux *.bbl *.blg *.dvi *.log *.ps *.pdf *.snm *.out *.nav *.toc *~

