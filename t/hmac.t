# vi:ft=

use Test::Nginx::Socket::Lua;

repeat_each(2);

plan tests => repeat_each() * (3 * blocks());

no_long_string();

run_tests();

__DATA__

=== TEST 1: Hello HMAC-SHA1
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            local hmac = require "resty.hmac"
            local str = require "resty.string"
            local hmac_sha1 = hmac:new("secret_key", hmac.ALGOS.SHA1)
            ngx.say(hmac_sha1:update("hello"))
            local mac = hmac_sha1:final()
            ngx.say(mac == ngx.hmac_sha1("secret_key", "hello"))
            ngx.say("hmac-sha1: ", str.to_hex(mac))
        ';
    }
--- request
GET /t
--- response_body
true
true
hmac-sha1: aee4b890b574ea8fa4f6a66aed96c3e590e5925a
--- no_error_log
[error]



=== TEST 2: HMAC-SHA1 incremental
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            local hmac = require "resty.hmac"
            local str = require "resty.string"
            local hmac_sha1 = hmac:new("test123", hmac.ALGOS.SHA1)
            ngx.say(hmac_sha1:update("hel"))
            ngx.say(hmac_sha1:update("lo"))
            local mac = hmac_sha1:final()
            ngx.say("hmac-sha1: ", str.to_hex(mac))
        ';
    }
--- request
GET /t
--- response_body
true
true
hmac-sha1: f1e6301275f5929edf0cf6451c6fc4a2b46df5f5
--- no_error_log
[error]



=== TEST 3: HMAC-SHA1 empty string
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            local hmac = require "resty.hmac"
            local str = require "resty.string"
            local hmac_sha1 = hmac:new("not4u", hmac.ALGOS.SHA1)
            ngx.say(hmac_sha1:update(""))
            local mac = hmac_sha1:final()
            ngx.say(mac == ngx.hmac_sha1("not4u", ""))
            ngx.say("hmac-sha1: ", str.to_hex(mac))
        ';
    }
--- request
GET /t
--- response_body
true
true
hmac-sha1: f97e3c6f613bbe9b39c8d8ffc2b27e2a5c9d7783
--- no_error_log
[error]



=== TEST 4: HMAC-SHA1 Short binary output
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            local hmac = require "resty.hmac"
            local str = require "resty.string"
            local hmac_sha1 = hmac:new("secret_key", hmac.ALGOS.SHA1)
            local mac = hmac_sha1:final("hello")
            ngx.say(mac == ngx.hmac_sha1("secret_key", "hello"))
            ngx.say("hmac-sha1: ", str.to_hex(mac))
        ';
    }
--- request
GET /t
--- response_body
true
hmac-sha1: aee4b890b574ea8fa4f6a66aed96c3e590e5925a
--- no_error_log
[error]



=== TEST 5: HMAC-SHA1 Short hex output
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            local hmac = require "resty.hmac"
            local str = require "resty.string"
            local hmac_sha1 = hmac:new("secret_key", hmac.ALGOS.SHA1)
            local mac_hex = hmac_sha1:final("hello", true)
            ngx.say(mac_hex == str.to_hex(ngx.hmac_sha1("secret_key", "hello")))
            ngx.say("hmac-sha1: ", mac_hex)
        ';
    }
--- request
GET /t
--- response_body
true
hmac-sha1: aee4b890b574ea8fa4f6a66aed96c3e590e5925a
--- no_error_log
[error]



=== TEST 6: HMAC-SHA1 Reset and re-use
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            local hmac = require "resty.hmac"
            local str = require "resty.string"
            local hmac_sha1 = hmac:new("secret_key", hmac.ALGOS.SHA1)
            ngx.say("hmac-sha1: ", hmac_sha1:final("hello", true))
            hmac_sha1:reset()
            local reset_hex = hmac_sha1:final("world", true)
            ngx.say(reset_hex == str.to_hex(ngx.hmac_sha1("secret_key", "world")))
            ngx.say("hmac-sha1: ", reset_hex)
        ';
    }
--- request
GET /t
--- response_body
hmac-sha1: aee4b890b574ea8fa4f6a66aed96c3e590e5925a
true
hmac-sha1: 4e9538f1efbe565c522acfb72fce6092ea6b15e0
--- no_error_log
[error]



=== TEST 7: Hello HMAC-SHA256
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            local hmac = require "resty.hmac"
            local hmac_sha256 = hmac:new("~@!$%^_", hmac.ALGOS.SHA256)
            ngx.say(hmac_sha256:update("hello, "))
            ngx.say(hmac_sha256:update("world"))
            ngx.say("hmac-sha256: ", hmac_sha256:final("!", true))
        ';
    }
--- request
GET /t
--- response_body
true
true
hmac-sha256: a9e4d61409ac1aceaa0fd825df76d664461bbdb93bb6fea65a285cd9240c4a1b
--- no_error_log
[error]



=== TEST 8: Hello HMAC-SHA512
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            local hmac = require "resty.hmac"
            local hmac_sha512 = hmac:new("小猫", hmac.ALGOS.SHA512)
            ngx.say(hmac_sha512:update("小狗"))
            ngx.say("hmac-sha512: ", hmac_sha512:final(_, true))
            ngx.say(hmac_sha512:reset())
            ngx.say("hmac-sha512: ", hmac_sha512:final("猴子", true))
        ';
    }
--- request
GET /t
--- response_body
true
hmac-sha512: a1f52b55635c9a6a945d6d98183744e16981455010850a4de06509cb91d506b26f1d710120eeea0348933cd0516a7e4d8f6b0f9da1281b2fd9dc8716d5c0ca71
true
hmac-sha512: e0ec96ca2b700643ea62916bb42923f2535dc3894aa30d9654333d51613b7fb48149ce6a01bc7efb257ddcd1994e8e7a71ada5df7fd44b391cf130ce9b53ebf0
--- no_error_log
[error]



=== TEST 9: Hello HMAC-MD5
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            local hmac = require "resty.hmac"
            local str = require "resty.string"
            local hmac_md5 = hmac:new("reeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeely long key", hmac.ALGOS.MD5)
            ngx.say(hmac_md5:update("hmac ftw!!!"))
            local mac = hmac_md5:final()
            ngx.say("hmac-md5: ", str.to_hex(mac))
        ';
    }
--- request
GET /t
--- response_body
true
hmac-md5: 80f9a1bc99575c2430fe04c982cf5700
--- no_error_log
[error]



=== TEST 10: Hello HMAC-MD5 Default
--- http_config eval: $::HttpConfig
--- config
    location /t {
        content_by_lua '
            local hmac = require "resty.hmac"
            local str = require "resty.string"
            local hmac_default = hmac:new("reeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeely long key")
            ngx.say(hmac_default:update("hmac ftw!!!"))
            local mac = hmac_default:final()
            ngx.say("hmac-default: ", str.to_hex(mac))
        ';
    }
--- request
GET /t
--- response_body
true
hmac-default: 80f9a1bc99575c2430fe04c982cf5700
--- no_error_log
[error]