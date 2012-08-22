.PHONY: all
all: index.html releases.html

index.html: README.txt
	asciidoc -b html5 -o $@ $<

releases.html: make-index.py index.t releases/*
	python3 make-index.py > $@
