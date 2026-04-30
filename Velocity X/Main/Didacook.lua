while wait() do
game.MarketplaceService:SignalPromptPurchaseFinished(game.Players.LocalPlayer,117040953049342,true) 
 wait(2) 
  game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
end
