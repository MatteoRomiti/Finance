####################################################
# --------------------------------------------------
# Mini Makefile for Latex papers 
# --------------------------------------------------
####################################################

# You can pass the three required variables via
# the command line without changeing the make file e.g.:
# $ FILE="template" make 

# I) File name of your LaTex source documebnt
FILE ?= main

# II) Change this if you use latex instead of pdflatex.
# However, this also requires to update the build rules.
LATEX ?= pdflatex

# III)  
BIBTEX ?= bibtex

### rules and commands ############################

.PHONY: all
all: todoon $(FILE).pdf clean

# generate pdf and bibtex entries 
.PHONY: $(FILE).pdf
$(FILE).pdf: $(FILE).tex
	$(LATEX) $(FILE).tex
	$(BIBTEX) $(FILE)
	$(LATEX) $(FILE).tex
	$(LATEX) $(FILE).tex

# generate pdf without bibtex, in case of inline bibentries
.PHONY: inline
inline:
	$(LATEX) $(FILE).tex
	$(LATEX) $(FILE).tex
	$(LATEX) $(FILE).tex

incremental:
	latexmk -pdf -pvc $(FILE).tex

# generate pdf containing todo notes
# This temporarly changes this line in the paper:
# ```latex
# \usepackage[disable]{todonotes} % to disable/un-display all todonotes at once uncomment this
# ```
.PHONY: submission
submission: todooff $(FILE).pdf clean

.PHONY: todoon
todoon: 
	bash search_replace.sh '^\\usepackage\[disable\]{todonotes}' '\\usepackage{todonotes}'    $(FILE).tex

.PHONY: todooff
todooff:
	bash search_replace.sh '^\\usepackage{todonotes}' '\\usepackage\[disable\]{todonotes}'    $(FILE).tex

# clean als temp files
clean:
	-rm -f $(FILE).aux $(FILE).log 
	-rm -f $(FILE).bbl $(FILE).blg
	-rm -f $(FILE).nav $(FILE).out
	-rm -f $(FILE).toc $(FILE).snm
	-rm -f $(FILE).idx $(FILE).fls
	-rm -f $(FILE).ind $(FILE).ilg
	-rm -f $(FILE).fdb_latexmk $(FILE).synctex.gz

# Experimental: Generate .docx file with pandoc
#.PHONY: doc
#doc:
#	pandoc -f latex  $(FILE).tex -o $(FILE).docx

