local Eggs = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local player = Players.LocalPlayer

local autoCollect = false
local autoPickup = false

local function getRemotes()
    local folder = ReplicatedStorage:FindFirstChild("EggRemotes")
    if not folder then
        return nil
    end

    return {
        StealEgg = folder:FindFirstChild("StealEgg"),
        DropEgg = folder:FindFirstChild("DropEgg")
    }
end

local function getEggs()
    local result = {}

    for _, egg in ipairs(CollectionService:GetTagged("StealableEgg")) do
        if egg:IsDescendantOf(workspace) then
            table.insert(result, egg)
        end
    end

    return result
end

function Eggs:Refresh()
    local eggs = getEggs()

    print("[Eggs] Found:", #eggs)

    return eggs
end

function Eggs:SetAutoCollect(enabled)
    autoCollect = enabled

    print("[Eggs] Auto Collect:", enabled)

    if not enabled then
        return
    end

    task.spawn(function()
        while autoCollect do
            local remotes = getRemotes()

            if remotes and remotes.StealEgg then
                local character = player.Character
                local root = character
                    and character:FindFirstChild("HumanoidRootPart")

                if root then
                    for _, egg in ipairs(getEggs()) do
                        if not autoCollect then
                            break
                        end

                        local primary = egg.PrimaryPart

                        if primary then
                            local distance =
                                (root.Position - primary.Position).Magnitude

                            if distance <= 10
                                and not egg:GetAttribute("Carrier") then

                                remotes.StealEgg:FireServer(egg)

                                task.wait(0.25)
                            end
                        end
                    end
                end
            end

            task.wait(1)
        end
    end)
end

function Eggs:SetAutoPickup(enabled)
    autoPickup = enabled

    print("[Eggs] Auto Pickup:", enabled)

    if not enabled then
        return
    end

    task.spawn(function()
        while autoPickup do
            local character = player.Character
            local root = character
                and character:FindFirstChild("HumanoidRootPart")

            if root then
                for _, egg in ipairs(getEggs()) do
                    if not autoPickup then
                        break
                    end

                    local primary = egg.PrimaryPart

                    if primary then
                        local distance =
                            (root.Position - primary.Position).Magnitude

                        if distance <= 8 then
                            print("[Eggs] Nearby egg:", egg:GetFullName())
                        end
                    end
                end
            end

            task.wait(0.5)
        end
    end)
end

function Eggs:IsAutoCollectEnabled()
    return autoCollect
end

function Eggs:IsAutoPickupEnabled()
    return autoPickup
end

return Eggs
