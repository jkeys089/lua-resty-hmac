package = 'lua-resty-hmac-tag-release-test'
version = '0.06-0'

source = {
  url = 'git://github.com/excitedturbofan38/lua-resty-hmac',
  tag = 'v0.06'
}

description = {
  summary = 'This is a test for the luarocks tag releases actions',
  homepage = 'https://github.com/excitedturbofan38/lua-resty-hmac',
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
