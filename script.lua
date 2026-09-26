local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer

local autoTrainEnabled = false
local stealEggEnabled = false

local VoidTheme = {
	Background = Color3.fromRGB(12, 10, 20),
	Header = Color3.fromRGB(18, 14, 30),
	Card = Color3.fromRGB(22, 18, 38),
	CardHover = Color3.fromRGB(34, 26, 58),
	ItemBg = Color3.fromRGB(28, 22, 48),
	Accent = Color3.fromRGB(150, 50, 255),
	AccentGlow = Color3.fromRGB(200, 90, 255),
	TextPrimary = Color3.fromRGB(245, 240, 255),
	TextDark = Color3.fromRGB(170, 160, 200),
	ToggleOff = Color3.fromRGB(34, 28, 52),
	ToggleOffCircle = Color3.fromRGB(100, 90, 130)
}

local rarityList = {
	{id = "common", name = "Common", weight = 1},
	{id = "uncommon", name = "Uncommon", weight = 2},
	{id = "rare", name = "Rare", weight = 3},
	{id = "epic", name = "Epic", weight = 4},
	{id = "legendary", name = "Legendary", weight = 5},
	{id = "mythic", name = "Mythic", weight = 6},
	{id = "divine", name = "Divine", weight = 7},
	{id = "secret", name = "Secret", weight = 8},
	{id = "cosmic", name = "Cosmic", weight = 9},
	{id = "eternal", name = "Eternal", weight = 10},
	{id = "admin", name = "Admin", weight = 11},
	{id = "titanium", name = "Titanium", weight = 14},
	{id = "magical", name = "Magical", weight = 15},
	{id = "nightfall", name = "Nightfall", weight = 16},
	{id = "frosty", name = "Frosty", weight = 17},
	{id = "lightning", name = "Lightning", weight = 18},
	{id = "god", name = "God", weight = 19},
	{id = "special", name = "Special", weight = 20},
	{id = "angelic", name = "Angelic", weight = 21},
	{id = "demonic", name = "Demonic", weight = 22},
	{id = "ink", name = "Ink", weight = 23},
	{id = "alien", name = "Alien", weight = 24},
	{id = "circus", name = "Circus", weight = 25},
	{id = "cloud", name = "Cloud", weight = 26},
	{id = "1x1x1x1", name = "1x1x1x1", weight = 27},
	{id = "easter", name = "Easter", weight = 28}
}

local mutationList = {
	{id = "normal", name = "Normal", weight = 1},
	{id = "golden", name = "Golden / Gold", weight = 5, alt = "gold"},
	{id = "candy", name = "Candy", weight = 6},
	{id = "diamond", name = "Diamond", weight = 8},
	{id = "void", name = "Void", weight = 10},
	{id = "sungod", name = "Sun God", weight = 15},
	{id = "rainbow", name = "Rainbow", weight = 18},
	{id = "animatedrainbow", name = "Animated Rainbow", weight = 22}
}

local selectedRarities = {}
for _, r in ipairs(rarityList) do selectedRarities[r.id] = true end

local selectedMutations = {}
for _, m in ipairs(mutationList) do selectedMutations[m.id] = true end

local existingGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("VoidStealer_Pro")
if existingGui then existingGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VoidStealer_Pro"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 330, 0, 380)
mainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
mainFrame.BackgroundColor3 = VoidTheme.Background
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = VoidTheme.Accent
mainStroke.Thickness = 2
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

task.spawn(function()
	while screenGui and screenGui.Parent do
		TweenService:Create(mainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = VoidTheme.AccentGlow}):Play()
		task.wait(1.5)
		TweenService:Create(mainStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Color = VoidTheme.Accent}):Play()
		task.wait(1.5)
	end
end)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 42)
titleBar.BackgroundColor3 = VoidTheme.Header
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 14, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "VOID HUB"
titleLabel.TextColor3 = VoidTheme.TextPrimary
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
minimizeBtn.Position = UDim2.new(1, -34, 0.5, -14)
minimizeBtn.BackgroundColor3 = VoidTheme.Card
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = VoidTheme.TextPrimary
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeBtn

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -16, 1, -52)
scrollFrame.Position = UDim2.new(0, 8, 0, 48)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.ScrollBarImageColor3 = VoidTheme.Accent
scrollFrame.Parent = mainFrame

local mainLayout = Instance.new("UIListLayout")
mainLayout.Padding = UDim.new(0, 8)
mainLayout.SortOrder = Enum.SortOrder.LayoutOrder
mainLayout.Parent = scrollFrame

local function updateScrollSize()
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, mainLayout.AbsoluteContentSize.Y + 16)
end
mainLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateScrollSize)

local function createToggleRow(parent, text, layoutOrder, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 38)
	frame.BackgroundColor3 = VoidTheme.Card
	frame.BorderSizePixel = 0
	frame.LayoutOrder = layoutOrder
	frame.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = frame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = VoidTheme.TextPrimary
	label.TextSize = 12
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 44, 0, 22)
	btn.Position = UDim2.new(1, -52, 0.5, -11)
	btn.BackgroundColor3 = VoidTheme.ToggleOff
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.Parent = frame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(1, 0)
	btnCorner.Parent = btn

	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 16, 0, 16)
	circle.Position = UDim2.new(0, 3, 0.5, -8)
	circle.BackgroundColor3 = VoidTheme.ToggleOffCircle
	circle.BorderSizePixel = 0
	circle.Parent = btn

	local circleCorner = Instance.new("UICorner")
	circleCorner.CornerRadius = UDim.new(1, 0)
	circleCorner.Parent = circle

	local isToggled = false

	local function setToggle(val)
		isToggled = val
		local targetColor = isToggled and VoidTheme.Accent or VoidTheme.ToggleOff
		local targetCirclePos = isToggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
		local targetCircleColor = isToggled and Color3.fromRGB(255, 255, 255) or VoidTheme.ToggleOffCircle

		TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
		TweenService:Create(circle, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Position = targetCirclePos,
			BackgroundColor3 = targetCircleColor
		}):Play()

		callback(isToggled)
	end

	btn.MouseButton1Click:Connect(function()
		setToggle(not isToggled)
	end)

	frame.MouseEnter:Connect(function()
		TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundColor3 = VoidTheme.CardHover}):Play()
	end)
	frame.MouseLeave:Connect(function()
		TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundColor3 = VoidTheme.Card}):Play()
	end)

	return setToggle
end

local function createAccordionSection(parent, titleText, itemsList, selectionTable, layoutOrder)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 34)
	container.BackgroundColor3 = VoidTheme.Card
	container.BorderSizePixel = 0
	container.ClipsDescendants = true
	container.LayoutOrder = layoutOrder
	container.Parent = parent

	local containerCorner = Instance.new("UICorner")
	containerCorner.CornerRadius = UDim.new(0, 8)
	containerCorner.Parent = container

	local headerBtn = Instance.new("TextButton")
	headerBtn.Size = UDim2.new(1, 0, 0, 34)
	headerBtn.BackgroundTransparency = 1
	headerBtn.Text = "  >  " .. titleText
	headerBtn.TextColor3 = VoidTheme.TextDark
	headerBtn.Font = Enum.Font.GothamBold
	headerBtn.TextSize = 11
	headerBtn.TextXAlignment = Enum.TextXAlignment.Left
	headerBtn.Parent = container

	local contentArea = Instance.new("Frame")
	contentArea.Size = UDim2.new(1, -16, 0, 0)
	contentArea.Position = UDim2.new(0, 8, 0, 38)
	contentArea.BackgroundTransparency = 1
	contentArea.Visible = false
	contentArea.Parent = container

	local ctrlFrame = Instance.new("Frame")
	ctrlFrame.Size = UDim2.new(1, 0, 0, 24)
	ctrlFrame.BackgroundTransparency = 1
	ctrlFrame.Parent = contentArea

	local selectAllBtn = Instance.new("TextButton")
	selectAllBtn.Size = UDim2.new(0.48, 0, 1, 0)
	selectAllBtn.BackgroundColor3 = VoidTheme.ItemBg
	selectAllBtn.BorderSizePixel = 0
	selectAllBtn.Text = "Select All"
	selectAllBtn.TextColor3 = VoidTheme.TextPrimary
	selectAllBtn.Font = Enum.Font.GothamMedium
	selectAllBtn.TextSize = 10
	selectAllBtn.Parent = ctrlFrame

	local selectAllCorner = Instance.new("UICorner")
	selectAllCorner.CornerRadius = UDim.new(0, 6)
	selectAllCorner.Parent = selectAllBtn

	local deselectAllBtn = Instance.new("TextButton")
	deselectAllBtn.Size = UDim2.new(0.48, 0, 1, 0)
	deselectAllBtn.Position = UDim2.new(0.52, 0, 0, 0)
	deselectAllBtn.BackgroundColor3 = VoidTheme.ItemBg
	deselectAllBtn.BorderSizePixel = 0
	deselectAllBtn.Text = "Deselect All"
	deselectAllBtn.TextColor3 = VoidTheme.TextPrimary
	deselectAllBtn.Font = Enum.Font.GothamMedium
	deselectAllBtn.TextSize = 10
	deselectAllBtn.Parent = ctrlFrame

	local deselectCorner = Instance.new("UICorner")
	deselectCorner.CornerRadius = UDim.new(0, 6)
	deselectCorner.Parent = deselectAllBtn

	local itemsContainer = Instance.new("Frame")
	itemsContainer.Size = UDim2.new(1, 0, 0, #itemsList * 28)
	itemsContainer.Position = UDim2.new(0, 0, 0, 30)
	itemsContainer.BackgroundTransparency = 1
	itemsContainer.Parent = contentArea

	local itemsLayout = Instance.new("UIListLayout")
	itemsLayout.Padding = UDim.new(0, 4)
	itemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	itemsLayout.Parent = itemsContainer

	local toggleSetters = {}

	for idx, item in ipairs(itemsList) do
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 24)
		row.BackgroundColor3 = VoidTheme.ItemBg
		row.BorderSizePixel = 0
		row.LayoutOrder = idx
		row.Parent = itemsContainer

		local rowCorner = Instance.new("UICorner")
		rowCorner.CornerRadius = UDim.new(0, 6)
		rowCorner.Parent = row

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -36, 1, 0)
		label.Position = UDim2.new(0, 10, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = item.name
		label.TextColor3 = VoidTheme.TextPrimary
		label.TextSize = 11
		label.Font = Enum.Font.Gotham
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = row

		local checkBtn = Instance.new("TextButton")
		checkBtn.Size = UDim2.new(0, 16, 0, 16)
		checkBtn.Position = UDim2.new(1, -22, 0.5, -8)
		checkBtn.BackgroundColor3 = VoidTheme.Accent
		checkBtn.BorderSizePixel = 0
		checkBtn.Text = "v"
		checkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		checkBtn.Font = Enum.Font.GothamBold
		checkBtn.TextSize = 10
		checkBtn.Parent = row

		local checkCorner = Instance.new("UICorner")
		checkCorner.CornerRadius = UDim.new(0, 4)
		checkCorner.Parent = checkBtn

		local function updateCheck(state)
			selectionTable[item.id] = state
			local color = state and VoidTheme.Accent or VoidTheme.ToggleOff
			TweenService:Create(checkBtn, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
			checkBtn.Text = state and "v" or ""
		end

		checkBtn.MouseButton1Click:Connect(function()
			updateCheck(not selectionTable[item.id])
		end)

		table.insert(toggleSetters, updateCheck)
	end

	selectAllBtn.MouseButton1Click:Connect(function()
		for _, setter in ipairs(toggleSetters) do setter(true) end
	end)

	deselectAllBtn.MouseButton1Click:Connect(function()
		for _, setter in ipairs(toggleSetters) do setter(false) end
	end)

	local isExpanded = false
	headerBtn.MouseButton1Click:Connect(function()
		isExpanded = not isExpanded
		local targetHeight = isExpanded and (38 + 30 + (#itemsList * 28)) or 34
		headerBtn.Text = (isExpanded and "  v  " or "  >  ") .. titleText
		headerBtn.TextColor3 = isExpanded and VoidTheme.AccentGlow or VoidTheme.TextDark

		if isExpanded then contentArea.Visible = true end

		local tween = TweenService:Create(container, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.new(1, 0, 0, targetHeight)
		})
		tween:Play()
		tween.Completed:Connect(function()
			if not isExpanded then contentArea.Visible = false end
			updateScrollSize()
		end)
	end)
end

local isTweening = false
local currentTween = nil

local function cancelCurrentTween()
	if currentTween then
		currentTween:Cancel()
		currentTween = nil
	end
	isTweening = false
end

createToggleRow(scrollFrame, "Auto Train (x2 Speed)", 1, function(val)
	autoTrainEnabled = val
	if not autoTrainEnabled then
		cancelCurrentTween()
	end
end)

createToggleRow(scrollFrame, "Auto Steal Eggs", 2, function(val)
	stealEggEnabled = val
	if stealEggEnabled then
		task.spawn(function()
			local self = getfenv().stealBestEggFunc
			if self then self() end
		end)
	else
		cancelCurrentTween()
	end
end)

createAccordionSection(scrollFrame, "Filter Rarities", rarityList, selectedRarities, 3)
createAccordionSection(scrollFrame, "Filter Mutations", mutationList, selectedMutations, 4)

local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	local targetSize = isMinimized and UDim2.new(0, 330, 0, 42) or UDim2.new(0, 330, 0, 380)
	minimizeBtn.Text = isMinimized and "+" or "-"
	TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)

local dragging = false
local dragInput, dragStart, startPos

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

local function getMyPlot()
	local plotsFolder = Workspace:FindFirstChild("Plots")
	if not plotsFolder then return nil end
	local playerName = LocalPlayer.Name
	for _, plotFolder in pairs(plotsFolder:GetChildren()) do
		for _, subPlot in pairs(plotFolder:GetChildren()) do
			for _, child in pairs(subPlot:GetChildren()) do
				if child.Name:find(playerName) then return subPlot end
			end
		end
	end
	return nil
end

local function tweenTo(targetCFrame, speedStuds)
	local character = LocalPlayer.Character
	if not character then return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	cancelCurrentTween()
	isTweening = true
	local distance = (hrp.Position - targetCFrame.Position).Magnitude
	local speed = speedStuds or 280
	local duration = math.clamp(distance / speed, 0.01, 1.0)

	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
	currentTween:Play()
	currentTween.Completed:Wait()
	isTweening = false
end

local function getSafeZoneCFrame()
	local line = Workspace:FindFirstChild("Line")
	if not line then return nil end
	local myPlot = getMyPlot()
	if myPlot then
		local placeholder = myPlot:FindFirstChild("TrainingAreaPlaceholder")
		if placeholder then
			local linePos = line.Position
			local placeholderPos = placeholder.Position
			local dir = (Vector3.new(placeholderPos.X, linePos.Y, placeholderPos.Z) - linePos).Unit
			local targetPos = linePos + (dir * 14) + Vector3.new(0, 3, 0)
			return CFrame.new(targetPos, targetPos + line.CFrame.LookVector)
		end
	end
	return line.CFrame * CFrame.new(0, 3, 14)
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
		tweenTo(targetCFrame, 280)
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
	task.wait(0.03)
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end

local function equipSlot1()
	local character = LocalPlayer.Character
	if not character then return end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

	if backpack and humanoid then
		local tools = backpack:GetChildren()
		if #tools > 0 then
			humanoid:EquipTool(tools[1])
		end
	end

	pcall(function()
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.One, false, game)
		task.wait(0.03)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.One, false, game)
	end)
end

local function getCarriedEggsCount()
	local character = LocalPlayer.Character
	if not character then return 0 end
	local count = 0
	for _, child in pairs(character:GetChildren()) do
		if child:GetAttribute("OwnerId") == LocalPlayer.UserId or child:HasTag("Pickable") then
			count = count + 1
		elseif child:IsA("Model") or child:IsA("BasePart") or child:IsA("Folder") then
			local lowerName = child.Name:lower()
			if lowerName:find("egg") or child:FindFirstChild("PPP") or child:FindFirstChild("PlacedEggBillboard") then
				count = count + 1
			end
		end
	end
	return count
end

local function getMaxPickup()
	local success, val = pcall(function()
		local Modifiers = require(ReplicatedStorage:FindFirstChild("Modifiers"))
		return Modifiers.Get(LocalPlayer, "MaxPickup")
	end)
	if success and type(val) == "number" and val > 0 then return val end
	return 5
end

local isLpmPressed = false

local function pressLPM()
	if isLpmPressed then return end
	isLpmPressed = true
	local camera = Workspace.CurrentCamera
	local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
	local centerX, centerY = viewport.X / 2, viewport.Y / 2

	if mouse1down then pcall(mouse1down) end
	pcall(function() VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 0) end)
	pcall(function() VirtualUser:Button1Down(Vector2.new(centerX, centerY)) end)
end

local function releaseLPM()
	if not isLpmPressed then return end
	isLpmPressed = false
	local camera = Workspace.CurrentCamera
	local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
	local centerX, centerY = viewport.X / 2, viewport.Y / 2

	if mouse1up then pcall(mouse1up) end
	pcall(function() VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 0) end)
	pcall(function() VirtualUser:Button1Up(Vector2.new(centerX, centerY)) end)
end

local function chargePower()
	if not stealEggEnabled then return end
	
	pressLPM()

	local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
	local startTime = tick()
	local maxHoldTime = 3.5

	while stealEggEnabled and (tick() - startTime < maxHoldTime) do
		task.wait(0.01)
		local effects = playerGui and playerGui:FindFirstChild("Effects")
		if effects then
			local chargeBar = effects:FindFirstChild("ChargeBar")
			if chargeBar and chargeBar.Visible then
				local frame = chargeBar:FindFirstChild("Frame")
				if frame then
					local bar = frame:FindFirstChild("BAR") or frame:FindFirstChild("Bar") or frame:FindFirstChild("Fill")
					if bar then
						local fillX = (frame.AbsoluteSize.X > 0) and (bar.AbsoluteSize.X / frame.AbsoluteSize.X) or bar.Size.X.Scale
						local fillY = (frame.AbsoluteSize.Y > 0) and (bar.AbsoluteSize.Y / frame.AbsoluteSize.Y) or bar.Size.Y.Scale
						local fill = math.min(fillX, fillY)
						if fill >= 0.94 then
							break
						end
					end
				end
			end
		end
	end

	releaseLPM()
end

local function firePrompt(prompt)
	if not prompt or not prompt.Parent then return end
	if fireproximityprompt then
		pcall(function() fireproximityprompt(prompt) end)
	else
		pcall(function()
			if prompt.InputHoldBegan then prompt:InputHoldBegan() end
			task.wait(prompt.HoldDuration or 0)
			if prompt.InputHoldEnd then prompt:InputHoldEnd() end
		end)
	end
end

local function detectEggInfo(pppPart)
	local billboard = pppPart:FindFirstChild("PlacedEggBillboard")
	local combinedText = ""
	if billboard then
		for _, desc in pairs(billboard:GetDescendants()) do
			if desc:IsA("TextLabel") then combinedText = combinedText .. " " .. desc.Text:lower() end
		end
	end
	combinedText = combinedText .. " " .. pppPart.Name:lower()

	local foundRarity, highestRarityWeight = nil, -1
	for _, r in ipairs(rarityList) do
		if combinedText:find(r.id) and r.weight > highestRarityWeight then
			highestRarityWeight = r.weight
			foundRarity = r
		end
	end

	local foundMutation, highestMutationWeight = nil, -1
	for _, m in ipairs(mutationList) do
		if (combinedText:find(m.id) or (m.alt and combinedText:find(m.alt))) and m.weight > highestMutationWeight then
			highestMutationWeight = m.weight
			foundMutation = m
		end
	end

	if not foundMutation then
		for _, m in ipairs(mutationList) do
			if m.id == "normal" then foundMutation = m break end
		end
	end

	return foundRarity, foundMutation
end

local function getSortedEggs()
	local spawnedItems = Workspace:FindFirstChild("SpawnedItems")
	if not spawnedItems then return {} end

	local eggList = {}
	for _, prompt in pairs(spawnedItems:GetDescendants()) do
		if prompt:IsA("ProximityPrompt") and (prompt.Name == "PickablePrompt" or prompt.Name:lower():find("pick")) then
			local pppPart = prompt.Parent
			if pppPart and pppPart:IsA("BasePart") then
				local rarityObj, mutationObj = detectEggInfo(pppPart)
				local isRarityAllowed = (rarityObj == nil) or (selectedRarities[rarityObj.id] == true)
				local isMutationAllowed = (mutationObj == nil) or (selectedMutations[mutationObj.id] == true)

				if isRarityAllowed and isMutationAllowed then
					local rarityWeight = rarityObj and rarityObj.weight or 1
					local mutationWeight = mutationObj and mutationObj.weight or 1
					table.insert(eggList, {
						prompt = prompt,
						part = pppPart,
						score = (rarityWeight * 100) + mutationWeight
					})
				end
			end
		end
	end

	table.sort(eggList, function(a, b) return a.score > b.score end)
	return eggList
end

local function waitSeconds(seconds)
	local elapsed = 0
	while stealEggEnabled and elapsed < seconds do
		task.wait(0.05)
		elapsed = elapsed + 0.05
	end
end

local function stealBestEgg()
	while stealEggEnabled do
		local safeCFrame = getSafeZoneCFrame()
		if safeCFrame then
			tweenTo(safeCFrame, 280)
		elseif isPlayerInTrainingArea() then
			jump()
			task.wait(0.05)
		end

		if not stealEggEnabled then break end

		waitSeconds(3)

		if not stealEggEnabled then break end

		chargePower()

		if not stealEggEnabled then break end

		local maxCarry = getMaxPickup()
		while stealEggEnabled do
			if getCarriedEggsCount() >= maxCarry then break end

			local sortedEggs = getSortedEggs()
			if #sortedEggs == 0 then break end

			local pickedAny = false
			for _, eggData in ipairs(sortedEggs) do
				if not stealEggEnabled then break end

				local prompt = eggData.prompt
				local targetPart = eggData.part

				if prompt and targetPart and targetPart:IsDescendantOf(Workspace) then
					tweenTo(targetPart.CFrame * CFrame.new(0, 3, 0), 280)
					task.wait(0.02)

					firePrompt(prompt)

					local startCount = getCarriedEggsCount()
					local waitPickup = tick()
					local successPickup = false

					repeat
						task.wait(0.01)
						if getCarriedEggsCount() > startCount then
							successPickup = true
							break
						end
					until not targetPart:IsDescendantOf(Workspace) or (tick() - waitPickup > 0.35)

					if successPickup then
						pickedAny = true
						break
					end
				end
			end

			if not pickedAny then break end
			task.wait(0.02)
		end

		if not stealEggEnabled then break end

		safeCFrame = getSafeZoneCFrame()
		if safeCFrame then
			tweenTo(safeCFrame, 280)
		end

		equipSlot1()

		task.wait(0.1)
	end

	releaseLPM()
end

getfenv().stealBestEggFunc = stealBestEgg

local function getX2SpeedObject()
	local pGui = LocalPlayer:FindFirstChild("PlayerGui")
	if not pGui then return nil end
	local speedEffect = pGui:FindFirstChild("SpeedEffect")
	if not speedEffect then return nil end
	return speedEffect:FindFirstChild("x2Speed", true)
end

local function clickGuiObject(guiObject)
	if not guiObject or not guiObject.Parent then return end
	local insetY = GuiService:GetGuiInset().Y
	local pos = guiObject.AbsolutePosition
	local size = guiObject.AbsoluteSize
	local centerX = pos.X + (size.X / 2)
	local centerY = pos.Y + (size.Y / 2) + insetY

	VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 0)
	task.wait(0.02)
	VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 0)
end

task.spawn(function()
	while true do
		task.wait(0.1)
		if autoTrainEnabled and not stealEggEnabled then
			if not isPlayerInTrainingArea() then
				tweenToTrainingArea()
			else
				local x2Btn = getX2SpeedObject()
				if x2Btn and x2Btn:IsA("GuiObject") and x2Btn.Visible then
					clickGuiObject(x2Btn)
				end
			end
		end
	end
end)
