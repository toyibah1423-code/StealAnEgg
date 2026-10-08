local Notifications = {}

local StarterGui = game:GetService("StarterGui")

function Notifications:Send(title, message, duration)
    duration = duration or 3

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = tostring(title),
            Text = tostring(message),
            Duration = duration
        })
    end)

    print("[Notification] " .. tostring(title) .. ": " .. tostring(message))
end

return Notifications
