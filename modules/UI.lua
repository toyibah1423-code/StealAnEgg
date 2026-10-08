local UI = {}

local UserInputService = game:GetService("UserInputService")

function UI:Create(options)
    local player = game:GetService("Players").LocalPlayer

    local oldGui = player.PlayerGui:FindFirstChild("StealAnEggUI")
    if oldGui then
        oldGui:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "StealAnEggUI"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(380, 300)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -50, 0, 45)
    title.Position = UDim2.fromOffset(15, 0)
    title.BackgroundTransparency = 1
    title.Text = tostring(options.Title or "Steal An Egg")
        .. "  v"
        .. tostring(options.Version or "1.0.0")
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local close = Instance.new("TextButton")
    close.Size = UDim2.fromOffset(35, 35)
    close.Position = UDim2.new(1, -42, 0, 5)
    close.Text = "X"
    close.TextSize = 16
    close.TextColor3 = Color3.new(1, 1, 1)
    close.BackgroundTransparency = 1
    close.Parent = frame

    close.MouseButton1Click:Connect(function()
        gui.Enabled = false
    end)

    local tabs = {}
    local currentTab = nil

    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, -20, 0, 35)
    tabBar.Position = UDim2.fromOffset(10, 50)
    tabBar.BackgroundTransparency = 1
    tabBar.Parent = frame

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 1, -95)
    content.Position = UDim2.fromOffset(10, 90)
    content.BackgroundTransparency = 1
    content.Parent = frame

    local function showTab(name)
        for tabName, data in pairs(tabs) do
            data.Page.Visible = tabName == name
        end

        currentTab = name
    end

    function self:AddTab(name)
        if tabs[name] then
            return
        end

        local index = 0

        for _ in pairs(tabs) do
            index += 1
        end

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(
            1 / math.max(index + 1, 1),
            -4,
            1,
            0
        )
        button.Position = UDim2.new(
            index / math.max(index + 1, 1),
            index * 2,
            0,
            0
        )

        button.Text = name
        button.TextSize = 13
        button.TextColor3 = Color3.new(1, 1, 1)
        button.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
        button.BorderSizePixel = 0
        button.Parent = tabBar

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.fromScale(1, 1)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 4
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Visible = false
        page.Parent = content

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 6)
        layout.Parent = page

        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.fromOffset(
                0,
                layout.AbsoluteContentSize.Y + 10
            )
        end)

        tabs[name] = {
            Button = button,
            Page = page,
            Layout = layout
        }

        button.MouseButton1Click:Connect(function()
            showTab(name)
        end)

        if not currentTab then
            showTab(name)
        end
    end

    function self:AddToggle(tabName, name, default, callback)
        local tab = tabs[tabName]

        if not tab then
            warn("Tab tidak ditemukan:", tabName)
            return
        end

        local enabled = default == true

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -5, 0, 40)
        button.TextSize = 14
        button.Font = Enum.Font.Gotham
        button.TextColor3 = Color3.new(1, 1, 1)
        button.BorderSizePixel = 0
        button.Parent = tab.Page

        local function update()
            button.Text = name .. ": " .. (enabled and "ON" or "OFF")

            if enabled then
                button.BackgroundColor3 =
                    Color3.fromRGB(45, 120, 70)
            else
                button.BackgroundColor3 =
                    Color3.fromRGB(50, 50, 58)
            end
        end

        button.MouseButton1Click:Connect(function()
            enabled = not enabled
            update()

            if callback then
                callback(enabled)
            end
        end)

        update()

        if callback then
            callback(enabled)
        end
    end

    function self:AddButton(tabName, name, callback)
        local tab = tabs[tabName]

        if not tab then
            warn("Tab tidak ditemukan:", tabName)
            return
        end

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -5, 0, 40)
        button.Text = name
        button.TextSize = 14
        button.Font = Enum.Font.Gotham
        button.TextColor3 = Color3.new(1, 1, 1)
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
        button.BorderSizePixel = 0
        button.Parent = tab.Page

        button.MouseButton1Click:Connect(function()
            if callback then
                callback()
            end
        end)
    end

    self.Gui = gui
    self.Frame = frame
    self.Tabs = tabs

    return self
end

function UI:Destroy()
    if self.Gui then
        self.Gui:Destroy()
        self.Gui = nil
    end
end

return UI
