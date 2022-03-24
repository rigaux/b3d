clean:
	\rm -f *.aux *.bbl *.blg *.dvi *.log *.ps *~

td1: 
	pdflatex ed1_formalismeXML
	pdflatex ed1_formalismeXML-corr
	pdflatex ed1_formalismeXML
	pdflatex ed1_formalismeXML-corr
	make clean

td2: 
	pdflatex ed2_XPath
	pdflatex ed2_XPath-corr
	pdflatex ed2_XPath
	pdflatex ed2_XPath-corr
	make clean

td3: 
	pdflatex ed3_XSLT
	pdflatex ed3_XSLT-corr
	pdflatex ed3_XSLT
	pdflatex ed3_XSLT-corr
	make clean

td4: 
	pdflatex ed4_XMLSchema
	pdflatex ed4_XMLSchema-corr
	pdflatex ed4_XMLSchema
	pdflatex ed4_XMLSchema-corr
	make clean

td5: 
	pdflatex ed5_XQuery
	pdflatex ed5_XQuery-corr
	pdflatex ed5_XQuery
	pdflatex ed5_XQuery-corr
	make clean
all:
	make td1
	make td2
	make td3
	make td3
	make td4

ultraclean:
	\rm -f *.aux *.bbl *.blg *.dvi *.log *.ps *.pdf *~

