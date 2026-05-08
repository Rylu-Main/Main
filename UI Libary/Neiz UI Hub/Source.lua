local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

pcall(function()
    if CoreGui:FindFirstChild("NeizHub") then
        CoreGui.NeizHub:Destroy()
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NeizHub"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.Size = UDim2.new(0,420,0,320)
Main.Position = UDim2.new(0.5,-210,0.5,-160)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,12)

local Stroke = Instance.new("UIStroke")
Stroke.Parent = Main
Stroke.Color = Color3.fromRGB(255,255,255)
Stroke.Transparency = 0.85
Stroke.Thickness = 1

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0,15,0,10)
Title.Size = UDim2.new(1,-30,0,30)
Title.Font = Enum.Font.Code
Title.Text = "Neiz Hub"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local Info = Instance.new("TextLabel")
Info.Parent = Main
Info.BackgroundTransparency = 1
Info.Position = UDim2.new(0,15,0,40)
Info.Size = UDim2.new(1,-30,0,20)
Info.Font = Enum.Font.Code
Info.Text = "> Welcome " .. Players.LocalPlayer.Name
Info.TextColor3 = Color3.fromRGB(170,170,170)
Info.TextSize = 13
Info.TextXAlignment = Enum.TextXAlignment.Left

local Container = Instance.new("ScrollingFrame")
Container.Parent = Main
Container.Name = "TabContainer"
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0,15,0,70)
Container.Size = UDim2.new(1,-30,1,-85)
Container.CanvasSize = UDim2.new(0,0,0,0)
Container.ScrollBarThickness = 2
Container.BorderSizePixel = 0

local Layout = Instance.new("UIListLayout")
Layout.Parent = Container
Layout.Padding = UDim.new(0,8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

local function UpdateCanvas()
    task.wait()
    Container.CanvasSize = UDim2.new(
        0,
        0,
        0,
        Layout.AbsoluteContentSize.Y + 10
    )
end

local Dragging
local DragStart
local StartPos

Main.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = Input.Position
        StartPos = Main.Position

        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(Input)
    if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
        local Delta = Input.Position - DragStart

        Main.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + Delta.Y
        )
    end
end)

function _G.AddButton(args)
    local Button = Instance.new("TextButton")
    Button.Parent = Container
    Button.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Button.BackgroundTransparency = 0.2
    Button.Size = UDim2.new(1,0,0,32)
    Button.AutoButtonColor = false
    Button.Text = args.Text or "Button"
    Button.Font = Enum.Font.Code
    Button.TextColor3 = Color3.fromRGB(255,255,255)
    Button.TextSize = 14
    Button.BorderSizePixel = 0

    Instance.new("UICorner",Button).CornerRadius = UDim.new(0,8)

    Button.MouseButton1Click:Connect(function()
        pcall(function()
            if args.Callback then
                args.Callback()
            end
        end)
    end)

    UpdateCanvas()
end

function _G.AddDropdown(args)
    local Open = false
    local OptionSize = 28

    local Holder = Instance.new("Frame")
    Holder.Parent = Container
    Holder.BackgroundTransparency = 1
    Holder.Size = UDim2.new(1,0,0,32)

    local MainButton = Instance.new("TextButton")
    MainButton.Parent = Holder
    MainButton.BackgroundColor3 = Color3.fromRGB(20,20,20)
    MainButton.BackgroundTransparency = 0.2
    MainButton.Size = UDim2.new(1,0,0,32)
    MainButton.Text = (args.Text or "Dropdown") .. " ▼"
    MainButton.Font = Enum.Font.Code
    MainButton.TextColor3 = Color3.fromRGB(255,255,255)
    MainButton.TextSize = 14
    MainButton.BorderSizePixel = 0

    Instance.new("UICorner",MainButton).CornerRadius = UDim.new(0,8)

    local List = Instance.new("Frame")
    List.Parent = Holder
    List.BackgroundTransparency = 1
    List.Position = UDim2.new(0,0,0,36)
    List.Size = UDim2.new(1,0,0,0)
    List.ClipsDescendants = true

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Parent = List
    ListLayout.Padding = UDim.new(0,4)

    local Total = 0

    for _,v in pairs(args.List or {}) do
        Total += OptionSize + 4

        local Option = Instance.new("TextButton")
        Option.Parent = List
        Option.BackgroundColor3 = Color3.fromRGB(25,25,25)
        Option.BackgroundTransparency = 0.2
        Option.Size = UDim2.new(1,0,0,OptionSize)
        Option.Text = tostring(v)
        Option.Font = Enum.Font.Code
        Option.TextColor3 = Color3.fromRGB(200,200,200)
        Option.TextSize = 13
        Option.BorderSizePixel = 0

        Instance.new("UICorner",Option).CornerRadius = UDim.new(0,8)

        Option.MouseButton1Click:Connect(function()
            MainButton.Text = (args.Text or "Dropdown") .. ": " .. tostring(v)

            pcall(function()
                if args.Callback then
                    args.Callback(v)
                end
            end)
        end)
    end

    MainButton.MouseButton1Click:Connect(function()
        Open = not Open

        if Open then
            Holder.Size = UDim2.new(1,0,0,36 + Total)
            List.Size = UDim2.new(1,0,0,Total)
            MainButton.Text = (args.Text or "Dropdown") .. " ▲"
        else
            Holder.Size = UDim2.new(1,0,0,32)
            List.Size = UDim2.new(1,0,0,0)
            MainButton.Text = (args.Text or "Dropdown") .. " ▼"
        end

        UpdateCanvas()
    end)

    UpdateCanvas()
end

function _G.AddSlider(args)
    local Min = args.Min or 0
    local Max = args.Max or 100
    local Default = args.Default or Min

    local Frame = Instance.new("Frame")
    Frame.Parent = Container
    Frame.BackgroundTransparency = 1
    Frame.Size = UDim2.new(1,0,0,50)

    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1,0,0,20)
    Label.Font = Enum.Font.Code
    Label.Text = (args.Text or "Slider") .. ": " .. Default
    Label.TextColor3 = Color3.fromRGB(255,255,255)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Bar = Instance.new("Frame")
    Bar.Parent = Frame
    Bar.Position = UDim2.new(0,0,0,30)
    Bar.Size = UDim2.new(1,0,0,8)
    Bar.BackgroundColor3 = Color3.fromRGB(30,30,30)
    Bar.BorderSizePixel = 0

    Instance.new("UICorner",Bar).CornerRadius = UDim.new(1,0)

    local Fill = Instance.new("Frame")
    Fill.Parent = Bar
    Fill.Size = UDim2.new((Default-Min)/(Max-Min),0,1,0)
    Fill.BackgroundColor3 = Color3.fromRGB(255,255,255)
    Fill.BorderSizePixel = 0

    Instance.new("UICorner",Fill).CornerRadius = UDim.new(1,0)

    local Sliding = false

    Bar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Sliding = true
        end
    end)

    UIS.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Sliding = false
        end
    end)

    UIS.InputChanged:Connect(function(Input)
        if Sliding and Input.UserInputType == Enum.UserInputType.MouseMovement then
            local SizeX = math.clamp(
                (Input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X,
                0,
                1
            )

            Fill.Size = UDim2.new(SizeX,0,1,0)

            local Value = math.floor(((Max - Min) * SizeX) + Min)

            Label.Text = (args.Text or "Slider") .. ": " .. Value

            pcall(function()
                if args.Callback then
                    args.Callback(Value)
                end
            end)
        end
    end)

    UpdateCanvas()
end

UIS.InputBegan:Connect(function(Input,gp)
    if gp then return end

    if Input.KeyCode == Enum.KeyCode.RightControl then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

return ScreenGuitabContainer.Size = UDim2.new(1, -40, 1, -100)
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
