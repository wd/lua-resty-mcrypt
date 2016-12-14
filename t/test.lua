local mcrypt = require 'lib.resty.mcrypt'
modes = {'ecb', 'cbc', 'cfb', 'ofb', 'nofb', 'ncfb', 'ctr'}
ciphers = {'des', '3des', 'cast-128', 'cast-256', 'xtea', '3-way', 'skipjack', 'blowfish', 'twofish', 'loki97', 'rc2', 'arcfour', 'rc6', 'rijndael', 'mars', 'panama', 'wake', 'serpent', 'idea', 'enigma', 'gost', 'safer', 'safer+'}

math.randomseed(tostring(os.time()):reverse():sub(1, 6))
local get_random_char = function(len)
    local len = len or 1
    local res = ''
    for i=1,len do
        local idx = math.random(21, 126) -- All visable chars
        res = res .. string.char(idx)
    end
    return res
end

local do_test = function(cipher, mode)
    local m = mcrypt:new({cipher = 'blowfish', mode = mode})
    print("test for cipher: " .. cipher .. ", mode: " .. mode .. ", iv_size: " .. m:get_iv_size())
    local raw = get_random_char(math.random(10, 20))
    local iv = get_random_char(math.random(8, 16))
    local key = get_random_char(math.random(8, 16))
    for i=1,100,1 do
        raw = raw .. get_random_char()
        local encrypted_string = m:encrypt(iv, key, raw)
        local decrypted_string = m:decrypt(iv, key, encrypted_string)
        if decrypted_string ~= raw then
            print('failed :' .. decrypted_string == raw)
            break
        end
    end
    m:close()
end

for k=1,#ciphers,1 do
    cipher = ciphers[k]
    for j=1,#modes,1 do
        local mode = modes[j]
        do_test(cipher, mode)
    end
end
