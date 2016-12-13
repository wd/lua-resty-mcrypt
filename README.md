## Name

lua-resty-mcrypt - Mcrypt wrapper for ngx-lua use luajit's ffi api.

## Status

This library only have useed with the 'blowfish' cipher and 'cbc' mode in production(CentOS release 6.4). So more tests needed if you want to use in your environment. Welcome to issue pull request.

## Description

This library requires libmcrypt.so, you can install with `yum install libmcrypt` in CentOS. Also requires LuaJIT.

## Synopsis

```
local mcrypt = require 'resty.mcrypt'
local m = mcrypt:new({cipher = 'blowfish', mode = 'cbc'})
local key = 'DE16DCCC-C890-443A-9367-48107AD7DBA1'
local iv = '1A695BD0-DFD0-41C8-8F06-528910B870D2'
local raw = 'BF1B5128-287B-410F-9455-A20CA01C7FC5'
local encrypted_raw = m:encrypt(iv, key, raw)
local decrypted_raw = m:decrypt(iv, key, encrypted_raw)
print(decrypted_raw == raw)
m:close()
```

## Methods

To load this library,

* you need to specify this library's path in ngx_lua's `lua_package_path` directive. For example, `lua_package_path "/path/to/lua-resty-rsa/lib/?.lua;;";`.
* you use require to load the library into a local Lua variable:

```
local rsa = require "resty.rsa"
```
### new

```
mcrypt:new({cipher = cipher, mode = mode})
```

### encrypt

```
encrypted = m:encrypt(iv, key, raw)
```

### decrypt

```
raw = m:decrypt(iv, key, encrypted)
```

## Test

You can run test file at `t/test.lua`. The test file is just a little lua script.
```
$ /path/to/openresty/luajit/bin/luajit* t/test.lua
```

## Reference links

* https://linux.die.net/man/3/mcrypt
* http://php.net/manual/en/mcrypt.ciphers.php


## TODO

* Do not support stream mode

## Author

Dong Wang(wd) https://wdicc.com

## Copyright and License

This module is licensed under the MIT license.

Copyright (C) 2014-2014, by Dong Wang(wd) https://wdicc.com .

All rights reserved.

* Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
