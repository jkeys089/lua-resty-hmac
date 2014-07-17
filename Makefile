OPENRESTY_PREFIX=/usr/local/openresty

PREFIX ?=          /usr/local/openresty
LUA_LIB_DIR ?=     $(PREFIX)/ext_lualib
INSTALL ?= install

.PHONY: all test install

all: ;

install: all
	$(INSTALL) -d $(LUA_LIB_DIR)/resty
	$(INSTALL) lib/resty/*.lua $(LUA_LIB_DIR)/resty

test: all
	PATH=$(OPENRESTY_PREFIX)/nginx/sbin:$$PATH prove -I../test-nginx/lib -r t

