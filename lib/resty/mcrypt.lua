local ffi = require 'ffi'
local ffi_new = ffi.new
local ffi_str = ffi.string
local ffi_copy = ffi.copy
local setmetatable = setmetatable

local _M = { _VERSION = '0.01' }
local mt = { __index = _M }

ffi.cdef[[
struct CRYPT_STREAM;
typedef struct CRYPT_STREAM *MCRYPT;

MCRYPT mcrypt_module_open(char *algorithm,
                          char *a_directory, char *mode,
                          char *m_directory);

int mcrypt_generic_init(const MCRYPT td, void *key, int lenofkey,
                        void *IV);

int mcrypt_generic_deinit(const MCRYPT td);
int mcrypt_generic_end(const MCRYPT td);
int mdecrypt_generic(MCRYPT td, void *plaintext, int len);
int mcrypt_generic(MCRYPT td, void *plaintext, int len);
int mcrypt_module_close(MCRYPT td);
int mcrypt_enc_get_iv_size(MCRYPT td);
]]

local mcrypt = ffi.load('mcrypt')

_M.new = function (self, opts)
    local cipher = opts.cipher
    local mode = opts.mode

    local c_cipher = ffi_new("char[?]", #cipher+1, cipher)
    local c_mode = ffi_new("char[?]", #mode+1, mode)

    local td = mcrypt.mcrypt_module_open(c_cipher, nil, c_mode, nil)
    return setmetatable( { _td = td }, mt )
end

_M.get_iv_size = function(self)
    local td = self._td
    return mcrypt.mcrypt_enc_get_iv_size(td)
end

_M.encrypt = function(self, iv, key, raw)
    local td = self._td

    local c_key = ffi_new("char[?]", #key+1, key)
    local c_iv = ffi_new("char[?]", #iv+1, iv)
    local c_raw = ffi_new("char[?]", #raw+1, raw)

    mcrypt.mcrypt_generic_init(td, c_key, #key, c_iv)
    mcrypt.mcrypt_generic(td, c_raw, #raw )
    mcrypt.mcrypt_generic_deinit(td)

    return ffi_str(c_raw, ffi.sizeof(c_raw)-1)
end

_M.decrypt = function(self, iv, key, raw)
    local td = self._td

    local c_key = ffi_new("char[?]", #key+1, key)
    local c_iv = ffi_new("char[?]", #iv+1, iv)
    local c_raw = ffi_new("char[?]", #raw+1, raw)

    mcrypt.mcrypt_generic_init(td, c_key, #key, c_iv)
    mcrypt.mdecrypt_generic(td, c_raw, #raw )
    mcrypt.mcrypt_generic_deinit(td)

    return ffi_str(c_raw, ffi.sizeof(c_raw)-1)
end

_M.close = function(self)
    local td = self._td
    if td then
        mcrypt.mcrypt_module_close(td)
     end
end

return _M
