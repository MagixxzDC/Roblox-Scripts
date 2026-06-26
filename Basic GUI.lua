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
local keybindText = "Left Control"

local teleportEnabled = false

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
    Title = "Remote Viewer",
    Description = "Remote Event Viewer by Ceniroso",
    Callback = function()
        loadstring(game:HttpGet(
            "https://raw.githubusercontent.com/MagixxzDC/Roblox-Scripts/main/Ceniroso%20Remote%20Spy.lua"
        ))()
    end
})

MainTab:AddButton({
    Title = "Anti-AFK",
    Description = "Disables AFK kick",
    Callback = function()
        local vu = game:GetService("VirtualUser")

        player.Idled:Connect(function()
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

local mouse = player:GetMouse()

local function teleportToMouse()
    local char = player.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local target = mouse.Hit
    if target then
        hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 3, 0))
    end
end

TeleportTab:AddButton({
    Title = "Press Q to Teleport",
    Description = "Toggle Q teleport",
    Callback = function()
        teleportEnabled = not teleportEnabled

        Fluent:Notify({
            Title = "Teleport",
            Content = "Q teleport: " .. tostring(teleportEnabled),
            Duration = 4
        })
    end
})

--------------------------------------------------
-- MISC TAB
--------------------------------------------------

local MiscTab = Window:AddTab({
    Title = "Misc",
    Icon = "settings"
})

local keybindButton

local function updateKeybindButton()
    task.defer(function()
        if keybindButton then
            keybindButton:Destroy()
        end

        keybindButton = MiscTab:AddButton({
            Title = "Set GUI Keybind",
            Description = "Current: " .. keybindText .. " | Click then type to change",
            Callback = function()
                waitingForKey = true
            end
        })
    end)
end

MiscTab:AddSlider("WalkSpeed", {
    Title = "Walk Speed",
    Description = "Change your walk speed",
    Default = 16,
    Min = 0,
    Max = 500,
    Rounding = 0
}):OnChanged(function(Value)
    local Character = player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.WalkSpeed = Value
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
    local character = player.Character
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
-- KEYBIND SYSTEM
--------------------------------------------------

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end

    local key = input.KeyCode

    if waitingForKey then
        if key ~= Enum.KeyCode.Unknown then
            guiKeybind = key
            keybindText = key.Name

            Fluent:Notify({
                Title = "GUI Key Updated",
                Content = "Keybind set to: " .. keybindText,
                Duration = 6
            })

            updateKeybindButton()
        end

        waitingForKey = false
        return
    end

    if guiKeybind and key == guiKeybind then
        Window:Minimize()
        return
    end

    if teleportEnabled and key == Enum.KeyCode.Q then
        teleportToMouse()
    end
end)

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

Fluent:Notify({
    Title = "Basic GUI",
    Content = "Loaded successfully!",
    Duration = 5
})