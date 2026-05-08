local Neizgay = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mainery-foxxie/Main/refs/heads/main/UI%20Libary/Neiz%20UI%20Hub/Source.lua"))()
-- title
_G.SetTitle("Neiz UI")
-- tabs
local HomeTab = _G.AddTab("Home")
local SettingsTab = _G.AddTab("Settings")
local ToolsTab = _G.AddTab("Tools")

-- HOME TAB
HomeTab:AddButton({
    Text = "Click Me!",
    Callback = function()
        print("Home button clicked!")
    end
})

HomeTab:AddButton({
    Text = "Print Message",
    Callback = function()
        print("This is a message from the Home tab")
    end
})

HomeTab:AddTextbox({
    Text = "Enter Your Name",
    Placeholder = "Type something...",
    Callback = function(text)
        print("You entered: " .. text)
    end
})

-- SETTINGS TAB
SettingsTab:AddToggle({
    Text = "Enable Feature",
    Default = false,
    Callback = function(state)
        print("Feature is now: " .. (state and "ENABLED" or "DISABLED"))
    end
})

SettingsTab:AddToggle({
    Text = "Dark Mode",
    Default = true,
    Callback = function(state)
        print("Dark mode: " .. tostring(state))
    end
})

SettingsTab:AddSlider({
    Text = "Volume",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Volume set to: " .. value)
    end
})

SettingsTab:AddSlider({
    Text = "Brightness",
    Min = 0,
    Max = 100,
    Default = 75,
    Callback = function(value)
        print("Brightness: " .. value)
    end
})

-- TOOLS TAB
local DropdownExample = ToolsTab:AddDropdown({
    Text = "Select Tool",
    List = {"Sword", "Gun", "Pickaxe", "Wand"},
    Default = "Sword",
    Callback = function(selected)
        print("Selected tool: " .. selected)
    end
})

ToolsTab:AddButton({
    Text = "Update Dropdown",
    Callback = function()
        DropdownExample:Update({"Hammer", "Axe", "Bow", "Staff", "Spear"})
        print("Dropdown list updated!")
    end
})

ToolsTab:AddTextbox({
    Text = "Item ID",
    Placeholder = "Enter item ID...",
    Callback = function(text)
        print("Item ID: " .. text)
    end
})



