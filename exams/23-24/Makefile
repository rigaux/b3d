
all:	nfe204-ticketscaisse.pdf

%.pdf: %.tex
	pdflatex   -shell-escape $*.tex
	pdflatex   -shell-escape $*.tex
	make clean

clean:
	\rm -f *.vrb *.aux *.bbl *.blg *.dvi *.log *.ps *.snm *.out *.nav *.toc *~
	\rm -Rf _minted*

ultraclean:
	\rm -f *.vrb *.aux *.bbl *.blg *.dvi *.log *.ps *.pdf *.snm *.out *.nav *.toc *~
