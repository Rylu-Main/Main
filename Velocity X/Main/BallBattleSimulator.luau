--!nonstrict
-- Ball Battle Simulator Script
-- Cleaned by alwi — original by Valtzdripness | https://discord.gg/g6h7Htg6uu

-- ── Services ──────────────────────────────────────────────────────────────────
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local Players           = game:GetService("Players")

local localPlayer = Players.LocalPlayer

-- ── RemoteEvents ──────────────────────────────────────────────────────────────
local FightClick        = ReplicatedStorage:WaitForChild("FightClick")
local RequestRebirth    = ReplicatedStorage:WaitForChild("RequestRebirth")
local RequestEventClaim = ReplicatedStorage:WaitForChild("RequestEventClaim")
local ClaimPetPack      = ReplicatedStorage:WaitForChild("ClaimPetPack")
local ClaimEggReward    = ReplicatedStorage:WaitForChild("ClaimEggReward")

-- ── WindUI ────────────────────────────────────────────────────────────────────
local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua", true
))()

local window = WindUI:CreateWindow({
    Title        = "Ball Battle Simulator",
    Icon         = "swords",
    Author       = "Valtzdripness | https://discord.gg/g6h7Htg6uu by Velocity x",
    Folder       = "BallBattleSim",
    Size         = UDim2.fromOffset(540, 500),
    Transparent  = true,
    Theme        = "Dark",
    SideBarWidth = 210,
})

local mainTab = window:Tab({
    Title = "Main",
    Icon  = "home",
})

-- ── Global flags ──────────────────────────────────────────────────────────────
getgenv().BuffShark        = false
getgenv().ZeusBoss         = false
getgenv().SuperSaiyanNinja = false
getgenv().AutoFarm         = false
getgenv().AutoRebirth      = false
getgenv().AutoClick        = false
getgenv().AutoEventEgg     = false
getgenv().AutoSpin         = false
getgenv().AutoClaimGift    = false
getgenv().AutoTrainSword   = false

-- ── Helper: boss farm loop ────────────────────────────────────────────────────
local fighterNPCs = Workspace:WaitForChild("FighterNPCs")

local function farmBoss(bossName: string, flagKey: string)
    task.spawn(function()
        while getgenv()[flagKey] do
            pcall(function()
                local boss = fighterNPCs:FindFirstChild(bossName)
                if not boss then return end

                local character = localPlayer.Character
                if not character then return end

                local hrp     = character:FindFirstChild("HumanoidRootPart")
                local bossHrp = boss:FindFirstChild("HumanoidRootPart")

                if hrp and bossHrp then
                    hrp.CFrame = bossHrp.CFrame * CFrame.new(0, 0, 4)
                end

                local prompt = boss:FindFirstChildWhichIsA("ProximityPrompt", true)
                if prompt then
                    fireproximityprompt(prompt)
                end

                for _ = 1, 8 do
                    FightClick:FireServer()
                end
            end)
            task.wait(0.08)
        end
    end)
end

-- ── Auto Click ────────────────────────────────────────────────────────────────
task.spawn(function()
    while task.wait() do
        if getgenv().AutoClick then
            pcall(function()
                FightClick:FireServer()
            end)
        end
    end
end)

mainTab:Toggle({
    Title    = "Auto Click",
    Desc     = "Always on by default",
    Default  = true,
    Callback = function(value: boolean)
        getgenv().AutoClick = value
    end,
})

-- ── Auto Event Egg ────────────────────────────────────────────────────────────
mainTab:Toggle({
    Title    = "Auto Event Egg",
    Desc     = "Claims event egg every 1 second",
    Default  = false,
    Callback = function(value: boolean)
        getgenv().AutoEventEgg = value
        if value then
            task.spawn(function()
                while getgenv().AutoEventEgg do
                    pcall(function()
                        RequestEventClaim:InvokeServer()
                        ClaimPetPack:InvokeServer(localPlayer)
                        RequestEventClaim:InvokeServer()
                        ClaimEggReward:InvokeServer()
                    end)
                    task.wait(1)
                end
            end)
        end
    end,
})

-- ── Auto Spin ─────────────────────────────────────────────────────────────────
mainTab:Toggle({
    Title    = "Auto Spin",
    Desc     = "Auto spins the wheel",
    Default  = false,
    Callback = function(value: boolean)
        getgenv().AutoSpin = value
        if value then
            task.spawn(function()
                while getgenv().AutoSpin do
                    pcall(function()
                        ReplicatedStorage:WaitForChild("RequestWheelSpin"):InvokeServer()
                    end)
                    task.wait(1)
                end
            end)
        end
    end,
})

-- ── Auto Claim Gift ───────────────────────────────────────────────────────────
mainTab:Toggle({
    Title    = "Auto Claim Gift",
    Desc     = "Claims all 12 gift rewards automatically",
    Default  = false,
    Callback = function(value: boolean)
        getgenv().AutoClaimGift = value
        if value then
            task.spawn(function()
                while getgenv().AutoClaimGift do
                    pcall(function()
                        local claimRemote = ReplicatedStorage:WaitForChild("RequestRewardClaim")
                        for i = 1, 12 do
                            claimRemote:InvokeServer(i)
                        end
                    end)
                    task.wait(3)
                end
            end)
        end
    end,
})

-- ── Auto Train Sword ──────────────────────────────────────────────────────────
mainTab:Toggle({
    Title    = "Auto Train Sword ▬▬ι═══════ﺤ",
    Desc     = "Equips and uses active sword tool automatically",
    Default  = false,
    Callback = function(value: boolean)
        getgenv().AutoTrainSword = value
        if value then
            task.spawn(function()
                while getgenv().AutoTrainSword do
                    pcall(function()
                        local character = localPlayer.Character
                        if not character then return end

                        -- Find already equipped sword in character
                        local sword: Tool? = nil
                        for _, item: Instance in character:GetChildren() do
                            if item:IsA("Tool") then
                                sword = item :: Tool
                                break
                            end
                        end

                        -- If not equipped, grab first tool from Backpack
                        if not sword then
                            local backpack = localPlayer:FindFirstChildOfClass("Backpack")
                            if backpack then
                                for _, item: Instance in backpack:GetChildren() do
                                    if item:IsA("Tool") then
                                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                                        if humanoid then
                                            humanoid:EquipTool(item :: Tool)
                                            task.wait(0.1)
                                            sword = item :: Tool
                                        end
                                        break
                                    end
                                end
                            end
                        end

                        if sword then
                            pcall(function() sword:Activate() end)
                            FightClick:FireServer()
                        end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end,
})

-- ── Buff Shark Boss (500M) ────────────────────────────────────────────────────
mainTab:Toggle({
    Title    = "Buff Shark Boss (500M)",
    Desc     = "Auto farm Buff Shark with proximity & attack spam",
    Default  = false,
    Callback = function(value: boolean)
        getgenv().BuffShark = value
        if value then
            farmBoss("Buff Shark", "BuffShark")
        end
    end,
})

-- ── Zeus Boss (45M) ───────────────────────────────────────────────────────────
mainTab:Toggle({
    Title    = "Zeus Boss (45M)",
    Desc     = "Auto farm Zeus with proximity & attack spam",
    Default  = false,
    Callback = function(value: boolean)
        getgenv().ZeusBoss = value
        if value then
            farmBoss("Zeus", "ZeusBoss")
        end
    end,
})

-- ── Super Saiyan Ninja Boss ───────────────────────────────────────────────────
mainTab:Toggle({
    Title    = "Super Saiyan Ninja Boss",
    Desc     = "Auto farm Super Saiyan Ninja with proximity & attack spam",
    Default  = false,
    Callback = function(value: boolean)
        getgenv().SuperSaiyanNinja = value
        if value then
            task.spawn(function()
                while getgenv().SuperSaiyanNinja do
                    pcall(function()
                        local boss = fighterNPCs:FindFirstChild("Super Saiyan Ninja")
                        if not boss then return end

                        local character = localPlayer.Character
                        if not character then return end

                        local hrp     = character:FindFirstChild("HumanoidRootPart")
                        local bossHrp = boss:FindFirstChild("HumanoidRootPart")

                        if hrp and bossHrp then
                            hrp.CFrame = bossHrp.CFrame * CFrame.new(0, 0, 4)

                            -- ProximityPrompt is inside HumanoidRootPart for this boss
                            local prompt = bossHrp:FindFirstChild("ProximityPrompt")
                            if prompt then
                                fireproximityprompt(prompt)
                            end
                        end

                        for _ = 1, 8 do
                            FightClick:FireServer()
                        end
                    end)
                    task.wait(0.08)
                end
            end)
        end
    end,
})

-- ── OP Farm Spam (Train) ──────────────────────────────────────────────────────
mainTab:Toggle({
    Title    = "OP Farm Spam (Train)",
    Desc     = "Extremely fast training farm",
    Default  = false,
    Callback = function(value: boolean)
        getgenv().AutoFarm = value
        if value then
            task.spawn(function()
                local trainRemote = nil
                local ok: boolean = pcall(function()
                    local folder = Workspace.TrainingSpotsFolder
                    local swing  = folder:WaitForChild("SwingingTrain")
                    local vip    = swing:WaitForChild("SwingW5-VIP")
                    trainRemote  = vip:WaitForChild("Train")
                end)

                if not ok or not trainRemote then
                    WindUI:Notify({
                        Title    = "Error",
                        Content  = "Train remote not found!",
                        Duration = 5,
                    })
                    getgenv().AutoFarm = false
                    return
                end

                while getgenv().AutoFarm do
                    pcall(function()
                        for _ = 1, 12 do
                            trainRemote:InvokeServer()
                            FightClick:FireServer()
                        end
                    end)
                    task.wait(0.04)
                end
            end)
        end
    end,
})

-- ── Auto Rebirth ──────────────────────────────────────────────────────────────
mainTab:Toggle({
    Title    = "Auto Rebirth",
    Desc     = "Automatically rebirth when possible",
    Default  = false,
    Callback = function(value: boolean)
        getgenv().AutoRebirth = value
        if value then
            task.spawn(function()
                while getgenv().AutoRebirth do
                    pcall(function()
                        RequestRebirth:FireServer()
                    end)
                    task.wait(3)
                end
            end)
        end
    end,
})

-- ── TP to Best Farm Zone ──────────────────────────────────────────────────────
mainTab:Button({
    Title    = "TP to Best Farm Zone",
    Callback = function()
        local character = localPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(-6237, 127, -2241)
            WindUI:Notify({ Title = "Teleported", Content = "Moved to Best Farm Zone", Duration = 3 })
        end
    end,
})

-- ── TP to World 1 ─────────────────────────────────────────────────────────────
mainTab:Button({
    Title    = "TP to World 1",
    Callback = function()
        local character = localPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(71.6, 4, -19.5)
            WindUI:Notify({ Title = "Teleported", Content = "Moved to World 1", Duration = 3 })
        end
    end,
})

-- ── TP to Super Saiyan Ninja ──────────────────────────────────────────────────
mainTab:Button({
    Title    = "TP to Super Saiyan Ninja",
    Callback = function()
        local character = localPlayer.Character
        local hrp       = character and character:FindFirstChild("HumanoidRootPart")

        if not hrp then
            WindUI:Notify({ Title = "Error", Content = "Character not ready", Duration = 4 })
            return
        end

        local boss    = fighterNPCs:FindFirstChild("Super Saiyan Ninja")
        local bossHrp = boss and boss:FindFirstChild("HumanoidRootPart")

        if bossHrp then
            hrp.CFrame = bossHrp.CFrame * CFrame.new(0, 0, 5)
            WindUI:Notify({ Title = "Teleported", Content = "Moved to Super Saiyan Ninja", Duration = 3 })
        elseif boss then
            WindUI:Notify({ Title = "Error", Content = "Boss HumanoidRootPart not found", Duration = 4 })
        else
            WindUI:Notify({ Title = "Error", Content = "Super Saiyan Ninja not found", Duration = 4 })
        end
    end,
})

-- ── Rebirth (Manual) ──────────────────────────────────────────────────────────
mainTab:Button({
    Title    = "Rebirth (Manual)",
    Callback = function()
        pcall(function()
            RequestRebirth:FireServer()
        end)
        WindUI:Notify({ Title = "Success", Content = "Rebirth requested!", Duration = 3 })
    end,
})
mainTab:Button({
    Title    = "anti afk",
    Callback = function()
    local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")

Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
    end,
})
-- ── Load notification ─────────────────────────────────────────────────────────
WindUI:Notify({
    Title    = "Ball Battle Simulator",
    Content  = "Script loaded successfully by Valtzdripness!",
    Duration = 6,
})
