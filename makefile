#
# Makefile for ESLint.bbpackage
#

SRC_DIR = ./src
PKG = ./ESLint.bbpackage
CONTENTS_DIR = $(PKG)/Contents
DIST_DIR = ./dist
INFO_PATH = $(PWD)/src/Info
VERSION = $(shell defaults read $(INFO_PATH) CFBundleShortVersionString)
ZIP = ./ESLint.bbpackage_v$(VERSION).zip

.DEFAULT: all

.PHONY: all clean install

all: clean build

clean:
	-rm -rf $(PKG)
	-rm -rf $(DIST_DIR)

install: all
	open $(PKG)/.

build: $(PKG) $(ZIP)

$(PKG):
	mkdir -p $(CONTENTS_DIR)
	cp README.md $(PKG)/.
	cp LICENCE $(PKG)/.
	cp -R $(SRC_DIR)/* $(CONTENTS_DIR)/.

$(ZIP):
	mkdir -p $(DIST_DIR)
	zip -r $(DIST_DIR)/$(ZIP) $(PKG)