wait(3) 
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local Player = Players.LocalPlayer

while task.wait(1) do
    pcall(function()
         --game.Players.LocalPlayer.Character:PivotTo(CFrame.new(Vector3.new(256.987030, 467.997772, 699.824585)))
        local Character = Player.Character or Player.CharacterAdded:Wait()
        local HRP = Character:WaitForChild("HumanoidRootPart")
        local WinPart = workspace:WaitForChild("Tower"):WaitForChild("WinPart")

        HRP.CFrame = WinPart.CFrame
    end)

    task.wait(1)

    local success, err = pcall(function()
        TeleportService:Teleport(game.PlaceId, Player)
    end)

    if not success then
        warn("Teleport failed: ".. tostring(err))
        task.wait(3)
    end
end
