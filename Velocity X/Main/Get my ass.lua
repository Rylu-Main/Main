local Env = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Kawai%20Lib/Source.luau", true))()

Env.Config:Init({
	Folder = "KawaiConfig",
	File = "default",
	AutoLoad = true,
	AutoSave = true,
})
-- Window
local Window = Env:Window({
	Title = "Nong Khaw",
	Desc  = "- Project",
	Logo  = 128185233852701,
})

-- Tabs
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

getgenv().SelectedDog = nil
getgenv().AutoPetDog = false
getgenv().AutoCollect = false
getgenv().TweenSpeed = 40

local General  = Window:Add({ Title = "General",  Desc = "General features",   Banner = 101849161408766 })
local DogSection = General:Section({
    Title = "Dogs",
    Side = "l"
})

local function GetDogs()
    local dogs = {}

    if workspace:FindFirstChild("ActiveDogs") then
        for _, dog in ipairs(workspace.ActiveDogs:GetChildren()) do
            table.insert(dogs, dog.Name)
        end
    end

    return dogs
end

DogSection:Dropdown({
    Title = "Select Dog",
    List = GetDogs(),
    Callback = function(v)
        getgenv().SelectedDog = v
    end,
})

DogSection:Slider({
    Title = "Tween Speed",
    Min = 10,
    Max = 200,
    Value = 40,
    Rounding = 0,
    CallBack = function(v)
        getgenv().TweenSpeed = v
    end,
})

DogSection:Toggle({
    Title = "Auto Pet Selected Dog",
    Value = false,
    Callback = function(v)
        getgenv().AutoPetDog = v
    end,
})

DogSection:Button({
    Title = "Refresh Dogs",
    Callback = function()
        print("Available Dogs:")
        for _, name in ipairs(GetDogs()) do
            print(name)
        end
    end,
})

task.spawn(function()
    while task.wait() do
        if not getgenv().AutoPetDog then
            continue
        end

        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")

        if not root then
            continue
        end

        local activeDogs = workspace:FindFirstChild("ActiveDogs")
        if not activeDogs then
            continue
        end

        local dog = activeDogs:FindFirstChild(getgenv().SelectedDog)
        if not dog then
            continue
        end

        local dogRoot = dog:FindFirstChild("HumanoidRootPart")
        if not dogRoot then
            continue
        end

        local prompt = dogRoot:FindFirstChild("PetPrompt")
        if not prompt then
            continue
        end

        local distance = (root.Position - dogRoot.Position).Magnitude
        local speed = math.max(getgenv().TweenSpeed, 1)
        local tweenTime = distance / speed

        local tween = TweenService:Create(
            root,
            TweenInfo.new(
                tweenTime,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out
            ),
            {
                CFrame = dogRoot.CFrame * CFrame.new(0, 0, 3)
            }
        )

        tween:Play()
        tween.Completed:Wait()

        pcall(function()
            fireproximityprompt(prompt)
        end)
    end
end)

-- this made by Others ppl hass using ai i lazy :3
DogSection:Toggle({
    Title = "Auto Collect Star Event",
    Value = false,
    Callback = function(v)
        getgenv().AutoCollect = v
   
        if v then
            task.spawn(function()
                while getgenv().AutoCollect do
                    local Character = LocalPlayer.Character
                    local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

                    if HRP then
                        for _, star in ipairs(workspace:GetChildren()) do
                            if star.Name == "FallingStar" and star:IsA("BasePart") then
                                pcall(function()
                                    firetouchinterest(HRP, star, 0)
                                    firetouchinterest(HRP, star, 1)
                                end)
                            end
                        end
                    end

                    task.wait(0.1)
                end
            end)
        end
    end,
})
DogSection:Button({
    Title = "Join alien? ",
    Callback = function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
	    ReplicatedStorage.RequestAlienTrigger:FireServer()
    end,
})
