local cloneref = cloneref or function(i) return i end
local RunService = cloneref(game:GetService("RunService"))

local function NewScreen(ScreenName)
    local Screen = Instance.new("ScreenGui")
    Screen.Name = ScreenName
    Screen.ResetOnSpawn = false
    Screen.IgnoreGuiInset = true
    Screen.DisplayOrder = 999

    -- Try gethui() first
    local ok1 = pcall(function()
        Screen.Parent = gethui()
    end)
    if ok1 and Screen.Parent ~= nil then return Screen end

    -- Try CoreGui second
    local ok2 = pcall(function()
        local CoreGui = cloneref(game:GetService("CoreGui"))
        pcall(function()
            sethiddenproperty(Screen, "OnTopOfCoreBlur", true)
        end)
        Screen.Parent = CoreGui
    end)
    if ok2 and Screen.Parent ~= nil then return Screen end

    -- Try PlayerGui third
    local ok3 = pcall(function()
        Screen.Parent = game:GetService("Players").LocalPlayer.PlayerGui
    end)
    if ok3 and Screen.Parent ~= nil then return Screen end

    -- Last resort
    pcall(function()
        Screen.Parent = game.CoreGui
    end)

    return Screen
end

local ErrorPrompt = nil
local useOriginal = false

pcall(function()
    local CoreGui = cloneref(game:GetService("CoreGui"))
    ErrorPrompt = getrenv().require(CoreGui.RobloxGui.Modules.ErrorPrompt)
    useOriginal = true
end)

local function BuildFallbackPrompt(Title, Message, Buttons, RichText)
    local Screen = NewScreen("Prompt")

    local Overlay = Instance.new("Frame")
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.5
    Overlay.BorderSizePixel = 0
    Overlay.ZIndex = 1
    Overlay.Parent = Screen

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 500, 0, 280)
    Frame.Position = UDim2.new(0.5, -250, 0.5, -140)
    Frame.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 2
    Frame.Parent = Screen
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -40, 0, 50)
    TitleLabel.Position = UDim2.new(0, 20, 0, 15)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 22
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Center
    TitleLabel.TextWrapped = true
    TitleLabel.ZIndex = 3
    TitleLabel.Parent = Frame

    local Divider = Instance.new("Frame")
    Divider.Size = UDim2.new(1, -40, 0, 1)
    Divider.Position = UDim2.new(0, 20, 0, 68)
    Divider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    Divider.BorderSizePixel = 0
    Divider.ZIndex = 3
    Divider.Parent = Frame

    local MsgLabel = Instance.new("TextLabel")
    MsgLabel.Size = UDim2.new(1, -60, 0, 120)
    MsgLabel.Position = UDim2.new(0, 30, 0, 80)
    MsgLabel.BackgroundTransparency = 1
    MsgLabel.Text = Message
    MsgLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    MsgLabel.TextSize = 16
    MsgLabel.Font = Enum.Font.Gotham
    MsgLabel.TextWrapped = true
    MsgLabel.TextXAlignment = Enum.TextXAlignment.Center
    MsgLabel.TextYAlignment = Enum.TextYAlignment.Top
    MsgLabel.RichText = RichText or false
    MsgLabel.ZIndex = 3
    MsgLabel.Parent = Frame

    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Size = UDim2.new(1, -40, 0, 48)
    ButtonFrame.Position = UDim2.new(0, 20, 1, -60)
    ButtonFrame.BackgroundTransparency = 1
    ButtonFrame.ZIndex = 3
    ButtonFrame.Parent = Frame

    local UIList = Instance.new("UIListLayout")
    UIList.FillDirection = Enum.FillDirection.Horizontal
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIList.VerticalAlignment = Enum.VerticalAlignment.Center
    UIList.Padding = UDim.new(0, 10)
    UIList.Parent = ButtonFrame

    local function closePrompt()
        pcall(function() RunService:SetRobloxGuiFocused(false) end)
        Screen:Destroy()
    end

    table.sort(Buttons, function(a, b)
        return (a.LayoutOrder or 0) < (b.LayoutOrder or 0)
    end)

    for _, Button in ipairs(Buttons) do
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(0, 180, 0, 42)
        Btn.BackgroundColor3 = Button.Primary
            and Color3.fromRGB(255, 255, 255)
            or Color3.fromRGB(42, 42, 42)
        Btn.BorderSizePixel = Button.Primary and 0 or 2
        Btn.BorderColor3 = Color3.fromRGB(150, 150, 150)
        Btn.Text = Button.Text or "OK"
        Btn.TextColor3 = Button.Primary
            and Color3.fromRGB(0, 0, 0)
            or Color3.fromRGB(255, 255, 255)
        Btn.TextSize = 15
        Btn.Font = Enum.Font.GothamSemibold
        Btn.ZIndex = 4
        Btn.Parent = ButtonFrame
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

        Btn.MouseEnter:Connect(function()
            Btn.BackgroundTransparency = 0.15
        end)
        Btn.MouseLeave:Connect(function()
            Btn.BackgroundTransparency = 0
        end)

        Btn.MouseButton1Click:Connect(function()
            closePrompt()
            if Button.Callback then
                pcall(Button.Callback)
            end
        end)
    end

    pcall(function() RunService:SetRobloxGuiFocused(true) end)
    return Screen
end

local function BuildOriginalPrompt(Title, Message, Buttons, RichText)
    local Screen = NewScreen("Prompt")
    local Prompt = ErrorPrompt.new(
        "Default",
        {
            MessageTextScaled = false,
            PlayAnimation = false,
            HideErrorCode = true
        }
    )

    if RichText then
        Prompt._frame.MessageArea.ErrorFrame.ErrorMessage.RichText = true
    end

    for _, Button in pairs(Buttons) do
        local Old = Button.Callback
        Button.Callback = function(...)
            RunService:SetRobloxGuiFocused(false)
            Prompt:_close()
            Screen:Destroy()
            return Old(...)
        end
    end

    Prompt:setErrorTitle(Title)
    Prompt:updateButtons(Buttons)
    Prompt:setParent(Screen)
    RunService:SetRobloxGuiFocused(true)
    Prompt:_open(Message)
    return Prompt, Screen
end

return function(Title, Message, Buttons, RichText)
    if useOriginal then
        local ok, result, screen = pcall(function()
            return BuildOriginalPrompt(Title, Message, Buttons, RichText)
        end)
        if ok then
            return result, screen
        end
    end

    return BuildFallbackPrompt(Title, Message, Buttons, RichText)
end
