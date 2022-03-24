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

cass-model : 
	pdflatex  -shell-escape "\newcommand\titreDiapos{Cassandra: mod\'elisation des donn\'ees}\newcommand\inputFile{cass-model}\input{genslides}"
	mv genslides.pdf ../ressources-web/slcass-model.pdf
	make clean
	
json : 
	pdflatex -shell-escape "\newcommand\titreDiapos{Codage JSON}\newcommand\inputFile{json}\input{generic-slides}"
	pdflatex -shell-escape "\newcommand\titreDiapos{Codage JSON}\newcommand\inputFile{json}\input{generic-slides}"
	mv generic-slides.pdf ../ressources-web/sljson.pdf
	make clean
	
couchdb : 
	pdflatex -shell-escape "\newcommand\titreDiapos{Web, REST et CouchDB}\newcommand\inputFile{couchdb}\input{genslides}"
	mv genslides.pdf ../ressources-web/slcouchdb.pdf
	make clean

mongodb : 
	pdflatex  -shell-escape "\newcommand\titreDiapos{Interrogation avec MongoDB}\newcommand\inputFile{mongodb}\input{genslides}"
	mv genslides.pdf ../ressources-web/slmongodb.pdf
	make clean

mapreduce : 
	pdflatex   -shell-escape "\newcommand\titreDiapos{MapReduce d\'emystifi\'e}\newcommand\inputFile{mapreduce}\input{genslides}"
	mv genslides.pdf ../ressources-web/slmapreduce.pdf
	make clean
	
mongo-mr : 
	pdflatex  -shell-escape  "\newcommand\titreDiapos{Frameworks MapReduce: MongoDB}\newcommand\inputFile{mongo-mapreduce}\input{genslides}"
	mv genslides.pdf ../ressources-web/slmongomr.pdf
	make clean


introri: 
	pdflatex  -shell-escape  "\newcommand\titreDiapos{Introduction \`a  la recherche d'information}\newcommand\inputFile{introri}\input{generic-slides}"
	pdflatex  -shell-escape  "\newcommand\titreDiapos{Introduction \`a  la recherche d'information}\newcommand\inputFile{introri}\input{generic-slides}"
	mv generic-slides.pdf ../ressources-web/slintrori.pdf
	make clean

boolsearch: 
	pdflatex   -shell-escape -interaction=nostopmode  "\newcommand\titreDiapos{Requêtes booléennes}\newcommand\inputFile{lucene-query}\input{generic-slides}"
	pdflatex  -shell-escape -interaction=nostopmode  "\newcommand\titreDiapos{Requêtes booléennes}\newcommand\inputFile{lucene-query}\input{generic-slides}"
	mv generic-slides.pdf ../ressources-web/slboolsearch.pdf
	make clean
	
installsolr : 
	pdflatex -shell-escape -interaction=nostopmode "\newcommand\titreDiapos{Installation de Solr}\newcommand\inputFile{solr-install}\input{generic-slides}"
	pdflatex -shell-escape  -interaction=nostopmode "\newcommand\titreDiapos{Installation de Solr}\newcommand\inputFile{solr-install}\input{generic-slides}"
	mv generic-slides.pdf ../ressources-web/slinstallsolr.pdf
	make clean

indexsolr : 
	pdflatex -shell-escape -interaction=nonstopmode "\newcommand\titreDiapos{Cr\'eation d'un index Solr}\newcommand\inputFile{solr-schema}\input{generic-slides}"
	pdflatex -shell-escape  -interaction=nonstopmode "\newcommand\titreDiapos{Cr\'eation d'un index  Solr}\newcommand\inputFile{solr-schema}\input{generic-slides}"
	mv generic-slides.pdf ../ressources-web/slindexsolr.pdf
	make clean

analysesolr : 
	pdflatex -shell-escape -interaction=nonstopmode "\newcommand\titreDiapos{Analyse des textes avec Solr}\newcommand\inputFile{solr-analyse}\input{generic-slides}"
	pdflatex -shell-escape  -interaction=nonstopmode "\newcommand\titreDiapos{Analyse des textes avec Solr}\newcommand\inputFile{solr-analyse}\input{generic-slides}"
	mv generic-slides.pdf ../ressources-web/slanalysesolr.pdf
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

pagerank: 
	pdflatex  "\newcommand\titreDiapos{L'algorithme PageRank}\newcommand\inputFile{pagerank}\input{generic-slides}"
	mv generic-slides.pdf ../ressources-web/slpagerank.pdf
	make clean

cloudold: 
	pdflatex -shell-escape -interaction=nostopmode "\newcommand\titreDiapos{Cloud et scalabilit\'e}\newcommand\inputFile{cloud}\input{generic-slides}"
	mv generic-slides.pdf ../ressources-web/slcloud.pdf
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
	pdflatex  -shell-escape  "\newcommand\titreDiapos{Map Reduce}\newcommand\inputFile{pig}\input{genslides}"
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

flinkstream : 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Streaming avec Flink}\newcommand\inputFile{flinkstream}\input{genslides}"
	mv genslides.pdf ../ressources-web/slflinkstream.pdf
	make clean

flinkwindows: 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Fenetrage avec Flink}\newcommand\inputFile{flinkwindows}\input{genslides}"
	mv genslides.pdf ../ressources-web/slflinkwindows.pdf
	make clean

ri-intro-principes: 
	pdflatex   -shell-escape "\newcommand\titreDiapos{Principes de la Recherche d'Information}\newcommand\inputFile{ri-intro-principesRI}\input{genslides}"
	mv genslides.pdf ../ressources-web/slri-intro-principes.pdf
	make clean

ri-intro-debuterES:
	pdflatex   -shell-escape "\newcommand\titreDiapos{BD documentaires et moteurs de recherche: ElasticSearch}\newcommand\inputFile{ri-intro-debuterES}\input{genslides}"
	mv genslides.pdf ../ressources-web/slri-intro-debuterES.pdf
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

all:	prescours.pdf

%.pdf: %.tex
	pdflatex   -shell-escape "\newcommand\inputFile{$*.tex}\input{genslides}"
	mv genslides.pdf ../ressources-web/sl$*.pdf
	make clean

clean:
	\rm -f *.vrb *.aux *.bbl *.blg *.dvi *.log *.ps *.snm *.out *.nav *.toc *~
	\rm -Rf _minted*

ultraclean:
	\rm -f *.vrb *.aux *.bbl *.blg *.dvi *.log *.ps *.pdf *.snm *.out *.nav *.toc *~

	
xml : 
	pdflatex -shell-escape "\newcommand\titreDiapos{Codage XML}\newcommand\inputFile{xml}\input{generic-slides}"
	pdflatex -shell-escape "\newcommand\titreDiapos{Codage XML}\newcommand\inputFile{xml}\input{generic-slides}"
	mv generic-slides.pdf ../ressources-web/slxml.pdf
	make clean

	
xpath : 
	pdflatex -shell-escape "\newcommand\titreDiapos{XPath, l'essentiel}\newcommand\inputFile{xpath}\input{generic-slides}"
	pdflatex -shell-escape "\newcommand\titreDiapos{XPath, l'essentiel}\newcommand\inputFile{xpath}\input{generic-slides}"
	mv generic-slides.pdf ../ressources-web/slxpath.pdf
	make clean

xquery : 
	pdflatex -shell-escape "\newcommand\titreDiapos{Introduction \`a XQuery}\newcommand\inputFile{xquery}\input{generic-slides}"
	pdflatex -shell-escape "\newcommand\titreDiapos{Introduction \`a XQuery}\newcommand\inputFile{xquery}\input{generic-slides}"
	mv generic-slides.pdf ../ressources-web/slxquery.pdf
	make clean
	