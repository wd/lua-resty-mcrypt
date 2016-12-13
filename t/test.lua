local mcrypt = require 'lib.resty.mcrypt'
modes = {'ecb', 'cbc', 'cfb', 'ofb', 'nofb', 'ncfb', 'ctr'}
ciphers = {'des', '3des', 'cast-128', 'cast-256', 'xtea', '3-way', 'skipjack', 'blowfish', 'twofish', 'loki97', 'rc2', 'arcfour', 'rc6', 'rijndael', 'mars', 'panama', 'wake', 'serpent', 'idea', 'enigma', 'gost', 'safer', 'safer+'}

local do_test = function(cipher, mode)
        local m = mcrypt:new({cipher = 'blowfish', mode = mode})
        print("test for cipher: " .. cipher .. ", mode: " .. mode .. ", iv_size: " .. m:get_iv_size())
        local raw = '504A-4C92-9E73-EBA2D97331B6'
        local iv = '9297AAFFFsSDwefsdf'
        local key = 'F4504D20-076A-4AF7-BFFE-616E8440E842'
        for i=1,100,1 do
            raw = raw .. i
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
