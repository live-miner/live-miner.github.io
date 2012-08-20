.PHONY: all
all: releases.html

releases.html: make-index.py index.t releases/*
	python3 make-index.py > $@
