local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local autoTrainEnabled = false

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoTrainGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 180, 0, 46)
mainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(60, 60, 70)
mainStroke.Thickness = 1.5
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 14, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Auto Train"
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local checkboxButton = Instance.new("TextButton")
checkboxButton.Name = "CheckboxButton"
checkboxButton.Size = UDim2.new(0, 26, 0, 26)
checkboxButton.Position = UDim2.new(1, -38, 0.5, -13)
checkboxButton.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
checkboxButton.BorderSizePixel = 0
checkboxButton.Text = ""
checkboxButton.AutoButtonColor = false
checkboxButton.Parent = mainFrame

local checkboxCorner = Instance.new("UICorner")
checkboxCorner.CornerRadius = UDim.new(0, 6)
checkboxCorner.Parent = checkboxButton

local checkboxStroke = Instance.new("UIStroke")
checkboxStroke.Color = Color3.fromRGB(80, 80, 95)
checkboxStroke.Thickness = 1.5
checkboxStroke.Parent = checkboxButton

local checkmarkLabel = Instance.new("TextLabel")
checkmarkLabel.Name = "Checkmark"
checkmarkLabel.Size = UDim2.new(1, 0, 1, 0)
checkmarkLabel.BackgroundTransparency = 1
checkmarkLabel.Text = ""
checkmarkLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
checkmarkLabel.TextSize = 16
checkmarkLabel.Font = Enum.Font.GothamBold
checkmarkLabel.Parent = checkboxButton

local dragging = false
local dragStart = nil
local startPos = nil

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		local connection
		connection = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				connection:Disconnect()
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(
			startPos.X.Scale, 
			startPos.X.Offset + delta.X, 
			startPos.Y.Scale, 
			startPos.Y.Offset + delta.Y
		)
	end
end)

local function getMyPlot()
	local plotsFolder = Workspace:FindFirstChild("Plots")
	if not plotsFolder then return nil end

	local playerName = LocalPlayer.Name

	for _, plotFolder in pairs(plotsFolder:GetChildren()) do
		for _, subPlot in pairs(plotFolder:GetChildren()) do
			for _, child in pairs(subPlot:GetChildren()) do
				if child.Name:find(playerName) then
					return subPlot
				end
			end
		end
	end
	return nil
end

local isTweening = false
local function tweenToTrainingArea()
	if isTweening then return end

	local myPlot = getMyPlot()
	if not myPlot then return end

	local placeholder = myPlot:FindFirstChild("TrainingAreaPlaceholder")
	if not placeholder then return end

	local character = LocalPlayer.Character
	if not character then return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local targetCFrame = placeholder.CFrame * CFrame.new(0, 3, 0)
	
	if (hrp.Position - targetCFrame.Position).Magnitude > 4 then
		isTweening = true
		local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
		tween:Play()
		tween.Completed:Connect(function()
			isTweening = false
		end)
	end
end

local function isPlayerInTrainingArea()
	local myPlot = getMyPlot()
	if not myPlot then return false end

	local placeholder = myPlot:FindFirstChild("TrainingAreaPlaceholder")
	if not placeholder then return false end

	local character = LocalPlayer.Character
	if not character then return false end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end

	local distance = (hrp.Position - placeholder.Position).Magnitude
	return distance <= 6
end

local function jump()
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
	task.wait(0.05)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

local playerGui = LocalPlayer:WaitForChild("PlayerGui")
local speedEffect = playerGui:WaitForChild("SpeedEffect")
local leftContainer = speedEffect:WaitForChild("LeftContainer")
local currency = leftContainer:WaitForChild("Currency")
local speed = currency:WaitForChild("Speed")
local x2Speed = speed:WaitForChild("x2Speed")

local lastPosition = x2Speed.Position

local function clickAtObject(guiObject)
	local centerPos = guiObject.AbsolutePosition + (guiObject.AbsoluteSize / 2)
	VirtualInputManager:SendMouseButtonEvent(centerPos.X, centerPos.Y + 36, 0, true, game, 0)
	task.wait(0.05)
	VirtualInputManager:SendMouseButtonEvent(centerPos.X, centerPos.Y + 36, 0, false, game, 0)
end

local function tryClickX2Speed()
	if not autoTrainEnabled then return end
	
	tweenToTrainingArea()
	task.wait(0.1)

	if isPlayerInTrainingArea() then
		clickAtObject(x2Speed)
	end
end

checkboxButton.MouseButton1Click:Connect(function()
	autoTrainEnabled = not autoTrainEnabled
	if autoTrainEnabled then
		checkboxButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
		checkboxStroke.Color = Color3.fromRGB(46, 204, 113)
		checkmarkLabel.Text = "✓"
		tryClickX2Speed()
	else
		checkboxButton.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
		checkboxStroke.Color = Color3.fromRGB(80, 80, 95)
		checkmarkLabel.Text = ""
		jump()
	end
end)

task.spawn(function()
	while true do
		task.wait(0.5)
		if autoTrainEnabled then
			if not isPlayerInTrainingArea() then
				tweenToTrainingArea()
			end
		end
	end
end)

x2Speed:GetPropertyChangedSignal("Position"):Connect(function()
	if x2Speed.Position ~= lastPosition then
		lastPosition = x2Speed.Position
		tryClickX2Speed()
	end
end)

x2Speed:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
	if autoTrainEnabled then
		tryClickX2Speed()
	end
end)
