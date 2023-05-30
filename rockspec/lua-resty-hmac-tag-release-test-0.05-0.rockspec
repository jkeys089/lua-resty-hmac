package = 'lua-resty-hmac-tag-release-test'
version = '0.05-0'

source = {
  url = 'git://github.com/excitedturbofan38/lua-resty-hmac',
  tag = '0.0.2'
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
