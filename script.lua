local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

local autoTrainEnabled = false
local stealEggEnabled = false

local rarityWeights = {
	common = 1, uncommon = 2, rare = 3, epic = 4, legendary = 5,
	mythic = 6, divine = 7, secret = 8, cosmic = 9, eternal = 10,
	admin = 11, cyber = 12, law = 13, titanium = 14, magical = 15,
	nightfall = 16, frosty = 17, lightning = 18, god = 19, special = 20,
	angelic = 21, demonic = 22, ink = 23, alien = 24, circus = 25,
	cloud = 26, ["1x1x1x1"] = 27, easter = 28, normal = 1, golden = 5,
	gold = 5, candy = 6, diamond = 8, void = 10, sungod = 15,
	rainbow = 18, animatedrainbow = 22
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoTrainGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 180, 0, 84)
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
titleLabel.Size = UDim2.new(1, -50, 0, 36)
titleLabel.Position = UDim2.new(0, 14, 0, 4)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Auto Train"
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local checkboxButton = Instance.new("TextButton")
checkboxButton.Name = "CheckboxButton"
checkboxButton.Size = UDim2.new(0, 22, 0, 22)
checkboxButton.Position = UDim2.new(1, -34, 0, 11)
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
checkmarkLabel.TextSize = 14
checkmarkLabel.Font = Enum.Font.GothamBold
checkmarkLabel.Parent = checkboxButton

local titleLabel2 = Instance.new("TextLabel")
titleLabel2.Name = "TitleLabel2"
titleLabel2.Size = UDim2.new(1, -50, 0, 36)
titleLabel2.Position = UDim2.new(0, 14, 0, 44)
titleLabel2.BackgroundTransparency = 1
titleLabel2.Text = "Steal Egg"
titleLabel2.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLabel2.TextSize = 14
titleLabel2.Font = Enum.Font.GothamBold
titleLabel2.TextXAlignment = Enum.TextXAlignment.Left
titleLabel2.Parent = mainFrame

local checkboxButton2 = Instance.new("TextButton")
checkboxButton2.Name = "CheckboxButton2"
checkboxButton2.Size = UDim2.new(0, 22, 0, 22)
checkboxButton2.Position = UDim2.new(1, -34, 0, 51)
checkboxButton2.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
checkboxButton2.BorderSizePixel = 0
checkboxButton2.Text = ""
checkboxButton2.AutoButtonColor = false
checkboxButton2.Parent = mainFrame

local checkboxCorner2 = Instance.new("UICorner")
checkboxCorner2.CornerRadius = UDim.new(0, 6)
checkboxCorner2.Parent = checkboxButton2

local checkboxStroke2 = Instance.new("UIStroke")
checkboxStroke2.Color = Color3.fromRGB(80, 80, 95)
checkboxStroke2.Thickness = 1.5
checkboxStroke2.Parent = checkboxButton2

local checkmarkLabel2 = Instance.new("TextLabel")
checkmarkLabel2.Name = "Checkmark2"
checkmarkLabel2.Size = UDim2.new(1, 0, 1, 0)
checkmarkLabel2.BackgroundTransparency = 1
checkmarkLabel2.Text = ""
checkmarkLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
checkmarkLabel2.TextSize = 14
checkmarkLabel2.Font = Enum.Font.GothamBold
checkmarkLabel2.Parent = checkboxButton2

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
local function tweenTo(targetCFrame, customTime)
	local character = LocalPlayer.Character
	if not character then return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	isTweening = true
	local distance = (hrp.Position - targetCFrame.Position).Magnitude
	local duration = customTime or math.clamp(distance / 28, 0.8, 6)
	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
	tween:Play()
	tween.Completed:Wait()
	isTweening = false
end

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
		tweenTo(targetCFrame)
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

	return (hrp.Position - placeholder.Position).Magnitude <= 6
end

local function jump()
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
	task.wait(0.05)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

local function chargePower()
	local line = Workspace:FindFirstChild("Line")
	if line then
		local lineCFrame = line.CFrame * CFrame.new(0, 3, 10)
		tweenTo(lineCFrame)
	end

	task.wait(0.2)
	VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)

	local playerGui = LocalPlayer:WaitForChild("PlayerGui")
	local effects = playerGui:WaitForChild("Effects")
	local chargeBar = effects:WaitForChild("ChargeBar"):WaitForChild("Frame")
	local bar = chargeBar:WaitForChild("BAR")

	repeat
		task.wait(0.01)
	until bar.Size.Y.Scale >= 0.98 or not stealEggEnabled

	VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

local function getBestEgg()
	local spawnedItems = Workspace:FindFirstChild("SpawnedItems")
	if not spawnedItems then return nil, nil end

	local bestPrompt = nil
	local bestPart = nil
	local highestScore = -1

	for _, prompt in pairs(spawnedItems:GetDescendants()) do
		if prompt:IsA("ProximityPrompt") and prompt.Name == "PickablePrompt" then
			local pppPart = prompt.Parent
			if pppPart and pppPart:IsA("BasePart") then
				local billboard = pppPart:FindFirstChild("PlacedEggBillboard")
				if billboard then
					local rarityLabel = billboard:FindFirstChild("RarityLabel")
					if rarityLabel and rarityLabel:IsA("TextLabel") then
						local rarityText = rarityLabel.Text:lower()
						local score = rarityWeights[rarityText] or 1

						if score > highestScore then
							highestScore = score
							bestPrompt = prompt
							bestPart = pppPart
						end
					end
				end
			end
		end
	end

	return bestPrompt, bestPart
end

local function stealBestEgg()
	while stealEggEnabled do
		if isPlayerInTrainingArea() then
			jump()
			task.wait(0.5)
		end

		chargePower()

		if not stealEggEnabled then break end

		task.wait(0.2)

		local prompt, targetPart = getBestEgg()
		if prompt and targetPart then
			tweenTo(targetPart.CFrame * CFrame.new(0, 3, 0))
			
			task.wait(0.3)
			if fireproximityprompt then
				fireproximityprompt(prompt)
			else
				VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
				task.wait(0.05)
				VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
			end
			task.wait(0.5)
		end

		local line = Workspace:FindFirstChild("Line")
		if line then
			tweenTo(line.CFrame * CFrame.new(0, 3, 10))
		end

		task.wait(0.5)
	end
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

checkboxButton2.MouseButton1Click:Connect(function()
	stealEggEnabled = not stealEggEnabled
	if stealEggEnabled then
		checkboxButton2.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
		checkboxStroke2.Color = Color3.fromRGB(46, 204, 113)
		checkmarkLabel2.Text = "✓"
		task.spawn(stealBestEgg)
	else
		checkboxButton2.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
		checkboxStroke2.Color = Color3.fromRGB(80, 80, 95)
		checkmarkLabel2.Text = ""
	end
end)

task.spawn(function()
	while true do
		task.wait(0.5)
		if autoTrainEnabled and not isTweening and not stealEggEnabled then
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
