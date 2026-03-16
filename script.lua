repeat task.wait() until game:IsLoaded()
pcall(function() setfpscap(999) end)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

-- Player & Character
local LocalPlayer = Players.LocalPlayer

-- Configuration
local NORMAL_SPEED = 60
local CARRY_SPEED = 30
local FOV_VALUE = 70
local UI_SCALE = 1.0

-- State Variables
local speedToggled = false
local autoBatToggled = false
local hittingCooldown = false
local floatEnabled = false
local floatHeight = 10

-- Keybinds
local Keybinds = {
AutoBat = Enum.KeyCode.E,
SpeedToggle = Enum.KeyCode.Q,
AutoLeft = Enum.KeyCode.Z,
AutoRight = Enum.KeyCode.C,
InfiniteJump = Enum.KeyCode.M,
UIToggle = Enum.KeyCode.U,
Float = Enum.KeyCode.F
}

-- Auto Movement State
local AutoLeftEnabled = false
local AutoRightEnabled = false
local autoLeftConnection = nil
local autoRightConnection = nil
local autoLeftPhase = 1
local autoRightPhase = 1

-- Positions
local POSITION_L1 = Vector3.new(-476.48, -6.28, 92.73)
local POSITION_L2 = Vector3.new(-483.12, -4.95, 94.80)
local POSITION_R1 = Vector3.new(-476.16, -6.52, 25.62)
local POSITION_R2 = Vector3.new(-483.04, -5.09, 23.14)

-- Steal System (Lust insta-grab logic)
local isStealing = false
local stealStartTime = nil
local StealData = {}
-- Lust caches
local lustAnimalCache = {}
local lustMemoryCache = {}
local lustStealCache = {}

-- Values
local Values = {
STEAL_RADIUS = 20,
STEAL_DURATION = 0.2,
DEFAULT_GRAVITY = 196.2,
GalaxyGravityPercent = 70,
HOP_POWER = 35,
HOP_COOLDOWN = 0.08,
}

-- Feature States
local Enabled = {
AntiRagdoll = false,
AutoSteal = false,
InfiniteJump = false,
ShinyGraphics = false,
Optimizer = false,
Unwalk = false,
AutoLeftEnabled = false,
AutoRightEnabled = false,
}

-- Connections
local Connections = {}
local galaxyVectorForce = nil
local galaxyAttachment = nil
local galaxyEnabled = false
local hopsEnabled = false
local lastHopTime = 0
local spaceHeld = false
local originalJumpPower = 50
local originalTransparency = {}
local savedAnimations = {}
local originalSkybox = nil
local shinyGraphicsSky = nil
local shinyGraphicsConn = nil
local shinyPlanets = {}
local shinyBloom = nil
local shinyCC = nil

-- Float Variables
local floatConn = nil
local floatAttachment = nil
local floatForce = nil
local floatVisualSetter = nil

-- GUI VARIABLES
local gui = Instance.new("ScreenGui")
gui.Name = "KEEK HUB"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Window
local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0,240,0,320)
main.Position = UDim2.new(0.75,0,0.25,0)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.BorderSizePixel = 0

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,18)
corner.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.Parent = main
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "KEEK HUB"
title.TextColor3 = Color3.fromRGB(0,255,150)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

-- Scroll area
local scroll = Instance.new("ScrollingFrame")
scroll.Parent = main
scroll.Position = UDim2.new(0,0,0,40)
scroll.Size = UDim2.new(1,0,1,-40)
scroll.CanvasSize = UDim2.new(0,0,0,600)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4

local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.Padding = UDim.new(0,8)

-- BUTTON CREATOR
local function createButton(text,callback)

    local button = Instance.new("TextButton")
    button.Parent = scroll
    button.Size = UDim2.new(1,-20,0,40)
    button.Position = UDim2.new(0,10,0,0)
    button.BackgroundColor3 = Color3.fromRGB(30,30,30)
    button.TextColor3 = Color3.new(1,1,1)
    button.Text = text.." [OFF]"
    button.Font = Enum.Font.Gotham
    button.TextSize = 16

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,10)
    corner.Parent = button

    local enabled = false

    button.MouseButton1Click:Connect(function()

        enabled = not enabled

        if enabled then
            button.Text = text.." [ON]"
            button.TextColor3 = Color3.fromRGB(0,255,150)
        else
            button.Text = text.." [OFF]"
            button.TextColor3 = Color3.new(1,1,1)
        end

        if callback then
            callback(enabled)
        end

    end)

end

-- BUTTONS
createButton("Anti Ragdoll", function(v)
    Enabled.AntiRagdoll = v
end)

createButton("Auto Bat", function(v)
    autoBatToggled = v
end)

createButton("Infinite Jump", function(v)
    Enabled.InfiniteJump = v
end)

createButton("Float", function(v)
    floatEnabled = v
end)

createButton("Auto Left", function(v)
    AutoLeftEnabled = v
end)

createButton("Auto Right", function(v)
    AutoRightEnabled = v
end)

createButton("Auto Steal", function(v)
    Enabled.AutoSteal = v
end)

createButton("Optimizer", function(v)
    Enabled.Optimizer = v
end)

createButton("Shiny Graphics", function(v)
    Enabled.ShinyGraphics = v
end)

-- DRAGGABLE WINDOW
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

main.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end

end)

main.InputChanged:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end

end)

UserInputService.InputChanged:Connect(function(input)

    if input == dragInput and dragging then
        update(input)
    end

end)
