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
mainFrame.Size = UDim2.new(0, 210, 0, 115)
mainFrame.Position = UDim2.new(0.05, 0, 0.35, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(45, 45, 60)
mainStroke.Thickness = 1.5
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

local headerLabel = Instance.new("TextLabel")
headerLabel.Name = "HeaderLabel"
headerLabel.Size = UDim2.new(1, 0, 0, 28)
headerLabel.Position = UDim2.new(0, 0, 0, 2)
headerLabel.BackgroundTransparency = 1
headerLabel.Text = "AUTO FARMER"
headerLabel.TextColor3 = Color3.fromRGB(140, 140, 170)
headerLabel.TextSize = 11
headerLabel.Font = Enum.Font.GothamBold
headerLabel.Parent = mainFrame

local divider = Instance.new("Frame")
divider.Size = UDim2.new(1, -24, 0, 1)
divider.Position = UDim2.new(0, 12, 0, 30)
divider.BackgroundColor3 = Color3.fromRGB(40, 40, 52)
divider.BorderSizePixel = 0
divider.Parent = mainFrame

local function createToggleRow(titleText, posY)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 0, 30)
	label.Position = UDim2.new(0, 16, 0, posY)
	label.BackgroundTransparency = 1
	label.Text = titleText
	label.TextColor3 = Color3.fromRGB(230, 230, 240)
	label.TextSize = 13
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = mainFrame

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 40, 0, 20)
	btn.Position = UDim2.new(1, -52, 0, posY + 5)
	btn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.AutoButtonColor = false
	btn.Parent = mainFrame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(1, 0)
	btnCorner.Parent = btn

	local btnStroke = Instance.new("UIStroke")
	btnStroke.Color = Color3.fromRGB(60, 60, 75)
	btnStroke.Thickness = 1
	btnStroke.Parent = btn

	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 14, 0, 14)
	circle.Position = UDim2.new(0, 3, 0.5, -7)
	circle.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
	circle.BorderSizePixel = 0
	circle.Parent = btn

	local circleCorner = Instance.new("UICorner")
	circleCorner.CornerRadius = UDim.new(1, 0)
	circleCorner.Parent = circle

	return btn, circle, btnStroke
end

local trainBtn, trainCircle, trainStroke = createToggleRow("Auto Train", 38)
local stealBtn, stealCircle, stealStroke = createToggleRow("Steal Egg", 72)

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
local currentTween = nil

local function tweenTo(targetCFrame, speedStuds)
	local character = LocalPlayer.Character
	if not character then return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if currentTween then
		currentTween:Cancel()
	end

	isTweening = true
	local distance = (hrp.Position - targetCFrame.Position).Magnitude
	local speed = speedStuds or 65
	local duration = math.clamp(distance / speed, 0.08, 4)

	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
	currentTween:Play()
	currentTween.Completed:Wait()
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
		tweenTo(targetCFrame, 65)
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
	task.wait(0.04)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

local function getSafeZoneCFrame()
	local line = Workspace:FindFirstChild("Line")
	if line then
		return line.CFrame * CFrame.new(0, 3, 14)
	end
	return nil
end

local function chargePower()
	VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)

	local playerGui = LocalPlayer:WaitForChild("PlayerGui")
	local effects = playerGui:FindFirstChild("Effects")
	
	local startTime = tick()
	while stealEggEnabled and (tick() - startTime < 2.5) do
		task.wait(0.01)
		if effects then
			local chargeBar = effects:FindFirstChild("ChargeBar")
			if not chargeBar or not chargeBar.Visible then
				break
			end
			local frame = chargeBar:FindFirstChild("Frame")
			if not frame or not frame.Visible then
				break
			end
			local bar = frame:FindFirstChild("BAR")
			if bar and bar.Size.Y.Scale >= 0.96 then
				break
			end
		else
			break
		end
	end

	VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
	task.wait(0.05)
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
		local safeCFrame = getSafeZoneCFrame()

		if safeCFrame then
			tweenTo(safeCFrame, 65)
		elseif isPlayerInTrainingArea() then
			jump()
			task.wait(0.15)
		end

		if not stealEggEnabled then break end

		chargePower()

		if not stealEggEnabled then break end

		local prompt, targetPart = getBestEgg()
		if prompt and targetPart then
			tweenTo(targetPart.CFrame * CFrame.new(0, 3, 0), 65)
			
			task.wait(0.08)
			if fireproximityprompt then
				fireproximityprompt(prompt)
			else
				VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
				task.wait(0.03)
				VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
			end
			task.wait(0.1)
		else
			task.wait(0.2)
		end

		if not stealEggEnabled then break end

		safeCFrame = getSafeZoneCFrame()
		if safeCFrame then
			tweenTo(safeCFrame, 65)
		end

		task.wait(0.1)
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
	task.wait(0.04)
	VirtualInputManager:SendMouseButtonEvent(centerPos.X, centerPos.Y + 36, 0, false, game, 0)
end

local function tryClickX2Speed()
	if not autoTrainEnabled then return end
	
	tweenToTrainingArea()
	task.wait(0.08)

	if isPlayerInTrainingArea() then
		clickAtObject(x2Speed)
	end
end

trainBtn.MouseButton1Click:Connect(function()
	autoTrainEnabled = not autoTrainEnabled
	if autoTrainEnabled then
		trainBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
		trainCircle.Position = UDim2.new(1, -17, 0.5, -7)
		trainCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		trainStroke.Color = Color3.fromRGB(46, 204, 113)
		tryClickX2Speed()
	else
		trainBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
		trainCircle.Position = UDim2.new(0, 3, 0.5, -7)
		trainCircle.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
		trainStroke.Color = Color3.fromRGB(60, 60, 75)
		jump()
	end
end)

stealBtn.MouseButton1Click:Connect(function()
	stealEggEnabled = not stealEggEnabled
	if stealEggEnabled then
		stealBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
		stealCircle.Position = UDim2.new(1, -17, 0.5, -7)
		stealCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		stealStroke.Color = Color3.fromRGB(46, 204, 113)
		task.spawn(stealBestEgg)
	else
		stealBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
		stealCircle.Position = UDim2.new(0, 3, 0.5, -7)
		stealCircle.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
		stealStroke.Color = Color3.fromRGB(60, 60, 75)
	end
end)

task.spawn(function()
	while true do
		task.wait(0.4)
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
