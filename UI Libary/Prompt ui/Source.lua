local cloneref = cloneref or function(i) return i end

local RunService = cloneref(game:GetService("RunService"))
local CoreGui = cloneref(game:GetService("CoreGui"))

local function NewScreen(ScreenName)
    local Screen = Instance.new("ScreenGui")
    Screen.Name = ScreenName
    Screen.ResetOnSpawn = false
    Screen.IgnoreGuiInset = true
    pcall(function()
        sethiddenproperty(Screen, "OnTopOfCoreBlur", true)
    end)
    Screen.Parent = CoreGui
    return Screen
end

local ErrorPrompt = nil
local useOriginal = false

local ok = pcall(function()
    ErrorPrompt = getrenv().require(CoreGui.RobloxGui.Modules.ErrorPrompt)
    useOriginal = true
end)

if useOriginal then
    warn("Using original ErrorPrompt UI")
else
    warn("⚠ ErrorPrompt failed, using fallback UI")
end

local function BuildFallbackPrompt(Title, Message, Buttons, RichText)
    local Screen = NewScreen("Prompt")
    local Overlay = Instance.new("Frame")
    Overlay.Size = UDim2.new(1, 0, 1, 0)
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.45
    Overlay.BorderSizePixel = 0
    Overlay.Parent = Screen

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 420, 0, 220)
    Frame.Position = UDim2.new(0.5, -210, 0.5, -110)
    Frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    Frame.BorderSizePixel = 0
    Frame.Parent = Screen
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 48)
    TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Frame
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -10, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 17
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    local MsgLabel = Instance.new("TextLabel")
    MsgLabel.Size = UDim2.new(1, -20, 0, 110)
    MsgLabel.Position = UDim2.new(0, 10, 0, 55)
    MsgLabel.BackgroundTransparency = 1
    MsgLabel.Text = Message
    MsgLabel.TextColor3 = Color3.fromRGB(195, 195, 195)
    MsgLabel.TextSize = 14
    MsgLabel.Font = Enum.Font.Gotham
    MsgLabel.TextWrapped = true
    MsgLabel.RichText = RichText or false
    MsgLabel.TextXAlignment = Enum.TextXAlignment.Left
    MsgLabel.Parent = Frame

  
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Size = UDim2.new(1, -20, 0, 38)
    ButtonFrame.Position = UDim2.new(0, 10, 1, -48)
    ButtonFrame.BackgroundTransparency = 1
    ButtonFrame.Parent = Frame

    local UIList = Instance.new("UIListLayout")
    UIList.FillDirection = Enum.FillDirection.Horizontal
    UIList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    UIList.VerticalAlignment = Enum.VerticalAlignment.Center
    UIList.Padding = UDim.new(0, 8)
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
        Btn.Size = UDim2.new(0, 145, 0, 32)
        Btn.BackgroundColor3 = Button.Primary
            and Color3.fromRGB(0, 120, 215)
            or Color3.fromRGB(55, 55, 55)
        Btn.Text = Button.Text or "OK"
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn.TextSize = 13
        Btn.Font = Enum.Font.GothamSemibold
        Btn.BorderSizePixel = 0
        Btn.Parent = ButtonFrame
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

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
        else
            warn("⚠️ Original ErrorPrompt call failed, switching to fallback: " .. tostring(result))
        end
    end
    return BuildFallbackPrompt(Title, Message, Buttons, RichText)
end
