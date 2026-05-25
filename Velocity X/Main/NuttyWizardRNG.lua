-- Nutty Wizards Auto Farm
-- Original by ZhyTrizes | Cleaned up
-- ts file was generate by https://discord.gg/jc6SAYtVNf

-- Services
local Players         = game:GetService("Players")
local VirtualUser     = game:GetService("VirtualUser")
local VirtualInput    = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService      = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- UI Library
local UI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
UI:SetNotificationLower(true)

-- Global Flags
_G.ZhyRoll      = false
_G.ZhyCollect   = false
_G.ZhySell      = false
_G.ZhyAutoSpin  = false
_G.ZhyAntiAfk   = true

-- Disable collisions on character parts while collecting
RunService.Stepped:Connect(function()
    if _G.ZhyCollect and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Remote references (cached on first use)
local BoostRF, SellRF

local function GetBoostRF()
    if not BoostRF then
        BoostRF = ReplicatedStorage
            :WaitForChild("Packages")
            :WaitForChild("Knit")
            :WaitForChild("Services")
            :WaitForChild("BoostService")
            :WaitForChild("RF")
            :WaitForChild("BuyBoost")
    end
    return BoostRF
end

local function GetSellRF()
    if not SellRF then
        SellRF = ReplicatedStorage
            :WaitForChild("Packages")
            :WaitForChild("Knit")
            :WaitForChild("Services")
            :WaitForChild("BackpackService")
            :WaitForChild("RF")
            :WaitForChild("SellItem")
    end
    return SellRF
end

-- Buy a boost by ID
local function InvokeShop(shopId)
    pcall(function()
        GetBoostRF():InvokeServer(shopId)
    end)
end

-- Auto Sell (slots 1-100, skips 115)
local function AutoSell()
    local rf = GetSellRF()
    for slotId = 1, 100 do
        if not _G.ZhySell then break end
        if slotId == 115 then continue end
        task.spawn(function()
            pcall(function()
                rf:InvokeServer(slotId, 1)
            end)
        end)
    end
end

-- Auto Collect (teleport to each drop item and interact)
local function AutoCollect()
    local dropFolder = workspace:FindFirstChild("DropPoint")
    if not dropFolder then return end

    for _, dropItem in ipairs(dropFolder:GetChildren()) do
        if not _G.ZhyCollect then break end

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")

        if hrp then
            hrp.CFrame = dropItem:GetPivot()
            task.wait(0.3)

            -- Fire any proximity prompts
            for _, desc in ipairs(dropItem:GetDescendants()) do
                if desc:IsA("ProximityPrompt") then
                    fireproximityprompt(desc)
                end
            end

            -- Press E
            VirtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
            task.wait(0.1)
            VirtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)

            -- Fire touch interest
            local basePart = (dropItem:IsA("BasePart") and dropItem)
                or dropItem:FindFirstChildWhichIsA("BasePart", true)
            if basePart then
                firetouchinterest(basePart, hrp, 0)
                task.wait(0.05)
                firetouchinterest(basePart, hrp, 1)
            end

            task.wait(0.4)
        end
    end
end

-- Auto Roll loop
task.spawn(function()
    while true do
        if _G.ZhyRoll then
            pcall(function()
                ReplicatedStorage.Packages.Knit.Services.RollService.RE.PlayerBegainRoll:FireServer()
            end)
        end
        task.wait(0.1)
    end
end)

-- Auto Spin Ticket loop
task.spawn(function()
    while true do
        if _G.ZhyAutoSpin then
            pcall(function()
                ReplicatedStorage.Packages.Knit.Services.UGCService.RF.SpecialRoll:InvokeServer()
            end)
        end
        task.wait(1)
    end
end)

-- Auto Collect loop
task.spawn(function()
    while true do
        if _G.ZhyCollect then
            AutoCollect()
        end
        task.wait(1)
    end
end)

-- Auto Sell loop
task.spawn(function()
    while true do
        if _G.ZhySell then
            AutoSell()
        end
        task.wait(6.5)
    end
end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    if _G.ZhyAntiAfk then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end
end)

-- UI
local Window = UI:CreateWindow({
    ["Title"]  = "Nutty Wizards - ZhyTrizes | skid by Velocity (Alwi) ",
    ["Icon"]   = "wand-sparkles",
    ["Author"] = "by ZhyTrizes",
    ["Folder"] = "ZhyNuttyWizards_Final",
})

local MainTab = Window:Tab({ ["Title"] = "Main", ["Icon"] = "sparkles" })
local BoosterTab = Window:Tab({ ["Title"] = "Booster", ["Icon"] = "zap" })
local MiscTab = Window:Tab({ ["Title"] = "Misc", ["Icon"] = "settings" })

-- Main Tab
MainTab:Section({ ["Title"] = "Auto Farming" })

MainTab:Toggle({
    ["Title"]    = "Auto Roll",
    ["Default"]  = false,
    ["Callback"] = function(val) _G.ZhyRoll = val end,
})

MainTab:Toggle({
    ["Title"]    = "Auto Spin Ticket",
    ["Desc"]     = "Instant Spin A Ticket UGC",
    ["Default"]  = false,
    ["Callback"] = function(val) _G.ZhyAutoSpin = val end,
})

MainTab:Toggle({
    ["Title"]    = "Auto Collect Boost",
    ["Default"]  = false,
    ["Callback"] = function(val) _G.ZhyCollect = val end,
})

MainTab:Toggle({
    ["Title"]    = "Auto Sell",
    ["Desc"]     = "Fixed Ticket Sell",
    ["Default"]  = false,
    ["Callback"] = function(val) _G.ZhySell = val end,
})

-- Booster Tab
BoosterTab:Section({ ["Title"] = "Standard Boosts" })

BoosterTab:Button({ ["Title"] = "Buy Boost 1",  ["Desc"] = "Cost: 100",  ["Callback"] = function() InvokeShop(1)  end })
BoosterTab:Button({ ["Title"] = "Buy Boost 2",  ["Desc"] = "Cost: 150",  ["Callback"] = function() InvokeShop(2)  end })
BoosterTab:Button({ ["Title"] = "Buy Boost 3",  ["Desc"] = "Cost: 250",  ["Callback"] = function() InvokeShop(3)  end })

BoosterTab:Section({ ["Title"] = "Advanced Boosts" })

BoosterTab:Button({ ["Title"] = "Buy Double Inspiration", ["Desc"] = "Cost: 50k",  ["Callback"] = function() InvokeShop(25) end })
BoosterTab:Button({ ["Title"] = "Buy Double Efficiency",  ["Desc"] = "Cost: 50k",  ["Callback"] = function() InvokeShop(24) end })
BoosterTab:Button({ ["Title"] = "Buy Triple Inspiration", ["Desc"] = "Cost: 120k", ["Callback"] = function() InvokeShop(27) end })
BoosterTab:Button({ ["Title"] = "Buy Triple Efficiency",  ["Desc"] = "Cost: 120k", ["Callback"] = function() InvokeShop(26) end })

-- Misc Tab
MiscTab:Section({ ["Title"] = "Utilities" })

MiscTab:Toggle({
    ["Title"]    = "Anti-AFK",
    ["Desc"]     = "Prevents disconnection for idling",
    ["Default"]  = true,
    ["Callback"] = function(val) _G.ZhyAntiAfk = val end,
})

MiscTab:Button({
    ["Title"] = "Copy YouTube",
    ["Callback"] = function()
        setclipboard("https://www.youtube.com/@ZhyTrizes")
        UI:Notify({ ["Title"] = "ZhyTrizes", ["Content"] = "Link Copied!", ["Duration"] = 3 })
    end,
})

MiscTab:Button({
    ["Title"] = "Rejoin Server",
    ["Callback"] = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end,
})

-- Startup notification
UI:Notify({
    ["Title"]    = "ZhyTrizes",
    ["Content"]  = "Fixed Sell, Add Spin Ticket, Anti-Afk!",
    ["Duration"] = 5,
})
