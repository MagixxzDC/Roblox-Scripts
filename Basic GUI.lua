local Fluent = loadstring(game:HttpGet(
    "https://github.com/dawid-scripts/Fluent/releases/download/1.1.0/main.lua"
))()

--------------------------------------------------
-- VARIABLES AND GUI SETUP
--------------------------------------------------

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local infiniteJumpEnabled = false
local guiKeybind = Enum.KeyCode.LeftControl
local waitingForKey = false
local keybindButton
local keybindText = "Left Control"

local Window = Fluent:CreateWindow({
    Title = "Basic GUI",
    SubTitle = "by Magixxz",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Ocean"
})

local function toggleGUI()
    Window:Minimize()
end

-------------------------------------------
-- HOME TAB
--------------------------------------------------

local HomeTab = Window:AddTab({
    Title = "Home",
    Icon = "home"
})

HomeTab:AddParagraph({
    Title = "Version",
    Content = "Version: V1"
})

HomeTab:AddParagraph({
    Title = "Thank You",
    Content = "Tysm for using my script! </3"
})

HomeTab:AddParagraph({
    Title = "Instructions",
    Content = "Click the tabs on the left for features!"
})

--------------------------------------------------
-- MAIN TAB
--------------------------------------------------

local MainTab = Window:AddTab({
    Title = "Main",
    Icon = "sword"
})

MainTab:AddButton({
    Title = "Infinite Yield FE Admin",
    Description = "Loads Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
        ))()
    end
})

MainTab:AddButton({
    Title = "Anti-AFK",
    Description = "Disables AFK kick",
    Callback = function()
        local vu = game:GetService("VirtualUser")

        game:GetService("Players").LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)

        Fluent:Notify({
            Title = "Anti-AFK",
            Content = "Anti-AFK enabled.",
            Duration = 5
        })
    end
})

--------------------------------------------------
-- TELEPORT TAB
--------------------------------------------------

local TeleportTab = Window:AddTab({
    Title = "Teleports",
    Icon = "map-pin"
})

local function Teleport(cf)
    local Character = game.Players.LocalPlayer.Character

    if Character and Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CFrame = cf
    end
end
--[[
TeleportTab:AddButton({
    Title = "TP to Orphan Home",
    Callback = function()
        Teleport(CFrame.new(
            -11.435148239135742,
            11.846817970275879,
            213.15394592285156
        ))
    end
})

TeleportTab:AddButton({
    Title = "TP to Inside",
    Callback = function()
        Teleport(CFrame.new(
            -21.989280700683594,
            11.946815490722656,
            269.50103759765625
        ))
    end
})

TeleportTab:AddButton({
    Title = "TP to Dorm",
    Callback = function()
        Teleport(CFrame.new(
            24.274734497070312,
            34.46929931640625,
            310.9074401855469
        ))
    end
})

TeleportTab:AddButton({
    Title = "TP to Jail",
    Callback = function()
        Teleport(CFrame.new(
            -24.373502731323242,
            34.40850067138672,
            358.6532897949219
        ))
    end
})

TeleportTab:AddButton({
    Title = "TP Out of Jail",
    Callback = function()
        Teleport(CFrame.new(
            -41.99845504760742,
            34.39680480957031,
            373.0892028808594
        ))
    end
})

TeleportTab:AddButton({
    Title = "TP to Shower",
    Callback = function()
        Teleport(CFrame.new(
            -72.95027160644531,
            8.079338073730469,
            255.73158264160156
        ))
    end
})

TeleportTab:AddButton({
    Title = "TP Upstairs",
    Callback = function()
        Teleport(CFrame.new(
            67.47733306884766,
            56.571800231933594,
            336.9016418457031
        ))
    end
})

TeleportTab:AddButton({
    Title = "TP to Kitchen",
    Callback = function()
        Teleport(CFrame.new(
            58.432098388671875,
            7.871817111968994,
            237.25221252441406
        ))
    end
})

TeleportTab:AddButton({
    Title = "TP to Playground",
    Callback = function()
        Teleport(CFrame.new(
            -150.2802276611328,
            4.882699966430664,
            308.1795349121094
        ))
    end
})
 --]]
TeleportTab:AddParagraph({
    Title = "More Coming Soon",
    Content = "Might add more teleports soon!"
})
--------------------------------------------------
-- MISC TAB
--------------------------------------------------

local MiscTab = Window:AddTab({
    Title = "Misc",
    Icon = "settings"
})

MiscTab:AddSlider("WalkSpeed", {
    Title = "Walk Speed",
    Description = "Change your walk speed",
    Default = 16,
    Min = 0,
    Max = 500,
    Rounding = 0
}):OnChanged(function(Value)
    local Character = game.Players.LocalPlayer.Character
    if Character and Character:FindFirstChild("Humanoid") then
        Character.Humanoid.WalkSpeed = Value
    end
end)

MiscTab:AddSlider("JumpPower", {
    Title = "Jump Power",
    Description = "Change your jump power",
    Default = 50,
    Min = 0,
    Max = 500,
    Rounding = 0
}):OnChanged(function(value)
    local character = game.Players.LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if humanoid then
        humanoid.UseJumpPower = true
        humanoid.JumpPower = value
    end
end)

keybindButton = MiscTab:AddButton({
    Title = "Set GUI Keybind",
    Description = "Current: " .. keybindText .. " | Click then type to change",
    Callback = function()
        waitingForKey = true
    end
})
--------------------------------------------------
-- CREDITS TAB
--------------------------------------------------

local CreditsTab = Window:AddTab({
    Title = "Credits",
    Icon = "heart"
})

CreditsTab:AddParagraph({
    Title = "Creator",
    Content = "Magixxz#3038 -- UI & Scripting </3"
})

Window:SelectTab(1)

local function safeKeyName(key)
    if typeof(key) == "EnumItem" then
        return key.Name
    end
    return "None"
end

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end

    local key = input.KeyCode

    if waitingForKey then
    local key = input.KeyCode

    if key ~= Enum.KeyCode.Unknown then
        guiKeybind = key
        keybindText = guiKeybind.Name

        Fluent:Notify({
        Title = "GUI Key Updated",
        Content = "Keybind set to: " .. keybindText,
        Duration = 6
        })

        keybindButton:Destroy()

        keybindButton = MiscTab:AddButton({
            Title = "Set GUI Keybind",
            Description = "Current: " .. keybindText .. " | Click then type to change",
            Callback = function()
                waitingForKey = true
            end
        })
    end

    waitingForKey = false
    return
end

    -- GUI TOGGLE
    if guiKeybind and key == guiKeybind then
        if Window and Window.Minimize then
            Window:Minimize()
        end
    end
end)

Fluent:Notify({
    Title = "Basic GUI",
    Content = "Loaded successfully!",
    Duration = 5
})
