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
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Name = "Main"
Main.Size = UDim2.new(0,420,0,320)
Main.Position = UDim2.new(0.5,-210,0.5,-160)
Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.BorderSizePixel = 0

Instance.new("UICorner",Main).CornerRadius = UDim.new(0,10)

local Stroke = Instance.new("UIStroke")
Stroke.Parent = Main
Stroke.Color = Color3.fromRGB(255,255,255)
Stroke.Transparency = 0.8

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0,15,0,10)
Title.Size = UDim2.new(1,-30,0,30)
Title.Font = Enum.Font.Code
Title.Text = "Loadyrinh UI"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local Container = Instance.new("ScrollingFrame")
Container.Parent = Main
Container.Name = "Container"
Container.Position = UDim2.new(0,15,0,50)
Container.Size = UDim2.new(1,-30,1,-65)
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.ScrollBarThickness = 2
Container.CanvasSize = UDim2.new(0,0,0,0)

local Layout = Instance.new("UIListLayout")
Layout.Parent = Container
Layout.Padding = UDim.new(0,8)

local function UpdateCanvas()
    task.wait()

    Container.CanvasSize = UDim2.new(
        0,
        0,
        0,
        Layout.AbsoluteContentSize.Y + 10
    )
end

local Dragging = false
local DragStart
local StartPos

Main.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton1
    or Input.UserInputType == Enum.UserInputType.Touch then

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
    if Dragging and (
        Input.UserInputType == Enum.UserInputType.MouseMovement
        or Input.UserInputType == Enum.UserInputType.Touch
    ) then

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
    Button.Size = UDim2.new(1,0,0,32)
    Button.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Button.BorderSizePixel = 0
    Button.Font = Enum.Font.Code
    Button.Text = args.Text or "Button"
    Button.TextColor3 = Color3.fromRGB(255,255,255)
    Button.TextSize = 14
    Button.AutoButtonColor = false

    Instance.new("UICorner",Button).CornerRadius = UDim.new(0,8)

    Button.MouseButton1Down:Connect(function()
        TweenService:Create(
            Button,
            TweenInfo.new(0.08),
            {
                Size = UDim2.new(1,-4,0,28)
            }
        ):Play()
    end)

    Button.MouseButton1Up:Connect(function()
        TweenService:Create(
            Button,
            TweenInfo.new(0.08),
            {
                Size = UDim2.new(1,0,0,32)
            }
        ):Play()
    end)

    Button.MouseButton1Click:Connect(function()
        pcall(function()
            if args.Callback then
                args.Callback()
            end
        end)
    end)

    UpdateCanvas()
end

function _G.AddToggle(args)
    local Enabled = args.Default or false
    local Debounce = false
    local Delay = args.Delay or 0.2

    local Button = Instance.new("TextButton")
    Button.Parent = Container
    Button.Size = UDim2.new(1,0,0,32)
    Button.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Button.BorderSizePixel = 0
    Button.Font = Enum.Font.Code
    Button.TextColor3 = Color3.fromRGB(255,255,255)
    Button.TextSize = 14
    Button.AutoButtonColor = false

    Instance.new("UICorner",Button).CornerRadius = UDim.new(0,8)

    local function Update()
        Button.Text =
            (args.Text or "Toggle")
            .. ": "
            .. (Enabled and "ON" or "OFF")

        TweenService:Create(
            Button,
            TweenInfo.new(0.2),
            {
                BackgroundColor3 = Enabled
                    and Color3.fromRGB(40,120,40)
                    or Color3.fromRGB(25,25,25)
            }
        ):Play()
    end

    Update()

    Button.MouseButton1Click:Connect(function()
        if Debounce then
            return
        end

        Debounce = true

        TweenService:Create(
            Button,
            TweenInfo.new(0.08),
            {
                Size = UDim2.new(1,-4,0,28)
            }
        ):Play()

        task.wait(0.08)

        TweenService:Create(
            Button,
            TweenInfo.new(0.08),
            {
                Size = UDim2.new(1,0,0,32)
            }
        ):Play()

        Enabled = not Enabled
        Update()

        pcall(function()
            if args.Callback then
                args.Callback(Enabled)
            end
        end)

        task.wait(Delay)

        Debounce = false
    end)

    UpdateCanvas()
end

function _G.AddTextbox(args)
    local Frame = Instance.new("Frame")
    Frame.Parent = Container
    Frame.Size = UDim2.new(1,0,0,55)
    Frame.BackgroundTransparency = 1

    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(1,0,0,18)
    Label.Font = Enum.Font.Code
    Label.Text = args.Text or "Textbox"
    Label.TextColor3 = Color3.fromRGB(255,255,255)
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Box = Instance.new("TextBox")
    Box.Parent = Frame
    Box.Position = UDim2.new(0,0,0,24)
    Box.Size = UDim2.new(1,0,0,28)
    Box.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Box.BorderSizePixel = 0
    Box.PlaceholderText = args.Placeholder or "Type here"
    Box.Font = Enum.Font.Code
    Box.TextColor3 = Color3.fromRGB(255,255,255)
    Box.TextSize = 13

    Instance.new("UICorner",Box).CornerRadius = UDim.new(0,8)

    Box.FocusLost:Connect(function()
        pcall(function()
            if args.Callback then
                args.Callback(Box.Text)
            end
        end)
    end)

    UpdateCanvas()
end

function _G.AddDropdown(args)
    local Open = false

    local Holder = Instance.new("Frame")
    Holder.Parent = Container
    Holder.Size = UDim2.new(1,0,0,32)
    Holder.BackgroundTransparency = 1
    Holder.ClipsDescendants = true

    local MainButton = Instance.new("TextButton")
    MainButton.Parent = Holder
    MainButton.Size = UDim2.new(1,0,0,32)
    MainButton.BackgroundColor3 = Color3.fromRGB(25,25,25)
    MainButton.BorderSizePixel = 0
    MainButton.Font = Enum.Font.Code
    MainButton.Text = (args.Text or "Dropdown") .. " ▼"
    MainButton.TextColor3 = Color3.fromRGB(255,255,255)
    MainButton.TextSize = 14
    MainButton.AutoButtonColor = false

    Instance.new("UICorner",MainButton).CornerRadius = UDim.new(0,8)

    local List = Instance.new("Frame")
    List.Parent = Holder
    List.Position = UDim2.new(0,0,0,36)
    List.Size = UDim2.new(1,0,0,0)
    List.BackgroundTransparency = 1
    List.ClipsDescendants = true

    local Layout2 = Instance.new("UIListLayout")
    Layout2.Parent = List
    Layout2.Padding = UDim.new(0,4)

    local Total = 0

    for _,v in pairs(args.List or {}) do
        Total += 32

        local Option = Instance.new("TextButton")
        Option.Parent = List
        Option.Size = UDim2.new(1,0,0,28)
        Option.BackgroundColor3 = Color3.fromRGB(30,30,30)
        Option.BorderSizePixel = 0
        Option.Font = Enum.Font.Code
        Option.Text = tostring(v)
        Option.TextColor3 = Color3.fromRGB(255,255,255)
        Option.TextSize = 13
        Option.AutoButtonColor = false

        Instance.new("UICorner",Option).CornerRadius = UDim.new(0,8)

        Option.MouseButton1Click:Connect(function()
            MainButton.Text =
                (args.Text or "Dropdown")
                .. ": "
                .. tostring(v)

            TweenService:Create(
                Option,
                TweenInfo.new(0.1),
                {
                    BackgroundColor3 = Color3.fromRGB(60,60,60)
                }
            ):Play()

            task.wait(0.1)

            TweenService:Create(
                Option,
                TweenInfo.new(0.15),
                {
                    BackgroundColor3 = Color3.fromRGB(30,30,30)
                }
            ):Play()

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
            TweenService:Create(
                Holder,
                TweenInfo.new(0.25,Enum.EasingStyle.Quart),
                {
                    Size = UDim2.new(1,0,0,36 + Total)
                }
            ):Play()

            TweenService:Create(
                List,
                TweenInfo.new(0.25,Enum.EasingStyle.Quart),
                {
                    Size = UDim2.new(1,0,0,Total)
                }
            ):Play()
        else
            TweenService:Create(
                Holder,
                TweenInfo.new(0.25,Enum.EasingStyle.Quart),
                {
                    Size = UDim2.new(1,0,0,32)
                }
            ):Play()

            TweenService:Create(
                List,
                TweenInfo.new(0.25,Enum.EasingStyle.Quart),
                {
                    Size = UDim2.new(1,0,0,0)
                }
            ):Play()
        end

        task.wait(0.26)

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
    Frame.Size = UDim2.new(1,0,0,50)
    Frame.BackgroundTransparency = 1

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
    Bar.BackgroundColor3 = Color3.fromRGB(35,35,35)
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
        if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
            Sliding = true
        end
    end)

    UIS.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then
            Sliding = false
        end
    end)

    UIS.InputChanged:Connect(function(Input)
        if Sliding and (
            Input.UserInputType == Enum.UserInputType.MouseMovement
            or Input.UserInputType == Enum.UserInputType.Touch
        ) then

            local SizeX = math.clamp(
                (Input.Position.X - Bar.AbsolutePosition.X)
                / Bar.AbsoluteSize.X,
                0,
                1
            )

            Fill.Size = UDim2.new(SizeX,0,1,0)

            local Value = math.floor(
                ((Max - Min) * SizeX) + Min
            )

            Label.Text =
                (args.Text or "Slider")
                .. ": "
                .. Value

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
    if gp then
        return
    end

    if Input.KeyCode == Enum.KeyCode.RightControl then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

return ScreenGui
