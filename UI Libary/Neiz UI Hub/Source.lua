local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game.CoreGui

-- Remove existing hub if any
local oldHub = CoreGui:FindFirstChild("NeizHub")
if oldHub then
    oldHub:Destroy()
end

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NeizHub"
screenGui.Parent = CoreGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local mainFrame = Instance.new("Frame")
mainFrame.Name = "Main"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 17, 20)
mainFrame.BackgroundTransparency = 0.3
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
mainFrame.Size = UDim2.new(0, 400, 0, 250)

-- UI corner and stroke
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1
stroke.Color = Color3.fromRGB(255, 255, 255)
stroke.Transparency = 0.8
stroke.Parent = mainFrame

-- Content label (shows time, IP, HWID, etc.)
local contentLabel = Instance.new("TextLabel")
contentLabel.Name = "Content"
contentLabel.Parent = mainFrame
contentLabel.BackgroundTransparency = 1
contentLabel.Position = UDim2.new(0, 25, 0, 25)
contentLabel.Size = UDim2.new(1, -50, 0.8, 0)
contentLabel.Font = Enum.Font.Code
contentLabel.Text = "" -- Will be filled after click
contentLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
contentLabel.TextSize = 14
contentLabel.TextXAlignment = Enum.TextXAlignment.Left
contentLabel.TextYAlignment = Enum.TextYAlignment.Top
contentLabel.LineHeight = 1.2

-- Triangle button (top right, rotates)
local triangleButton = Instance.new("TextButton")
triangleButton.Name = "Triangle"
triangleButton.Parent = mainFrame
triangleButton.AnchorPoint = Vector2.new(0.5, 0.5)
triangleButton.BackgroundTransparency = 1
triangleButton.Position = UDim2.new(0, 30, 1, -30)
triangleButton.Size = UDim2.new(0, 30, 0, 30)
triangleButton.Font = Enum.Font.Code
triangleButton.Text = "▲"
triangleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
triangleButton.TextTransparency = 0.8
triangleButton.TextSize = 25

-- Bottom info label (cycling messages)
local bottomInfo = Instance.new("TextLabel")
bottomInfo.Name = "BottomInfo"
bottomInfo.Parent = mainFrame
bottomInfo.BackgroundTransparency = 1
bottomInfo.Position = UDim2.new(0, 0, 1, -30)
bottomInfo.Size = UDim2.new(1, 0, 0, 20)
bottomInfo.Font = Enum.Font.Code
bottomInfo.TextColor3 = Color3.fromRGB(160, 160, 160)
bottomInfo.TextSize = 12
bottomInfo.TextXAlignment = Enum.TextXAlignment.Center

-- IP Reveal button (top left)
local ipRevealButton = Instance.new("TextButton")
ipRevealButton.Name = "IPReveal"
ipRevealButton.Parent = mainFrame
ipRevealButton.BackgroundTransparency = 1
ipRevealButton.Position = UDim2.new(0, 25, 0, 130)
ipRevealButton.Size = UDim2.new(0, 200, 0, 20)
ipRevealButton.Text = "Loading IP..." -- temporary
ipRevealButton.ZIndex = 10

-- HWID Reveal button (below IP)
local hwidRevealButton = Instance.new("TextButton")
hwidRevealButton.Name = "HWIDReveal"
hwidRevealButton.Parent = mainFrame
hwidRevealButton.BackgroundTransparency = 1
hwidRevealButton.Position = UDim2.new(0, 25, 0, 165)
hwidRevealButton.Size = UDim2.new(0, 300, 0, 20)
hwidRevealButton.Text = "HWID: Unknown" -- placeholder
hwidRevealButton.ZIndex = 10

-- Tab container (hidden initially, shown after first click)
local tabContainer = Instance.new("ScrollingFrame")
tabContainer.Name = "TabContainer"
tabContainer.Parent = mainFrame
tabContainer.BackgroundTransparency = 1
tabContainer.Position = UDim2.new(0, 20, 0, 60)
tabContainer.Size = UDim2.new(1, -40, 1, -100)
tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
tabContainer.ScrollBarThickness = 2
tabContainer.Visible = false

local tabList = Instance.new("UIListLayout")
tabList.Parent = tabContainer
tabList.Padding = UDim.new(0, 8)
tabList.SortOrder = Enum.SortOrder.LayoutOrder

-- Variables for dragging
local dragStartPosition = nil
local frameStartPosition = nil

-- Color themes for cycling
local themes = {
    { Color3.fromRGB(15, 17, 20), 0.3 },
    { Color3.fromRGB(10, 10, 10), 0.1 },
    { Color3.fromRGB(25, 15, 30), 0.4 },
    { Color3.fromRGB(15, 25, 20), 0.4 },
}
local currentTheme = 1

-- Flag to track if hub has been "opened"
local hubOpened = false

-- Executor & IP info (will be updated)
local executorName = "Unknown"
local ipInfo = "Loading..."
local hwidInfo = "Unknown"
local message = "Loading..."

-- ==================== IP API Integration ====================
-- Function to fetch IP from a public API
local function fetchIP()
    local url = "https://api.ipify.org?format=json"  -- simple JSON response
    local success, result = pcall(function()
        -- Try different HTTP functions depending on executor
        if game.HttpGet then
            return game:HttpGet(url)
        elseif http_request then
            return http_request({ Url = url, Method = "GET" }).Body
        elseif syn and syn.request then
            local response = syn.request({ Url = url, Method = "GET" })
            return response.Body
        else
            error("No HTTP function available")
        end
    end)

    if success and result then
        -- Parse JSON (api.ipify returns {"ip":"..."})
        local json = game:GetService("HttpService"):JSONDecode(result)
        if json and json.ip then
            ipInfo = json.ip
            ipRevealButton.Text = "IP: " .. ipInfo
        else
            ipInfo = "Parse error"
            ipRevealButton.Text = "IP: error"
        end
    else
        ipInfo = "Failed to fetch"
        ipRevealButton.Text = "IP: failed"
    end
end

-- Try to get executor info
local success, result = pcall(function()
    if identifyexecutor then return identifyexecutor() end
end)
if success then executorName = result or "Unknown" end

success, result = pcall(function()
    if gethwid then return gethwid() end
    if get_hwid then return get_hwid() end
end)
if success then hwidInfo = result or "Unknown" end
hwidRevealButton.Text = "HWID: " .. hwidInfo

-- Kick off IP fetch
fetchIP()

-- ==================== Functions ====================

-- Cycle theme on T press
local function cycleTheme()
    currentTheme = currentTheme % #themes + 1
    local theme = themes[currentTheme]
    local tweenInfo = TweenInfo.new(0.6)
    local tween = TweenService:Create(mainFrame, tweenInfo, {
        BackgroundColor3 = theme[1],
        BackgroundTransparency = theme[2],
    })
    tween:Play()
end

-- Keybind: T to cycle theme
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.T then
        cycleTheme()
    end
end)

-- Dragging
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStartPosition = input.Position
        frameStartPosition = mainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragStartPosition then
        local delta = input.Position - dragStartPosition
        mainFrame.Position = UDim2.new(
            frameStartPosition.X.Scale,
            frameStartPosition.X.Offset + delta.X,
            frameStartPosition.Y.Scale,
            frameStartPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStartPosition = nil
    end
end)

-- Triangle click: open hub
triangleButton.MouseButton1Click:Connect(function()
    if not hubOpened then
        hubOpened = true
        triangleButton.Visible = false
        bottomInfo.Visible = false
        ipRevealButton.Visible = false
        hwidRevealButton.Visible = false
        contentLabel.Text = "> Welcome, " .. Players.LocalPlayer.Name
        tabContainer.Visible = true
    end
end)

-- IP / HWID button clicks (you can add functionality later)
ipRevealButton.MouseButton1Click:Connect(function()
    -- Do nothing, or copy IP to clipboard
end)

hwidRevealButton.MouseButton1Click:Connect(function()
    -- Do nothing
end)

-- Rotate triangle
task.spawn(function()
    while mainFrame.Parent do
        triangleButton.Rotation += 2
        task.wait()
    end
end)

-- Update content label dynamically
task.spawn(function()
    while hubOpened and mainFrame.Parent do
        local timeStr = os.date("%X")
        contentLabel.Text = "> " .. timeStr ..
            "\n\n> " .. executorName ..
            "\n\n> " .. message ..
            "\n\n> IP: " .. ipInfo ..
            "\n\n> HWID: " .. hwidInfo
        task.wait(0.1)
    end
end)

-- Cycle bottom messages
task.spawn(function()
    while mainFrame.Parent do
        bottomInfo.Text = "> you love ugcs ?"
        task.wait(3)
        bottomInfo.Text = "> sub to neiz"
        task.wait(3)
    end
end)

-- Placeholder feature/slider functions (simplified)
function _G.AddFeature(args)
    local btn = Instance.new("TextButton")
    btn.Name = "Feature"
    btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Font = Enum.Font.Code
    btn.Text = args and args.Text or "Feature"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Parent = tabContainer
    tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabList.AbsoluteContentSize.Y)
end

function _G.AddSlider(args)
    local frame = Instance.new("Frame")
    frame.Name = "Slider"
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(1, 0, 0, 45)
    frame.Parent = tabContainer

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = Enum.Font.Code
    label.Text = args and args.Text or "Slider"
    label.TextColor3 = Color3.fromRGB(150, 150, 150)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Right
    label.Parent = frame

    local bar = Instance.new("Frame")
    bar.BackgroundTransparency = 0.9
    bar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bar.Size = UDim2.new(1, 0, 0, 6)
    bar.Parent = frame

    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fill.BackgroundTransparency = 0.5
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.Parent = bar

    tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabList.AbsoluteContentSize.Y)
end

return screenGui
