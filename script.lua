local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local autoTrainEnabled = false
local stealEggEnabled = false

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
for _, r in ipairs(rarityList) do
	selectedRarities[r.id] = true
end

local selectedMutations = {}
for _, m in ipairs(mutationList) do
	selectedMutations[m.id] = true
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EggStealerGUI_V2"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 380)
mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(110, 86, 207)
mainStroke.Thickness = 1.8
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(26, 28, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "EGG STEALER PRO"
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 26, 0, 26)
minimizeBtn.Position = UDim2.new(1, -31, 0.5, -13)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(38, 42, 60)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -36)
contentFrame.Position = UDim2.new(0, 0, 0, 36)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -20, 0, 30)
tabBar.Position = UDim2.new(0, 10, 0, 8)
tabBar.BackgroundColor3 = Color3.fromRGB(24, 26, 36)
tabBar.BorderSizePixel = 0
tabBar.Parent = contentFrame

local tabBarCorner = Instance.new("UICorner")
tabBarCorner.CornerRadius = UDim.new(0, 8)
tabBarCorner.Parent = tabBar

local function createTabBtn(text, posX, widthScale)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(widthScale, -4, 1, -4)
	btn.Position = UDim2.new(posX, 2, 0, 2)
	btn.BackgroundColor3 = Color3.fromRGB(32, 35, 50)
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(180, 180, 200)
	btn.Font = Enum.Font.GothamMedium
	btn.TextSize = 11
	btn.Parent = tabBar

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn

	return btn
end

local tabMainBtn = createTabBtn("Główne", 0, 0.33)
local tabRarityBtn = createTabBtn("Rzadkości", 0.33, 0.33)
local tabMutationBtn = createTabBtn("Mutacje", 0.66, 0.34)

local pagesFolder = Instance.new("Folder")
pagesFolder.Name = "Pages"
pagesFolder.Parent = contentFrame

local function createPage()
	local page = Instance.new("Frame")
	page.Size = UDim2.new(1, -20, 1, -52)
	page.Position = UDim2.new(0, 10, 0, 44)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = pagesFolder
	return page
end

local pageMain = createPage()
local pageRarity = createPage()
local pageMutation = createPage()

pageMain.Visible = true
tabMainBtn.BackgroundColor3 = Color3.fromRGB(110, 86, 207)
tabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

local function switchTab(activeBtn, activePage)
	for _, btn in ipairs({tabMainBtn, tabRarityBtn, tabMutationBtn}) do
		btn.BackgroundColor3 = Color3.fromRGB(32, 35, 50)
		btn.TextColor3 = Color3.fromRGB(180, 180, 200)
	end
	for _, page in ipairs(pagesFolder:GetChildren()) do
		page.Visible = false
	end

	activeBtn.BackgroundColor3 = Color3.fromRGB(110, 86, 207)
	activeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	activePage.Visible = true
end

tabMainBtn.MouseButton1Click:Connect(function() switchTab(tabMainBtn, pageMain) end)
tabRarityBtn.MouseButton1Click:Connect(function() switchTab(tabRarityBtn, pageRarity) end)
tabMutationBtn.MouseButton1Click:Connect(function() switchTab(tabMutationBtn, pageMutation) end)

local function createToggleRow(parent, text, posY, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 36)
	frame.Position = UDim2.new(0, 0, 0, posY)
	frame.BackgroundColor3 = Color3.fromRGB(25, 27, 38)
	frame.BorderSizePixel = 0
	frame.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = frame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(230, 230, 245)
	label.TextSize = 12
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 42, 0, 22)
	btn.Position = UDim2.new(1, -50, 0.5, -11)
	btn.BackgroundColor3 = Color3.fromRGB(40, 44, 60)
	btn.BorderSizePixel = 0
	btn.Text = ""
	btn.Parent = frame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(1, 0)
	btnCorner.Parent = btn

	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 16, 0, 16)
	circle.Position = UDim2.new(0, 3, 0.5, -8)
	circle.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
	circle.BorderSizePixel = 0
	circle.Parent = btn

	local circleCorner = Instance.new("UICorner")
	circleCorner.CornerRadius = UDim.new(1, 0)
	circleCorner.Parent = circle

	local isToggled = false

	local function setToggle(val)
		isToggled = val
		if isToggled then
			btn.BackgroundColor3 = Color3.fromRGB(110, 86, 207)
			circle.Position = UDim2.new(1, -19, 0.5, -8)
			circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		else
			btn.BackgroundColor3 = Color3.fromRGB(40, 44, 60)
			circle.Position = UDim2.new(0, 3, 0.5, -8)
			circle.BackgroundColor3 = Color3.fromRGB(160, 160, 180)
		end
		callback(isToggled)
	end

	btn.MouseButton1Click:Connect(function()
		setToggle(not isToggled)
	end)

	return setToggle
end

local infoCard = Instance.new("Frame")
infoCard.Size = UDim2.new(1, 0, 0, 120)
infoCard.Position = UDim2.new(0, 0, 0, 106)
infoCard.BackgroundColor3 = Color3.fromRGB(25, 27, 38)
infoCard.BorderSizePixel = 0
infoCard.Parent = pageMain

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 8)
infoCorner.Parent = infoCard

local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.new(1, -20, 1, -20)
infoText.Position = UDim2.new(0, 10, 0, 10)
infoText.BackgroundTransparency = 1
infoText.Text = "• Skrypt ląduje w Safe Zone\n• Wybiera broń pod [1]\n• Czeka 3 sekundy przed rajdem\n• Filtruje wybrane Rzadkości i Mutacje"
infoText.TextColor3 = Color3.fromRGB(170, 175, 195)
infoText.TextSize = 11
infoText.Font = Enum.Font.Gotham
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.Parent = infoCard

local function createFilterPage(page, itemsList, selectionTable)
	local ctrlFrame = Instance.new("Frame")
	ctrlFrame.Size = UDim2.new(1, 0, 0, 26)
	ctrlFrame.Position = UDim2.new(0, 0, 0, 0)
	ctrlFrame.BackgroundTransparency = 1
	ctrlFrame.Parent = page

	local selectAllBtn = Instance.new("TextButton")
	selectAllBtn.Size = UDim2.new(0.48, 0, 1, 0)
	selectAllBtn.Position = UDim2.new(0, 0, 0, 0)
	selectAllBtn.BackgroundColor3 = Color3.fromRGB(38, 42, 60)
	selectAllBtn.BorderSizePixel = 0
	selectAllBtn.Text = "Zaznacz wsz."
	selectAllBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
	selectAllBtn.Font = Enum.Font.GothamMedium
	selectAllBtn.TextSize = 10
	selectAllBtn.Parent = ctrlFrame

	local selectAllCorner = Instance.new("UICorner")
	selectAllCorner.CornerRadius = UDim.new(0, 6)
	selectAllCorner.Parent = selectAllBtn

	local deselectAllBtn = Instance.new("TextButton")
	deselectAllBtn.Size = UDim2.new(0.48, 0, 1, 0)
	deselectAllBtn.Position = UDim2.new(0.52, 0, 0, 0)
	deselectAllBtn.BackgroundColor3 = Color3.fromRGB(38, 42, 60)
	deselectAllBtn.BorderSizePixel = 0
	deselectAllBtn.Text = "Odznacz wsz."
	deselectAllBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
	deselectAllBtn.Font = Enum.Font.GothamMedium
	deselectAllBtn.TextSize = 10
	deselectAllBtn.Parent = ctrlFrame

	local deselectCorner = Instance.new("UICorner")
	deselectCorner.CornerRadius = UDim.new(0, 6)
	deselectCorner.Parent = deselectAllBtn

	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, 0, 1, -32)
	scroll.Position = UDim2.new(0, 0, 0, 32)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.ScrollBarImageColor3 = Color3.fromRGB(110, 86, 207)
	scroll.Parent = page

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 5)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = scroll

	local toggleSetters = {}

	for idx, item in ipairs(itemsList) do
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -8, 0, 28)
		row.BackgroundColor3 = Color3.fromRGB(25, 27, 38)
		row.BorderSizePixel = 0
		row.LayoutOrder = idx
		row.Parent = scroll

		local rowCorner = Instance.new("UICorner")
		rowCorner.CornerRadius = UDim.new(0, 6)
		rowCorner.Parent = row

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -40, 1, 0)
		label.Position = UDim2.new(0, 10, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = item.name
		label.TextColor3 = Color3.fromRGB(210, 210, 230)
		label.TextSize = 11
		label.Font = Enum.Font.Gotham
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = row

		local checkBtn = Instance.new("TextButton")
		checkBtn.Size = UDim2.new(0, 20, 0, 20)
		checkBtn.Position = UDim2.new(1, -26, 0.5, -10)
		checkBtn.BackgroundColor3 = Color3.fromRGB(110, 86, 207)
		checkBtn.BorderSizePixel = 0
		checkBtn.Text = "✓"
		checkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		checkBtn.Font = Enum.Font.GothamBold
		checkBtn.TextSize = 12
		checkBtn.Parent = row

		local checkCorner = Instance.new("UICorner")
		checkCorner.CornerRadius = UDim.new(0, 4)
		checkCorner.Parent = checkBtn

		local function updateCheck(state)
			selectionTable[item.id] = state
			checkBtn.BackgroundColor3 = state and Color3.fromRGB(110, 86, 207) or Color3.fromRGB(45, 48, 65)
			checkBtn.Text = state and "✓" or ""
		end

		checkBtn.MouseButton1Click:Connect(function()
			updateCheck(not selectionTable[item.id])
		end)

		table.insert(toggleSetters, updateCheck)
	end

	selectAllBtn.MouseButton1Click:Connect(function()
		for _, setter in ipairs(toggleSetters) do
			setter(true)
		end
	end)

	deselectAllBtn.MouseButton1Click:Connect(function()
		for _, setter in ipairs(toggleSetters) do
			setter(false)
		end
	end)

	scroll.CanvasSize = UDim2.new(0, 0, 0, (#itemsList * 33))
end

createFilterPage(pageRarity, rarityList, selectedRarities)
createFilterPage(pageMutation, mutationList, selectedMutations)

local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		mainFrame:TweenSize(UDim2.new(0, 320, 0, 36), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
		minimizeBtn.Text = "+"
	else
		mainFrame:TweenSize(UDim2.new(0, 320, 0, 380), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.25, true)
		minimizeBtn.Text = "-"
	end
end)

local dragging, dragStart, startPos = false, nil, nil

titleBar.InputBegan:Connect(function(input)
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
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
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

	if currentTween then currentTween:Cancel() end

	isTweening = true
	local distance = (hrp.Position - targetCFrame.Position).Magnitude
	local speed = speedStuds or 260
	local duration = math.clamp(distance / speed, 0.02, 1.2)

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
		tweenTo(targetCFrame, 260)
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
	pcall(function()
		VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.One, false, game)
		task.wait(0.05)
		VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.One, false, game)
	end)

	pcall(function()
		local character = LocalPlayer.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
		if humanoid and backpack then
			local tools = backpack:GetChildren()
			if #tools > 0 then
				humanoid:EquipTool(tools[1])
			end
		end
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

	local success2, val2 = pcall(function()
		local Knit = require(ReplicatedStorage.Packages.Knit)
		local ReplicaController = Knit.GetController("ReplicaController")
		local data = ReplicaController:GetPlayerData(LocalPlayer)
		return data.Upgrades and data.Upgrades.Carry
	end)
	if success2 and type(val2) == "number" and val2 > 0 then return val2 end

	return 5
end

local function pressLPM()
	local camera = Workspace.CurrentCamera
	local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
	local centerX, centerY = viewport.X / 2, viewport.Y / 2

	if mouse1down then pcall(mouse1down) end
	pcall(function() VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 0) end)
	pcall(function() VirtualUser:Button1Down(Vector2.new(centerX, centerY)) end)
end

local function releaseLPM()
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
	local maxHoldTime = 3.2

	while stealEggEnabled and (tick() - startTime < maxHoldTime) do
		task.wait(0.01)
		local effects = playerGui and playerGui:FindFirstChild("Effects")
		if effects then
			local chargeBar = effects:FindFirstChild("ChargeBar")
			if chargeBar and chargeBar.Visible then
				local frame = chargeBar:FindFirstChild("Frame")
				if frame then
					local bar = frame:FindFirstChild("BAR") or frame:FindFirstChild("Bar")
					if bar then
						local fill = math.max(bar.Size.X.Scale, bar.Size.Y.Scale)
						if fill >= 0.92 then break end
					end
				end
			end
		end
	end

	releaseLPM()
	task.wait(0.04)
end

local function detectEggInfo(pppPart)
	local billboard = pppPart:FindFirstChild("PlacedEggBillboard")
	local combinedText = ""
	if billboard then
		for _, desc in pairs(billboard:GetDescendants()) do
			if desc:IsA("TextLabel") then
				combinedText = combinedText .. " " .. desc.Text:lower()
			end
		end
	end
	combinedText = combinedText .. " " .. pppPart.Name:lower()

	local foundRarity = nil
	local highestRarityWeight = -1
	for _, r in ipairs(rarityList) do
		if combinedText:find(r.id) then
			if r.weight > highestRarityWeight then
				highestRarityWeight = r.weight
				foundRarity = r
			end
		end
	end

	local foundMutation = nil
	local highestMutationWeight = -1
	for _, m in ipairs(mutationList) do
		if combinedText:find(m.id) or (m.alt and combinedText:find(m.alt)) then
			if m.weight > highestMutationWeight then
				highestMutationWeight = m.weight
				foundMutation = m
			end
		end
	end

	if not foundMutation then
		for _, m in ipairs(mutationList) do
			if m.id == "normal" then
				foundMutation = m
				break
			end
		end
	end

	return foundRarity, foundMutation
end

local function getSortedEggs()
	local spawnedItems = Workspace:FindFirstChild("SpawnedItems")
	if not spawnedItems then return {} end

	local eggList = {}

	for _, prompt in pairs(spawnedItems:GetDescendants()) do
		if prompt:IsA("ProximityPrompt") and prompt.Name == "PickablePrompt" then
			local pppPart = prompt.Parent
			if pppPart and pppPart:IsA("BasePart") then
				local rarityObj, mutationObj = detectEggInfo(pppPart)

				local isRarityAllowed = (rarityObj == nil) or (selectedRarities[rarityObj.id] == true)
				local isMutationAllowed = (mutationObj == nil) or (selectedMutations[mutationObj.id] == true)

				if isRarityAllowed and isMutationAllowed then
					local rarityWeight = rarityObj and rarityObj.weight or 1
					local mutationWeight = mutationObj and mutationObj.weight or 1
					local totalScore = (rarityWeight * 100) + mutationWeight

					table.insert(eggList, {
						prompt = prompt,
						part = pppPart,
						score = totalScore
					})
				end
			end
		end
	end

	table.sort(eggList, function(a, b)
		return a.score > b.score
	end)

	return eggList
end

local function waitSeconds(seconds)
	local elapsed = 0
	while stealEggEnabled and elapsed < seconds do
		task.wait(0.1)
		elapsed = elapsed + 0.1
	end
end

local function stealBestEgg()
	while stealEggEnabled do
		local safeCFrame = getSafeZoneCFrame()

		if safeCFrame then
			tweenTo(safeCFrame, 260)
		elseif isPlayerInTrainingArea() then
			jump()
			task.wait(0.05)
		end

		if not stealEggEnabled then break end

		equipSlot1()
		waitSeconds(3)

		if not stealEggEnabled then break end

		chargePower()

		if not stealEggEnabled then break end

		local maxCarry = getMaxPickup()

		while stealEggEnabled do
			local currentCarried = getCarriedEggsCount()
			if currentCarried >= maxCarry then break end

			local sortedEggs = getSortedEggs()
			if #sortedEggs == 0 then break end

			local pickedAny = false

			for _, eggData in ipairs(sortedEggs) do
				if not stealEggEnabled then break end

				local prompt = eggData.prompt
				local targetPart = eggData.part

				if prompt and targetPart and targetPart:IsDescendantOf(Workspace) then
					tweenTo(targetPart.CFrame * CFrame.new(0, 3, 0), 260)
					task.wait(0.02)

					if fireproximityprompt then
						fireproximityprompt(prompt)
					else
						VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
						task.wait(0.02)
						VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
					end

					local startCount = getCarriedEggsCount()
					local waitPickup = tick()
					local successPickup = false

					repeat
						task.wait(0.01)
						if getCarriedEggsCount() > startCount then
							successPickup = true
							break
						end
					until not targetPart:IsDescendantOf(Workspace) or (tick() - waitPickup > 0.4)

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
			tweenTo(safeCFrame, 260)
		end

		task.wait(0.1)
	end

	releaseLPM()
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

setTrainToggle = createToggleRow(pageMain, "Auto Train (x2 Speed)", 10, function(val)
	autoTrainEnabled = val
	if autoTrainEnabled then
		tryClickX2Speed()
	else
		jump()
	end
end)

setStealToggle = createToggleRow(pageMain, "Steal Egg (Auto Farm)", 56, function(val)
	stealEggEnabled = val
	if stealEggEnabled then
		task.spawn(stealBestEgg)
	else
		releaseLPM()
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
