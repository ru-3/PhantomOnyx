local Core = loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumLibrary/refs/heads/main/Core.lua"))()
local JsonEncode = Core.JsonEncode
local JsonDecode = Core.JsonDecode
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local SaveSystem = {
    FolderName = "Quantum Onyx Hub",
    Settings = {}
}

SaveSystem._Keys = {}

function SaveSystem:RegisterKey(key)
    self._Keys[key] = true
end

function SaveSystem:PruneStaleKeys()
    if not next(self._Keys) then return end
    local changed = false
    for k in pairs(self.Settings) do
        if k:sub(1, 1) ~= "_" and not self._Keys[k] then
            self.Settings[k] = nil
            changed = true
        end
    end
    local slots = self:Get("_saveSlots", {})
    local SlotChanged = false
    for _,v in ipairs(slots) do
        if v.data then
            for k in pairs(v.data) do
                if not self._Keys[k] then
                    v.data[k] = nil
                    SlotChanged = true
                end
            end
        end
    end
    if changed then self:Save() end
    if SlotChanged then self:Save("_saveSlots", slots) end
end
local _fileName = nil

function SaveSystem:GetFileName()
    if not _fileName then
        _fileName = LocalPlayer.Name .. "-" .. tostring(game.GameId) .. ".json"
    end
    return _fileName
end

function SaveSystem:Save(key, value)
    if key ~= nil then self.Settings[key] = value end
    if not isfolder(self.FolderName) then makefolder(self.FolderName) end
    pcall(writefile, self.FolderName .. "/" .. self:GetFileName(), JsonEncode(self.Settings))
end

function SaveSystem:Load()
    if not isfolder(self.FolderName) then makefolder(self.FolderName) end
    local i, v = pcall(function()
        return JsonDecode(readfile(self.FolderName .. "/" .. self:GetFileName()))
    end)
    if i and type(v) == "table" then
        self.Settings = v
        return v
    end
    self:Save()
    return {}
end

function SaveSystem:Get(key, default)
    local val = self.Settings[key]
    return val ~= nil and val or default
end

function SaveSystem:ElementSave(key, value)
    self:Save(key, value)
    if not (self.IsAutoSave and self.IsAutoSave()) then return end
    local slots = self:Get("_saveSlots", {})
    local Index = nil
    for i, s in ipairs(slots) do
        if s.name == "[Auto]" then
            Index = i
            break
        end
    end
    local Snapshot = {}
    for k, v in pairs(self.Settings) do
        if k:sub(1, 1) ~= "_" and self._Keys[k] then
            Snapshot[k] = v
        end
    end
    if Index then
        slots[Index].data = Snapshot
    else
        table.insert(slots, 1, {name = "[Auto]", data = Snapshot})
    end
    self:Save("_saveSlots", slots)
end

function SaveSystem:ClearAll()
    self.Settings = {}
    if isfolder(self.FolderName) then
        pcall(writefile, self.FolderName .. "/" .. self:GetFileName(), "{}")
    end
end

SaveSystem:Load()

return SaveSystem
