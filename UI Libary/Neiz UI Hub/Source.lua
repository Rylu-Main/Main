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
Main.Size = UDim2.new(0,550,0,380)
Main.Position = UDim2.new(0.5,-275,0.5,-190)
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
Title.Size = UDim2.new(1,-80,0,30)
Title.Font = Enum.Font.Code
Title.Text = "Neiz UI Hub"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local ToggleButton = Instance.new("ImageButton")
ToggleButton.Parent = Main
ToggleButton.BackgroundTransparency = 1
ToggleButton.Image = ""
ToggleButton.Position = UDim2.new(1, -35, 0, 10)
ToggleButton.Size = UDim2.new(0, 25, 0, 25)

local toggleIcon = Instance.new("ImageLabel")
toggleIcon.Parent = ToggleButton
toggleIcon.BackgroundTransparency = 1
toggleIcon.Image = "http://www.roblox.com/asset/?id=6031094670"
toggleIcon.Size = UDim2.new(1, 0, 1, 0)
toggleIcon.Rotation = 90

local hidden = false
local toggleDebounce = false

local function tween(instance, time, properties, callback)
    callback = callback or function() end
    local tweenObj = TweenService:Create(instance, TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), properties)
    tweenObj:Play()
    tweenObj.Completed:Connect(function()
        callback()
    end)
end

ToggleButton.MouseButton1Click:Connect(function()
    if toggleDebounce then return end
    toggleDebounce = true
    hidden = not hidden
    tween(toggleIcon, 0.5, {Rotation = hidden and 270 or 90})
    if not hidden then
        tween(Main, 0.5, {Size = UDim2.new(0, 550, 0, 45)}, function()
            tween(Main, 0.5, {Size = UDim2.new(0, 550, 0, 380)}, function()
                toggleDebounce = false
            end)
        end)
    else
        tween(Main, 0.5, {Size = UDim2.new(0, 550, 0, 45)}, function()
            tween(Main, 0.5, {Size = UDim2.new(0, 550, 0, 45)}, function()
                toggleDebounce = false
            end)
        end)
    end
end)

-- Tab system
local TabBar = Instance.new("Frame")
TabBar.Parent = Main
TabBar.Name = "TabBar"
TabBar.Position = UDim2.new(0, 0, 0, 45)
TabBar.Size = UDim2.new(0, 150, 1, -55)
TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabBar.BorderSizePixel = 0

Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 10)

local TabMenu = Instance.new("ScrollingFrame")
TabMenu.Parent = TabBar
TabMenu.Name = "TabMenu"
TabMenu.BackgroundTransparency = 1
TabMenu.Size = UDim2.new(1, -5, 1, 0)
TabMenu.CanvasSize = UDim2.new(0, 0, 0, 0)
TabMenu.ScrollBarThickness = 4
TabMenu.BorderSizePixel = 0

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabMenu
TabLayout.Padding = UDim.new(0, 5)

local Pages = Instance.new("Frame")
Pages.Parent = Main
Pages.Name = "Pages"
Pages.Position = UDim2.new(0, 150, 0, 45)
Pages.Size = UDim2.new(1, -150, 1, -55)
Pages.BackgroundTransparency = 1
Pages.BorderSizePixel = 0
Pages.ZIndex = 5

local selectedPage = nil
local pageDebounce = false
local tabCount = 0

local function selectTab(btn)
    if pageDebounce then return end
    pageDebounce = true
    for i, v in pairs(TabMenu:GetChildren()) do
        if v:IsA("TextButton") then
            if v ~= btn then
                tween(v, 0.3, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)})
                tween(Pages[v.Name], 0.4, {Position = UDim2.new(1, 0, 0, 0)})
            end
        end
    end
    if selectedPage ~= nil then task.wait(0.2) end
    tween(btn, 0.3, {BackgroundColor3 = Color3.fromRGB(50, 100, 200)})
    tween(Pages[btn.Name], 0.4, {Position = UDim2.new(0, 0, 0, 0)})
    selectedPage = btn.Name
    pageDebounce = false
end

local function UpdateTabCanvas()
    task.wait()
    TabMenu.CanvasSize = UDim2.new(
        0,
        0,
        0,
        TabLayout.AbsoluteContentSize.Y + 10
    )
end

function _G.AddTab(tabName)
    local comp = {}
    tabCount = tabCount + 1

    local TabButton = Instance.new("TextButton")
    TabButton.Parent = TabMenu
    TabButton.Name = tabName
    TabButton.Size = UDim2.new(1, -10, 0, 35)
    TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabButton.BorderSizePixel = 0
    TabButton.Font = Enum.Font.Code
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = 13
    TabButton.AutoButtonColor = false

    Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 8)

    TabButton.MouseButton1Click:Connect(function()
        coroutine.wrap(selectTab)(TabButton)
    end)

    TabButton.MouseEnter:Connect(function()
        if selectedPage ~= TabButton.Name then
            tween(TabButton, 0.2, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)})
        end
    end)

    TabButton.MouseLeave:Connect(function()
        if selectedPage ~= TabButton.Name then
            tween(TabButton, 0.2, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)})
        end
    end)

    UpdateTabCanvas()

    -- Create page for tab
    local Page = Instance.new("ScrollingFrame")
    Page.Parent = Pages
    Page.Name = tabName
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarImageColor3 = Color3.fromRGB(42, 43, 53)
    Page.BottomImage = ""
    Page.TopImage = ""
    Page.ScrollBarThickness = 4
    Page.Position = UDim2.new(1, 0, 0, 0)

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.Padding = UDim.new(0, 8)

    local PagePadding = Instance.new("UIPadding")
    PagePadding.Parent = Page
    PagePadding.PaddingLeft = UDim.new(0, 15)
    PagePadding.PaddingRight = UDim.new(0, 15)
    PagePadding.PaddingTop = UDim.new(0, 15)
    PagePadding.PaddingBottom = UDim.new(0, 15)

    local function UpdatePageCanvas()
        task.wait()
        Page.CanvasSize = UDim2.new(
            0,
            0,
            0,
            PageLayout.AbsoluteContentSize.Y + 30
        )
    end

    -- Auto-select first tab
    if tabCount == 1 then
        coroutine.wrap(selectTab)(TabButton)
    end

    function comp:AddButton(args)
        local Button = Instance.new("TextButton")
        Button.Parent = Page
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

        UpdatePageCanvas()
    end

    function comp:AddToggle(args)
        local Enabled = args.Default or false
        local Debounce = false
        local Delay = args.Delay or 0.2

        local Holder = Instance.new("Frame")
        Holder.Parent = Page
        Holder.Size = UDim2.new(1,0,0,36)
        Holder.BackgroundColor3 = Color3.fromRGB(25,25,25)
        Holder.BorderSizePixel = 0

        Instance.new("UICorner",Holder).CornerRadius = UDim.new(0,8)

        local Label = Instance.new("TextLabel")
        Label.Parent = Holder
        Label.BackgroundTransparency = 1
        Label.Position = UDim2.new(0,10,0,0)
        Label.Size = UDim2.new(1,-60,1,0)
        Label.Font = Enum.Font.Code
        Label.Text = args.Text or "Toggle"
        Label.TextColor3 = Color3.fromRGB(255,255,255)
        Label.TextSize = 14
        Label.TextXAlignment = Enum.TextXAlignment.Left

        local ToggleBack = Instance.new("Frame")
        ToggleBack.Parent = Holder
        ToggleBack.Size = UDim2.new(0,42,0,20)
        ToggleBack.Position = UDim2.new(1,-52,0.5,-10)
        ToggleBack.BackgroundColor3 = Color3.fromRGB(45,45,45)
        ToggleBack.BorderSizePixel = 0

        Instance.new("UICorner",ToggleBack).CornerRadius = UDim.new(1,0)

        local Circle = Instance.new("Frame")
        Circle.Parent = ToggleBack
        Circle.Size = UDim2.new(0,16,0,16)
        Circle.Position = UDim2.new(0,2,0.5,-8)
        Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
        Circle.BorderSizePixel = 0

        Instance.new("UICorner",Circle).CornerRadius = UDim.new(1,0)

        local function Update()
            TweenService:Create(
                ToggleBack,
                TweenInfo.new(0.2),
                {
                    BackgroundColor3 = Enabled
                        and Color3.fromRGB(60,170,90)
                        or Color3.fromRGB(45,45,45)
                }
            ):Play()

            TweenService:Create(
                Circle,
                TweenInfo.new(
                    0.25,
                    Enum.EasingStyle.Quart,
                    Enum.EasingDirection.Out
                ),
                {
                    Position = Enabled
                        and UDim2.new(1,-18,0.5,-8)
                        or UDim2.new(0,2,0.5,-8)
                }
            ):Play()
        end

        Update()

        Holder.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch then

                if Debounce then
                    return
                end

                Debounce = true

                Enabled = not Enabled

                Update()

                pcall(function()
                    if args.Callback then
                        args.Callback(Enabled)
                    end
                end)

                task.wait(Delay)

                Debounce = false
            end
        end)

        UpdatePageCanvas()
    end

    function comp:AddTextbox(args)
        local Frame = Instance.new("Frame")
        Frame.Parent = Page
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

        UpdatePageCanvas()
    end

    function comp:AddDropdown(args)
        local ee = {}
        local dropdownOpen = false
        local items = args.List or {}
        local selectedItem = args.Default or ""
        
        local b1 = Instance.new("Frame")
        b1.Parent = Page
        b1.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        b1.Size = UDim2.new(1, 0, 0, 32)
        b1.BorderSizePixel = 0
        b1.ClipsDescendants = true
        
        Instance.new("UICorner", b1).CornerRadius = UDim.new(0, 8)
        
        local stroke = Instance.new("UIStroke")
        stroke.Parent = b1
        stroke.ApplyStrokeMode = 1
        stroke.Color = Color3.fromRGB(60, 60, 60)
        
        local titleLabel = Instance.new("TextLabel")
        titleLabel.Parent = b1
        titleLabel.BackgroundTransparency = 1
        titleLabel.Position = UDim2.new(0, 10, 0, 8)
        titleLabel.Size = UDim2.new(1, -10, 0, 14)
        titleLabel.Font = Enum.Font.Code
        titleLabel.Text = args.Text or "Dropdown"
        titleLabel.TextColor3 = Color3.new(1, 1, 1)
        titleLabel.TextSize = 13
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        local textbox = Instance.new("TextBox")
        textbox.Parent = b1
        textbox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        textbox.Size = UDim2.new(0, 120, 0, 24)
        textbox.Position = UDim2.new(1, -155, 0, 3)
        textbox.Font = Enum.Font.Code
        textbox.Text = selectedItem
        textbox.PlaceholderText = "..."
        textbox.TextColor3 = Color3.new(1, 1, 1)
        textbox.TextSize = 13
        textbox.TextWrapped = true
        textbox.TextEditable = false
        textbox.BorderSizePixel = 0
        
        Instance.new("UICorner", textbox).CornerRadius = UDim.new(0, 4)
        
        local txtstroke = Instance.new("UIStroke")
        txtstroke.Parent = textbox
        txtstroke.ApplyStrokeMode = 1
        txtstroke.Color = Color3.fromRGB(50, 50, 50)
        
        local dropdownTog = Instance.new("ImageButton")
        dropdownTog.Parent = b1
        dropdownTog.BackgroundTransparency = 1
        dropdownTog.Image = ""
        dropdownTog.Position = UDim2.new(1, -30, 0, 3)
        dropdownTog.Size = UDim2.new(0, 24, 0, 24)
        
        local togstroke = Instance.new("UIStroke")
        togstroke.Parent = dropdownTog
        togstroke.ApplyStrokeMode = 1
        togstroke.Color = Color3.fromRGB(50, 50, 50)
        
        Instance.new("UICorner", dropdownTog).CornerRadius = UDim.new(0, 4)
        
        local dropdownIcon = Instance.new("ImageLabel")
        dropdownIcon.Parent = dropdownTog
        dropdownIcon.BackgroundTransparency = 1
        dropdownIcon.Image = "http://www.roblox.com/asset/?id=6031094670"
        dropdownIcon.Size = UDim2.new(1, 0, 1, 0)
        dropdownIcon.Rotation = 270
        
        local dropdownContainer = Instance.new("ScrollingFrame")
        dropdownContainer.Parent = b1
        dropdownContainer.BackgroundTransparency = 1
        dropdownContainer.BorderSizePixel = 0
        dropdownContainer.Size = UDim2.new(1, -4, 1, -32)
        dropdownContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
        dropdownContainer.ScrollBarImageColor3 = Color3.fromRGB(42, 43, 53)
        dropdownContainer.BottomImage = ""
        dropdownContainer.TopImage = ""
        dropdownContainer.ScrollBarThickness = 6
        dropdownContainer.VerticalScrollBarInset = 1
        dropdownContainer.Position = UDim2.new(0, 2, 0, 32)
        
        Instance.new("UIListLayout", dropdownContainer).Padding = UDim.new(0, 5)
        
        local padding = Instance.new("UIPadding", dropdownContainer)
        padding.PaddingLeft = UDim.new(0, 5)
        padding.PaddingRight = UDim.new(0, 5)
        padding.PaddingTop = UDim.new(0, 5)
        padding.PaddingBottom = UDim.new(0, 5)
        
        dropdownTog.MouseButton1Click:Connect(function()
            dropdownOpen = not dropdownOpen
            tween(dropdownIcon, 0.3, {Rotation = dropdownOpen and 90 or 270})
            tween(b1, 0.3, {Size = dropdownOpen and UDim2.new(1, 0, 0, 120) or UDim2.new(1, 0, 0, 32)})
        end)
        
        b1.Changed:Connect(function(it)
            if it == "Size" then
                UpdatePageCanvas()
            end
        end)
        
        function ee:Update(newlist)
            for i, v in pairs(dropdownContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    v:Destroy()
                end
            end
            items = newlist
            textbox.Text = ""
            for i, v in pairs(items) do
                local btndebounce = false
                local optbtn = Instance.new("TextButton")
                optbtn.Parent = dropdownContainer
                optbtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                optbtn.Size = UDim2.new(1, 0, 0, 28)
                optbtn.Font = Enum.Font.Code
                optbtn.Text = tostring(v)
                optbtn.TextColor3 = Color3.new(1, 1, 1)
                optbtn.TextSize = 13
                optbtn.AutoButtonColor = false
                optbtn.BorderSizePixel = 0
                
                Instance.new("UICorner", optbtn).CornerRadius = UDim.new(0, 4)
                
                local optstroke = Instance.new("UIStroke")
                optstroke.Parent = optbtn
                optstroke.ApplyStrokeMode = 1
                optstroke.Color = Color3.fromRGB(50, 50, 50)
                
                dropdownContainer.CanvasSize = UDim2.new(0, 0, 0, dropdownContainer.CanvasSize.Y.Offset + 36)
                
                optbtn.MouseButton1Click:Connect(function()
                    textbox.Text = tostring(v)
                    selectedItem = tostring(v)
                    if not btndebounce then
                        btndebounce = true
                        TweenService:Create(optstroke, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, true), {Color = Color3.fromRGB(100, 100, 100)}):Play()
                        task.wait(0.4)
                        btndebounce = false
                    end
                    pcall(function()
                        if args.Callback then
                            args.Callback(tostring(v))
                        end
                    end)
                end)
            end
        end
        
        for i, v in pairs(items) do
            local btndebounce = false
            local optbtn = Instance.new("TextButton")
            optbtn.Parent = dropdownContainer
            optbtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            optbtn.Size = UDim2.new(1, 0, 0, 28)
            optbtn.Font = Enum.Font.Code
            optbtn.Text = tostring(v)
            optbtn.TextColor3 = Color3.new(1, 1, 1)
            optbtn.TextSize = 13
            optbtn.AutoButtonColor = false
            optbtn.BorderSizePixel = 0
            
            Instance.new("UICorner", optbtn).CornerRadius = UDim.new(0, 4)
            
            local optstroke = Instance.new("UIStroke")
            optstroke.Parent = optbtn
            optstroke.ApplyStrokeMode = 1
            optstroke.Color = Color3.fromRGB(50, 50, 50)
            
            dropdownContainer.CanvasSize = UDim2.new(0, 0, 0, dropdownContainer.CanvasSize.Y.Offset + 36)
            
            optbtn.MouseButton1Click:Connect(function()
                textbox.Text = tostring(v)
                selectedItem = tostring(v)
                if not btndebounce then
                    btndebounce = true
                    TweenService:Create(optstroke, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, true), {Color = Color3.fromRGB(100, 100, 100)}):Play()
                    task.wait(0.4)
                    btndebounce = false
                end
                pcall(function()
                    if args.Callback then
                        args.Callback(tostring(v))
                    end
                end)
            end)
        end
        
        UpdatePageCanvas()
        return ee
    end

    function comp:AddSlider(args)
        local Min = args.Min or 0
        local Max = args.Max or 100
        local Default = args.Default or Min

        local Frame = Instance.new("Frame")
        Frame.Parent = Page
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

        UpdatePageCanvas()
    end

    return comp
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

function _G.SetTitle(text)
    Title.Text = tostring(text)
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
