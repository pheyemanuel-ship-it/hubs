--------------------------------------------------
-- HUB UI
--------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "KeekHub"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,320,0,260)
frame.Position = UDim2.new(0.5,-160,0.5,-130)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.Text = "KEEK HUB"
title.TextColor3 = Color3.fromRGB(255,80,80)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

--------------------------------------------------
-- TAB SYSTEM
--------------------------------------------------

local tabBar = Instance.new("Frame")
tabBar.Parent = frame
tabBar.Position = UDim2.new(0,0,0,30)
tabBar.Size = UDim2.new(1,0,0,30)
tabBar.BackgroundTransparency = 1

local content = Instance.new("Frame")
content.Parent = frame
content.Position = UDim2.new(0,0,0,60)
content.Size = UDim2.new(1,0,1,-60)
content.BackgroundTransparency = 1

local tabs = {}

local function createTab(name)

    local tabButton = Instance.new("TextButton")
    tabButton.Parent = tabBar
    tabButton.Size = UDim2.new(0,100,1,0)
    tabButton.BackgroundColor3 = Color3.fromRGB(40,40,40)
    tabButton.Text = name
    tabButton.TextColor3 = Color3.new(1,1,1)

    local tabFrame = Instance.new("Frame")
    tabFrame.Parent = content
    tabFrame.Size = UDim2.new(1,0,1,0)
    tabFrame.Visible = false
    tabFrame.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout")
    layout.Parent = tabFrame
    layout.Padding = UDim.new(0,6)

    tabButton.MouseButton1Click:Connect(function()

        for _,v in pairs(content:GetChildren()) do
            if v:IsA("Frame") then
                v.Visible = false
            end
        end

        tabFrame.Visible = true

    end)

    tabs[name] = tabFrame

end

--------------------------------------------------
-- BUTTON CREATOR
--------------------------------------------------

local function createToggle(parent,text,callback)

    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0.9,0,0,30)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text.." : OFF"

    local state = false

    btn.MouseButton1Click:Connect(function()

        state = not state

        if state then
            btn.Text = text.." : ON"
        else
            btn.Text = text.." : OFF"
        end

        callback(state)

    end)

end

--------------------------------------------------
-- CREATE TABS
--------------------------------------------------

createTab("Combat")
createTab("Movement")
createTab("Misc")

tabs["Combat"].Visible = true

--------------------------------------------------
-- COMBAT TAB
--------------------------------------------------

createToggle(tabs["Combat"],"Auto Bat",ToggleAutoBat)
createToggle(tabs["Combat"],"Melee Aimbot",ToggleMeleeAimbot)

--------------------------------------------------
-- MOVEMENT TAB
--------------------------------------------------

createToggle(tabs["Movement"],"Speed Boost",ToggleSpeed)
createToggle(tabs["Movement"],"Auto Left/Right",ToggleAutoLR)
createToggle(tabs["Movement"],"Infinite Jump",ToggleInfJump)

--------------------------------------------------
-- MISC TAB
--------------------------------------------------

createToggle(tabs["Misc"],"Auto Steal",ToggleAutoSteal)
createToggle(tabs["Misc"],"Anti Ragdoll",ToggleAntiRagdoll)
