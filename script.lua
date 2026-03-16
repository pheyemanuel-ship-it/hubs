-- KEEK DUEL HUB

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local lp = Players.LocalPlayer
local PlayerGui = lp:WaitForChild("PlayerGui")

-------------------------------------------------
-- POSITIONS
-------------------------------------------------

local L1 = Vector3.new(-473.90,-7.00,27.34)

-------------------------------------------------
-- CHARACTER FUNCTIONS
-------------------------------------------------

local function getHRP()
    local char = lp.Character
    if char then
        return char:FindFirstChild("HumanoidRootPart")
    end
end

local function getHum()
    local char = lp.Character
    if char then
        return char:FindFirstChildOfClass("Humanoid")
    end
end

-------------------------------------------------
-- GUI
-------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Parent = PlayerGui
gui.Name = "KEEK_DUEL_GUI"

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0,450,0,260)
frame.Position = UDim2.new(0.5,-225,0.5,-130)
frame.BackgroundColor3 = Color3.fromRGB(20,20,25)
frame.BorderColor3 = Color3.fromRGB(255,0,0)
frame.BorderSizePixel = 3

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,35)
title.BackgroundTransparency = 1
title.Text = "KEEK DUEL"
title.TextColor3 = Color3.fromRGB(255,0,0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local left = Instance.new("Frame")
left.Parent = frame
left.Size = UDim2.new(0.48,0,0.8,0)
left.Position = UDim2.new(0.02,0,0.15,0)
left.BackgroundTransparency = 1

local right = Instance.new("Frame")
right.Parent = frame
right.Size = UDim2.new(0.48,0,0.8,0)
right.Position = UDim2.new(0.5,0,0.15,0)
right.BackgroundTransparency = 1

-------------------------------------------------
-- BUTTON MAKER
-------------------------------------------------

function makeButton(parent,text,posY)

local b = Instance.new("TextButton")
b.Parent = parent
b.Size = UDim2.new(1,0,0,30)
b.Position = UDim2.new(0,0,0,posY)
b.BackgroundColor3 = Color3.fromRGB(35,35,40)
b.BorderColor3 = Color3.fromRGB(255,0,0)
b.BorderSizePixel = 2
b.TextColor3 = Color3.fromRGB(255,255,255)
b.Text = text
b.Font = Enum.Font.GothamBold
b.TextScaled = true

return b
end

-------------------------------------------------
-- BUTTONS
-------------------------------------------------

local antiRagdoll = makeButton(left,"ANTI RAGDOLL",0)
local infJump = makeButton(left,"INF JUMP",35)
local xray = makeButton(left,"X-RAY",70)

local speed = makeButton(right,"SPEED",0)
local spinbot = makeButton(right,"SPINBOT",35)
local autoLeftBtn = makeButton(right,"AUTO LEFT",70)

-------------------------------------------------
-- INF JUMP
-------------------------------------------------

local infJumpEnabled = false

infJump.MouseButton1Click:Connect(function()
infJumpEnabled = not infJumpEnabled
end)

UIS.JumpRequest:Connect(function()

if infJumpEnabled then
local hum = getHum()
if hum then
hum:ChangeState(Enum.HumanoidStateType.Jumping)
end
end

end)

-------------------------------------------------
-- SPINBOT
-------------------------------------------------

local spinning = false

spinbot.MouseButton1Click:Connect(function()

spinning = not spinning

local root = getHRP()

if spinning then

local bav = Instance.new("BodyAngularVelocity")
bav.Name = "spin"
bav.MaxTorque = Vector3.new(0,math.huge,0)
bav.AngularVelocity = Vector3.new(0,25,0)
bav.Parent = root

else

if root and root:FindFirstChild("spin") then
root.spin:Destroy()
end

end

end)

-------------------------------------------------
-- SPEED
-------------------------------------------------

speed.MouseButton1Click:Connect(function()

local hum = getHum()

if hum then
hum.WalkSpeed = 60
end

end)

-------------------------------------------------
-- XRAY
-------------------------------------------------

xray.MouseButton1Click:Connect(function()

for _,v in pairs(workspace:GetDescendants()) do
if v:IsA("BasePart") then
v.LocalTransparencyModifier = 0.5
end
end

end)

-------------------------------------------------
-- ANTI RAGDOLL
-------------------------------------------------

antiRagdoll.MouseButton1Click:Connect(function()

local char = lp.Character

for _,v in pairs(char:GetDescendants()) do
if v:IsA("BallSocketConstraint") then
v:Destroy()
end
end

end)

-------------------------------------------------
-- AUTO LEFT
-------------------------------------------------

local autoLeftEnabled = false

autoLeftBtn.MouseButton1Click:Connect(function()

autoLeftEnabled = not autoLeftEnabled

if autoLeftEnabled then
autoLeftBtn.Text = "AUTO LEFT : ON"
else
autoLeftBtn.Text = "AUTO LEFT : OFF"
end

end)

RS.Heartbeat:Connect(function()

if not autoLeftEnabled then return end

local h = getHRP()
local hum = getHum()

if not h or not hum then return end

local target = L1

local d = Vector3.new(
target.X - h.Position.X,
0,
target.Z - h.Position.Z
)

local md = d.Unit

hum:Move(md,false)

h.AssemblyLinearVelocity = Vector3.new(
md.X * 59,
h.AssemblyLinearVelocity.Y,
md.Z * 59
)

end)
