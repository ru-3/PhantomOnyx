local Config = {
    Debug = false,
    Placeholder = "Unknown",
    DefaultMode = "Fake",
    Modes = {
        JobId = "Real",
        PlaceId = "Real",
        ServerType = "Real",
        HWID = "Real",
        Ping = "Real",
        DeviceType = "Real",
        ScreenResolution = "Real",
        RobloxVersion = "Real",
        ScriptStartTime = "Real",
    },
}

local FakeData = {
    Username = "ShadowPlayer482",
    DisplayName = "Shadow",
    UserId = 2847195631,

    AccountCreationDate = "2019-08-17",
    AccountAge = 2606,

    IPAddress = "104.28.214.67",
    Country = "Saudi Arabia",
    Region = "Riyadh",
    ISP = "Saudi Telecom Company",
    Timezone = "Asia/Riyadh",

    VPN = false,
    Proxy = false,

    Ping = 42,

    Executor = "Delta",
    RobloxVersion = "version-690",

    ScreenResolution = "1920x1080",
    DeviceType = "PC",

    ServerType = "Public",
    PlaceId = 9876543210,
    JobId = "7f4c9a2e-83d1-4b6a-91e7-52c8f0a34d19",

    ClientId = "a91f73c8-4e52-47bd-9f16-82c4d7e31a05",
    SessionId = "c4e8b2a6-1d37-4f90-a5b8-6e2d9c71f043",
    HWID = "HWID-8F2A91C7D46E03B5",

    ScriptStartTime = "2026-10-05 19:30:00",
}

local GlobalHooks = {
    { Global = "identifyexecutor", Field = "Executor" },
    { Global = "getexecutorname", Field = "Executor" },
    { Global = "gethwid", Field = "HWID" },
    { Global = "get_hwid", Field = "HWID" },
}

local NamecallHooks = {
    GetClientId = "ClientId",
    GetSessionId = "SessionId",
}

local env = getgenv and getgenv() or _G

if type(env.PrivacyShieldCleanup) == "function" then
    pcall(env.PrivacyShieldCleanup)
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Analytics = game:GetService("RbxAnalyticsService")
local startTime = os.time()

local PrivacyShield = {}
local restore = {}
local originals = {}
local requests = {}
local validModes = { real = "Real", fake = "Fake", hidden = "Hidden" }

local Live = {
    Username = function()
        return Players.LocalPlayer.Name
    end,
    DisplayName = function()
        return Players.LocalPlayer.DisplayName
    end,
    UserId = function()
        return Players.LocalPlayer.UserId
    end,
    AccountAge = function()
        return Players.LocalPlayer.AccountAge
    end,
    AccountCreationDate = function()
        return os.date("%Y-%m-%d", os.time() - Players.LocalPlayer.AccountAge * 86400)
    end,
    Timezone = function()
        local offset = os.date("%z")
        return "UTC" .. string.sub(offset, 1, 3) .. ":" .. string.sub(offset, 4, 5)
    end,
    Ping = function()
        return math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
    end,
    Executor = function()
        return (assert(originals.identifyexecutor or originals.getexecutorname)())
    end,
    RobloxVersion = function()
        return version()
    end,
    ScreenResolution = function()
        local size = workspace.CurrentCamera.ViewportSize
        return math.floor(size.X) .. "x" .. math.floor(size.Y)
    end,
    DeviceType = function()
        local uis = UserInputService
        if uis.TouchEnabled and not uis.KeyboardEnabled then
            return "Mobile"
        end
        if uis.GamepadEnabled and not uis.KeyboardEnabled then
            return "Console"
        end
        return "PC"
    end,
    ServerType = function()
        if game.PrivateServerId == "" then
            return "Public"
        end
        return game.PrivateServerOwnerId ~= 0 and "VIP" or "Reserved"
    end,
    PlaceId = function()
        return game.PlaceId
    end,
    JobId = function()
        return game.JobId
    end,
    ClientId = function()
        return Analytics:GetClientId()
    end,
    SessionId = function()
        return Analytics:GetSessionId()
    end,
    HWID = function()
        return (assert(originals.gethwid or originals.get_hwid)())
    end,
    ScriptStartTime = function()
        return os.date("%Y-%m-%d %H:%M:%S", startTime)
    end,
}

local function normalize(name)
    return (string.lower((string.gsub(tostring(name), "[^%w]", ""))))
end

local function lookup(tbl, name)
    local target = normalize(name)
    for key, value in pairs(tbl) do
        if normalize(key) == target then
            return key, value
        end
    end
    return nil
end

local function findKey(name)
    return (lookup(FakeData, name)) or (lookup(Live, name))
end

local function modeOf(key)
    local _, mode = lookup(Config.Modes, key)
    return string.lower(tostring(mode or Config.DefaultMode))
end

local function track(key)
    requests[key] = (requests[key] or 0) + 1
    if Config.Debug then
        print("[PrivacyShield] requested: " .. key .. " (" .. modeOf(key) .. ")")
    end
end

local function resolve(key)
    local mode = modeOf(key)
    if mode == "hidden" then
        return Config.Placeholder
    end
    if mode == "real" and Live[key] then
        local ok, value = pcall(Live[key])
        if ok and value ~= nil then
            return value
        end
    end
    local fake = FakeData[key]
    if fake == nil then
        return Config.Placeholder
    end
    return fake
end

function PrivacyShield:Get(name)
    local key = findKey(name)
    if key == nil then
        if Config.Debug then
            print("[PrivacyShield] requested: " .. tostring(name) .. " (unconfigured)")
        end
        return Config.Placeholder
    end
    track(key)
    return resolve(key)
end

function PrivacyShield:Set(name, value)
    FakeData[findKey(name) or tostring(name)] = value
end

function PrivacyShield:Remove(name)
    local key = lookup(FakeData, name)
    if key then
        FakeData[key] = nil
    end
end

function PrivacyShield:Has(name)
    return findKey(name) ~= nil
end

function PrivacyShield:SetMode(name, mode)
    local normalized = validModes[string.lower(tostring(mode))]
    if not normalized then
        return false
    end
    local key = findKey(name) or tostring(name)
    Config.Modes[lookup(Config.Modes, key) or key] = normalized
    return true
end

function PrivacyShield:GetMode(name)
    return validModes[modeOf(findKey(name) or tostring(name))]
end

function PrivacyShield:GetAll()
    local out = {}
    for key in pairs(FakeData) do
        out[key] = resolve(key)
    end
    for key in pairs(Live) do
        if out[key] == nil then
            out[key] = resolve(key)
        end
    end
    return out
end

function PrivacyShield:GetRequests()
    local copy = {}
    for key, count in pairs(requests) do
        copy[key] = count
    end
    return copy
end

local function protect(fn)
    if newcclosure then
        return newcclosure(fn)
    end
    return fn
end

local function wrapGlobal(entry)
    local original = env[entry.Global]
    if type(original) ~= "function" then
        return
    end
    originals[entry.Global] = original
    local wrapper = protect(function(...)
        if modeOf(entry.Field) == "real" then
            track(entry.Field)
            return original(...)
        end
        return PrivacyShield:Get(entry.Field)
    end)
    env[entry.Global] = wrapper
    table.insert(restore, function()
        if env[entry.Global] == wrapper then
            env[entry.Global] = original
        end
    end)
end

local function hookNamecall()
    if not (hookmetamethod and getnamecallmethod) then
        return
    end
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", protect(function(self, ...)
        if self == Analytics then
            local field = NamecallHooks[getnamecallmethod()]
            if field then
                if modeOf(field) == "real" then
                    track(field)
                    return oldNamecall(self, ...)
                end
                return PrivacyShield:Get(field)
            end
        end
        return oldNamecall(self, ...)
    end))
    table.insert(restore, function()
        hookmetamethod(game, "__namecall", oldNamecall)
    end)
end

for _, entry in ipairs(GlobalHooks) do
    pcall(wrapGlobal, entry)
end
pcall(hookNamecall)

local function cleanup()
    for i = #restore, 1, -1 do
        pcall(restore[i])
    end
    table.clear(restore)
    table.clear(originals)
    env.PrivacyShieldCleanup = nil
    env.PrivacyShield = nil
end

env.PrivacyShieldCleanup = cleanup
env.PrivacyShield = PrivacyShield

return PrivacyShield
