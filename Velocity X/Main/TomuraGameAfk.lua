if game.PlaceId == 80261671008194 or game.PlaceId == 9300467672 then
getgenv().Tomura_Session = tick()
local SESSION = getgenv().Tomura_Session

local StarterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

local function notify(msg)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "Velocity X",
            Text = msg,
            Duration = 3
        })
    end)
end

local function getButtonAndText()
    for _, bubble in pairs(LP.PlayerGui.MainUI.MainFrame.RandomBubble:GetChildren()) do
        local foundBtn, foundText

        for _, v in pairs(bubble:GetDescendants()) do
            if v:IsA("TextButton") or v:IsA("ImageButton") then
                foundBtn = v
            elseif v:IsA("TextLabel") then
                foundText = v.Text
            end
        end

        if foundBtn then
            return foundBtn, foundText
        end
    end
end

local lastBtn = nil

task.spawn(function()
    while getgenv().Tomura_Session == SESSION do
        if not getgenv().Tomura_AfkGame["Auto Click Bubble"] then
            task.wait()
            continue
        end

        task.wait()

        local btn, txt = getButtonAndText()
        if btn and btn ~= lastBtn then
            lastBtn = btn

            notify("Bubble: " .. (txt or "Unknown"))

            pcall(function()
                firesignal(btn.MouseButton1Click)
            end)

            pcall(function()
                btn:Activate()
            end)
        end
    end
end)

if getgenv().Tomura_AfkGame["Anti Afk"] and not getgenv().Tomura_AntiAfkLoaded then
    getgenv().Tomura_AntiAfkLoaded = true

    local vu = game:GetService("VirtualUser")
    LP.Idled:Connect(function()
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
end

if getgenv().Tomura_AfkGame["Auto Reconnect"] and not getgenv().Tomura_ReconnectLoaded then
    getgenv().Tomura_ReconnectLoaded = true

    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/norwaylua/Alwi-script/refs/heads/main/Auto%20Reconnect.lua"))()
    end)
end
end
