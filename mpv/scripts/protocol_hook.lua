-- protocol_hook_youtube.lua

local msg = require "mp.msg"

-- ===== Base64 decode (keep only what we need) =====
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local function dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do
            r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0')
        end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do
            c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0)
        end
        return string.char(c)
    end))
end

local function atobUrl(url)
    url = url:gsub('_', '/')
    url = url:gsub('-', '+')
    return dec(url)
end

-- ===== Query string parser =====
local function parseqs(url)
    local query = url:match("%?.+") 
    if not query then return {} end

    local args = {}
    for arg, param in query:gmatch("(%w+)=([^&]+)") do
        args[arg] = param
    end
    return args
end

-- ===== Playlist link validation =====
local function is_supported(url)
    return url:find("youtube.com") or url:find("youtu.be") or url:match("m3u8") or url:match("m3u$")
end

-- ===== Main hook =====
mp.add_hook("on_load", 1, function()
    local raw = mp.get_property("stream-open-filename", "")

    if not raw:find("^mpv://") then
        return
    end

    msg.info("Protocol hook triggered: " .. raw)

    -- Split mpv://play/<encoded>
    local parts = {}
    for p in raw:gmatch("[^/]+") do
        table.insert(parts, p)
    end

    if parts[2] ~= "play" then
        msg.warn("Only mpv://play supported")
        return
    end

    local encoded = parts[3]
    if not encoded then
        msg.error("Missing encoded URL")
        return
    end

    local url = atobUrl(encoded)
    local qs = parseqs(raw)

    msg.info("Decoded URL: " .. url)

    -- -- Only allow YouTube
    if not is_supported(url) then
        msg.error(string.format("url: %s is not supported", url))
        return
    end

    -- Apply referer if provided
    if qs["referer"] then
        local referer = atobUrl(qs["referer"])
        mp.set_property("http-header-fields", "Referer: " .. referer)
        msg.info("Referer set: " .. referer)
    end

    -- Replace current load with actual URL
    mp.commandv("loadfile", url, "replace")
end)