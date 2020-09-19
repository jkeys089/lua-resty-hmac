package = 'lua-resty-hmac-ffi'
version = '0.05-0'

source = {
  url = 'git://github.com/jkeys089/lua-resty-hmac',
  tag = 'v0.05'
}

description = {
  summary = 'HMAC functions for ngx_lua and LuaJIT',
  homepage = 'https://github.com/jkeys089/lua-resty-hmac',
  license = 'BSD-2-Clause License'
}

dependencies = {
  'lua == 5.1'
}

build = {
  type = 'builtin',
  modules = {
    ['resty.hmac'] = 'lib/resty/hmac.lua'
  }
}
