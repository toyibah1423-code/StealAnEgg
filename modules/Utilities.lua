local Utilities = {}

function Utilities:GetCharacter(player)
    if not player then
        return nil
    end

    return player.Character
        or player.CharacterAdded:Wait()
end

function Utilities:GetRoot(player)
    local character = self:GetCharacter(player)

    if not character then
        return nil
    end

    return character:FindFirstChild("HumanoidRootPart")
end

function Utilities:GetHumanoid(player)
    local character = self:GetCharacter(player)

    if not character then
        return nil
    end

    return character:FindFirstChildOfClass("Humanoid")
end

function Utilities:Distance(part1, part2)
    if not part1 or not part2 then
        return math.huge
    end

    return (part1.Position - part2.Position).Magnitude
end

function Utilities:IsAlive(player)
    local humanoid = self:GetHumanoid(player)

    return humanoid ~= nil
        and humanoid.Health > 0
end

function Utilities:Notify(message)
    print("[Steal An Egg] " .. tostring(message))
end

return Utilities
