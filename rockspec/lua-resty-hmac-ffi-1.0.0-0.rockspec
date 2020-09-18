package = 'lua-resty-hmac-ffi'
version = '1.0-0'

source = {
  url = 'git://github.com/jamesmarlowe/lua-resty-hmac',
  tag = 'v1.0'
}

description = {
  summary = 'Lua driver for making and receiving hmac signed requests',
  homepage = 'https://github.com/jamesmarlowe/lua-resty-hmac',
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
