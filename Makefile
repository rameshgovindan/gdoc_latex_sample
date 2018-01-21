# NB: By default fetch the paper from Google docs every time
# use "make recompile" to avoid the extra fetch

NAME=routing_is_hard
TARGET=$(NAME).pdf

# Change the line below to contain an export URL.
# Make sure the sharing mode on the Doc is set to "anyone with link can view"
# DOCS_LINK=https://docs.google.com/document/d/1RnQewCHXls6r4rFZTgfdb7j_9u7keZzbOAC074LYA4Y/export?format=txt
# DOCS_LINK=https://docs.google.com/document/d/1HekeFXTQ8SyPU7iWre_hefPB8V0cfVTvBX9vJD3jusg/export?format=txt
DOCS_LINK=https://docs.google.com/document/d/1k0uJ9ZqTlqUQvpDOtwoj_8gHrS6pqMdXWlYILakTddg/export?format=txt

# This line should not change; however, you can customize the template.tex for the conference
PANDOC_FLAGS=-s -N --template=template.tex -f markdown+yaml_metadata_block -t latex

# Customize the line below to change the bib file and the csl file (either ieee or acm)
# and to use pandoc-citeproc or biblatex (the latter is the default)
# BIBLIO_FLAGS=--bibliography=mybib.bib --csl=acm.csl
# BIBLIO_FLAGS=--bibliography=mybib.bib --biblatex
BIBLIO_FLAGS=--bibliography=mybib.bib --natbib

# This file contains title, authors and abstract, and other Pandoc metadata including bibliography
# YAML_METADATA=config.yaml

.SUFFIXES:
.SUFFIXES: .stamp .tex .pdf

top: all

recompile: $(TARGET)

all: trigger $(TARGET)

clean:
	rm -f $(NAME).aux $(NAME).bbl $(NAME).blg $(NAME).log $(NAME).pdf $(NAME).md $(NAME).out $(NAME).trig
	rm -f $(NAME).tex  # CAUTION remove if source is moved from Google docs

trigger $(NAME).trig:
	touch $(NAME).trig

# This fetches the shared source from Google docs
$(NAME).tex: $(NAME).trig
	#wget --no-check-certificate -O$(NAME).mdt $(DOCS_LINK)
	mv "$(HOME)/Downloads/Routing Experiences Paper.txt" $(NAME).mdt
	iconv -c -t ASCII//TRANSLIT $(NAME).mdt | sed -e 's/\[[a-z]*]//g' -e '/^# Bibliography/q' -e '/%/a\ ' | awk '{if (/^#/) print ""; print $0}' > $(NAME).mdtt
	cat $(YAML_METADATA) $(NAME).mdtt > $(NAME).md
	rm $(NAME).mdt $(NAME).mdtt
	pandoc $(PANDOC_FLAGS) $(BIBLIO_FLAGS) $(NAME).md > $(NAME).tex

# Iterate on latex until cross references don't change
$(NAME).pdf: $(NAME).tex
	pdflatex $(NAME)
	bibtex $(NAME)
	pdflatex $(NAME)
	pdflatex $(NAME)

spell: $(NAME).tex
	cat $(NAME).tex | aspell list | sort -u | aspell -a
