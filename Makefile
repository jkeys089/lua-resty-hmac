PREFIX		?= /usr/local/openresty
LUA_LIB_DIR	?= $(PREFIX)/lualib
INSTALL		?= install
VALGRIND	?= 0
CHECK_LEAK	?= 0
MODULES		?=

.PHONY: all test install

all:
	@$(INSTALL) -d resty_modules/lualib/resty
	@test -f resty_modules/lualib/resty/string.lua || curl -s -o resty_modules/lualib/resty/string.lua https://raw.githubusercontent.com/openresty/lua-resty-string/master/lib/resty/string.lua

install: all
	$(INSTALL) -d $(LUA_LIB_DIR)/resty
	$(INSTALL) resty_modules/lualib/resty/*.lua $(LUA_LIB_DIR)/resty
	$(INSTALL) lib/resty/*.lua $(LUA_LIB_DIR)/resty

test: install
	LUA_PATH="$(LUA_LIB_DIR)/?.lua;;" TEST_NGINX_USE_VALGRIND=$(VALGRIND) TEST_NGINX_CHECK_LEAK=$(CHECK_LEAK) TEST_NGINX_LOAD_MODULES="$(MODULES)" prove -I../test-nginx/lib -r t
