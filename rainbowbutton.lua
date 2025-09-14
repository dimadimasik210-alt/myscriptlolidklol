-- gui and rainbow button
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- blleh
if playerGui:FindFirstChild("ColorChangerGUI") then
    playerGui.ColorChangerGUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ColorChangerGUI"
screenGui.Parent = playerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0.5, -25)
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button.Text = "Нажми меня!"
button.Parent = screenGui

local function changeColor()
    button.BackgroundColor3 = Color3.new(math.random(), math.random(), math.random())
end

button.MouseButton1Click:Connect(changeColor)
