--[[
getgenv().Evade_Event = {
    AutoCollect = true,
    EspNpc = true,
    AutoAvoid = true,
    AntiAfk = true,
    AutoReconnect = true,
    AutoRespawn = true
}
--]]

if game.PlaceId == 9872472334 then
    if not game:IsLoaded() then game.Loaded:Wait() end

local cloneref = cloneref or function(obj) return obj end
local Players = cloneref(game:GetService("Players"))
local LP = Players.LocalPlayer
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService = cloneref(game:GetService("RunService"))
local VirtualUser = cloneref(game:GetService("VirtualUser"))
local StarterGui = cloneref(game:GetService("StarterGui"))
local HttpService = cloneref(game:GetService("HttpService"))

    local function Notify(title, text)
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = title,
                Text = text,
                Duration = 10
            })
        end)
    end

    local function IsPrivateServer()
        local id = tostring(game.JobId)
        local place = tostring(game.PlaceId)

        local success, result = pcall(function()
            return HttpService:JSONDecode(
                game:HttpGet("https://games.roblox.com/v1/games/"..place.."/servers/Public?limit=100")
            )
        end)

        if success and result and result.data then
            for _, server in pairs(result.data) do
                if server.id == id then
                    return false
                end
            end
        end

        return true
    end
  
    local Threads = {}
    local ESPCache = {}

    local function StopThread(name)
        if Threads[name] then
            Threads[name] = false
        end
    end

    local function StartAutoCollect()
        if Threads.AutoCollect then return end
        Threads.AutoCollect = true
        task.spawn(function()
            while Threads.AutoCollect do
                if not getgenv().Evade_Event.AutoCollect then break end
                for _, v in pairs(workspace.Game.Effects.Tickets:GetChildren()) do
                    if not Threads.AutoCollect then break end
                    if v:IsA("Model") and (string.find(v.Name,"Visual") or string.find(v.Name,"Ticket")) then
                        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = v:GetPivot() + Vector3.new(0,1,0)
                        end
                        task.wait()
                    end
                end
                task.wait(0.2)
            end
            Threads.AutoCollect = nil
        end)
    end

    local function StartAutoAvoid()
        if Threads.AutoAvoid then return end
        Threads.AutoAvoid = true
        task.spawn(function()
            local SAFE_DISTANCE = 80
            local lastTP = 0
            while Threads.AutoAvoid do
                if not getgenv().Evade_Event.AutoAvoid then break end
                task.wait()
                local char = LP.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if not root then continue end

                local closest, dist = nil, math.huge
                for _, obj in pairs(workspace.Game.Players:GetChildren()) do
                    if not Players:FindFirstChild(obj.Name) then
                        local part = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
                        if part then
                            local d = (root.Position - part.Position).Magnitude
                            if d < dist then
                                dist = d
                                closest = part
                            end
                        end
                    end
                end

                if closest and dist < SAFE_DISTANCE and tick() - lastTP > 0.2 then
                    local dir = (root.Position - closest.Position).Unit
                    local pos = root.Position + dir * 60
                    lastTP = tick()
                    root.CFrame = CFrame.new(pos)
                end
            end
            Threads.AutoAvoid = nil
        end)
    end

    local function StartAntiAfk()
        if Threads.AntiAfk then return end
        Threads.AntiAfk = true
        LP.Idled:Connect(function()
            if getgenv().Evade_Event.AntiAfk then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
    end

    local function StartAutoReconnect()
        if Threads.AutoReconnect then return end
        Threads.AutoReconnect = true
        if getgenv().Evade_Event.AutoReconnect then
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/norwaylua/Alwi-script/refs/heads/main/Auto%20Reconnect.lua"))()
            end)
        end
    end

    RunService.RenderStepped:Connect(function()
        if not getgenv().Evade_Event.EspNpc then
            for _,v in pairs(ESPCache) do
                v:Destroy()
            end
            table.clear(ESPCache)
            return
        end

        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")

        for _, obj in pairs(workspace.Game.Players:GetChildren()) do
            if Players:FindFirstChild(obj.Name) then continue end

            if not ESPCache[obj] then
                local head = obj:FindFirstChild("Head") or obj:FindFirstChildWhichIsA("BasePart")
                if head then
                    local bill = Instance.new("BillboardGui", head)
                    bill.Size = UDim2.new(0,120,0,30)
                    bill.AlwaysOnTop = true
                    bill.StudsOffset = Vector3.new(0,3,0)

                    local txt = Instance.new("TextLabel", bill)
                    txt.Size = UDim2.new(1,0,1,0)
                    txt.BackgroundTransparency = 1
                    txt.Font = Enum.Font.Arcade
                    txt.TextScaled = true
                    txt.TextColor3 = Color3.fromRGB(0,255,0)

                    ESPCache[obj] = bill
                end
            end

            local bill = ESPCache[obj]
            if bill and root then
                local head = obj:FindFirstChild("Head") or obj:FindFirstChildWhichIsA("BasePart")
                if head then
                    local dist = math.floor((root.Position - head.Position).Magnitude)
                    bill.TextLabel.Text = "[NPC] "..obj.Name.." ["..dist.."]"
                end
            end
        end
    end)

    local function fireMode()
        ReplicatedStorage:WaitForChild("Events"):WaitForChild("Player"):WaitForChild("ChangePlayerMode"):FireServer(true)
    end

    local function onCharacter(char)
        local hum = char:WaitForChild("Humanoid")
        local fired = false

        hum:GetPropertyChangedSignal("Health"):Connect(function()
            if hum.Health <= 0 and not fired then
                fired = true
                if getgenv().Evade_Event.AutoRespawn then
                    fireMode()
                end
            end
        end)
    end

    if LP.Character then
        onCharacter(LP.Character)
    end

    LP.CharacterAdded:Connect(onCharacter)

    task.spawn(function()
        while task.wait(.1) do
            if getgenv().Evade_Event.AutoCollect then
                StartAutoCollect()
            else
                StopThread("AutoCollect")
            end

            if getgenv().Evade_Event.AutoAvoid then
                StartAutoAvoid()
            else
                StopThread("AutoAvoid")
            end

            if getgenv().Evade_Event.AntiAfk then
                StartAntiAfk()
            end

            if getgenv().Evade_Event.AutoReconnect then
                StartAutoReconnect()
            end
        end
    end)
    
    if getgenv().Checker then
        return
    end
  getgenv().Checker = true
  Notify("Velocity X", "Do Not using this script public server please using in private server to prevent not getting banned")
end
