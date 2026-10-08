local BASE =
    "https://raw.githubusercontent.com/toyibah1423-code/StealAnEgg/main/"

local function loadModule(path)
    local ok, source = pcall(function()
        return game:HttpGet(BASE .. path)
    end)

    if not ok then
        error("Gagal mengambil " .. path .. "\n" .. tostring(source))
    end

    local fn, err = loadstring(source)

    if not fn then
        error("Gagal compile " .. path .. "\n" .. tostring(err))
    end

    local success, result = pcall(fn)

    if not success then
        error("Gagal menjalankan " .. path .. "\n" .. tostring(result))
    end

    return result
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

app:AddTab("Main")
app:AddTab("Eggs")
app:AddTab("Player")
app:AddTab("Settings")

app:AddToggle(
    "Main",
    "Auto Collect",
    false,
    function(enabled)
        Eggs:SetAutoCollect(enabled)
    end
)

app:AddToggle(
    "Main",
    "Auto Pickup",
    false,
    function(enabled)
        Eggs:SetAutoPickup(enabled)
    end
)

app:AddToggle(
    "Player",
    "Flight",
    false,
    function(enabled)
        Player:SetFlight(enabled)
    end
)

app:AddButton(
    "Eggs",
    "Refresh Eggs",
    function()
        local eggs = Eggs:Refresh()

        Notifications:Send(
            "Eggs",
            "Found " .. tostring(#eggs) .. " egg(s)."
        )
    end
)

app:AddButton(
    "Settings",
    "Destroy UI",
    function()
        app:Destroy()
    end
)

Notifications:Send(
    "Steal An Egg",
    "Loaded successfully!"
)
