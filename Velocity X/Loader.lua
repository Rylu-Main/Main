-- ========== PREVENT DUPLICATE LOADER ==========
if getgenv().Velocity_X_Loader then
    local Notify
    pcall(function()
        Notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Nofication/BocusLuke.lua"))()
    end)
    if Notify then
        pcall(function()
            Notify:Notify({
                Title = "Velocity X",
                Description = "This session is already loaded. Do you want to delete the config file?",
            }, {
                OutlineColor = Color3.fromRGB(255, 80, 80),
                Time = 10,
                Type = "option",
            }, {
                Callback = function(choice)
                    if choice then
                        local CONFIG_FILE = "Velocity X/VelocityX_Settings.json"
                        local deleted = false
                        if isfile and delfile then
                            pcall(function()
                                if isfile(CONFIG_FILE) then
                                    delfile(CONFIG_FILE)
                                    deleted = true
                                    getgenv().Velocity_X_Loader = false
                                end
                            end)
                        end
                        if deleted then
                            pcall(function()
                                Notify:Notify({
                                    Title = "Config Deleted",
                                    Description = "Settings file has been removed.",
                                }, {
                                    OutlineColor = Color3.fromRGB(255, 100, 100),
                                    Time = 3,
                                    Type = "default",
                                }, {
                                    Image = "rbxassetid://103887859853708",
                                    ImageColor = Color3.fromRGB(255, 255, 255),
                                })
                            end)
                        end
                    else
                        pcall(function()
                            Notify:Notify({
                                Title = "Loader Already Running",
                                Description = "Velocity X is already active in this session.",
                            }, {
                                OutlineColor = Color3.fromRGB(255, 50, 50),
                                Time = 4,
                                Type = "default",
                            }, {
                                Image = "rbxassetid://103887859853708",
                                ImageColor = Color3.fromRGB(255, 255, 255),
                            })
                        end)
                    end
                end
            })
        end)
    else
        warn("Velocity X is already active.")
    end
    return
end
getgenv().Velocity_X_Loader = true

-- ========== NOTIFICATION LIBRARY ==========
local Notify
pcall(function()
    Notify = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Nofication/BocusLuke.lua"))()
end)

local function showNotification(title, desc, outlineColor, duration, imageId)
    if Notify then
        pcall(function()
            Notify:Notify({
                Title = title,
                Description = desc,
            }, {
                OutlineColor = outlineColor or Color3.fromRGB(0, 170, 255),
                Time = duration or 4,
                Type = "default",
            }, {
                Image = imageId or "rbxassetid://103887859853708",
                ImageColor = Color3.fromRGB(255, 255, 255),
            })
        end)
    else
        warn(title .. ": " .. desc)
    end
end

-- ========== UTILITIES ==========
local function randomString(len)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local str = ""
    for i = 1, len do
        local r = math.random(1, #chars)
        str = str .. chars:sub(r, r)
    end
    return str
end

-- ========== TIME-BASED EMOJI ==========
local function ThisActuallyCool()
    local currentTime = os.date("*t")
    local hour = currentTime.hour

    if hour >= 6 and hour < 12 then
        return "🌅"
    elseif hour >= 12 and hour < 15 then
        return "☀️🕛"
    elseif hour >= 15 and hour < 18 then
        return "🌞"
    elseif hour >= 18 or hour < 6 then
        return "🌙"
    else
        return "🌄"
    end
end

local cloneref = cloneref or function(obj) return obj end
local CoreGui = cloneref(game:GetService("CoreGui"))
local HttpService = cloneref(game:GetService("HttpService"))
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- ========== MAIN GUI ==========
local RealZzHub = Instance.new("ScreenGui")
RealZzHub.Name = "Velocity_" .. randomString(10)
RealZzHub.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(RealZzHub)
        RealZzHub.Parent = CoreGui
    elseif gethui then
        RealZzHub.Parent = gethui()
    else
        RealZzHub.Parent = CoreGui
    end
end)

local MainBackground = Instance.new("ImageLabel", RealZzHub)
MainBackground.AnchorPoint = Vector2.new(0.5, 0.5)
MainBackground.Position = UDim2.new(0.5, 0, 0.5, 0)
MainBackground.Size = UDim2.new(0, 1, 0, 1)
MainBackground.Image = "rbxassetid://7877641241"
MainBackground.BackgroundColor3 = Color3.new(1, 1, 1)
MainBackground.BorderSizePixel = 0
MainBackground.Visible = false
MainBackground.ImageTransparency = 1

local Gradient = Instance.new("UIGradient", MainBackground)
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255))
}
Gradient.Rotation = 45

local ShadowStroke = Instance.new("UIStroke", MainBackground)
ShadowStroke.Color = Color3.fromRGB(0, 100, 150)
ShadowStroke.Thickness = 4.5
ShadowStroke.Transparency = 0.6

local EdgeStroke = Instance.new("UIStroke", MainBackground)
EdgeStroke.Thickness = 3.5
EdgeStroke.Transparency = 0.3

local colorGreen = Color3.fromRGB(0, 255, 120)
local colorBlue = Color3.fromRGB(0, 170, 255)

local startTime = tick()
local cycleDuration = 4

spawn(function()
    while MainBackground and MainBackground.Parent do
        pcall(function()
            local t = (tick() - startTime) / cycleDuration
            local factor = (math.sin(t * math.pi * 2) + 1) / 2
            local r = colorGreen.R + (colorBlue.R - colorGreen.R) * factor
            local g = colorGreen.G + (colorBlue.G - colorGreen.G) * factor
            local b = colorGreen.B + (colorBlue.B - colorGreen.B) * factor
            EdgeStroke.Color = Color3.new(r, g, b)
        end)
        RunService.Heartbeat:Wait()
    end
end)

local Corner = Instance.new("UICorner", MainBackground)
Corner.CornerRadius = UDim.new(0, 8)

local Logo = Instance.new("ImageButton", MainBackground)
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0, 6, 0, 6)
Logo.Size = UDim2.new(0, 25, 0, 25)
Logo.Image = "rbxassetid://103887859853708"
Logo.Visible = false

local Name = Instance.new("TextLabel", MainBackground)
Name.BackgroundTransparency = 1
Name.Position = UDim2.new(0.11, 0, 0.04, 0)
Name.Size = UDim2.new(0, 78, 0, 25)
Name.Font = Enum.Font.Arcade
Name.Text = "Velocity X Loader"
Name.TextSize = 15
Name.TextXAlignment = Enum.TextXAlignment.Left
Name.TextColor3 = Color3.fromRGB(0, 255, 150)
Name.TextStrokeTransparency = 0
Name.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Name.Visible = false

local InjectButton = Instance.new("TextButton", MainBackground)
InjectButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
InjectButton.BackgroundTransparency = 1
InjectButton.Position = UDim2.new(0.11, 0, 0.33, 0)
InjectButton.Size = UDim2.new(0, 252, 0, 47)
InjectButton.Font = Enum.Font.Arcade
InjectButton.Text = "Initializing..."
InjectButton.TextScaled = true
InjectButton.TextColor3 = Color3.new(0, 0, 0)
InjectButton.Visible = false

Instance.new("UICorner", InjectButton).CornerRadius = UDim.new(0, 4)

local BtnGradient = Instance.new("UIGradient", InjectButton)
BtnGradient.Color = Gradient.Color
BtnGradient.Rotation = 90

local BtnStroke = Instance.new("UIStroke", InjectButton)
BtnStroke.Color = Color3.fromRGB(0, 255, 150)
BtnStroke.Thickness = 1.5

local Version = Instance.new("TextLabel", MainBackground)
Version.BackgroundTransparency = 1
Version.Position = UDim2.new(0.26, 0, 0.86, 0)
Version.Size = UDim2.new(0, 227, 0, 21)
Version.Font = Enum.Font.Arcade
Version.Text = "Loading..."
Version.TextSize = 13
Version.TextXAlignment = Enum.TextXAlignment.Right
Version.TextColor3 = Color3.fromRGB(0, 200, 255)
Version.TextStrokeTransparency = 0
Version.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
Version.Visible = false

-- Time emoji label
local TimeEmoji = Instance.new("TextLabel", MainBackground)
TimeEmoji.BackgroundTransparency = 1
TimeEmoji.Position = UDim2.new(0.02, 0, 0.86, 0)
TimeEmoji.Size = UDim2.new(0, 40, 0, 21)
TimeEmoji.Font = Enum.Font.Arcade
TimeEmoji.Text = ThisActuallyCool()
TimeEmoji.TextSize = 18
TimeEmoji.TextXAlignment = Enum.TextXAlignment.Left
TimeEmoji.TextColor3 = Color3.fromRGB(0, 255, 150)
TimeEmoji.TextStrokeTransparency = 0
TimeEmoji.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
TimeEmoji.Visible = false
local EmojiStroke = Instance.new("UIStroke", TimeEmoji)
EmojiStroke.Color = Color3.fromRGB(0, 200, 255)
EmojiStroke.Thickness = 1
EmojiStroke.Transparency = 0.4

local CloseButton = Instance.new("TextButton", MainBackground)
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(0.928, 0, 0, -2)
CloseButton.Rotation = 45
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Font = Enum.Font.Arcade
CloseButton.Text = "+"
CloseButton.TextSize = 29
CloseButton.Visible = false

local SettingsIcon = Instance.new("ImageButton", MainBackground)
SettingsIcon.BackgroundTransparency = 1
SettingsIcon.Position = UDim2.new(0.85, 0, 0.01, 0)
SettingsIcon.Size = UDim2.new(0, 22, 0, 22)
SettingsIcon.Image = "rbxassetid://101339235267993"
SettingsIcon.Visible = false
SettingsIcon.ImageTransparency = 0.2

-- ==================== CREATE CONFIRMATION DIALOGS EARLY ====================
local ConfirmFrame = Instance.new("ImageLabel", MainBackground)
ConfirmFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ConfirmFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
ConfirmFrame.Size = UDim2.new(0, 200, 0, 100)
ConfirmFrame.Image = "rbxassetid://7877641241"
ConfirmFrame.BackgroundColor3 = Color3.new(1, 1, 1)
ConfirmFrame.BorderSizePixel = 0
ConfirmFrame.Visible = false
ConfirmFrame.ZIndex = 3

local ConfirmGradient = Instance.new("UIGradient", ConfirmFrame)
ConfirmGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255))
}
ConfirmGradient.Rotation = 45
Instance.new("UIStroke", ConfirmFrame).Color = Color3.fromRGB(0, 200, 255)
Instance.new("UIStroke", ConfirmFrame).Thickness = 2
Instance.new("UIStroke", ConfirmFrame).Transparency = 0.3
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 8)

local ConfirmText = Instance.new("TextLabel", ConfirmFrame)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Position = UDim2.new(0, 0, 0.2, 0)
ConfirmText.Size = UDim2.new(1, 0, 0.3, 0)
ConfirmText.Font = Enum.Font.Arcade
ConfirmText.Text = "Are you sure you want\nto close Velocity X?"
ConfirmText.TextSize = 12
ConfirmText.TextColor3 = Color3.fromRGB(0, 255, 150)
ConfirmText.TextStrokeTransparency = 0
ConfirmText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

local YesButton = Instance.new("TextButton", ConfirmFrame)
YesButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
YesButton.BackgroundTransparency = 1
YesButton.Position = UDim2.new(0.15, 0, 0.65, 0)
YesButton.Size = UDim2.new(0, 70, 0, 30)
YesButton.Font = Enum.Font.Arcade
YesButton.Text = "Yes"
YesButton.TextScaled = true
YesButton.TextColor3 = Color3.new(0, 0, 0)
Instance.new("UICorner", YesButton).CornerRadius = UDim.new(0, 4)
local YesGradient = Instance.new("UIGradient", YesButton)
YesGradient.Color = ConfirmGradient.Color
YesGradient.Rotation = 90
Instance.new("UIStroke", YesButton).Color = Color3.fromRGB(0, 255, 150)
Instance.new("UIStroke", YesButton).Thickness = 1.5

local NoButton = Instance.new("TextButton", ConfirmFrame)
NoButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NoButton.BackgroundTransparency = 1
NoButton.Position = UDim2.new(0.55, 0, 0.65, 0)
NoButton.Size = UDim2.new(0, 70, 0, 30)
NoButton.Font = Enum.Font.Arcade
NoButton.Text = "No"
NoButton.TextScaled = true
NoButton.TextColor3 = Color3.new(0, 0, 0)
Instance.new("UICorner", NoButton).CornerRadius = UDim.new(0, 4)
local NoGradient = Instance.new("UIGradient", NoButton)
NoGradient.Color = ConfirmGradient.Color
NoGradient.Rotation = 90
Instance.new("UIStroke", NoButton).Color = Color3.fromRGB(0, 255, 150)
Instance.new("UIStroke", NoButton).Thickness = 1.5

local DeleteConfirmFrame = Instance.new("ImageLabel", MainBackground)
DeleteConfirmFrame.Name = "DeleteConfirmFrame"
DeleteConfirmFrame.AnchorPoint = Vector2.new(0.5, 0.5)
DeleteConfirmFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
DeleteConfirmFrame.Size = UDim2.new(0, 200, 0, 100)
DeleteConfirmFrame.Image = "rbxassetid://7877641241"
DeleteConfirmFrame.BackgroundColor3 = Color3.new(1, 1, 1)
DeleteConfirmFrame.BorderSizePixel = 0
DeleteConfirmFrame.Visible = false
DeleteConfirmFrame.ZIndex = 3

local DeleteConfirmGradient = Instance.new("UIGradient", DeleteConfirmFrame)
DeleteConfirmGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))
}
DeleteConfirmGradient.Rotation = 45
Instance.new("UIStroke", DeleteConfirmFrame).Color = Color3.fromRGB(255, 100, 100)
Instance.new("UIStroke", DeleteConfirmFrame).Thickness = 2
Instance.new("UIStroke", DeleteConfirmFrame).Transparency = 0.3
Instance.new("UICorner", DeleteConfirmFrame).CornerRadius = UDim.new(0, 8)

local DeleteConfirmText = Instance.new("TextLabel", DeleteConfirmFrame)
DeleteConfirmText.BackgroundTransparency = 1
DeleteConfirmText.Position = UDim2.new(0, 0, 0.2, 0)
DeleteConfirmText.Size = UDim2.new(1, 0, 0.3, 0)
DeleteConfirmText.Font = Enum.Font.Arcade
DeleteConfirmText.Text = "Delete config file?"
DeleteConfirmText.TextSize = 12
DeleteConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
DeleteConfirmText.TextStrokeTransparency = 0
DeleteConfirmText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

local DeleteYesButton = Instance.new("TextButton", DeleteConfirmFrame)
DeleteYesButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DeleteYesButton.BackgroundTransparency = 1
DeleteYesButton.Position = UDim2.new(0.15, 0, 0.65, 0)
DeleteYesButton.Size = UDim2.new(0, 70, 0, 30)
DeleteYesButton.Font = Enum.Font.Arcade
DeleteYesButton.Text = "Yes"
DeleteYesButton.TextScaled = true
DeleteYesButton.TextColor3 = Color3.new(0, 0, 0)
Instance.new("UICorner", DeleteYesButton).CornerRadius = UDim.new(0, 4)
local DeleteYesGradient = Instance.new("UIGradient", DeleteYesButton)
DeleteYesGradient.Color = DeleteConfirmGradient.Color
DeleteYesGradient.Rotation = 90
Instance.new("UIStroke", DeleteYesButton).Color = Color3.fromRGB(255, 100, 100)
Instance.new("UIStroke", DeleteYesButton).Thickness = 1.5

local DeleteNoButton = Instance.new("TextButton", DeleteConfirmFrame)
DeleteNoButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
DeleteNoButton.BackgroundTransparency = 1
DeleteNoButton.Position = UDim2.new(0.55, 0, 0.65, 0)
DeleteNoButton.Size = UDim2.new(0, 70, 0, 30)
DeleteNoButton.Font = Enum.Font.Arcade
DeleteNoButton.Text = "No"
DeleteNoButton.TextScaled = true
DeleteNoButton.TextColor3 = Color3.new(0, 0, 0)
Instance.new("UICorner", DeleteNoButton).CornerRadius = UDim.new(0, 4)
local DeleteNoGradient = Instance.new("UIGradient", DeleteNoButton)
DeleteNoGradient.Color = DeleteConfirmGradient.Color
DeleteNoGradient.Rotation = 90
Instance.new("UIStroke", DeleteNoButton).Color = Color3.fromRGB(255, 100, 100)
Instance.new("UIStroke", DeleteNoButton).Thickness = 1.5

-- ==================== SETTINGS PANEL ====================
local SettingsPanel = Instance.new("ImageLabel", MainBackground)
SettingsPanel.AnchorPoint = Vector2.new(1, 0)
SettingsPanel.Position = UDim2.new(0.85, 0, 0.09, 0)
SettingsPanel.Size = UDim2.new(0, 200, 0, 150)
SettingsPanel.Image = "rbxassetid://7877641241"
SettingsPanel.BackgroundColor3 = Color3.new(1, 1, 1)
SettingsPanel.BorderSizePixel = 0
SettingsPanel.Visible = false
SettingsPanel.ZIndex = 2

local PanelGradient = Instance.new("UIGradient", SettingsPanel)
PanelGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255))
}
PanelGradient.Rotation = 45

local PanelStroke = Instance.new("UIStroke", SettingsPanel)
PanelStroke.Color = Color3.fromRGB(0, 200, 255)
PanelStroke.Thickness = 2
PanelStroke.Transparency = 0.3

local PanelCorner = Instance.new("UICorner", SettingsPanel)
PanelCorner.CornerRadius = UDim.new(0, 8)

local PanelTitle = Instance.new("TextLabel", SettingsPanel)
PanelTitle.BackgroundTransparency = 1
PanelTitle.Position = UDim2.new(0, 8, 0, 5)
PanelTitle.Size = UDim2.new(1, -16, 0, 20)
PanelTitle.Font = Enum.Font.Arcade
PanelTitle.Text = "Settings"
PanelTitle.TextColor3 = Color3.fromRGB(0, 255, 150)
PanelTitle.TextSize = 12
PanelTitle.TextXAlignment = Enum.TextXAlignment.Left
PanelTitle.ZIndex = 3

local ScrollingFrame = Instance.new("ScrollingFrame", SettingsPanel)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 30)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -35)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 6
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 150)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ZIndex = 2

local ToggleList = Instance.new("UIListLayout", ScrollingFrame)
ToggleList.Padding = UDim.new(0, 8)
ToggleList.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function addToggle(parent, labelText, defaultValue, callback)
    local toggleFrame = Instance.new("Frame", parent)
    toggleFrame.Size = UDim2.new(0, 180, 0, 25)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.ZIndex = 2
    
    local label = Instance.new("TextLabel", toggleFrame)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 0, 0, 0)
    label.Size = UDim2.new(0, 130, 1, 0)
    label.Font = Enum.Font.Arcade
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 2
    
    local checkFrame = Instance.new("Frame", toggleFrame)
    checkFrame.Name = "Check"
    checkFrame.AnchorPoint = Vector2.new(1, 0.5)
    checkFrame.Position = UDim2.new(1, -5, 0.5, 0)
    checkFrame.Size = UDim2.new(0, 20, 0, 20)
    checkFrame.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    checkFrame.BorderSizePixel = 0
    checkFrame.ZIndex = 2
    
    local inner = Instance.new("Frame", checkFrame)
    inner.AnchorPoint = Vector2.new(0.5, 0.5)
    inner.Position = UDim2.new(0.5, 0, 0.5, 0)
    inner.Size = UDim2.new(1, 0, 1, 0)
    inner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    inner.BackgroundTransparency = 1
    inner.ZIndex = 2
    
    local innerCorner = Instance.new("UICorner", inner)
    innerCorner.CornerRadius = UDim.new(1, 0)
    
    local grad = Instance.new("UIGradient", inner)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255))
    }
    grad.Rotation = 48
    
    local checkCorner = Instance.new("UICorner", checkFrame)
    checkCorner.CornerRadius = UDim.new(1, 0)
    
    local function updateUI(value)
        pcall(function()
            if value then
                TweenService:Create(inner, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0.8, 0, 0.8, 0),
                    BackgroundTransparency = 0
                }):Play()
                TweenService:Create(checkFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                }):Play()
            else
                TweenService:Create(inner, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 0, 0, 0),
                    BackgroundTransparency = 1
                }):Play()
                TweenService:Create(checkFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = Color3.fromRGB(42, 42, 42)
                }):Play()
            end
        end)
    end
    
    local clickBtn = Instance.new("TextButton", toggleFrame)
    clickBtn.Name = "Click"
    clickBtn.BackgroundTransparency = 1
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.Text = ""
    clickBtn.ZIndex = 3
    
    local currentValue = defaultValue
    updateUI(currentValue)
    
    clickBtn.MouseButton1Click:Connect(function()
        currentValue = not currentValue
        updateUI(currentValue)
        if callback then
            pcall(callback, currentValue)
        end
    end)
    
    return {
        Frame = toggleFrame,
        Get = function() return currentValue end,
        Set = function(value)
            if value ~= currentValue then
                currentValue = value
                updateUI(currentValue)
                if callback then
                    pcall(callback, currentValue)
                end
            end
        end
    }
end

-- ========== CONFIGURATION ==========
local CONFIG_FOLDER = "Velocity X"
local CONFIG_FILE = CONFIG_FOLDER .. "/VelocityX_Settings.json"

if makefolder and not isfolder(CONFIG_FOLDER) then
    pcall(makefolder, CONFIG_FOLDER)
end

local config = {
    autoSave = false,
    autoInject = false,
    autoExecutorLoader = false,
    antiAfk = false,
    antiFling = false,
    antiGameplayPause = false
}

local function loadConfig()
    if readfile and isfile then
        pcall(function()
            if isfile(CONFIG_FILE) then
                local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
                config.autoSave = data.autoSave or false
                config.autoInject = data.autoInject or false
                config.autoExecutorLoader = data.autoExecutorLoader or false
                config.antiAfk = data.antiAfk or false
                config.antiFling = data.antiFling or false
                config.antiGameplayPause = data.antiGameplayPause or false
            end
        end)
    end
end

local function saveConfig()
    if writefile and config.autoSave then
        pcall(function()
            local data = HttpService:JSONEncode({
                autoSave = config.autoSave,
                autoInject = config.autoInject,
                autoExecutorLoader = config.autoExecutorLoader,
                antiAfk = config.antiAfk,
                antiFling = config.antiFling,
                antiGameplayPause = config.antiGameplayPause
            })
            writefile(CONFIG_FILE, data)
        end)
    end
end

-- ========== AUTO EXECUTOR LOADER ==========
local function setupAutoExecutorLoader()
    local queueteleport = queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
    if queueteleport then
        spawn(function()
            pcall(function()
                queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/Loader.lua'))()")
            end)
        end)
    else
        showNotification("Executor Not Supported", "queue_on_teleport is not available.", Color3.fromRGB(255, 50, 50), 5)
    end
end

local function setButtonActive(button, active)
    if not button or not button.Parent then return end
    button.Active = active
    if button:IsA("TextButton") then
        button.TextTransparency = active and 0 or 0.5
    elseif button:IsA("ImageButton") then
        button.ImageTransparency = active and 0.2 or 0.6
    end
end

-- ========== SCRIPT URL DETECTION ==========
local scriptUrl = nil
local gameName = "Universal"
local injected = false

local UNIVERSAL_URL = "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/Main/Universal/Main.lua"
local GITHUB_BASE = "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/Main/"
local GITHUB_JSON_URL = "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/config/SupportedGames.json"
local PASTEBIN_JSON_URL = "https://pastebin.com/raw/vYB4r00Z"

local function fetch(url)
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    return success and result or nil
end

local gameId = tostring(game.GameId)

pcall(function()
    local githubData = fetch(GITHUB_JSON_URL .. "?nocache=" .. tick())
    if githubData then
        local json = HttpService:JSONDecode(githubData)
        if json and json[gameId] then
            scriptUrl = GITHUB_BASE .. json[gameId].Path
            gameName = json[gameId].Name
        end
    end
end)

if not scriptUrl then
    pcall(function()
        local pastebinData = fetch(PASTEBIN_JSON_URL .. "?nocache=" .. tick())
        if pastebinData then
            local json = HttpService:JSONDecode(pastebinData)
            if json and json[gameId] then
                local path = json[gameId].Path
                local randomstring = json[gameId].randomstring or ""
                scriptUrl = path .. randomstring
                gameName = json[gameId].Name
            end
        end
    end)
end

if not scriptUrl then
    scriptUrl = UNIVERSAL_URL
    gameName = "Universal"
    showNotification("Using Universal Script", "No game-specific script found.", Color3.fromRGB(0, 170, 255), 3)
else
    showNotification("Game Supported", "Loaded: " .. gameName, Color3.fromRGB(0, 255, 120), 3)
end

InjectButton.Text = gameName .. ".lua"

pcall(function()
    local versionStr = game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/config/version.json")
    Version.Text = "Version: " .. versionStr
end)

local function clearText()
    for _, v in ipairs(MainBackground:GetDescendants()) do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            v.Text = ""
        end
    end
end

-- Cleanup function for anti features
local antiAfkConnection = nil
local antiFlingConnection = nil
local antiGameplayPauseRunning = false
local antiGameplayPauseThread = nil

local function cleanupAntiFeatures()
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
        antiAfkConnection = nil
    end
    if antiFlingConnection then
        antiFlingConnection:Disconnect()
        antiFlingConnection = nil
    end
    antiGameplayPauseRunning = false
    if antiGameplayPauseThread then
        task.cancel(antiGameplayPauseThread)
        antiGameplayPauseThread = nil
    end
end

local function injectScript()
    if injected then return end
    injected = true
    pcall(function()
        loadstring(game:HttpGet(scriptUrl))()
    end)
end

local function performAutoInject()
    if injected then return end
    injectScript()
    InjectButton.Text = "Injecting..."
    TweenService:Create(MainBackground, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        ImageTransparency = 1
    }):Play()
    clearText()
    task.wait(0.35)
    cleanupAntiFeatures()
    if RealZzHub then RealZzHub:Destroy() end
end

-- ========== OPEN ANIMATION ==========
MainBackground.Visible = true
MainBackground.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainBackground, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 318, 0, 150),
    ImageTransparency = 0.2
}):Play()
task.wait(0.4)

CloseButton.Visible = true
InjectButton.Visible = true
Name.Visible = true
Logo.Visible = true
Version.Visible = true
SettingsIcon.Visible = true
TimeEmoji.Visible = true

loadConfig()

-- ========== TOGGLES ==========
local autoSaveCtrl = addToggle(ScrollingFrame, "Auto Save Config", config.autoSave, function(val)
    config.autoSave = val
    if config.autoSave then saveConfig() end
    showNotification("Auto Save Config", val and "Enabled" or "Disabled", Color3.fromRGB(0, 255, 120), 2)
end)

local autoInjectCtrl = addToggle(ScrollingFrame, "Auto Inject", config.autoInject, function(val)
    config.autoInject = val
    if config.autoSave then saveConfig() end
    showNotification("Auto Inject", val and "Enabled" or "Disabled", Color3.fromRGB(0, 255, 120), 2)
    if val and not injected then
        performAutoInject()
    end
end)

local autoLoaderCtrl = addToggle(ScrollingFrame, "Auto Executor Loader", config.autoExecutorLoader, function(val)
    config.autoExecutorLoader = val
    if config.autoSave then saveConfig() end
    showNotification("Auto Executor Loader", val and "Enabled" or "Disabled", Color3.fromRGB(0, 255, 120), 2)
    if val then
        setupAutoExecutorLoader()
    end
end)

-- ANTI AFK TOGGLE
local antiAfkCtrl = addToggle(ScrollingFrame, "Anti AFK", config.antiAfk, function(val)
    config.antiAfk = val
    if config.autoSave then saveConfig() end
    if val then
        if not antiAfkConnection then
            antiAfkConnection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                pcall(function()
                    game:GetService("VirtualUser"):CaptureController()
                    game:GetService("VirtualUser"):ClickButton2(Vector2.new())
                end)
            end)
        end
    else
        if antiAfkConnection then
            antiAfkConnection:Disconnect()
            antiAfkConnection = nil
        end
    end
    showNotification("Anti AFK", val and "Enabled" or "Disabled", Color3.fromRGB(0, 255, 120), 2)
end)

-- ANTI FLING TOGGLE
local antiFlingCtrl = addToggle(ScrollingFrame, "Anti Fling", config.antiFling, function(val)
    config.antiFling = val
    if config.autoSave then saveConfig() end
    if val then
        if not antiFlingConnection then
            antiFlingConnection = game:GetService("RunService").Stepped:Connect(function()
                local localPlayer = game:GetService("Players").LocalPlayer
                for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                    if player ~= localPlayer and player.Character then
                        for _, v in pairs(player.Character:GetDescendants()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end
    else
        if antiFlingConnection then
            antiFlingConnection:Disconnect()
            antiFlingConnection = nil
        end
    end
    showNotification("Anti Fling", val and "Enabled" or "Disabled", Color3.fromRGB(0, 255, 120), 2)
end)

-- ANTI GAMEPLAY PAUSE TOGGLE
local antiGameplayPauseCtrl = addToggle(ScrollingFrame, "Anti Gameplay Pause", config.antiGameplayPause, function(val)
    config.antiGameplayPause = val
    if config.autoSave then saveConfig() end
    if val then
        if not antiGameplayPauseRunning then
            antiGameplayPauseRunning = true
            antiGameplayPauseThread = task.spawn(function()
                while antiGameplayPauseRunning do
                    pcall(function()
                        game:GetService("Players").LocalPlayer.GameplayPaused = false
                    end)
                    task.wait()
                end
            end)
        end
    else
        antiGameplayPauseRunning = false
        if antiGameplayPauseThread then
            task.cancel(antiGameplayPauseThread)
            antiGameplayPauseThread = nil
        end
    end
    showNotification("Anti Gameplay Pause", val and "Enabled" or "Disabled", Color3.fromRGB(0, 255, 120), 2)
end)

local deleteConfigButton = Instance.new("TextButton")
deleteConfigButton.Name = "DeleteConfigButton"
deleteConfigButton.Size = UDim2.new(0, 180, 0, 30)
deleteConfigButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
deleteConfigButton.BackgroundTransparency = 0.9
deleteConfigButton.BorderSizePixel = 0
deleteConfigButton.Font = Enum.Font.Arcade
deleteConfigButton.Text = "Delete Config"
deleteConfigButton.TextColor3 = Color3.fromRGB(255, 100, 100)
deleteConfigButton.TextSize = 12
deleteConfigButton.ZIndex = 2

Instance.new("UICorner", deleteConfigButton).CornerRadius = UDim.new(0, 4)
local delBtnStroke = Instance.new("UIStroke", deleteConfigButton)
delBtnStroke.Color = Color3.fromRGB(255, 100, 100)
delBtnStroke.Thickness = 1.5
delBtnStroke.Transparency = 0.5

deleteConfigButton.Parent = ScrollingFrame

local function updateCanvasSize()
    local totalHeight = 0
    for _, child in ipairs(ScrollingFrame:GetChildren()) do
        if child:IsA("GuiObject") and child ~= ToggleList then
            totalHeight = totalHeight + child.Size.Y.Offset + 8
        end
    end
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(totalHeight, 150))
end
updateCanvasSize()

local function onPanelOpen()
    updateCanvasSize()
end

-- ========== AUTO ACTIONS ==========
if config.autoInject then
    performAutoInject()
end
if config.autoExecutorLoader then
    setupAutoExecutorLoader()
end

-- Start time emoji updater
spawn(function()
    while RealZzHub and RealZzHub.Parent do
        task.wait(60)
        pcall(function()
            if TimeEmoji and TimeEmoji.Parent then
                TimeEmoji.Text = ThisActuallyCool()
            end
        end)
    end
end)

-- ========== EVENT HANDLERS ==========
InjectButton.MouseButton1Click:Connect(function()
    if not InjectButton.Active then return end
    injectScript()
    InjectButton.Text = "Injecting..."
    TweenService:Create(MainBackground, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        ImageTransparency = 1
    }):Play()
    clearText()
    task.wait(0.35)
    cleanupAntiFeatures()
    if RealZzHub then RealZzHub:Destroy() end
end)

SettingsIcon.MouseButton1Click:Connect(function()
    if not SettingsPanel then return end
    if SettingsPanel.Visible then
        TweenService:Create(SettingsPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            ImageTransparency = 1
        }):Play()
        task.wait(0.15)
        if SettingsPanel then
            SettingsPanel.Visible = false
            SettingsPanel.Size = UDim2.new(0, 200, 0, 150)
            SettingsPanel.ImageTransparency = 0
        end
        if ConfirmFrame and not ConfirmFrame.Visible and DeleteConfirmFrame and not DeleteConfirmFrame.Visible then
            setButtonActive(InjectButton, true)
            setButtonActive(CloseButton, true)
        end
    else
        SettingsPanel.Visible = true
        SettingsPanel.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(SettingsPanel, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 200, 0, 150),
            ImageTransparency = 0
        }):Play()
        setButtonActive(InjectButton, false)
        setButtonActive(CloseButton, false)
        onPanelOpen()
    end
end)

local confirmClosing = false
local function closeConfirmDialog(callback)
    if not ConfirmFrame or not ConfirmFrame.Parent or not ConfirmFrame.Visible or confirmClosing then
        if callback then callback() end
        return
    end
    confirmClosing = true
    local tween = TweenService:Create(ConfirmFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        ImageTransparency = 1
    })
    tween.Completed:Connect(function()
        if ConfirmFrame and ConfirmFrame.Parent then
            ConfirmFrame.Visible = false
            ConfirmFrame.Size = UDim2.new(0, 200, 0, 100)
            ConfirmFrame.ImageTransparency = 0
        end
        confirmClosing = false
        if SettingsPanel and SettingsPanel.Visible then
            setButtonActive(InjectButton, false)
            setButtonActive(CloseButton, false)
            setButtonActive(SettingsIcon, true)
        else
            setButtonActive(InjectButton, true)
            setButtonActive(CloseButton, true)
            setButtonActive(SettingsIcon, true)
        end
        if callback then callback() end
    end)
    tween:Play()
end

CloseButton.MouseButton1Click:Connect(function()
    if not ConfirmFrame or ConfirmFrame.Visible or (DeleteConfirmFrame and DeleteConfirmFrame.Visible) then return end
    setButtonActive(InjectButton, false)
    setButtonActive(CloseButton, false)
    setButtonActive(SettingsIcon, false)
    if SettingsPanel and SettingsPanel.Visible then
        SettingsPanel.Visible = false
        SettingsPanel.Size = UDim2.new(0, 200, 0, 150)
        SettingsPanel.ImageTransparency = 0
    end
    ConfirmFrame.Visible = true
    ConfirmFrame.Size = UDim2.new(0, 0, 0, 0)
    ConfirmFrame.ImageTransparency = 1
    TweenService:Create(ConfirmFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 200, 0, 100),
        ImageTransparency = 0
    }):Play()
end)

YesButton.MouseButton1Click:Connect(function()
    closeConfirmDialog(function()
        clearText()
        TweenService:Create(MainBackground, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            ImageTransparency = 1
        }):Play()
        task.wait(0.3)
        cleanupAntiFeatures()
        if RealZzHub then RealZzHub:Destroy() end
    end)
end)

NoButton.MouseButton1Click:Connect(function()
    closeConfirmDialog()
end)

local deleteConfirmClosing = false
local function closeDeleteConfirmDialog(callback)
    if not DeleteConfirmFrame or not DeleteConfirmFrame.Parent or not DeleteConfirmFrame.Visible or deleteConfirmClosing then
        if callback then callback() end
        return
    end
    deleteConfirmClosing = true
    local tween = TweenService:Create(DeleteConfirmFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        ImageTransparency = 1
    })
    tween.Completed:Connect(function()
        if DeleteConfirmFrame and DeleteConfirmFrame.Parent then
            DeleteConfirmFrame.Visible = false
            DeleteConfirmFrame.Size = UDim2.new(0, 200, 0, 100)
            DeleteConfirmFrame.ImageTransparency = 0
        end
        deleteConfirmClosing = false
        if SettingsPanel and SettingsPanel.Visible then
            setButtonActive(InjectButton, false)
            setButtonActive(CloseButton, false)
            setButtonActive(SettingsIcon, true)
        else
            setButtonActive(InjectButton, true)
            setButtonActive(CloseButton, true)
            setButtonActive(SettingsIcon, true)
        end
        if callback then callback() end
    end)
    tween:Play()
end

deleteConfigButton.MouseButton1Click:Connect(function()
    if (DeleteConfirmFrame and DeleteConfirmFrame.Visible) or (ConfirmFrame and ConfirmFrame.Visible) then return end
    setButtonActive(InjectButton, false)
    setButtonActive(CloseButton, false)
    setButtonActive(SettingsIcon, false)
    DeleteConfirmFrame.Visible = true
    DeleteConfirmFrame.Size = UDim2.new(0, 0, 0, 0)
    DeleteConfirmFrame.ImageTransparency = 1
    TweenService:Create(DeleteConfirmFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 200, 0, 100),
        ImageTransparency = 0
    }):Play()
end)

DeleteYesButton.MouseButton1Click:Connect(function()
    closeDeleteConfirmDialog(function()
        local fileDeleted = false
        if isfile and delfile then
            pcall(function()
                if isfile(CONFIG_FILE) then
                    delfile(CONFIG_FILE)
                    fileDeleted = true
                end
            end)
        end
        if fileDeleted then
            config.autoSave = false
            config.autoInject = false
            config.autoExecutorLoader = false
            config.antiAfk = false
            config.antiFling = false
            config.antiGameplayPause = false
            
            autoSaveCtrl:Set(false)
            autoInjectCtrl:Set(false)
            autoLoaderCtrl:Set(false)
            antiAfkCtrl:Set(false)
            antiFlingCtrl:Set(false)
            antiGameplayPauseCtrl:Set(false)
            
            showNotification("Config Deleted", "Settings file has been removed.", Color3.fromRGB(255, 100, 100), 3)
        end
    end)
end)

DeleteNoButton.MouseButton1Click:Connect(function()
    closeDeleteConfirmDialog()
end)

-- ========== DRAG SYSTEM ==========
local UIS = game:GetService("UserInputService")
local dragging = false
local dragInput, mousePos, framePos

local function update(input)
    local delta = input.Position - mousePos
    MainBackground.Position = UDim2.new(
        framePos.X.Scale,
        framePos.X.Offset + delta.X,
        framePos.Y.Scale,
        framePos.Y.Offset + delta.Y
    )
end

MainBackground.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = MainBackground.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainBackground.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        pcall(update, input)
    end
end)
