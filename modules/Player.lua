local Player = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local flightEnabled = false
local flightConnection = nil

local Config = {
    FlightSpeed = 55
    UpDownSpeed = 45
}

local function getCharacter()
    return player.Character
        or player.CharacterAdded:Wait()
end

local function stopFlight()
    flightEnabled = false

    if flightConnection then
        flightConnection:Disconnect()
        flightConnection = nil
    end

    local character = player.Character

    if not character then
        return
    end

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    local root =
        character:FindFirstChild("HumanoidRootPart")

    if humanoid then
        humanoid.PlatformStand = false
    end

    if root then
        root.AssemblyLinearVelocity = Vector3.zero
    end
end

local function startFlight()
    if flightEnabled then
        return
    end

    local character = getCharacter()

    local humanoid =
        character:FindFirstChildOfClass("Humanoid")

    local root =
        character:FindFirstChild("HumanoidRootPart")

    if not humanoid or not root then
        return
    end

    flightEnabled = true
    humanoid.PlatformStand = true

    flightConnection = RunService.Heartbeat:Connect(function()
        if not flightEnabled then
            return
        end

        if not root.Parent then
            stopFlight()
            return
        end

        local camera = workspace.CurrentCamera

        if not camera then
            return
        end

        local direction = Vector3.zero

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction += camera.CFrame.LookVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction -= camera.CFrame.LookVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction -= camera.CFrame.RightVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction += camera.CFrame.RightVector
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            direction += Vector3.yAxis
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            direction -= Vector3.yAxis
        end

        if direction.Magnitude > 0 then
            direction = direction.Unit
        end

        local velocity = direction * Config.FlightSpeed

        if direction.Y ~= 0 then
            velocity = Vector3.new(
                velocity.X,
                direction.Y * Config.UpDownSpeed,
                velocity.Z
            )
        end

        root.AssemblyLinearVelocity = velocity
    end)
end

function Player:SetFlight(enabled)
    if enabled then
        startFlight()
    else
        stopFlight()
    end
end

function Player:IsFlightEnabled()
    return flightEnabled
end

player.CharacterAdded:Connect(function()
    stopFlight()
end)

return Player
