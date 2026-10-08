local BASE = "https://raw.githubusercontent.com/toyibah1423-code/StealAnEgg/main/"

local function loadModule(path)
    local source = game:HttpGet(BASE .. path)
    local fn, err = loadstring(source)

    if not fn then
        error("Failed to load " .. path .. ": " .. tostring(err))
    end

    return fn()
end

local Config = loadModule("config.lua")
local UI = loadModule("modules/UI.lua")
local Eggs = loadModule("modules/Eggs.lua")
local Player = loadModule("modules/Player.lua")
local Utilities = loadModule("modules/Utilities.lua")
local Notifications = loadModule("modules/Notifications.lua")

local app = UI:Create({
    Title = Config.Title,
    Version = Config.Version
})

UI:AddTab("Main")
UI:AddTab("Eggs")
UI:AddTab("Player")
UI:AddTab("Settings")

UI:AddToggle("Main", "Auto Collect", false, function(enabled)
    Eggs:SetAutoCollect(enabled)
end)

UI:AddToggle("Main", "Auto Pickup", false, function(enabled)
    Eggs:SetAutoPickup(enabled)
end)

UI:AddToggle("Player", "Flight", false, function(enabled)
    Player:SetFlight(enabled)
end)

UI:AddButton("Eggs", "Refresh Eggs", function()
    Eggs:Refresh()
end)

UI:AddButton("Settings", "Destroy UI", function()
    UI:Destroy()
end)

Notifications:Send(
    "Steal An Egg",
    "Loaded successfully!"
)
