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
local cloneref = cloneref or function(obj) return obj end
local CoreGui = cloneref(game:GetService("CoreGui"))
local HttpService = cloneref(game:GetService("HttpService"))
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local CoreGui
if RunService:IsStudio() then
    CoreGui = player.PlayerGui
else
    CoreGui = game:GetService("CoreGui")
end
local gui = Instance.new("ScreenGui")
gui.Name = "Introvert"
gui.Parent = CoreGui
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 999999

local sound = Instance.new("Sound")
sound.Parent = gui
sound.SoundId = "rbxassetid://8745692251"
sound.Volume = 2
sound:Play()

local bg = Instance.new("Frame")
bg.Parent = gui
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.new(0,0,0)
bg.BorderSizePixel = 0

local image = Instance.new("ImageLabel")
image.Parent = gui
image.BackgroundTransparency = 1
image.Image = "rbxassetid://103887859853708"
image.Size = UDim2.new(0,0,0,0)
image.Position = UDim2.new(0.5,0,0.5,0)
image.AnchorPoint = Vector2.new(0.5,0.5)
image.ImageTransparency = 1
image.Rotation = -180
image.ZIndex = 5

local glow = Instance.new("ImageLabel")
glow.Parent = gui
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://5028857084"
glow.Size = UDim2.new(0,0,0,0)
glow.Position = UDim2.new(0.5,0,0.5,0)
glow.AnchorPoint = Vector2.new(0.5,0.5)
glow.ImageTransparency = 1
glow.ZIndex = 4

local title = Instance.new("TextLabel")
title.Parent = gui
title.BackgroundTransparency = 1
title.Size = UDim2.new(1,0,0.1,0)
title.Position = UDim2.new(0,-1000,0.37,0)

title.Text = "Velocity X Loader V.1.1"
title.Font = Enum.Font.Arcade
title.TextScaled = true
title.TextTransparency = 1
title.TextColor3 = Color3.fromRGB(255,215,0)
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = Color3.fromRGB(120,80,0)
title.ZIndex = 10

local sub = Instance.new("TextLabel")
sub.Parent = gui
sub.BackgroundTransparency = 1
sub.Size = UDim2.new(1,0,0.05,0)
sub.Position = UDim2.new(0,1000,0.47,0)

sub.Text = "UwU Does need furry?"
sub.Font = Enum.Font.Arcade
sub.TextScaled = true
sub.TextColor3 = Color3.fromRGB(255,255,255)
sub.TextTransparency = 1
sub.ZIndex = 10

local barBg = Instance.new("Frame")
barBg.Parent = gui
barBg.Size = UDim2.new(0.4,0,0.015,0)
barBg.Position = UDim2.new(0.3,0,0.7,0)
barBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
barBg.BorderSizePixel = 0
barBg.Visible = false

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1,0)
corner.Parent = barBg

local bar = Instance.new("Frame")
bar.Parent = barBg
bar.Size = UDim2.new(0,0,1,0)
bar.BorderSizePixel = 0

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(1,0)
corner2.Parent = bar

local barGradient = Instance.new("UIGradient")
barGradient.Parent = bar

local progressText = Instance.new("TextLabel")
progressText.Parent = gui
progressText.BackgroundTransparency = 1
progressText.Size = UDim2.new(0.4,0,0.03,0)
progressText.Position = UDim2.new(0.3,0,0.725,0)

progressText.Font = Enum.Font.Code
progressText.TextScaled = true
progressText.TextColor3 = Color3.fromRGB(255,255,255)
progressText.TextStrokeTransparency = 0.4
progressText.TextStrokeColor3 = Color3.fromRGB(120,80,0)
progressText.Text = "0/100"
progressText.ZIndex = 20

local progressGradient = Instance.new("UIGradient")
progressGradient.Parent = progressText

local flash = Instance.new("Frame")
flash.Parent = gui
flash.Size = UDim2.new(1,0,1,0)
flash.BackgroundColor3 = Color3.new(1,1,1)
flash.BackgroundTransparency = 1
flash.ZIndex = 100

local goldGradient = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255,215,0)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255,240,150)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255,220,50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,170,0))
}

barGradient.Color = goldGradient
progressGradient.Color = goldGradient

task.spawn(function()
    while gui.Parent do
        barGradient.Rotation += 1
        progressGradient.Rotation += 1

        barGradient.Offset = Vector2.new(math.sin(tick()) * 0.3,0)
        progressGradient.Offset = Vector2.new(math.sin(tick()) * 0.3,0)

        task.wait()
    end
end)

TweenService:Create(
    flash,
    TweenInfo.new(0.15),
    {BackgroundTransparency = 0.4}
):Play()

task.wait(0.15)

TweenService:Create(
    flash,
    TweenInfo.new(0.5),
    {BackgroundTransparency = 1}
):Play()

TweenService:Create(
    image,
    TweenInfo.new(
        1.5,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ),
    {
        Size = UDim2.new(0,500,0,500),
        Rotation = 0,
        ImageTransparency = 0
    }
):Play()

TweenService:Create(
    glow,
    TweenInfo.new(
        1.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ),
    {
        Size = UDim2.new(0,700,0,700),
        ImageTransparency = 0.5
    }
):Play()

task.wait(0.3)

TweenService:Create(
    title,
    TweenInfo.new(
        1,
        Enum.EasingStyle.Exponential,
        Enum.EasingDirection.Out
    ),
    {
        Position = UDim2.new(0,0,0.37,0),
        TextTransparency = 0
    }
):Play()

task.wait(0.2)

TweenService:Create(
    sub,
    TweenInfo.new(
        1,
        Enum.EasingStyle.Exponential,
        Enum.EasingDirection.Out
    ),
    {
        Position = UDim2.new(0,0,0.47,0),
        TextTransparency = 0
    }
):Play()

task.wait(0.5)

barBg.Visible = true


task.spawn(function()
    for i = 0,100 do
        progressText.Text = i.."/100"

        bar.Size = UDim2.new(i/100,0,1,0)

        task.wait(0.03)
    end

    
    progressText.Text = "Loaded!"

    TweenService:Create(
        progressText,
        TweenInfo.new(
            0.5,
            Enum.EasingStyle.Back,
            Enum.EasingDirection.Out
        ),
        {
            Rotation = 2
        }
    ):Play()

    -- FLASH EFFECT
    TweenService:Create(
        flash,
        TweenInfo.new(0.2),
        {
            BackgroundTransparency = 0.7
        }
    ):Play()

    task.wait(0.2)

    TweenService:Create(
        flash,
        TweenInfo.new(0.4),
        {
            BackgroundTransparency = 1
        }
    ):Play()
end)

task.spawn(function()
    while gui.Parent do
        TweenService:Create(
            image,
            TweenInfo.new(
                2,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Rotation = 8,
                Size = UDim2.new(0,530,0,530)
            }
        ):Play()

        TweenService:Create(
            glow,
            TweenInfo.new(
                2,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Rotation = -15,
                Size = UDim2.new(0,760,0,760)
            }
        ):Play()

        task.wait(2)

        TweenService:Create(
            image,
            TweenInfo.new(
                2,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Rotation = -8,
                Size = UDim2.new(0,500,0,500)
            }
        ):Play()

        TweenService:Create(
            glow,
            TweenInfo.new(
                2,
                Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut
            ),
            {
                Rotation = 15,
                Size = UDim2.new(0,700,0,700)
            }
        ):Play()

        task.wait(2)
    end
end)

task.wait(4)

TweenService:Create(
    flash,
    TweenInfo.new(0.4),
    {BackgroundTransparency = 0.2}
):Play()

task.wait(0.3)

TweenService:Create(
    image,
    TweenInfo.new(
        1,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.In
    ),
    {
        Size = UDim2.new(0,0,0,0),
        Rotation = 180,
        ImageTransparency = 1
    }
):Play()

TweenService:Create(
    glow,
    TweenInfo.new(1),
    {
        ImageTransparency = 1,
        Size = UDim2.new(0,0,0,0)
    }
):Play()

TweenService:Create(
    title,
    TweenInfo.new(1),
    {
        Position = UDim2.new(0,-1000,0.37,0),
        TextTransparency = 1
    }
):Play()

TweenService:Create(
    sub,
    TweenInfo.new(1),
    {
        Position = UDim2.new(0,1000,0.47,0),
        TextTransparency = 1
    }
):Play()

TweenService:Create(
    barBg,
    TweenInfo.new(1),
    {
        BackgroundTransparency = 1
    }
):Play()

TweenService:Create(
    bar,
    TweenInfo.new(1),
    {
        BackgroundTransparency = 1
    }
):Play()

TweenService:Create(
    progressText,
    TweenInfo.new(1),
    {
        TextTransparency = 1
    }
):Play()

task.wait(1.5)

gui:Destroy()
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

local function randomString(len)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local str = ""
    for i = 1, len do
        local r = math.random(1, #chars)
        str = str .. chars:sub(r, r)
    end
    return str
end

local function GetGreetingAndTime()
    local currentTime = os.date("*t")
    local hour = currentTime.hour
    local minute = currentTime.min
    local emoji = ""
    local greeting = ""

    if hour >= 6 and hour < 12 then
        greeting = "Good Morning"
        emoji = "🌅"
    elseif hour >= 12 and hour < 15 then
        greeting = "Good Noon"
        emoji = "☀️🕛"
    elseif hour >= 15 and hour < 18 then
        greeting = "Good Afternoon"
        emoji = "🌞"
    elseif hour >= 18 or hour < 6 then
        greeting = "Good Night"
        emoji = "🌙"
    else
        greeting = "Hello"
        emoji = "🌄"
    end

    local hour12 = hour % 12
    if hour12 == 0 then hour12 = 12 end
    local ampm = hour < 12 and "AM" or "PM"
    local timeStr = string.format("%02d:%02d %s", hour12, minute, ampm)

    return greeting, emoji, timeStr
end

local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function base64_decode(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

local function decode_obfuscated(obj)
    if type(obj) == "table" then
        local new = {}
        for k, v in pairs(obj) do
            local dec_key = base64_decode(k)
            new[dec_key] = decode_obfuscated(v)
        end
        return new
    elseif type(obj) == "string" then
        return base64_decode(obj)
    else
        return obj
    end
end

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

local GreetingLabel = Instance.new("TextLabel", MainBackground)
GreetingLabel.BackgroundTransparency = 1
GreetingLabel.Position = UDim2.new(0.02, 0, 0.86, 0)
GreetingLabel.Size = UDim2.new(0, 250, 0, 21)
GreetingLabel.Font = Enum.Font.Arcade
GreetingLabel.TextSize = 11
GreetingLabel.TextXAlignment = Enum.TextXAlignment.Left
GreetingLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
GreetingLabel.TextStrokeTransparency = 0
GreetingLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
GreetingLabel.Visible = false
local GreetingStroke = Instance.new("UIStroke", GreetingLabel)
GreetingStroke.Color = Color3.fromRGB(0, 200, 255)
GreetingStroke.Thickness = 1
GreetingStroke.Transparency = 0.4

local function UpdateGreeting()
    local playerName = Players.LocalPlayer.DisplayName
    local greeting, emoji, timeStr = GetGreetingAndTime()
    GreetingLabel.Text = string.format("%s, %s %s %s", greeting, playerName, emoji, timeStr)
end

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

local function clearTeleportQueue()
    if clearteleportqueue then pcall(clearteleportqueue) end
    if clear_teleport_queue then pcall(clear_teleport_queue) end
    if clearqueueonteleport then pcall(clearqueueonteleport) end
    if queue_on_teleport then pcall(queue_on_teleport, nil) end
    if fluxus and fluxus.queue_on_teleport then pcall(fluxus.queue_on_teleport, nil) end
    if syn and syn.queue_on_teleport then pcall(syn.queue_on_teleport, nil) end
    
    if setclipboard then
        pcall(function() setclipboard("") end)
    end
    showNotification("Velocity X", "Auto Executor cleared", Color3.fromRGB(255, 200, 0), 2)
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

local scriptUrl = nil
local gameName = "Universal"
local injected = false

local UNIVERSAL_URL = "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/Main/Universal/Main.lua"
local GITHUB_BASE = "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/Main/"
local GITHUB_JSON_URL = "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/config/SupportedGames.json"
local PASTEBIN_JSON_URL = "https://pastefy.app/IwsPvLXh/raw"

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
            local rawJson = HttpService:JSONDecode(pastebinData)
            local json = decode_obfuscated(rawJson)
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
GreetingLabel.Visible = true

loadConfig()

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
    if val then
        setupAutoExecutorLoader()
        showNotification("Auto Executor Loader", "Enabled – will reload on teleport", Color3.fromRGB(0, 255, 120), 2)
    else
        clearTeleportQueue()
    end
end)

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

local antiGameplayPauseCtrl = addToggle(ScrollingFrame, "Anti Gameplay Pause", config.antiGameplayPause, function(val)
    config.antiGameplayPause = val
    if config.autoSave then saveConfig() end
    if val then
        if not antiGameplayPauseRunning then
            antiGameplayPauseRunning = true
            antiGameplayPauseThread = task.spawn(function()
                while antiGameplayPauseRunning do
                    pcall(function()
                        game:GetService("GuiService"):SetGameplayPausedNotificationEnabled(false)
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

if config.autoInject then
    performAutoInject()
end
if config.autoExecutorLoader then
    setupAutoExecutorLoader()
end

UpdateGreeting()
spawn(function()
    while RealZzHub and RealZzHub.Parent do
        task.wait(60)
        pcall(UpdateGreeting)
    end
end)

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
