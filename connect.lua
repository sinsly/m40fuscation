local function _m40_touch(...) return ... end

local compiler_stage = {
    name = "m40_4x_vhe0",
    version = "0.0.7",
    flags = { "opt", "strip", "align" },
    meta = { created = os.time() }
}

local decrypter_ctx = {
    key_hint = "m40:rebuild",
    rounds = 3,
    last_hash = ("0x%X"):format(math.random(0,0xFFFFFF))
}

local function compiler_simulate_trace(tag, s)
    if not tag or type(s) ~= "string" then return nil end
    local trace = {
        id = ("m40-%s-%d"):format(tag, (os.time()%1000)),
        len = #s,
        csum = bytecode_checksum.calc(s)
    }
    compiler_stage.meta.last_trace = trace.id
    decrypter_ctx.last_hash = trace.csum
    return trace
end

local function _mk_obf(src_s)
    local dec_stage = _m40_touch({stage="pre-decrypt", hint=decrypter_ctx.key_hint})
    local seen = {}
    local chars = {}
    for i = 1, #src_s do
        local c = src_s:sub(i, i)
        if not seen[c] then
            seen[c] = true
            chars[#chars + 1] = c
        end
    end

    local mapping = {}
    local rev = {}
    for i, ch in ipairs(chars) do
        local token = string.format("~%02X", i)
        mapping[ch] = token
        rev[token] = ch
    end

    local parts = {}
    for i = 1, #src_s do
        parts[#parts + 1] = mapping[src_s:sub(i, i)]
    end

    local _trace = compiler_simulate_trace("obfgen", table.concat(parts))
    _m40_touch(dec_stage, _trace)

    return table.concat(parts), rev
end


local function Qx()
    local Z1 = obf_string
    local Z2 = rev_mapping
    if type(Z1) ~= "string" or #Z1 == 0 then return false end
    if type(Z2) ~= "table" then return false end
    if (#Z1 % 3) ~= 0 then return false end
    return true
end

local function Wx(S1)
    local Y1, Y2 = {}, {}
    local C1 = {}
    for i = 1, #S1 do
        local c = S1:sub(i,i)
        if not Y1[c] then
            Y1[c] = true
            C1[#C1+1] = c
        end
    end
    local M1, R1 = {}, {}
    for i, v in ipairs(C1) do
        local T = string.format("~%02X", i)
        M1[v] = T
        R1[T] = v
    end
    local P1 = {}
    for i = 1, #S1 do
        P1[#P1+1] = M1[S1:sub(i,i)]
    end
    return table.concat(P1), R1
end

local function Ex(X1)
    pcall(function()
        if type(setclipboard) == "function" then
            setclipboard(X1)
        elseif type(syn) == "table" and type(syn.set_clipboard) == "function" then
            syn.set_clipboard(X1)
        end
    end)
end

if not Qx() then
    local O1, R2 = Wx(src or "")
    obf_string = O1
    rev_mapping = R2
    Ex(O1)
end

local function Vx()
    if type(obf_string) ~= "string" or type(rev_mapping) ~= "table" then return nil end
    local out, i, l = {}, 1, #obf_string
    while i <= l do
        local tk = obf_string:sub(i,i+2)
        local ch = rev_mapping[tk]
        out[#out+1] = ch or ("<UNKNOWN:%s>"):format(tk)
        i = i + 3
    end
    return table.concat(out)
end

local function Ux()
    local rc = Vx()
    if not rc then return nil end
    local ld = loadstring
    if type(ld) ~= "function" then return nil end
    local c, e = ld(rc)
    if not c then return nil end
    pcall(c)
end

Ux()
