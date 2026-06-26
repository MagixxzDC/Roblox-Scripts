--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- =====================================================================
-- CENIROSO REMOTE SPY - V1.7 (Adds Slow Mode / Anti-Spam)
-- Based on direct listening method (OnClientEvent / OnClientInvoke)
-- =====================================================================

if getgenv().SoroniceV1SpyLoaded then
    if game.CoreGui:FindFirstChild("cenirosoRemoteSpy") then
        game.CoreGui.SoroniceRemoteSpy:Destroy()
    end
end
getgenv().SoroniceV1SpyLoaded = true

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

_G.RawCode = ""

-- Queue system for Slow Mode
local RemoteQueue = {}
local IsSlowMode = false
local MAX_QUEUE_SIZE = 150 -- Limit to prevent memory overflow if the game spams endlessly

-- =====================================================================
-- 1. UI CREATION
-- =====================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "cenirosoRemoteSpy"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 37, 43)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Active = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 30)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

local TopBarHider = Instance.new("Frame")
TopBarHider.Parent = TopBar
TopBarHider.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
TopBarHider.BorderSizePixel = 0
TopBarHider.Position = UDim2.new(0, 0, 1, -5)
TopBarHider.Size = UDim2.new(1, 0, 0, 5)

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Remote Spy - V1.7"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TopBar
CloseButton.BackgroundTransparency = 1
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseButton.TextSize = 14

local RemotesList = Instance.new("ScrollingFrame")
RemotesList.Name = "RemotesList"
RemotesList.Parent = MainFrame
RemotesList.Active = true
RemotesList.BackgroundColor3 = Color3.fromRGB(28, 30, 36)
RemotesList.BorderSizePixel = 0
RemotesList.Position = UDim2.new(0, 10, 0, 40)
RemotesList.Size = UDim2.new(0, 180, 1, -50)
RemotesList.CanvasSize = UDim2.new(0, 0, 0, 0)
RemotesList.ScrollBarThickness = 4
RemotesList.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 6)
ListCorner.Parent = RemotesList

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = RemotesList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

local CodeDisplay = Instance.new("TextLabel")
CodeDisplay.Name = "CodeDisplay"
CodeDisplay.Parent = MainFrame
CodeDisplay.BackgroundColor3 = Color3.fromRGB(40, 42, 54)
CodeDisplay.BorderSizePixel = 0
CodeDisplay.Position = UDim2.new(0, 200, 0, 40)
CodeDisplay.Size = UDim2.new(1, -210, 1, -90)
CodeDisplay.Font = Enum.Font.Code
CodeDisplay.Text = "<font color=\"#7A828B\">-- Waiting for events...\n-- Scripts will appear here with syntax highlighting.</font>"
CodeDisplay.TextColor3 = Color3.fromRGB(248, 248, 242)
CodeDisplay.TextSize = 14
CodeDisplay.TextXAlignment = Enum.TextXAlignment.Left
CodeDisplay.TextYAlignment = Enum.TextYAlignment.Top
CodeDisplay.RichText = true
CodeDisplay.TextWrapped = true

local CodeCorner = Instance.new("UICorner")
CodeCorner.CornerRadius = UDim.new(0, 6)
CodeCorner.Parent = CodeDisplay

local UIPadding = Instance.new("UIPadding")
UIPadding.Parent = CodeDisplay
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingLeft = UDim.new(0, 10)

-- Buttons (Repositioned to include Slow button)
local CopyButton = Instance.new("TextButton")
CopyButton.Name = "CopyButton"
CopyButton.Parent = MainFrame
CopyButton.BackgroundColor3 = Color3.fromRGB(45, 100, 200)
CopyButton.Position = UDim2.new(0, 200, 1, -40)
CopyButton.Size = UDim2.new(0, 110, 0, 30)
CopyButton.Font = Enum.Font.GothamBold
CopyButton.Text = "Copy"
CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyButton.TextSize = 13

local CopyCorner = Instance.new("UICorner")
CopyCorner.CornerRadius = UDim.new(0, 6)
CopyCorner.Parent = CopyButton

local SlowButton = Instance.new("TextButton")
SlowButton.Name = "SlowButton"
SlowButton.Parent = MainFrame
SlowButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
SlowButton.Position = UDim2.new(0, 315, 1, -40)
SlowButton.Size = UDim2.new(0, 110, 0, 30)
SlowButton.Font = Enum.Font.GothamBold
SlowButton.Text = "Slow Mode: OFF"
SlowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SlowButton.TextSize = 13

local SlowCorner = Instance.new("UICorner")
SlowCorner.CornerRadius = UDim.new(0, 6)
SlowCorner.Parent = SlowButton

local ClearButton = Instance.new("TextButton")
ClearButton.Name = "ClearButton"
ClearButton.Parent = MainFrame
ClearButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
ClearButton.Position = UDim2.new(0, 430, 1, -40)
ClearButton.Size = UDim2.new(0, 110, 0, 30)
ClearButton.Font = Enum.Font.GothamBold
ClearButton.Text = "Clear"
ClearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ClearButton.TextSize = 13

local ClearCorner = Instance.new("UICorner")
ClearCorner.CornerRadius = UDim.new(0, 6)
ClearCorner.Parent = ClearButton

-- =====================================================================
-- 2. DRAG SYSTEM
-- =====================================================================

local dragging, dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- =====================================================================
-- 3. SYNTAX HIGHLIGHTING ENGINE
-- =====================================================================

local function ApplySyntaxHighlighting(codeString)
    local highlighted = codeString:gsub("<", "&lt;"):gsub(">", "&gt;")

    local colorKeyword = "#FF79C6" 
    local colorString = "#F1FA8C"  
    local colorNumber = "#BD93F9"  
    local colorMethod = "#50FA7B"  

    highlighted = highlighted:gsub('("[^"]*")', '<font color="'..colorString..'">%1</font>')
    highlighted = highlighted:gsub("([%s%[,=])(%d+%.?%d*)([%s%],;])", "%1<font color=\""..colorNumber.."\">%2</font>%3")
    highlighted = highlighted:gsub("^(%d+%.?%d*)([%s%],;])", "<font color=\""..colorNumber.."\">%1</font>%2")
    highlighted = highlighted:gsub("(FireServer)", '<font color="'..colorMethod..'">%1</font>')
    highlighted = highlighted:gsub("(InvokeServer)", '<font color="'..colorMethod..'">%1</font>')

    local keywords = {
        "local", "function", "return", "if", "then", "else", "elseif", 
        "end", "for", "while", "do", "in", "and", "or", "not", 
        "true", "false", "nil", "unpack"
    }

    for _, kw in pairs(keywords) do
        highlighted = highlighted:gsub("([^%a_])("..kw..")([^%a_])", "%1<font color=\""..colorKeyword.."\">%2</font>%3")
        highlighted = highlighted:gsub("^("..kw..")([^%a_])", "<font color=\""..colorKeyword.."\">%1</font>%2")
        highlighted = highlighted:gsub("([^%a_])("..kw..")$", "%1<font color=\""..colorKeyword.."\">%2</font>")
    end

    return highlighted
end

-- =====================================================================
-- 4. ARGUMENT FORMATTING LOGIC
-- =====================================================================

local function getPathToInstance(instance)
    local path = {}
    local current = instance
    while current and current ~= game do
        local name = current.Name
        if name:sub(1, 4) == "Game" then
            name = "game" .. name:sub(5)
        end
        table.insert(path, 1, name)
        current = current.Parent
    end
    return table.concat(path, ".")
end

local function formatValue(value)
    if typeof(value) == "string" then
        return string.format("%q", value)
    elseif typeof(value) == "number" then
        return tostring(value)
    elseif typeof(value) == "boolean" then
        return value and "true" or "false"
    elseif typeof(value) == "Instance" then
        return getPathToInstance(value)
    elseif typeof(value) == "Vector3" then
        return string.format("Vector3.new(%f, %f, %f)", value.X, value.Y, value.Z)
    elseif typeof(value) == "CFrame" then
        return string.format("CFrame.new(%f, %f, %f)", value.X, value.Y, value.Z)
    else
        return string.format("%q", tostring(value))
    end
end

local function Format(args)
    local formattedArgs = {}
    for i, arg in ipairs(args) do
        formattedArgs[i] = string.format("[%d] = %s", i, formatValue(arg))
    end
    return formattedArgs
end

-- =====================================================================
-- 5. INTERCEPTION, UI DISPLAY & QUEUE SYSTEM
-- =====================================================================

local function CreateRemoteButton(remoteName, generatedCode)
    local RemoteBtn = Instance.new("TextButton")
    RemoteBtn.Name = remoteName
    RemoteBtn.Parent = RemotesList
    RemoteBtn.BackgroundColor3 = Color3.fromRGB(45, 47, 55)
    RemoteBtn.BorderSizePixel = 0
    RemoteBtn.Size = UDim2.new(1, -10, 0, 25)
    RemoteBtn.Position = UDim2.new(0, 5, 0, 0)
    RemoteBtn.Font = Enum.Font.Gotham
    RemoteBtn.Text = " " .. remoteName
    RemoteBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    RemoteBtn.TextSize = 13
    RemoteBtn.TextXAlignment = Enum.TextXAlignment.Left

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 4)
    BtnCorner.Parent = RemoteBtn

    RemotesList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)

    RemoteBtn.MouseButton1Click:Connect(function()
        _G.RawCode = generatedCode 
        local coloredCode = ApplySyntaxHighlighting(generatedCode)
        CodeDisplay.Text = coloredCode
    end)
end

task.spawn(function()
    while true do
        if #RemoteQueue > 0 then
            if IsSlowMode then
                local eventData = table.remove(RemoteQueue, 1)
                CreateRemoteButton(eventData.Name, eventData.Code)
                task.wait(5)
            else
                for i = 1, #RemoteQueue do
                    local eventData = table.remove(RemoteQueue, 1)
                    CreateRemoteButton(eventData.Name, eventData.Code)
                end
                task.wait(0.1)
            end
        else
            task.wait(0.1)
        end
    end
end)

local function handleRemote(remote)
    local path = {}
    local current = remote
    while current and current.Parent ~= game do
        local name = current.Name
        if name:sub(1, 4) == "Game" then
            name = "game" .. name:sub(5)
        end
        table.insert(path, 1, name)
        current = current.Parent
    end
    local fullPath = table.concat(path, ".")

    if remote:IsA("RemoteEvent") then
        remote.OnClientEvent:Connect(function(...)
            local args = {...}
            local argsFormatted = Format(args)
            local argsString = table.concat(argsFormatted, ",\n    ")
            
            local code = string.format("local args = {\n    %s\n}\n\n%s:FireServer(unpack(args))", argsString, fullPath)
            
            if #RemoteQueue < MAX_QUEUE_SIZE then
                table.insert(RemoteQueue, {Name = remote.Name, Code = code})
            end
        end)

    elseif remote:IsA("RemoteFunction") then
        remote.OnClientInvoke = function(...)
            local args = {...}
            local argsFormatted = Format(args)
            local argsString = table.concat(argsFormatted, ",\n    ")
            
            local code = string.format("local args = {\n    %s\n}\n\nlocal response = %s:InvokeServer(unpack(args))", argsString, fullPath)
            
            if #RemoteQueue < MAX_QUEUE_SIZE then
                table.insert(RemoteQueue, {Name = remote.Name, Code = code})
            end
            
            return ...
        end
    end
end

local function wrapRemotes(folder)
    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            handleRemote(obj)
        end
    end
    folder.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
            handleRemote(descendant)
        end
    end)
end

-- =====================================================================
-- 6. STARTUP & EXTRA BUTTONS
-- =====================================================================

local folders = {
    game:GetService("ReplicatedStorage"),
    game:GetService("StarterGui"),
    game:GetService("StarterPack"),
    game:GetService("StarterPlayer")
}

for _, folder in ipairs(folders) do
    wrapRemotes(folder)
end

CopyButton.MouseButton1Click:Connect(function()
    if setclipboard then
        if _G.RawCode ~= "" then
            setclipboard(_G.RawCode)
            CopyButton.Text = "Copied!"
            task.wait(1.5)
            CopyButton.Text = "Copy"
        end
    else
        warn("Your executor does not support setclipboard")
    end
end)

SlowButton.MouseButton1Click:Connect(function()
    IsSlowMode = not IsSlowMode
    
    if IsSlowMode then
        SlowButton.Text = "Slow Mode: ON"
        SlowButton.BackgroundColor3 = Color3.fromRGB(200, 130, 40)
    else
        SlowButton.Text = "Slow Mode: OFF"
        SlowButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    end
end)

ClearButton.MouseButton1Click:Connect(function()
    RemoteQueue = {}
    
    for _, child in pairs(RemotesList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    RemotesList.CanvasSize = UDim2.new(0, 0, 0, 0)
    CodeDisplay.Text = "<font color=\"#7A828B\">-- Waiting for events...\n-- Scripts will appear here with syntax highlighting.</font>"
    _G.RawCode = ""
end)

print("SORONICE Spy V1.7 loaded successfully (Slow Mode enabled).")