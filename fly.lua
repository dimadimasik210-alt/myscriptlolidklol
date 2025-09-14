-- Переменные игрока
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

-- Настройки
local flySpeed = 50
local flying = false
local direction = Vector3.new(0,0,0)

-- GUI
local playerGui = player:WaitForChild("PlayerGui")
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "FlyGUI"

-- Кнопка включения/выключения летания
local button = Instance.new("TextButton", screenGui)
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0.5, -75, 0.1, 0)
button.Text = "Включить летание"
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextScaled = true

button.MouseButton1Click:Connect(function()
    flying = not flying
    button.Text = flying and "Выключить летание" or "Включить летание"
end)

-- Ползунок для скорости
local speedLabel = Instance.new("TextLabel", screenGui)
speedLabel.Size = UDim2.new(0, 200, 0, 30)
speedLabel.Position = UDim2.new(0.5, -100, 0.2, 0)
speedLabel.Text = "Скорость: "..flySpeed
speedLabel.TextScaled = true
speedLabel.BackgroundTransparency = 1

local speedSlider = Instance.new("Frame", screenGui)
speedSlider.Size = UDim2.new(0, 200, 0, 20)
speedSlider.Position = UDim2.new(0.5, -100, 0.25, 0)
speedSlider.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

local sliderHandle = Instance.new("Frame", speedSlider)
sliderHandle.Size = UDim2.new(0, 20, 1, 0)
sliderHandle.Position = UDim2.new(flySpeed/100, 0, 0, 0)
sliderHandle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

-- Движение ползунка мышью
local dragging = false
sliderHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

sliderHandle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

uis.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local relative = math.clamp((input.Position.X - speedSlider.AbsolutePosition.X) / speedSlider.AbsoluteSize.X, 0, 1)
        sliderHandle.Position = UDim2.new(relative, 0, 0, 0)
        flySpeed = math.floor(relative * 200) -- скорость до 200
        speedLabel.Text = "Скорость: "..flySpeed
    end
end)

-- Отслеживание клавиш для летания
uis.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then direction = Vector3.new(0,0,-1) end
    if input.KeyCode == Enum.KeyCode.S then direction = Vector3.new(0,0,1) end
    if input.KeyCode == Enum.KeyCode.A then direction = Vector3.new(-1,0,0) end
    if input.KeyCode == Enum.KeyCode.D then direction = Vector3.new(1,0,0) end
    if input.KeyCode == Enum.KeyCode.Space then direction = direction + Vector3.new(0,1,0) end
    if input.KeyCode == Enum.KeyCode.LeftShift then direction = direction + Vector3.new(0,-1,0) end
end)

uis.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S or
       input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.D or
       input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then
        direction = Vector3.new(0,0,0)
    end
end)

-- Летание
runService.RenderStepped:Connect(function()
    if flying then
        humanoidRootPart.Velocity = direction * flySpeed
    end
end)
