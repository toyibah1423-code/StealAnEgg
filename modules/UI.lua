local UI = {}

function UI:Create(options)
    local player = game:GetService("Players").LocalPlayer
    local gui = Instance.new("ScreenGui")

    gui.Name = "StealAnEggUI"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(340, 260)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.BackgroundTransparency = 1
    title.Text = options.Title .. "  v" .. options.Version
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    self.Gui = gui
    self.Frame = frame

    return self
end

function UI:AddTab(name)
    print("Tab:", name)
end

function UI:AddToggle(tab, name, default, callback)
    print("Toggle:", tab, name)

    if callback then
        callback(default)
    end
end

function UI:AddButton(tab, name, callback)
    print("Button:", tab, name)
end

function UI:Destroy()
    if self.Gui then
        self.Gui:Destroy()
        self.Gui = nil
    end
end

return UI
