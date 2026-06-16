--!nonstrict
-- ── Already-running guard ────────────────────────────────────────────────────
if getgenv().Velocity_X_Loader then
    local Notify: any = nil
    pcall(function()
        Notify = loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Nofication/BocusLuke.lua"
        ))()
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
                Callback = function(choice: boolean)
                    if choice then
                        local CONFIG_FILE: string = "Velocity X/VelocityX_Settings.json"
                        local deleted: boolean = false
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
-- // cloneref polyfill for executors that don't support it
if not cloneref then
    local _probe: Part = Instance.new("Part")
    local _instanceList: { [any]: any }? = nil

    for _: any, _tbl: any in getreg() do
        if type(_tbl) == "table" and #_tbl >= 0 then
            if rawget(_tbl, "__mode") == "kvs" then
                for _k: any, _v: any in _tbl do
                    if _v == _probe then
                        _instanceList = _tbl
                        break
                    end
                end
            end
        end
        if _instanceList then break end
    end

    local function _invalidate(obj: Instance): Instance?
        if not _instanceList then return obj end
        for k: any, v: any in _instanceList :: { [any]: any } do
            if v == obj then
                (_instanceList :: { [any]: any })[k] = nil
                return obj
            end
        end
        return obj
    end

    getgenv().cloneref = _invalidate
end
local cloneref: (obj: any) -> any = cloneref or function(obj: any): any return obj end
local HttpService  = cloneref(game:GetService("HttpService"))
local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")
local Players      = game:GetService("Players")
local player       = Players.LocalPlayer

-- ── CoreGui (Studio-safe) ────────────────────────────────────────────────────
local CoreGui: Instance
if RunService:IsStudio() then
    CoreGui = player.PlayerGui
else
    CoreGui = cloneref(game:GetService("CoreGui"))
end

local gui: ScreenGui = Instance.new("ScreenGui")
gui.Name            = "Introvert"
gui.Parent          = CoreGui
gui.IgnoreGuiInset  = true
gui.ResetOnSpawn    = false
gui.DisplayOrder    = 999999

local sound: Sound = Instance.new("Sound")
sound.Parent  = gui
sound.SoundId = "rbxassetid://8745692251"
sound.Volume  = 2

-- ── Early skip-intro check ───────────────────────────────────────────────────
local _earlySkipIntro: boolean = false
pcall(function()
    if readfile and isfile then
        local _cfgPath: string = "Velocity X/VelocityX_Settings.json"
        if isfile(_cfgPath) then
            local _d: any = HttpService:JSONDecode(readfile(_cfgPath))
            _earlySkipIntro = _d and _d.skipIntroUI == true
        end
    end
end)
-- function that start to count who executor my script

local function log()
    task.spawn(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/config/Log.luau"))()
    end)
end

task.spawn(function()
    log()
end)
if not _earlySkipIntro then
    sound:Play()

    local bg: Frame = Instance.new("Frame")
    bg.Parent           = gui
    bg.Size             = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.new(0, 0, 0)
    bg.BorderSizePixel  = 0

    local image: ImageLabel = Instance.new("ImageLabel")
    image.Parent             = gui
    image.BackgroundTransparency = 1
    image.Image              = "rbxassetid://103887859853708"
    image.Size               = UDim2.new(0, 0, 0, 0)
    image.Position           = UDim2.new(0.5, 0, 0.5, 0)
    image.AnchorPoint        = Vector2.new(0.5, 0.5)
    image.ImageTransparency  = 1
    image.Rotation           = -180
    image.ZIndex             = 5

    local glow: ImageLabel = Instance.new("ImageLabel")
    glow.Parent              = gui
    glow.BackgroundTransparency = 1
    glow.Image               = "rbxassetid://5028857084"
    glow.Size                = UDim2.new(0, 0, 0, 0)
    glow.Position            = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint         = Vector2.new(0.5, 0.5)
    glow.ImageTransparency   = 1
    glow.ZIndex              = 4

    local title: TextLabel = Instance.new("TextLabel")
    title.Parent               = gui
    title.BackgroundTransparency = 1
    title.Size                 = UDim2.new(1, 0, 0.1, 0)
    title.Position             = UDim2.new(0, -1000, 0.37, 0)
    title.Text                 = "Velocity X Loader V.1.1"
    title.Font                 = Enum.Font.Arcade
    title.TextScaled           = true
    title.TextTransparency     = 1
    title.TextColor3           = Color3.fromRGB(255, 215, 0)
    title.TextStrokeTransparency = 0
    title.TextStrokeColor3     = Color3.fromRGB(120, 80, 0)
    title.ZIndex               = 10

    local sub: TextLabel = Instance.new("TextLabel")
    sub.Parent               = gui
    sub.BackgroundTransparency = 1
    sub.Size                 = UDim2.new(1, 0, 0.05, 0)
    sub.Position             = UDim2.new(0, 1000, 0.47, 0)
    sub.Text                 = "UwU Does need furry?"
    sub.Font                 = Enum.Font.Arcade
    sub.TextScaled           = true
    sub.TextColor3           = Color3.fromRGB(255, 255, 255)
    sub.TextTransparency     = 1
    sub.ZIndex               = 10

    local barBg: Frame = Instance.new("Frame")
    barBg.Parent           = gui
    barBg.Size             = UDim2.new(0.4, 0, 0.015, 0)
    barBg.Position         = UDim2.new(0.3, 0, 0.7, 0)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    barBg.BorderSizePixel  = 0
    barBg.Visible          = false

    local corner: UICorner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent       = barBg

    local bar: Frame = Instance.new("Frame")
    bar.Parent        = barBg
    bar.Size          = UDim2.new(0, 0, 1, 0)
    bar.BorderSizePixel = 0

    local corner2: UICorner = Instance.new("UICorner")
    corner2.CornerRadius = UDim.new(1, 0)
    corner2.Parent       = bar

    local barGradient: UIGradient = Instance.new("UIGradient")
    barGradient.Parent = bar

    local progressText: TextLabel = Instance.new("TextLabel")
    progressText.Parent               = gui
    progressText.BackgroundTransparency = 1
    progressText.Size                 = UDim2.new(0.4, 0, 0.03, 0)
    progressText.Position             = UDim2.new(0.3, 0, 0.725, 0)
    progressText.Font                 = Enum.Font.Code
    progressText.TextScaled           = true
    progressText.TextColor3           = Color3.fromRGB(255, 255, 255)
    progressText.TextStrokeTransparency = 0.4
    progressText.TextStrokeColor3     = Color3.fromRGB(120, 80, 0)
    progressText.Text                 = "0/100"
    progressText.ZIndex               = 20

    local progressGradient: UIGradient = Instance.new("UIGradient")
    progressGradient.Parent = progressText

    local flash: Frame = Instance.new("Frame")
    flash.Parent               = gui
    flash.Size                 = UDim2.new(1, 0, 1, 0)
    flash.BackgroundColor3     = Color3.new(1, 1, 1)
    flash.BackgroundTransparency = 1
    flash.ZIndex               = 100

    local goldGradient: ColorSequence = ColorSequence.new{
        ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 240, 150)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 220, 50)),
        ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 170, 0)),
    }

    barGradient.Color      = goldGradient
    progressGradient.Color = goldGradient

    task.spawn(function()
        local _gradFrame: number = 0
        while gui.Parent do
            _gradFrame += 1
            if _gradFrame % 4 == 0 then  -- update every 4 frames (~15 fps) – plenty for a gradient
                local t: number = tick()
                barGradient.Rotation      += 4
                progressGradient.Rotation += 4
                barGradient.Offset        = Vector2.new(math.sin(t) * 0.3, 0)
                progressGradient.Offset   = Vector2.new(math.sin(t) * 0.3, 0)
            end
            task.wait()
        end
    end)

    TweenService:Create(flash, TweenInfo.new(0.15), { BackgroundTransparency = 0.4 }):Play()
    task.wait(0.15)
    TweenService:Create(flash, TweenInfo.new(0.5),  { BackgroundTransparency = 1   }):Play()

    TweenService:Create(image, TweenInfo.new(1.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 500, 0, 500), Rotation = 0, ImageTransparency = 0
    }):Play()
    TweenService:Create(glow, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 700, 0, 700), ImageTransparency = 0.5
    }):Play()

    task.wait(0.3)

    TweenService:Create(title, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0.37, 0), TextTransparency = 0
    }):Play()

    task.wait(0.2)

    TweenService:Create(sub, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0.47, 0), TextTransparency = 0
    }):Play()

    task.wait(0.5)
    barBg.Visible = true

    task.spawn(function()
        for i: number = 0, 100 do
            progressText.Text = i .. "/100"
            bar.Size = UDim2.new(i / 100, 0, 1, 0)
            task.wait(0.03)
        end
        progressText.Text = "Loaded!"
        TweenService:Create(progressText, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Rotation = 2
        }):Play()
        TweenService:Create(flash, TweenInfo.new(0.2), { BackgroundTransparency = 0.7 }):Play()
        task.wait(0.2)
        TweenService:Create(flash, TweenInfo.new(0.4), { BackgroundTransparency = 1   }):Play()
    end)

    task.spawn(function()
        while gui.Parent do
            TweenService:Create(image, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Rotation = 8, Size = UDim2.new(0, 530, 0, 530)
            }):Play()
            TweenService:Create(glow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Rotation = -15, Size = UDim2.new(0, 760, 0, 760)
            }):Play()
            task.wait(2)
            TweenService:Create(image, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Rotation = -8, Size = UDim2.new(0, 500, 0, 500)
            }):Play()
            TweenService:Create(glow, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Rotation = 15, Size = UDim2.new(0, 700, 0, 700)
            }):Play()
            task.wait(2)
        end
    end)

    task.wait(4)

    TweenService:Create(flash, TweenInfo.new(0.4), { BackgroundTransparency = 0.2 }):Play()
    task.wait(0.3)

    TweenService:Create(image, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0), Rotation = 180, ImageTransparency = 1
    }):Play()
    TweenService:Create(glow, TweenInfo.new(1), { ImageTransparency = 1, Size = UDim2.new(0, 0, 0, 0) }):Play()
    TweenService:Create(title, TweenInfo.new(1), { Position = UDim2.new(0, -1000, 0.37, 0), TextTransparency = 1 }):Play()
    TweenService:Create(sub, TweenInfo.new(1),   { Position = UDim2.new(0, 1000,  0.47, 0), TextTransparency = 1 }):Play()
    TweenService:Create(barBg, TweenInfo.new(1), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(bar, TweenInfo.new(1),   { BackgroundTransparency = 1 }):Play()
    TweenService:Create(progressText, TweenInfo.new(1), { TextTransparency = 1 }):Play()

    task.wait(1.5)
    gui:Destroy()
end -- end skip-intro guard

if _earlySkipIntro then
    pcall(function() gui:Destroy() end)
end

-- ── Notification library ─────────────────────────────────────────────────────
local Notify: any = nil
local notifyOk: boolean, notifyErr: any = pcall(function()
    local src: string = game:HttpGet(
        "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Nofication/BocusLuke.lua"
    )
    if not src or #src == 0 then error("Empty notification library response") end
    Notify = loadstring(src)()
end)

if not notifyOk then
    print("[VelocityX] ❌ Notification UI failed to load.")
    print("[VelocityX] Reason: " .. tostring(notifyErr))
    print("[VelocityX] Falling back to print-based notifications.")
end

local function showNotification(
    title: string,
    desc: string,
    outlineColor: Color3?,
    duration: number?,
    imageId: string?
)
    if Notify then
        pcall(function()
            Notify:Notify({
                Title       = title,
                Description = desc,
            }, {
                OutlineColor = outlineColor or Color3.fromRGB(0, 170, 255),
                Time         = duration or 4,
                Type         = "default",
            }, {
                Image      = imageId or "rbxassetid://103887859853708",
                ImageColor = Color3.fromRGB(255, 255, 255),
            })
        end)
    else
        -- Notify UI not available — fall back to print
        print("[VelocityX] 🔔 " .. title .. " | " .. desc)
    end
end

-- ── Utility functions ────────────────────────────────────────────────────────
local function randomString(len: number): string
    local chars: string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local str: string = ""
    for _: number = 1, len do
        local r: number = math.random(1, #chars)
        str ..= chars:sub(r, r)
    end
    return str
end

local function GetGreetingAndTime(): (string, string, string)
    local currentTime: any = os.date("*t")
    local hour: number   = currentTime.hour
    local minute: number = currentTime.min
    local greeting: string
    local emoji: string

    if hour >= 6 and hour < 12 then
        greeting = "Good Morning"
        emoji    = "🌅"
    elseif hour >= 12 and hour < 15 then
        greeting = "Good Noon"
        emoji    = "☀️🕛"
    elseif hour >= 15 and hour < 18 then
        greeting = "Good Afternoon"
        emoji    = "🌞"
    elseif hour >= 18 or hour < 6 then
        greeting = "Good Night"
        emoji    = "🌙"
    else
        greeting = "Hello"
        emoji    = "🌄"
    end

    local hour12: number = hour % 12
    if hour12 == 0 then hour12 = 12 end
    local ampm: string   = hour < 12 and "AM" or "PM"
    local timeStr: string = string.format("%02d:%02d %s", hour12, minute, ampm)

    return greeting, emoji, timeStr
end

-- ── Base64 decoder (fast lookup-table, no per-char string ops) ───────────────
-- Pre-built decode table: char → 6-bit value
local _b64chars: string = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local _b64lut: { [number]: number } = {}
for i: number = 1, #_b64chars do
    _b64lut[string.byte(_b64chars, i)] = i - 1
end

local function base64_decode(data: string): string
    -- Strip any character not in the base64 alphabet (including whitespace / newlines)
    data = data:gsub("[^A-Za-z0-9+/=]", "")
    local out: { string } = {}
    local len: number = #data
    local i:   number = 1
    while i <= len do
        local b0: number = _b64lut[string.byte(data, i)]     or 0
        local b1: number = _b64lut[string.byte(data, i + 1)] or 0
        local b2: number = _b64lut[string.byte(data, i + 2)] or 0
        local b3: number = _b64lut[string.byte(data, i + 3)] or 0
        local n:  number = (b0 * 0x40000) + (b1 * 0x1000) + (b2 * 0x40) + b3
        out[#out + 1] = string.char(
            math.floor(n / 0x10000) % 256,
            math.floor(n / 0x100)   % 256,
            n % 256
        )
        i += 4
    end
    local result: string = table.concat(out)
    -- Trim padding bytes introduced by "=" characters
    local pad: number = 0
    if data:sub(-1) == "=" then pad += 1 end
    if data:sub(-2, -2) == "=" then pad += 1 end
    return pad > 0 and result:sub(1, #result - pad) or result
end

-- Only attempt decode on strings that look like valid base64 (length multiple of 4,
-- contains only b64 alphabet). This avoids pointlessly decoding plain-text values.
local _b64Pattern: string = "^[A-Za-z0-9+/]+=?=?$"
local function _isBase64(s: string): boolean
    return (#s > 0) and (#s % 4 == 0) and (s:match(_b64Pattern) ~= nil)
end

local function decode_obfuscated(obj: any): any
    if type(obj) == "table" then
        local new: { [any]: any } = {}
        for k: any, v: any in obj do
            local sk: string = tostring(k)
            local dk: string = _isBase64(sk) and base64_decode(sk) or sk
            new[dk] = decode_obfuscated(v)
        end
        return new
    elseif type(obj) == "string" then
        local s: string = obj :: string
        return _isBase64(s) and base64_decode(s) or s
    end
    return obj
end

-- ── Main GUI ScreenGui ───────────────────────────────────────────────────────
local RealZzHub: ScreenGui = Instance.new("ScreenGui")
RealZzHub.Name            = "Velocity_" .. randomString(10)
RealZzHub.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling

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

-- ── MainBackground ───────────────────────────────────────────────────────────
local MainBackground: ImageLabel = Instance.new("ImageLabel", RealZzHub)
MainBackground.AnchorPoint        = Vector2.new(0.5, 0.5)
MainBackground.Position           = UDim2.new(0.5, 0, 0.5, 0)
MainBackground.Size               = UDim2.new(0, 1, 0, 1)
MainBackground.Image              = "rbxassetid://7877641241"
MainBackground.BackgroundColor3   = Color3.new(1, 1, 1)
MainBackground.BorderSizePixel    = 0
MainBackground.ClipsDescendants   = false
MainBackground.Visible            = false
MainBackground.ImageTransparency  = 1

local Gradient: UIGradient = Instance.new("UIGradient", MainBackground)
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255)),
}
Gradient.Rotation = 45

local ShadowStroke: UIStroke = Instance.new("UIStroke", MainBackground)
ShadowStroke.Color       = Color3.fromRGB(0, 100, 150)
ShadowStroke.Thickness   = 4.5
ShadowStroke.Transparency = 0.6

local EdgeStroke: UIStroke = Instance.new("UIStroke", MainBackground)
EdgeStroke.Thickness   = 3.5
EdgeStroke.Transparency = 0.3

local colorGreen: Color3 = Color3.fromRGB(0, 255, 120)
local colorBlue:  Color3 = Color3.fromRGB(0, 170, 255)
local startTime:  number = tick()
local cycleDuration: number = 4

task.spawn(function()
    local _strokeFrame: number = 0
    while MainBackground and MainBackground.Parent do
        _strokeFrame += 1
        if _strokeFrame % 3 == 0 then  -- ~20 fps is more than enough for a smooth color cycle
            pcall(function()
                local t: number      = (tick() - startTime) / cycleDuration
                local factor: number = (math.sin(t * math.pi * 2) + 1) / 2
                local r: number = colorGreen.R + (colorBlue.R - colorGreen.R) * factor
                local g: number = colorGreen.G + (colorBlue.G - colorGreen.G) * factor
                local bv: number = colorGreen.B + (colorBlue.B - colorGreen.B) * factor
                EdgeStroke.Color = Color3.new(r, g, bv)
            end)
        end
        RunService.Heartbeat:Wait()
    end
end)

local Corner: UICorner = Instance.new("UICorner", MainBackground)
Corner.CornerRadius = UDim.new(0, 8)

local Logo: ImageButton = Instance.new("ImageButton", MainBackground)
Logo.BackgroundTransparency = 1
Logo.Position = UDim2.new(0, 6, 0, 6)
Logo.Size     = UDim2.new(0, 25, 0, 25)
Logo.Image    = "rbxassetid://103887859853708"
Logo.Visible  = false

local Name: TextLabel = Instance.new("TextLabel", MainBackground)
Name.BackgroundTransparency = 1
Name.Position             = UDim2.new(0.11, 0, 0.035, 0)
Name.Size                 = UDim2.new(0.72, 0, 0, 20)
Name.Font                 = Enum.Font.Arcade
Name.Text                 = "Velocity X Loader"
Name.TextSize             = 14
Name.TextXAlignment       = Enum.TextXAlignment.Left
Name.TextColor3           = Color3.fromRGB(0, 255, 150)
Name.TextStrokeTransparency = 0
Name.TextStrokeColor3     = Color3.fromRGB(0, 0, 0)
Name.Visible              = false

local InjectButton: TextButton = Instance.new("TextButton", MainBackground)
InjectButton.BackgroundColor3     = Color3.fromRGB(255, 255, 255)
InjectButton.BackgroundTransparency = 1
InjectButton.AnchorPoint          = Vector2.new(0.5, 0.5)
InjectButton.Position             = UDim2.new(0.5, 0, 0.46, 0)
InjectButton.Size                 = UDim2.new(0.82, 0, 0, 48)
InjectButton.Font                 = Enum.Font.Arcade
InjectButton.Text                 = "Initializing..."
InjectButton.TextScaled           = true
InjectButton.TextColor3           = Color3.new(0, 0, 0)
InjectButton.Visible              = false

Instance.new("UICorner", InjectButton).CornerRadius = UDim.new(0, 4)

local BtnGradient: UIGradient = Instance.new("UIGradient", InjectButton)
BtnGradient.Color    = Gradient.Color
BtnGradient.Rotation = 90

local BtnStroke: UIStroke = Instance.new("UIStroke", InjectButton)
BtnStroke.Color     = Color3.fromRGB(0, 255, 150)
BtnStroke.Thickness = 1.5

local Version: TextLabel = Instance.new("TextLabel", MainBackground)
Version.BackgroundTransparency = 1
Version.AnchorPoint        = Vector2.new(1, 1)
Version.Position           = UDim2.new(0.99, 0, 0.985, 0)
Version.Size               = UDim2.new(0.36, 0, 0, 14)
Version.Font               = Enum.Font.Arcade
Version.Text               = "Loading..."
Version.TextSize           = 11
Version.TextXAlignment     = Enum.TextXAlignment.Right
Version.TextColor3         = Color3.fromRGB(0, 200, 255)
Version.TextStrokeTransparency = 0.4
Version.TextStrokeColor3   = Color3.fromRGB(0, 0, 0)
Version.Visible            = false

-- ── Greeting card (greeting ↔ Discord, clickable) ───────────────────────────
local DISCORD_LINK: string = "https://discord.gg/jc6SAYtVNf"

local GreetingCard: Frame = Instance.new("Frame", MainBackground)
GreetingCard.Name                   = "GreetingCard"
GreetingCard.AnchorPoint            = Vector2.new(0, 1)
GreetingCard.Position               = UDim2.new(0.01, 0, 0.99, 0)
-- Occupies left 60% of the bottom bar, right 40% is Version label
GreetingCard.Size                   = UDim2.new(0.60, 0, 0, 24)
GreetingCard.BackgroundColor3       = Color3.fromRGB(15, 15, 20)
GreetingCard.BackgroundTransparency = 0.30
GreetingCard.BorderSizePixel        = 0
GreetingCard.ClipsDescendants       = true
GreetingCard.Visible                = false

Instance.new("UICorner", GreetingCard).CornerRadius = UDim.new(0, 5)

-- Left colour accent bar
local GCardBar: Frame = Instance.new("Frame", GreetingCard)
GCardBar.Size             = UDim2.new(0, 2, 1, 0)
GCardBar.Position         = UDim2.new(0, 0, 0, 0)
GCardBar.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
GCardBar.BorderSizePixel  = 0
Instance.new("UICorner", GCardBar).CornerRadius = UDim.new(0, 2)

local GCardStroke: UIStroke = Instance.new("UIStroke", GreetingCard)
GCardStroke.Thickness    = 1
GCardStroke.Transparency = 0.55
GCardStroke.Color        = Color3.fromRGB(0, 200, 255)

-- Discord icon (hidden in greeting mode)
local GCardIcon: ImageLabel = Instance.new("ImageLabel", GreetingCard)
GCardIcon.AnchorPoint           = Vector2.new(0, 0.5)
GCardIcon.Position              = UDim2.new(0, 5, 0.5, 0)
GCardIcon.Size                  = UDim2.new(0, 13, 0, 13)
GCardIcon.BackgroundTransparency = 1
GCardIcon.Image                 = "rbxassetid://94937742565147"
GCardIcon.ImageTransparency     = 1
GCardIcon.ScaleType             = Enum.ScaleType.Fit

-- Main greeting / title line
local GreetingLabel: TextLabel = Instance.new("TextLabel", GreetingCard)
GreetingLabel.AnchorPoint            = Vector2.new(0, 0.5)
GreetingLabel.Position               = UDim2.new(0, 6, 0.5, 0)
GreetingLabel.Size                   = UDim2.new(1, -8, 1, 0)
GreetingLabel.BackgroundTransparency = 1
GreetingLabel.Font                   = Enum.Font.Arcade
GreetingLabel.TextScaled             = true
GreetingLabel.TextXAlignment         = Enum.TextXAlignment.Left
GreetingLabel.TextColor3             = Color3.fromRGB(0, 255, 150)
GreetingLabel.TextStrokeTransparency = 0.5
GreetingLabel.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)

local GreetingConstraint: UITextSizeConstraint = Instance.new("UITextSizeConstraint", GreetingLabel)
GreetingConstraint.MinTextSize = 6
GreetingConstraint.MaxTextSize = 11

-- Sub label (Discord link, only in Discord mode)
local GCardSub: TextLabel = Instance.new("TextLabel", GreetingCard)
GCardSub.AnchorPoint            = Vector2.new(0, 1)
GCardSub.Position               = UDim2.new(0, 22, 1, -1)
GCardSub.Size                   = UDim2.new(1, -24, 0, 9)
GCardSub.BackgroundTransparency = 1
GCardSub.Font                   = Enum.Font.Arcade
GCardSub.TextScaled             = true
GCardSub.TextXAlignment         = Enum.TextXAlignment.Left
GCardSub.TextColor3             = Color3.fromRGB(160, 160, 255)
GCardSub.TextTransparency       = 1
GCardSub.Text                   = DISCORD_LINK

local GCardSubConstraint: UITextSizeConstraint = Instance.new("UITextSizeConstraint", GCardSub)
GCardSubConstraint.MinTextSize = 5
GCardSubConstraint.MaxTextSize = 8

-- Ripple circle
local GCardRipple: Frame = Instance.new("Frame", GreetingCard)
GCardRipple.AnchorPoint            = Vector2.new(0.5, 0.5)
GCardRipple.Position               = UDim2.new(0.5, 0, 0.5, 0)
GCardRipple.Size                   = UDim2.new(0, 0, 0, 0)
GCardRipple.BackgroundColor3       = Color3.fromRGB(88, 101, 242)
GCardRipple.BackgroundTransparency = 0.5
GCardRipple.BorderSizePixel        = 0
GCardRipple.ZIndex                 = 10
Instance.new("UICorner", GCardRipple).CornerRadius = UDim.new(1, 0)

-- Invisible click overlay
local GCardClick: TextButton = Instance.new("TextButton", GreetingCard)
GCardClick.Size                   = UDim2.new(1, 0, 1, 0)
GCardClick.BackgroundTransparency = 1
GCardClick.Text                   = ""
GCardClick.ZIndex                 = 11

-- Scale spring on the card itself
local GreetingScale: UIScale = Instance.new("UIScale", GreetingCard)
GreetingScale.Scale = 0.85

-- ── State & helpers ───────────────────────────────────────────────────────────
local _greetingShowDiscord: boolean = false

local function GetNormalGreetingText(): string
    local ok: boolean, result: string = pcall(function(): string
        local playerName: string = Players.LocalPlayer.DisplayName
        local greeting: string, emoji: string, timeStr: string = GetGreetingAndTime()
        return string.format("%s, %s %s %s", greeting, playerName, emoji, timeStr)
    end)
    if ok then return result end
    return "Hello, " .. tostring(Players.LocalPlayer.DisplayName)
end

-- Switches visual state (no animation — caller handles that)
local function ApplyGreetingState()
    if _greetingShowDiscord then
        -- Discord mode: taller card, icon visible, sub-link visible
        GreetingCard.Size          = UDim2.new(0.60, 0, 0, 34)
        GreetingLabel.Position     = UDim2.new(0, 22, 0.30, 0)
        GreetingLabel.Size         = UDim2.new(1, -24, 0.45, 0)
        GreetingLabel.Text         = "Need help? Join Discord!"
        GreetingLabel.TextColor3   = Color3.fromRGB(160, 150, 255)
        GCardBar.BackgroundColor3  = Color3.fromRGB(88, 101, 242)
        GCardStroke.Color          = Color3.fromRGB(88, 101, 242)
        GCardStroke.Transparency   = 0.4
    else
        -- Normal greeting mode: single line, no icon
        GreetingCard.Size          = UDim2.new(0.60, 0, 0, 24)
        GreetingLabel.Position     = UDim2.new(0, 6, 0.5, 0)
        GreetingLabel.Size         = UDim2.new(1, -8, 1, 0)
        GreetingLabel.Text         = GetNormalGreetingText()
        GreetingLabel.TextColor3   = Color3.fromRGB(0, 255, 150)
        GCardBar.BackgroundColor3  = Color3.fromRGB(0, 255, 150)
        GCardStroke.Color          = Color3.fromRGB(0, 200, 255)
        GCardStroke.Transparency   = 0.55
    end
end

local function UpdateGreeting()
    pcall(ApplyGreetingState)
end

pcall(UpdateGreeting)

-- ── Click → copy to clipboard + ripple + press bounce ────────────────────────
GCardClick.MouseButton1Click:Connect(function()
    if not _greetingShowDiscord then return end  -- only copy when showing Discord
    pcall(setclipboard, DISCORD_LINK)

    -- Ripple from center
    GCardRipple.Size                 = UDim2.new(0, 0, 0, 0)
    GCardRipple.BackgroundTransparency = 0.55
    GCardRipple.Position             = UDim2.new(0.5, 0, 0.5, 0)
    pcall(function()
        TweenService:Create(GCardRipple, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(2.5, 0, 6, 0),
            BackgroundTransparency = 1,
        }):Play()
    end)

    -- Press-down squeeze → spring back
    pcall(function()
        TweenService:Create(GreetingScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Scale = 0.93,
        }):Play()
    end)
    task.delay(0.12, function()
        pcall(function()
            TweenService:Create(GreetingScale, TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
                Scale = 1,
            }):Play()
        end)
    end)

    -- Icon wiggle (brand-phone style)
    pcall(function()
        TweenService:Create(GCardIcon, TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Rotation = -18,
        }):Play()
    end)
    task.delay(0.12, function()
        pcall(function()
            TweenService:Create(GCardIcon, TweenInfo.new(0.15, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {
                Rotation = 18,
            }):Play()
        end)
        task.delay(0.16, function()
            pcall(function()
                TweenService:Create(GCardIcon, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Rotation = 0,
                }):Play()
            end)
        end)
    end)

    -- Brief label flash: "Copied!" → restore
    GreetingLabel.Text = "Copied! ✓"
    GreetingLabel.TextColor3 = Color3.fromRGB(100, 255, 160)
    task.delay(1.2, function()
        pcall(function()
            if _greetingShowDiscord then
                TweenService:Create(GreetingLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    TextTransparency = 1,
                }):Play()
                task.wait(0.32)
                GreetingLabel.Text = "Need help? Join our Discord!"
                GreetingLabel.TextColor3 = Color3.fromRGB(170, 160, 255)
                TweenService:Create(GreetingLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    TextTransparency = 0,
                }):Play()
            end
        end)
    end)
end)

local CloseButton: TextButton = Instance.new("TextButton", MainBackground)
CloseButton.BackgroundTransparency = 1
CloseButton.Position  = UDim2.new(0.928, 0, 0, -2)
CloseButton.Rotation  = 45
CloseButton.Size      = UDim2.new(0, 25, 0, 25)
CloseButton.Font      = Enum.Font.Arcade
CloseButton.Text      = "+"
CloseButton.TextSize  = 29
CloseButton.Visible   = false

local SettingsIcon: ImageButton = Instance.new("ImageButton", MainBackground)
SettingsIcon.BackgroundTransparency = 1
SettingsIcon.Position          = UDim2.new(0.85, 0, 0.01, 0)
SettingsIcon.Size              = UDim2.new(0, 22, 0, 22)
SettingsIcon.Image             = "rbxassetid://101339235267993"
SettingsIcon.Visible           = false
SettingsIcon.ImageTransparency = 0.2

-- ── Confirm close dialog ─────────────────────────────────────────────────────
local ConfirmFrame: ImageLabel = Instance.new("ImageLabel", MainBackground)
ConfirmFrame.AnchorPoint        = Vector2.new(0.5, 0.5)
ConfirmFrame.Position           = UDim2.new(0.5, 0, 0.5, 0)
ConfirmFrame.Size               = UDim2.new(0, 200, 0, 100)
ConfirmFrame.Image              = "rbxassetid://7877641241"
ConfirmFrame.BackgroundColor3   = Color3.new(1, 1, 1)
ConfirmFrame.BorderSizePixel    = 0
ConfirmFrame.Visible            = false
ConfirmFrame.ZIndex             = 3

local ConfirmGradient: UIGradient = Instance.new("UIGradient", ConfirmFrame)
ConfirmGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255)),
}
ConfirmGradient.Rotation = 45
Instance.new("UIStroke", ConfirmFrame).Color       = Color3.fromRGB(0, 200, 255)
Instance.new("UIStroke", ConfirmFrame).Thickness   = 2
Instance.new("UIStroke", ConfirmFrame).Transparency = 0.3
Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 8)

local ConfirmText: TextLabel = Instance.new("TextLabel", ConfirmFrame)
ConfirmText.BackgroundTransparency = 1
ConfirmText.Position           = UDim2.new(0, 0, 0.2, 0)
ConfirmText.Size               = UDim2.new(1, 0, 0.3, 0)
ConfirmText.Font               = Enum.Font.Arcade
ConfirmText.Text               = "Are you sure you want\nto close Velocity X?"
ConfirmText.TextSize           = 12
ConfirmText.TextColor3         = Color3.fromRGB(0, 255, 150)
ConfirmText.TextStrokeTransparency = 0
ConfirmText.TextStrokeColor3   = Color3.fromRGB(0, 0, 0)

local YesButton: TextButton = Instance.new("TextButton", ConfirmFrame)
YesButton.BackgroundColor3     = Color3.fromRGB(255, 255, 255)
YesButton.BackgroundTransparency = 1
YesButton.Position             = UDim2.new(0.15, 0, 0.65, 0)
YesButton.Size                 = UDim2.new(0, 70, 0, 30)
YesButton.Font                 = Enum.Font.Arcade
YesButton.Text                 = "Yes"
YesButton.TextScaled           = true
YesButton.TextColor3           = Color3.new(0, 0, 0)
Instance.new("UICorner", YesButton).CornerRadius = UDim.new(0, 4)
local YesGradient: UIGradient = Instance.new("UIGradient", YesButton)
YesGradient.Color    = ConfirmGradient.Color
YesGradient.Rotation = 90
Instance.new("UIStroke", YesButton).Color     = Color3.fromRGB(0, 255, 150)
Instance.new("UIStroke", YesButton).Thickness = 1.5

local NoButton: TextButton = Instance.new("TextButton", ConfirmFrame)
NoButton.BackgroundColor3     = Color3.fromRGB(255, 255, 255)
NoButton.BackgroundTransparency = 1
NoButton.Position             = UDim2.new(0.55, 0, 0.65, 0)
NoButton.Size                 = UDim2.new(0, 70, 0, 30)
NoButton.Font                 = Enum.Font.Arcade
NoButton.Text                 = "No"
NoButton.TextScaled           = true
NoButton.TextColor3           = Color3.new(0, 0, 0)
Instance.new("UICorner", NoButton).CornerRadius = UDim.new(0, 4)
local NoGradient: UIGradient = Instance.new("UIGradient", NoButton)
NoGradient.Color    = ConfirmGradient.Color
NoGradient.Rotation = 90
Instance.new("UIStroke", NoButton).Color     = Color3.fromRGB(0, 255, 150)
Instance.new("UIStroke", NoButton).Thickness = 1.5

-- ── Confirm delete dialog ────────────────────────────────────────────────────
local DeleteConfirmFrame: ImageLabel = Instance.new("ImageLabel", MainBackground)
DeleteConfirmFrame.Name             = "DeleteConfirmFrame"
DeleteConfirmFrame.AnchorPoint      = Vector2.new(0.5, 0.5)
DeleteConfirmFrame.Position         = UDim2.new(0.5, 0, 0.5, 0)
DeleteConfirmFrame.Size             = UDim2.new(0, 200, 0, 100)
DeleteConfirmFrame.Image            = "rbxassetid://7877641241"
DeleteConfirmFrame.BackgroundColor3 = Color3.new(1, 1, 1)
DeleteConfirmFrame.BorderSizePixel  = 0
DeleteConfirmFrame.Visible          = false
DeleteConfirmFrame.ZIndex           = 3

local DeleteConfirmGradient: UIGradient = Instance.new("UIGradient", DeleteConfirmFrame)
DeleteConfirmGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50)),
}
DeleteConfirmGradient.Rotation = 45
Instance.new("UIStroke", DeleteConfirmFrame).Color       = Color3.fromRGB(255, 100, 100)
Instance.new("UIStroke", DeleteConfirmFrame).Thickness   = 2
Instance.new("UIStroke", DeleteConfirmFrame).Transparency = 0.3
Instance.new("UICorner", DeleteConfirmFrame).CornerRadius = UDim.new(0, 8)

local DeleteConfirmText: TextLabel = Instance.new("TextLabel", DeleteConfirmFrame)
DeleteConfirmText.BackgroundTransparency = 1
DeleteConfirmText.Position           = UDim2.new(0, 0, 0.2, 0)
DeleteConfirmText.Size               = UDim2.new(1, 0, 0.3, 0)
DeleteConfirmText.Font               = Enum.Font.Arcade
DeleteConfirmText.Text               = "Delete config file?"
DeleteConfirmText.TextSize           = 12
DeleteConfirmText.TextColor3         = Color3.fromRGB(255, 255, 255)
DeleteConfirmText.TextStrokeTransparency = 0
DeleteConfirmText.TextStrokeColor3   = Color3.fromRGB(0, 0, 0)

local DeleteYesButton: TextButton = Instance.new("TextButton", DeleteConfirmFrame)
DeleteYesButton.BackgroundColor3     = Color3.fromRGB(255, 255, 255)
DeleteYesButton.BackgroundTransparency = 1
DeleteYesButton.Position             = UDim2.new(0.15, 0, 0.65, 0)
DeleteYesButton.Size                 = UDim2.new(0, 70, 0, 30)
DeleteYesButton.Font                 = Enum.Font.Arcade
DeleteYesButton.Text                 = "Yes"
DeleteYesButton.TextScaled           = true
DeleteYesButton.TextColor3           = Color3.new(0, 0, 0)
Instance.new("UICorner", DeleteYesButton).CornerRadius = UDim.new(0, 4)
local DeleteYesGradient: UIGradient = Instance.new("UIGradient", DeleteYesButton)
DeleteYesGradient.Color    = DeleteConfirmGradient.Color
DeleteYesGradient.Rotation = 90
Instance.new("UIStroke", DeleteYesButton).Color     = Color3.fromRGB(255, 100, 100)
Instance.new("UIStroke", DeleteYesButton).Thickness = 1.5

local DeleteNoButton: TextButton = Instance.new("TextButton", DeleteConfirmFrame)
DeleteNoButton.BackgroundColor3     = Color3.fromRGB(255, 255, 255)
DeleteNoButton.BackgroundTransparency = 1
DeleteNoButton.Position             = UDim2.new(0.55, 0, 0.65, 0)
DeleteNoButton.Size                 = UDim2.new(0, 70, 0, 30)
DeleteNoButton.Font                 = Enum.Font.Arcade
DeleteNoButton.Text                 = "No"
DeleteNoButton.TextScaled           = true
DeleteNoButton.TextColor3           = Color3.new(0, 0, 0)
Instance.new("UICorner", DeleteNoButton).CornerRadius = UDim.new(0, 4)
local DeleteNoGradient: UIGradient = Instance.new("UIGradient", DeleteNoButton)
DeleteNoGradient.Color    = DeleteConfirmGradient.Color
DeleteNoGradient.Rotation = 90
Instance.new("UIStroke", DeleteNoButton).Color     = Color3.fromRGB(255, 100, 100)
Instance.new("UIStroke", DeleteNoButton).Thickness = 1.5

-- ── Settings panel ───────────────────────────────────────────────────────────
local SettingsPanel: ImageLabel = Instance.new("ImageLabel", MainBackground)
SettingsPanel.AnchorPoint      = Vector2.new(1, 0)
SettingsPanel.Position         = UDim2.new(0.85, 0, 0.09, 0)
SettingsPanel.Size             = UDim2.new(0, 200, 0, 220)
SettingsPanel.Image            = "rbxassetid://7877641241"
SettingsPanel.BackgroundColor3 = Color3.new(1, 1, 1)
SettingsPanel.BorderSizePixel  = 0
SettingsPanel.ClipsDescendants = true
SettingsPanel.Visible          = false
SettingsPanel.ZIndex           = 2

local PanelGradient: UIGradient = Instance.new("UIGradient", SettingsPanel)
PanelGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255)),
}
PanelGradient.Rotation = 45

local PanelStroke: UIStroke = Instance.new("UIStroke", SettingsPanel)
PanelStroke.Color       = Color3.fromRGB(0, 200, 255)
PanelStroke.Thickness   = 2
PanelStroke.Transparency = 0.3

local PanelCorner: UICorner = Instance.new("UICorner", SettingsPanel)
PanelCorner.CornerRadius = UDim.new(0, 8)

local PanelTitle: TextLabel = Instance.new("TextLabel", SettingsPanel)
PanelTitle.BackgroundTransparency = 1
PanelTitle.Position          = UDim2.new(0, 8, 0, 5)
PanelTitle.Size              = UDim2.new(1, -16, 0, 20)
PanelTitle.Font              = Enum.Font.Arcade
PanelTitle.Text              = "Settings"
PanelTitle.TextColor3        = Color3.fromRGB(0, 255, 150)
PanelTitle.TextSize          = 12
PanelTitle.TextXAlignment    = Enum.TextXAlignment.Left
PanelTitle.ZIndex            = 3

local ScrollingFrame: ScrollingFrame = Instance.new("ScrollingFrame", SettingsPanel)
ScrollingFrame.Position              = UDim2.new(0, 0, 0, 30)
ScrollingFrame.Size                  = UDim2.new(1, 0, 1, -35)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel       = 0
ScrollingFrame.ClipsDescendants      = true
ScrollingFrame.ScrollBarThickness    = 6
ScrollingFrame.ScrollBarImageColor3  = Color3.fromRGB(0, 255, 150)
ScrollingFrame.CanvasSize            = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ZIndex                = 2

local ToggleList: UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
ToggleList.Padding              = UDim.new(0, 8)
ToggleList.HorizontalAlignment  = Enum.HorizontalAlignment.Center

-- ── Toggle builder ───────────────────────────────────────────────────────────
type ToggleControl = {
    Frame: Frame,
    Get:   () -> boolean,
    Set:   (value: boolean) -> (),
}

local function addToggle(
    parent: Instance,
    labelText: string,
    defaultValue: boolean,
    callback: ((val: boolean) -> ())?
): ToggleControl
    local toggleFrame: Frame = Instance.new("Frame", parent)
    toggleFrame.Size                 = UDim2.new(0, 180, 0, 25)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.ZIndex               = 2

    local label: TextLabel = Instance.new("TextLabel", toggleFrame)
    label.BackgroundTransparency = 1
    label.Position          = UDim2.new(0, 0, 0, 0)
    label.Size              = UDim2.new(0, 130, 1, 0)
    label.Font              = Enum.Font.Arcade
    label.Text              = labelText
    label.TextColor3        = Color3.fromRGB(255, 255, 255)
    label.TextSize          = 10
    label.TextXAlignment    = Enum.TextXAlignment.Left
    label.ZIndex            = 2

    local checkFrame: Frame = Instance.new("Frame", toggleFrame)
    checkFrame.Name             = "Check"
    checkFrame.AnchorPoint      = Vector2.new(1, 0.5)
    checkFrame.Position         = UDim2.new(1, -5, 0.5, 0)
    checkFrame.Size             = UDim2.new(0, 20, 0, 20)
    checkFrame.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
    checkFrame.BorderSizePixel  = 0
    checkFrame.ZIndex           = 2

    local inner: Frame = Instance.new("Frame", checkFrame)
    inner.AnchorPoint        = Vector2.new(0.5, 0.5)
    inner.Position           = UDim2.new(0.5, 0, 0.5, 0)
    inner.Size               = UDim2.new(1, 0, 1, 0)
    inner.BackgroundColor3   = Color3.fromRGB(255, 255, 255)
    inner.BackgroundTransparency = 1
    inner.ZIndex             = 2

    local innerCorner: UICorner = Instance.new("UICorner", inner)
    innerCorner.CornerRadius = UDim.new(1, 0)

    local grad: UIGradient = Instance.new("UIGradient", inner)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 170, 255)),
    }
    grad.Rotation = 48

    local checkCorner: UICorner = Instance.new("UICorner", checkFrame)
    checkCorner.CornerRadius = UDim.new(1, 0)

    local function updateUI(value: boolean)
        pcall(function()
            if value then
                TweenService:Create(inner, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0.8, 0, 0.8, 0), BackgroundTransparency = 0
                }):Play()
                TweenService:Create(checkFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                }):Play()
            else
                TweenService:Create(inner, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1
                }):Play()
                TweenService:Create(checkFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = Color3.fromRGB(42, 42, 42)
                }):Play()
            end
        end)
    end

    local clickBtn: TextButton = Instance.new("TextButton", toggleFrame)
    clickBtn.Name               = "Click"
    clickBtn.BackgroundTransparency = 1
    clickBtn.Size               = UDim2.new(1, 0, 1, 0)
    clickBtn.Text               = ""
    clickBtn.ZIndex             = 3

    local currentValue: boolean = defaultValue
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
        Get   = function(): boolean return currentValue end,
        Set   = function(value: boolean)
            if value ~= currentValue then
                currentValue = value
                updateUI(currentValue)
                if callback then
                    pcall(callback, currentValue)
                end
            end
        end,
    }
end

-- ── Config ───────────────────────────────────────────────────────────────────
local CONFIG_FOLDER: string = "Velocity X"
local CONFIG_FILE:   string = CONFIG_FOLDER .. "/VelocityX_Settings.json"
local CONFIG_VER:    string = "v1.1"

if makefolder then
    local folderOk: boolean = pcall(function()
        if not isfolder(CONFIG_FOLDER) then
            makefolder(CONFIG_FOLDER)
        end
    end)
    if not folderOk then
        warn("[VelocityX] Could not create config folder — settings won't be saved this session.")
    end
end

type Config = {
    autoSave:           boolean,
    autoInject:         boolean,
    autoExecutorLoader: boolean,
    antiAfk:            boolean,
    antiFling:          boolean,
    antiGameplayPause:  boolean,
    skipIntroUI:        boolean,
}

local config: Config = {
    autoSave           = false,
    autoInject         = false,
    autoExecutorLoader = false,
    antiAfk            = false,
    antiFling          = false,
    antiGameplayPause  = false,
    skipIntroUI        = false,
}

local function loadConfig()
    if not (readfile and isfile) then return end
    local loadOk: boolean, loadErr: any = pcall(function()
        if not isfile(CONFIG_FILE) then return end
        local raw:  string = readfile(CONFIG_FILE)
        local data: any    = HttpService:JSONDecode(raw)
        if type(data) ~= "table" then
            error("Config root is not a table — file is corrupted.")
        end
        config.autoSave           = data.autoSave           == true
        config.autoInject         = data.autoInject         == true
        config.autoExecutorLoader = data.autoExecutorLoader == true
        config.antiAfk            = data.antiAfk            == true
        config.antiFling          = data.antiFling          == true
        config.antiGameplayPause  = data.antiGameplayPause  == true
        config.skipIntroUI        = data.skipIntroUI        == true
    end)
    if not loadOk then
        warn("[VelocityX] Config corrupted (" .. tostring(loadErr) .. ") — resetting to defaults.")
        pcall(function()
            if isfile(CONFIG_FILE) then delfile(CONFIG_FILE) end
        end)
        pcall(function()
            if isfolder and isfolder(CONFIG_FOLDER) then
                pcall(delfolder, CONFIG_FOLDER)
            end
            if makefolder then makefolder(CONFIG_FOLDER) end
        end)
    end
end

local function saveConfig()
    if not (writefile and config.autoSave) then return end
    pcall(function()
        if makefolder and isfolder and not isfolder(CONFIG_FOLDER) then
            makefolder(CONFIG_FOLDER)
        end
        local data: string = HttpService:JSONEncode({
            _version           = CONFIG_VER,
            autoSave           = config.autoSave,
            autoInject         = config.autoInject,
            autoExecutorLoader = config.autoExecutorLoader,
            antiAfk            = config.antiAfk,
            antiFling          = config.antiFling,
            antiGameplayPause  = config.antiGameplayPause,
            skipIntroUI        = config.skipIntroUI,
        })
        writefile(CONFIG_FILE, data)
    end)
end

-- ── Auto-executor helpers ────────────────────────────────────────────────────
local function setupAutoExecutorLoader()
    local queueteleport: any = queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
    if queueteleport then
        task.spawn(function()
            pcall(function()
                queueteleport(
                    "loadstring(game:HttpGet('https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/Loader.lua'))()"
                )
            end)
        end)
    else
        showNotification("Executor Not Supported", "queue_on_teleport is not available.", Color3.fromRGB(255, 50, 50), 5)
    end
end

local function clearTeleportQueue()
    if clearteleportqueue      then pcall(clearteleportqueue) end
    if clear_teleport_queue    then pcall(clear_teleport_queue) end
    if clearqueueonteleport    then pcall(clearqueueonteleport) end
    if queue_on_teleport       then pcall(queue_on_teleport, nil) end
    if fluxus and fluxus.queue_on_teleport then pcall(fluxus.queue_on_teleport, nil) end
    if syn and syn.queue_on_teleport       then pcall(syn.queue_on_teleport, nil) end
    if setclipboard then pcall(function() setclipboard("") end) end
    showNotification("Velocity X", "Auto Executor cleared", Color3.fromRGB(255, 200, 0), 2)
end

local function setButtonActive(button: GuiButton?, active: boolean)
    if not button or not button.Parent then return end
    button.Active = active
    if button:IsA("TextButton") then
        (button :: TextButton).TextTransparency = active and 0 or 0.5
    elseif button:IsA("ImageButton") then
        (button :: ImageButton).ImageTransparency = active and 0.2 or 0.6
    end
end

-- ── Script fetch / inject ────────────────────────────────────────────────────
local scriptUrl:  string? = nil
local gameName:   string  = "Universal"
local injected:   boolean = false

local UNIVERSAL_URL:    string = "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/Main/Universal/Main.lua"
local GITHUB_BASE:      string = "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/Main/"
local GITHUB_JSON_URL:  string = "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/config/SupportedGames.json"
local PASTEBIN_JSON_URL: string = "https://pastefy.app/IwsPvLX/raw"

local function fetch(url: string): string?
    local success: boolean, result: any = pcall(function()
        return game:HttpGet(url)
    end)
    return (success and result) :: string? or nil
end

local gameId: string = tostring(game.GameId)

-- ── Parallel fetch: GitHub + Pastefy run at the same time ───────────────────
-- We fire both in task.spawn, collect results into shared state,
-- then pick the winner once both finish (or one succeeds early).
do
    local githubResult:  { url: string, name: string }? = nil
    local pastebinResult: { url: string, name: string }? = nil
    local done1: boolean = false
    local done2: boolean = false

    -- Cache-bust token shared between both so they're in the same fetch round
    local cacheBust: string = tostring(math.floor(tick()))

    local function tryGithub()
        local ok: boolean = pcall(function()
            local data: string? = fetch(GITHUB_JSON_URL .. "?t=" .. cacheBust)
            if not data or #(data :: string) == 0 then error("Empty") end
            local json: any = HttpService:JSONDecode(data :: string)
            if json and json[gameId] then
                githubResult = {
                    url  = GITHUB_BASE .. json[gameId].Path,
                    name = json[gameId].Name,
                }
            end
        end)
        if not ok then warn("[VelocityX] GitHub game list failed") end
        done1 = true
    end

    local function tryPastebin()
        local ok: boolean = pcall(function()
            local data: string? = fetch(PASTEBIN_JSON_URL .. "?t=" .. cacheBust)
            if not data or #(data :: string) == 0 then error("Empty") end
            local rawJson: any = HttpService:JSONDecode(data :: string)
            local json: any    = decode_obfuscated(rawJson)
            if json and json[gameId] then
                local path:         string = json[gameId].Path
                local randomstring: string = json[gameId].randomstring or ""
                pastebinResult = {
                    url  = path .. randomstring,
                    name = json[gameId].Name,
                }
            end
        end)
        if not ok then warn("[VelocityX] Pastefy game list failed") end
        done2 = true
    end

    -- Fire both in parallel
    task.spawn(tryGithub)
    task.spawn(tryPastebin)

    -- Wait until BOTH are done (each takes ~0.5-1 s; parallel = no extra wait)
    local deadline: number = tick() + 8  -- safety timeout
    while (not done1 or not done2) and tick() < deadline do
        task.wait(0.05)
    end

    -- GitHub wins if it found the game; Pastebin is fallback
    if githubResult then
        scriptUrl = githubResult.url
        gameName  = githubResult.name
    elseif pastebinResult then
        scriptUrl = pastebinResult.url
        gameName  = pastebinResult.name
    end
end

if not scriptUrl then
    scriptUrl = UNIVERSAL_URL
    gameName  = "Universal"
    showNotification("Using Universal Script", "No game-specific script found.", Color3.fromRGB(0, 170, 255), 3)
else
    showNotification("Game Supported", "Loaded: " .. gameName, Color3.fromRGB(0, 255, 120), 3)
end

InjectButton.Text = gameName .. ".lua"

-- Version fetch is fire-and-forget; no need to block the UI for it
task.spawn(function()
    local ok: boolean = pcall(function()
        local versionStr: string = game:HttpGet(
            "https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/Velocity%20X/config/version.json"
        )
        if not versionStr or #versionStr == 0 then error("Empty version response") end
        Version.Text = "Version: " .. versionStr
    end)
    if not ok then
        Version.Text = "Version: ?"
        warn("[VelocityX] Version fetch failed")
    end
end)

local function clearText()
    for _, v: Instance in MainBackground:GetDescendants() do
        if v:IsA("TextLabel") or v:IsA("TextButton") then
            (v :: TextLabel).Text = ""
        end
    end
end

-- ── Anti-feature state ───────────────────────────────────────────────────────
local antiAfkConnection:          RBXScriptConnection? = nil
local antiFlingConnection:        RBXScriptConnection? = nil
local antiGameplayPauseRunning:   boolean              = false
local antiGameplayPauseThread:    thread?              = nil

local function cleanupAntiFeatures()
    print("🥺🤟😞😜❤💙🧡") 
end

-- ── Error UI panel ────────────────────────────────────────────────────────────
-- Slides up from the bottom of MainBackground when inject fails.
-- Shows error type icon, message, and a Retry button.
local ErrorPanel: Frame = Instance.new("Frame", MainBackground)
ErrorPanel.Name                   = "ErrorPanel"
ErrorPanel.AnchorPoint            = Vector2.new(0, 1)
ErrorPanel.Position               = UDim2.new(0, 0, 1.05, 0)   -- starts hidden below
ErrorPanel.Size                   = UDim2.new(1, 0, 0, 60)
ErrorPanel.BackgroundColor3       = Color3.fromRGB(20, 8, 8)
ErrorPanel.BackgroundTransparency = 0.10
ErrorPanel.BorderSizePixel        = 0
ErrorPanel.ClipsDescendants       = true
ErrorPanel.ZIndex                 = 5
ErrorPanel.Visible                = false

Instance.new("UICorner", ErrorPanel).CornerRadius = UDim.new(0, 8)

local ErrStroke: UIStroke = Instance.new("UIStroke", ErrorPanel)
ErrStroke.Color       = Color3.fromRGB(255, 60, 60)
ErrStroke.Thickness   = 1.5
ErrStroke.Transparency = 0.3

-- Top red accent line
local ErrTopBar: Frame = Instance.new("Frame", ErrorPanel)
ErrTopBar.Size             = UDim2.new(1, 0, 0, 2)
ErrTopBar.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
ErrTopBar.BorderSizePixel  = 0
local ErrTopGrad: UIGradient = Instance.new("UIGradient", ErrTopBar)
ErrTopGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(255, 80, 80)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 160, 60)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(255, 80, 80)),
}

-- Warning icon
local ErrIcon: TextLabel = Instance.new("TextLabel", ErrorPanel)
ErrIcon.AnchorPoint            = Vector2.new(0, 0.5)
ErrIcon.Position               = UDim2.new(0, 8, 0.38, 0)
ErrIcon.Size                   = UDim2.new(0, 18, 0, 18)
ErrIcon.BackgroundTransparency = 1
ErrIcon.Font                   = Enum.Font.GothamBold
ErrIcon.Text                   = "⚠"
ErrIcon.TextScaled             = true
ErrIcon.TextColor3             = Color3.fromRGB(255, 140, 40)
ErrIcon.ZIndex                 = 6

-- Error title
local ErrTitle: TextLabel = Instance.new("TextLabel", ErrorPanel)
ErrTitle.AnchorPoint            = Vector2.new(0, 0)
ErrTitle.Position               = UDim2.new(0, 30, 0, 6)
ErrTitle.Size                   = UDim2.new(0.7, 0, 0, 16)
ErrTitle.BackgroundTransparency = 1
ErrTitle.Font                   = Enum.Font.Arcade
ErrTitle.Text                   = "Network Error"
ErrTitle.TextSize               = 12
ErrTitle.TextXAlignment         = Enum.TextXAlignment.Left
ErrTitle.TextColor3             = Color3.fromRGB(255, 100, 100)
ErrTitle.TextStrokeTransparency = 0.4
ErrTitle.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
ErrTitle.ZIndex                 = 6

-- Error description (shorter message)
local ErrDesc: TextLabel = Instance.new("TextLabel", ErrorPanel)
ErrDesc.AnchorPoint            = Vector2.new(0, 0)
ErrDesc.Position               = UDim2.new(0, 30, 0, 23)
ErrDesc.Size                   = UDim2.new(0.68, 0, 0, 22)
ErrDesc.BackgroundTransparency = 1
ErrDesc.Font                   = Enum.Font.Arcade
ErrDesc.Text                   = "Failed to fetch script."
ErrDesc.TextSize               = 9
ErrDesc.TextWrapped            = true
ErrDesc.TextXAlignment         = Enum.TextXAlignment.Left
ErrDesc.TextYAlignment         = Enum.TextYAlignment.Top
ErrDesc.TextColor3             = Color3.fromRGB(220, 180, 180)
ErrDesc.ZIndex                 = 6

-- Retry button
local ErrRetryBtn: TextButton = Instance.new("TextButton", ErrorPanel)
ErrRetryBtn.AnchorPoint            = Vector2.new(1, 0.5)
ErrRetryBtn.Position               = UDim2.new(0.98, 0, 0.55, 0)
ErrRetryBtn.Size                   = UDim2.new(0, 54, 0, 22)
ErrRetryBtn.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
ErrRetryBtn.BackgroundTransparency = 1
ErrRetryBtn.BorderSizePixel        = 0
ErrRetryBtn.Font                   = Enum.Font.Arcade
ErrRetryBtn.Text                   = "Retry"
ErrRetryBtn.TextSize               = 11
ErrRetryBtn.TextColor3             = Color3.fromRGB(255, 255, 255)
ErrRetryBtn.ZIndex                 = 7
Instance.new("UICorner", ErrRetryBtn).CornerRadius = UDim.new(0, 4)
local ErrRetryGrad: UIGradient = Instance.new("UIGradient", ErrRetryBtn)
ErrRetryGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 40, 40)),
}
ErrRetryGrad.Rotation = 90
Instance.new("UIStroke", ErrRetryBtn).Color     = Color3.fromRGB(255, 80, 80)
Instance.new("UIStroke", ErrRetryBtn).Thickness = 1

-- Dismiss (×) button
local ErrDismissBtn: TextButton = Instance.new("TextButton", ErrorPanel)
ErrDismissBtn.AnchorPoint            = Vector2.new(1, 0)
ErrDismissBtn.Position               = UDim2.new(1, -2, 0, 2)
ErrDismissBtn.Size                   = UDim2.new(0, 14, 0, 14)
ErrDismissBtn.BackgroundTransparency = 1
ErrDismissBtn.BorderSizePixel        = 0
ErrDismissBtn.Font                   = Enum.Font.GothamBold
ErrDismissBtn.Text                   = "×"
ErrDismissBtn.TextSize               = 13
ErrDismissBtn.TextColor3             = Color3.fromRGB(180, 100, 100)
ErrDismissBtn.ZIndex                 = 8

-- Helper: slide the error panel up into view / back down
local _errPanelOpen: boolean = false
local function showErrorPanel(title: string, desc: string, onRetry: (() -> ())?)
    if not ErrorPanel or not ErrorPanel.Parent then return end
    ErrTitle.Text = title
    ErrDesc.Text  = desc
    _errPanelOpen  = true
    ErrorPanel.Visible  = true
    ErrorPanel.Position = UDim2.new(0, 0, 1.05, 0)
    TweenService:Create(ErrorPanel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0.62, 0),
    }):Play()

    -- Retry wires up fresh each call
    local retryConn: RBXScriptConnection
    retryConn = ErrRetryBtn.MouseButton1Click:Connect(function()
        retryConn:Disconnect()
        pcall(function()
            TweenService:Create(ErrorPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(0, 0, 1.05, 0),
            }):Play()
        end)
        task.wait(0.22)
        ErrorPanel.Visible = false
        _errPanelOpen = false
        if onRetry then task.spawn(onRetry) end
    end)
end

local function hideErrorPanel()
    if not _errPanelOpen then return end
    _errPanelOpen = false
    pcall(function()
        TweenService:Create(ErrorPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(0, 0, 1.05, 0),
        }):Play()
    end)
    task.delay(0.22, function()
        if not _errPanelOpen and ErrorPanel then ErrorPanel.Visible = false end
    end)
end

ErrDismissBtn.MouseButton1Click:Connect(function()
    hideErrorPanel()
end)

local function shakeError()
    pcall(function()
        local orig: UDim2 = MainBackground.Position
        local shakeInfo: TweenInfo = TweenInfo.new(0.07, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 4, true)
        TweenService:Create(MainBackground, shakeInfo, {
            Position = UDim2.new(orig.X.Scale, orig.X.Offset + 8, orig.Y.Scale, orig.Y.Offset)
        }):Play()
        task.wait(0.6)
        TweenService:Create(MainBackground, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = orig
        }):Play()
    end)
end

-- ── Retry-aware inject (3 attempts per URL) ──────────────────────────────────
local MAX_RETRIES: number = 3
local RETRY_DELAY: number = 2  -- seconds between attempts

local function tryFetchAndRun(url: string): (boolean, string)
    local ok: boolean, err: any = pcall(function()
        local content: string = game:HttpGet(url)
        if not content or #content == 0 then
            error("Empty response from URL")
        end
        local loadOk: boolean, loadErr: any = pcall(loadstring(content))
        if not loadOk then
            error("Script runtime error: " .. tostring(loadErr))
        end
    end)
    return ok, tostring(err)
end

local function injectScript()
    if injected then return end
    injected = true

    setButtonActive(InjectButton, false)

    local currentUrl:  string = scriptUrl :: string
    local currentName: string = gameName
    local lastErr:     string = ""

    -- ── Phase 1: try current URL up to MAX_RETRIES times ──────────────────────
    local phase1Ok: boolean = false
    for attempt: number = 1, MAX_RETRIES do
        InjectButton.Text = string.format("Attempt %d/%d...", attempt, MAX_RETRIES)
        local ok: boolean, err: string = tryFetchAndRun(currentUrl)
        if ok then
            phase1Ok = true
            break
        end
        lastErr = err
        warn(string.format("[VelocityX] %s attempt %d/%d failed: %s", currentName, attempt, MAX_RETRIES, err))
        if attempt < MAX_RETRIES then
            showNotification(
                string.format("⚠ Attempt %d/%d Failed", attempt, MAX_RETRIES),
                "Retrying in " .. RETRY_DELAY .. "s...",
                Color3.fromRGB(255, 150, 0), RETRY_DELAY
            )
            task.wait(RETRY_DELAY)
        end
    end

    if phase1Ok then
        setButtonActive(InjectButton, true)
        return  -- success – caller handles GUI close
    end

    -- ── Phase 2: game-specific URL failed → fall back to Universal ────────────
    if currentUrl ~= UNIVERSAL_URL then
        showNotification(
            "⚠ Game Script Failed",
            "All 3 attempts failed — switching to Universal script...",
            Color3.fromRGB(255, 150, 0), 3
        )
        task.spawn(shakeError)
        scriptUrl = UNIVERSAL_URL
        gameName  = "Universal"

        local phase2Ok: boolean = false
        for attempt: number = 1, MAX_RETRIES do
            InjectButton.Text = string.format("Universal %d/%d...", attempt, MAX_RETRIES)
            local ok: boolean, err: string = tryFetchAndRun(UNIVERSAL_URL)
            if ok then
                phase2Ok = true
                break
            end
            lastErr = err
            warn(string.format("[VelocityX] Universal attempt %d/%d failed: %s", attempt, MAX_RETRIES, err))
            if attempt < MAX_RETRIES then
                showNotification(
                    string.format("⚠ Universal %d/%d Failed", attempt, MAX_RETRIES),
                    "Retrying in " .. RETRY_DELAY .. "s...",
                    Color3.fromRGB(255, 150, 0), RETRY_DELAY
                )
                task.wait(RETRY_DELAY)
            end
        end

        if phase2Ok then
            setButtonActive(InjectButton, true)
            return  -- success
        end
    end

    -- ── All attempts exhausted ─────────────────────────────────────────────────
    injected          = false
    InjectButton.Text = gameName .. ".lua"
    setButtonActive(InjectButton, true)
    task.spawn(shakeError)

    showErrorPanel(
        "✘ All 3 Attempts Failed",
        "Check your connection or the URL\nmay have been deleted.",
        function()
            task.spawn(injectScript)
        end
    )
    showNotification(
        "✘ All Attempts Failed (3/3)",
        "Check your connection — the URL may have been deleted.",
        Color3.fromRGB(255, 50, 50), 8
    )
end

local function performAutoInject()
    if injected then return end
    injectScript()
    if not injected then return end  -- failed – error panel shown, keep GUI open
    InjectButton.Text = "Injecting..."
    TweenService:Create(MainBackground, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0), ImageTransparency = 1
    }):Play()
    clearText()
    task.wait(0.35)
    cleanupAntiFeatures()
    if RealZzHub then RealZzHub:Destroy() end
end

-- ── Show main window ─────────────────────────────────────────────────────────
MainBackground.Visible = true
MainBackground.Size    = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainBackground, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 318, 0, 162), ImageTransparency = 0.2
}):Play()
task.wait(0.4)

CloseButton.Visible   = true
InjectButton.Visible  = true
Name.Visible          = true
Logo.Visible          = true
Version.Visible       = true
SettingsIcon.Visible  = true
GreetingCard.Visible  = true

loadConfig()

-- ── Settings toggles ─────────────────────────────────────────────────────────
local autoSaveCtrl = addToggle(ScrollingFrame, "Auto Save Config", config.autoSave, function(val: boolean)
    config.autoSave = val
    if config.autoSave then saveConfig() end
    showNotification("Auto Save Config", val and "Enabled" or "Disabled", Color3.fromRGB(0, 255, 120), 2)
end)

local autoInjectCtrl = addToggle(ScrollingFrame, "Auto Inject", config.autoInject, function(val: boolean)
    config.autoInject = val
    if config.autoSave then saveConfig() end
    showNotification("Auto Inject", val and "Enabled" or "Disabled", Color3.fromRGB(0, 255, 120), 2)
    if val and not injected then
        performAutoInject()
    end
end)

local autoLoaderCtrl = addToggle(ScrollingFrame, "Auto Executor Loader", config.autoExecutorLoader, function(val: boolean)
    config.autoExecutorLoader = val
    if config.autoSave then saveConfig() end
    if val then
        setupAutoExecutorLoader()
        showNotification("Auto Executor Loader", "Enabled – will reload on teleport", Color3.fromRGB(0, 255, 120), 2)
    else
        clearTeleportQueue()
    end
end)

local antiAfkCtrl = addToggle(ScrollingFrame, "Anti AFK", config.antiAfk, function(val: boolean)
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

local antiFlingCtrl = addToggle(ScrollingFrame, "Anti Fling", config.antiFling, function(val: boolean)
    config.antiFling = val
    if config.autoSave then saveConfig() end
    if val then
        if not antiFlingConnection then
            antiFlingConnection = game:GetService("RunService").Stepped:Connect(function()
                local localPlayer = game:GetService("Players").LocalPlayer
                for _, p: Player in game:GetService("Players"):GetPlayers() do
                    if p == localPlayer or not p.Character then continue end
                    for _, v: Instance in p.Character:GetDescendants() do
                        if v:IsA("BasePart") then
                            (v :: BasePart).CanCollide = false
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

local antiGameplayPauseCtrl = addToggle(ScrollingFrame, "Anti Gameplay Pause", config.antiGameplayPause, function(val: boolean)
    config.antiGameplayPause = val
    if config.autoSave then saveConfig() end
    if val then
        if not antiGameplayPauseRunning then
            antiGameplayPauseRunning = true
            antiGameplayPauseThread  = task.spawn(function()
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

local skipIntroCtrl = addToggle(ScrollingFrame, "Skip Intro UI", config.skipIntroUI, function(val: boolean)
    config.skipIntroUI = val
    if config.autoSave then saveConfig() end
    showNotification("Skip Intro UI", val and "Will skip next session" or "Intro restored", Color3.fromRGB(0, 255, 120), 2)
end)

-- ── Open Console button ───────────────────────────────────────────────────────
local openConsoleButton: TextButton = Instance.new("TextButton")
openConsoleButton.Name               = "OpenConsoleButton"
openConsoleButton.Size               = UDim2.new(0, 180, 0, 30)
openConsoleButton.BackgroundColor3   = Color3.fromRGB(255, 255, 255)
openConsoleButton.BackgroundTransparency = 0.9
openConsoleButton.BorderSizePixel    = 0
openConsoleButton.Font               = Enum.Font.Arcade
openConsoleButton.Text               = "Open Console"
openConsoleButton.TextColor3         = Color3.fromRGB(0, 200, 255)
openConsoleButton.TextSize           = 12
openConsoleButton.ZIndex             = 2
Instance.new("UICorner", openConsoleButton).CornerRadius = UDim.new(0, 4)
local consoleBtnStroke: UIStroke = Instance.new("UIStroke", openConsoleButton)
consoleBtnStroke.Color       = Color3.fromRGB(0, 200, 255)
consoleBtnStroke.Thickness   = 1.5
consoleBtnStroke.Transparency = 0.5
openConsoleButton.Parent = ScrollingFrame
openConsoleButton.MouseButton1Click:Connect(function()
    pcall(function()
        game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)
    end)
end)

-- ── Delete Config button ─────────────────────────────────────────────────────
local deleteConfigButton: TextButton = Instance.new("TextButton")
deleteConfigButton.Name               = "DeleteConfigButton"
deleteConfigButton.Size               = UDim2.new(0, 180, 0, 30)
deleteConfigButton.BackgroundColor3   = Color3.fromRGB(255, 255, 255)
deleteConfigButton.BackgroundTransparency = 0.9
deleteConfigButton.BorderSizePixel    = 0
deleteConfigButton.Font               = Enum.Font.Arcade
deleteConfigButton.Text               = "Delete Config"
deleteConfigButton.TextColor3         = Color3.fromRGB(255, 100, 100)
deleteConfigButton.TextSize           = 12
deleteConfigButton.ZIndex             = 2
Instance.new("UICorner", deleteConfigButton).CornerRadius = UDim.new(0, 4)
local delBtnStroke: UIStroke = Instance.new("UIStroke", deleteConfigButton)
delBtnStroke.Color       = Color3.fromRGB(255, 100, 100)
delBtnStroke.Thickness   = 1.5
delBtnStroke.Transparency = 0.5
deleteConfigButton.Parent = ScrollingFrame

local function updateCanvasSize()
    local totalHeight: number = 0
    for _, child: Instance in ScrollingFrame:GetChildren() do
        if child:IsA("GuiObject") and child ~= (ToggleList :: Instance) then
            totalHeight += (child :: GuiObject).Size.Y.Offset + 8
        end
    end
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(totalHeight, 150))
end
updateCanvasSize()

local function onPanelOpen()
    updateCanvasSize()
end

if config.autoInject         then performAutoInject()         end
if config.autoExecutorLoader then setupAutoExecutorLoader()   end

UpdateGreeting()
pcall(function()
    TweenService:Create(GreetingScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
end)

task.spawn(function()
    while RealZzHub and RealZzHub.Parent do
        task.wait(3)
        if not (RealZzHub and RealZzHub.Parent) then break end

        -- 1. Slide + fade out (card slides left, shrinks, fades)
        pcall(function()
            TweenService:Create(GreetingScale, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Scale = 0.88,
            }):Play()
            TweenService:Create(GreetingLabel, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1,
                TextStrokeTransparency = 1,
            }):Play()
            TweenService:Create(GCardSub, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                TextTransparency = 1,
            }):Play()
            TweenService:Create(GCardIcon, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                ImageTransparency = 1,
            }):Play()
        end)
        task.wait(0.25)

        -- 2. Swap state
        _greetingShowDiscord = not _greetingShowDiscord
        pcall(ApplyGreetingState)

        -- 3. Slide + fade in (Back easing = overshoot bounce like a brand phone notification)
        if _greetingShowDiscord then
            -- Discord mode: show icon + sub link
            pcall(function()
                TweenService:Create(GCardIcon, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    ImageTransparency = 0,
                }):Play()
                TweenService:Create(GCardSub, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextTransparency = 0.2,
                }):Play()
            end)
        else
            -- Normal mode: hide icon + sub
            pcall(function()
                GCardIcon.ImageTransparency = 1
                GCardSub.TextTransparency   = 1
            end)
        end

        pcall(function()
            TweenService:Create(GreetingScale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Scale = 1,
            }):Play()
            TweenService:Create(GreetingLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                TextTransparency = 0,
                TextStrokeTransparency = 0.6,
            }):Play()
        end)
    end
end)

-- ── Button handlers ───────────────────────────────────────────────────────────
InjectButton.MouseButton1Click:Connect(function()
    if not InjectButton.Active then return end
    injectScript()
    InjectButton.Text = "Injecting..."
    TweenService:Create(MainBackground, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0), ImageTransparency = 1
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
            Size = UDim2.new(0, 0, 0, 0), ImageTransparency = 1
        }):Play()
        task.wait(0.15)
        if SettingsPanel then
            SettingsPanel.Visible          = false
            SettingsPanel.Size             = UDim2.new(0, 200, 0, 220)
            SettingsPanel.ImageTransparency = 0
        end
        if ConfirmFrame and not ConfirmFrame.Visible and DeleteConfirmFrame and not DeleteConfirmFrame.Visible then
            setButtonActive(InjectButton, true)
            setButtonActive(CloseButton,  true)
        end
    else
        SettingsPanel.Visible = true
        SettingsPanel.Size    = UDim2.new(0, 0, 0, 0)
        TweenService:Create(SettingsPanel, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 200, 0, 220), ImageTransparency = 0
        }):Play()
        setButtonActive(InjectButton, false)
        setButtonActive(CloseButton,  false)
        onPanelOpen()
    end
end)

-- ── Close confirm dialog ──────────────────────────────────────────────────────
local confirmClosing: boolean = false
local function closeConfirmDialog(callback: (() -> ())?)
    if not ConfirmFrame or not ConfirmFrame.Parent or not ConfirmFrame.Visible or confirmClosing then
        if callback then callback() end
        return
    end
    confirmClosing = true
    local tween: Tween = TweenService:Create(ConfirmFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0), ImageTransparency = 1
    })
    tween.Completed:Connect(function()
        if ConfirmFrame and ConfirmFrame.Parent then
            ConfirmFrame.Visible           = false
            ConfirmFrame.Size              = UDim2.new(0, 200, 0, 100)
            ConfirmFrame.ImageTransparency = 0
        end
        confirmClosing = false
        if SettingsPanel and SettingsPanel.Visible then
            setButtonActive(InjectButton, false)
            setButtonActive(CloseButton,  false)
            setButtonActive(SettingsIcon, true)
        else
            setButtonActive(InjectButton, true)
            setButtonActive(CloseButton,  true)
            setButtonActive(SettingsIcon, true)
        end
        if callback then callback() end
    end)
    tween:Play()
end

CloseButton.MouseButton1Click:Connect(function()
    if not ConfirmFrame or ConfirmFrame.Visible or (DeleteConfirmFrame and DeleteConfirmFrame.Visible) then return end
    setButtonActive(InjectButton, false)
    setButtonActive(CloseButton,  false)
    setButtonActive(SettingsIcon, false)
    if SettingsPanel and SettingsPanel.Visible then
        SettingsPanel.Visible           = false
        SettingsPanel.Size              = UDim2.new(0, 200, 0, 220)
        SettingsPanel.ImageTransparency = 0
    end
    ConfirmFrame.Visible           = true
    ConfirmFrame.Size              = UDim2.new(0, 0, 0, 0)
    ConfirmFrame.ImageTransparency = 1
    TweenService:Create(ConfirmFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 200, 0, 100), ImageTransparency = 0
    }):Play()
end)

YesButton.MouseButton1Click:Connect(function()
    closeConfirmDialog(function()
        clearText()
        TweenService:Create(MainBackground, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0), ImageTransparency = 1
        }):Play()
        task.wait(0.3)
        cleanupAntiFeatures()
        if RealZzHub then RealZzHub:Destroy() end
    end)
end)

NoButton.MouseButton1Click:Connect(function()
    closeConfirmDialog()
end)

-- ── Delete confirm dialog ─────────────────────────────────────────────────────
local deleteConfirmClosing: boolean = false
local function closeDeleteConfirmDialog(callback: (() -> ())?)
    if not DeleteConfirmFrame or not DeleteConfirmFrame.Parent
        or not DeleteConfirmFrame.Visible or deleteConfirmClosing then
        if callback then callback() end
        return
    end
    deleteConfirmClosing = true
    local tween: Tween = TweenService:Create(DeleteConfirmFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0), ImageTransparency = 1
    })
    tween.Completed:Connect(function()
        if DeleteConfirmFrame and DeleteConfirmFrame.Parent then
            DeleteConfirmFrame.Visible           = false
            DeleteConfirmFrame.Size              = UDim2.new(0, 200, 0, 100)
            DeleteConfirmFrame.ImageTransparency = 0
        end
        deleteConfirmClosing = false
        if SettingsPanel and SettingsPanel.Visible then
            setButtonActive(InjectButton, false)
            setButtonActive(CloseButton,  false)
            setButtonActive(SettingsIcon, true)
        else
            setButtonActive(InjectButton, true)
            setButtonActive(CloseButton,  true)
            setButtonActive(SettingsIcon, true)
        end
        if callback then callback() end
    end)
    tween:Play()
end

deleteConfigButton.MouseButton1Click:Connect(function()
    if (DeleteConfirmFrame and DeleteConfirmFrame.Visible) or (ConfirmFrame and ConfirmFrame.Visible) then return end
    setButtonActive(InjectButton, false)
    setButtonActive(CloseButton,  false)
    setButtonActive(SettingsIcon, false)
    DeleteConfirmFrame.Visible           = true
    DeleteConfirmFrame.Size              = UDim2.new(0, 0, 0, 0)
    DeleteConfirmFrame.ImageTransparency = 1
    TweenService:Create(DeleteConfirmFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 200, 0, 100), ImageTransparency = 0
    }):Play()
end)

DeleteYesButton.MouseButton1Click:Connect(function()
    closeDeleteConfirmDialog(function()
        local fileDeleted: boolean = false
        if isfile and delfile then
            pcall(function()
                if isfile(CONFIG_FILE) then
                    delfile(CONFIG_FILE)
                    fileDeleted = true
                end
            end)
        end
        if fileDeleted then
            config.autoSave           = false
            config.autoInject         = false
            config.autoExecutorLoader = false
            config.antiAfk            = false
            config.antiFling          = false
            config.antiGameplayPause  = false
            config.skipIntroUI        = false

            autoSaveCtrl:Set(false)
            autoInjectCtrl:Set(false)
            autoLoaderCtrl:Set(false)
            antiAfkCtrl:Set(false)
            antiFlingCtrl:Set(false)
            antiGameplayPauseCtrl:Set(false)
            skipIntroCtrl:Set(false)

            showNotification("Config Deleted", "Settings file has been removed.", Color3.fromRGB(255, 100, 100), 3)
        end
    end)
end)

DeleteNoButton.MouseButton1Click:Connect(function()
    closeDeleteConfirmDialog()
end)

-- ── Drag system ───────────────────────────────────────────────────────────────
local _dragOk: boolean, _dragErr: any = pcall(function()
    local probe: UIDragDetector = Instance.new("UIDragDetector")
    probe:Destroy()

    local drag: UIDragDetector = Instance.new("UIDragDetector")
    drag.Parent = MainBackground

    local dragScale: UIScale = Instance.new("UIScale")
    dragScale.Scale  = 1
    dragScale.Parent = MainBackground

    local pressTweenInfo: TweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad,    Enum.EasingDirection.Out)
    local snapTweenInfo:  TweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Elastic,  Enum.EasingDirection.Out)

    local function applyTween(obj: Instance, props: { [string]: any }, info: TweenInfo?)
        local ok: boolean, err: any = pcall(function()
            TweenService:Create(obj, info or pressTweenInfo, props):Play()
        end)
        if not ok then warn("[VelocityX] Drag tween error:", err) end
    end

    local isDragging:    boolean = false
    local lastSwayTime:  number  = 0
    local SWAY_THROTTLE: number  = 0.06
    local SWAY_SPEED:    number  = 3.2
    local SWAY_AMP:      number  = 5

    local function settingsOpen(): boolean
        return SettingsPanel ~= nil and SettingsPanel.Visible
    end

    drag.DragStart:Connect(function()
        if settingsOpen() then return end
        isDragging   = true
        lastSwayTime = tick()
        applyTween(dragScale,      { Scale = 0.96 })
        applyTween(MainBackground, { BackgroundTransparency = 0.5 })
    end)

    drag.DragContinue:Connect(function()
        if not isDragging or settingsOpen() then return end
        local now: number = tick()
        if (now - lastSwayTime) < SWAY_THROTTLE then return end
        lastSwayTime = now
        local sway: number = math.sin(now * SWAY_SPEED) * SWAY_AMP
        applyTween(MainBackground, { Rotation = sway })
    end)

    drag.DragEnd:Connect(function()
        isDragging   = false
        lastSwayTime = 0
        applyTween(dragScale,      { Scale = 1 },                                      snapTweenInfo)
        applyTween(MainBackground, { BackgroundTransparency = 0, Rotation = 0 }, snapTweenInfo)
    end)
end)

if not _dragOk then
    warn("[VelocityX] UIDragDetector unavailable — using fallback drag. Reason:", _dragErr)

    local UserInputService = game:GetService("UserInputService")
    local dragging:       boolean       = false
    local dragStartMouse: Vector2?      = nil
    local dragStartPos:   UDim2?        = nil

    local function isDragInput(input: InputObject): boolean
        return input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
    end

    local function isMotionInput(input: InputObject): boolean
        return input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch
    end

    MainBackground.InputBegan:Connect(function(input: InputObject)
        if not isDragInput(input) then return end
        if SettingsPanel and SettingsPanel.Visible then return end
        dragging       = true
        dragStartMouse = Vector2.new(input.Position.X, input.Position.Y)
        dragStartPos   = MainBackground.Position
        pcall(function()
            TweenService:Create(MainBackground, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 0.5
            }):Play()
        end)
    end)

    UserInputService.InputChanged:Connect(function(input: InputObject)
        if not dragging or not isMotionInput(input) then return end
        if SettingsPanel and SettingsPanel.Visible then return end
        local delta:    Vector2 = Vector2.new(input.Position.X, input.Position.Y) - (dragStartMouse :: Vector2)
        local viewport: Vector2 = workspace.CurrentCamera.ViewportSize
        local sp: UDim2 = dragStartPos :: UDim2
        MainBackground.Position = UDim2.new(
            sp.X.Scale + delta.X / viewport.X,
            sp.X.Offset,
            sp.Y.Scale + delta.Y / viewport.Y,
            sp.Y.Offset
        )
    end)

    UserInputService.InputEnded:Connect(function(input: InputObject)
        if not isDragInput(input) or not dragging then return end
        dragging = false
        pcall(function()
            TweenService:Create(MainBackground, TweenInfo.new(0.35, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0
            }):Play()
        end)
    end)
end
