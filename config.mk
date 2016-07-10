TARG=/srv/sssg
#TARG=_site
SITE=http://sssg.pickfire.wha.la/
#-# Needed for other scripts

POSTS = $(shell find -type f -name '*.md')
MENUS = $(wildcard [0-9]*.* index.*)
FEEDS = $(patsubst %, %atom.xml, $(dir $(POSTS)))
EXTRA = $(shell find -name '*.png' -o -name '*.jpg' -o -name '*.gif') $(wildcard css/*.css)
PAGES = $(POSTS) $(MENUS)
