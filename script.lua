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

local selectedRarities, selectedMutations = {}, {}
for _, r in ipairs(rarityList) do selectedRarities[r.id] = true end
for _, m in ipairs(mutationList) do selectedMutations[m.id] = true end

local isTweening = false
local currentTween = nil

local function cancelCurrentTween()
	if currentTween then
		currentTween:Cancel()
		currentTween = nil
	end
	isTweening = false
end

-- DOKŁADNE WYKRYWANIE TWOJEJ DZIAŁKI (STRICT SEARCH)
local function getMyPlot()
	local plotsFolder = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("PlotsFolder")
	if not plotsFolder then return nil end

	local pName = LocalPlayer.Name:lower()
	local uId = LocalPlayer.UserId

	for _, plot in pairs(plotsFolder:GetChildren()) do
		-- Sprawdzenie bezpośrednich atrybutów działki
		local ownerAttr = plot:GetAttribute("Owner") or plot:GetAttribute("OwnerId") or plot:GetAttribute("Player")
		if ownerAttr and (tostring(ownerAttr):lower() == pName or ownerAttr == uId) then
			return plot
		end

		-- Sprawdzenie obiektów OwnerValue/Owner
		local ownerObj = plot:FindFirstChild("Owner") or plot:FindFirstChild("OwnerValue")
		if ownerObj and ownerObj:IsA("ValueBase") then
			if tostring(ownerObj.Value):lower() == pName or ownerObj.Value == uId or ownerObj.Value == LocalPlayer then
				return plot
			end
		end

		-- Nazwa działki zawierająca nazwę gracza
		if plot.Name:lower():find(pName) then
			return plot
		end
	end
	return nil
end

local function getTrainingPlaceholder(plot)
	if not plot then return nil end
	return plot:FindFirstChild("TrainingAreaPlaceholder") 
		or plot:FindFirstChild("TrainingArea") 
		or plot:FindFirstChild("Training")
end

local function isPlayerInTrainingArea()
	local myPlot = getMyPlot()
	local placeholder = getTrainingPlaceholder(myPlot)
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")

	if not placeholder or not hrp then return false end

	local pos = placeholder:IsA("Model") and placeholder:GetPivot().Position or placeholder.Position
	local distance = (Vector3.new(hrp.Position.X, 0, hrp.Position.Z) - Vector3.new(pos.X, 0, pos.Z)).Magnitude
	return distance <= 15
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
	local duration = math.clamp(distance / speed, 0.05, 3.0)

	local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
	currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
	currentTween:Play()

	local startTime = tick()
	while isTweening and (tick() - startTime < duration) do
		if not autoTrainEnabled and not stealEggEnabled then
			cancelCurrentTween()
			break
		end
		task.wait(0.02)
	end
	isTweening = false
end

local function tweenToTrainingArea()
	local myPlot = getMyPlot()
	local placeholder = getTrainingPlaceholder(myPlot)
	if not placeholder then return end

	local targetCFrame = (placeholder:IsA("Model") and placeholder:GetPivot() or placeholder.CFrame) * CFrame.new(0, 3, 0)
	tweenTo(targetCFrame, 280)
end

local function getX2SpeedButton()
	local pg = LocalPlayer:FindFirstChild("PlayerGui")
	if not pg then return nil end

	local speedEffect = pg:FindFirstChild("SpeedEffect", true)
	if speedEffect then
		local frame = speedEffect:FindFirstChild("x2SpeedFrame", true) or speedEffect:FindFirstChild("x2Speed", true) or speedEffect
		if frame then
			return frame:FindFirstChildOfClass("TextButton") or frame:FindFirstChildOfClass("ImageButton") or frame
		end
	end
	return nil
end

local function clickGuiObject(guiObj)
	if not guiObj then return end

	local targetBtn = guiObj:IsA("GuiButton") and guiObj or guiObj:FindFirstChildWhichIsA("GuiButton", true)
	if not targetBtn then targetBtn = guiObj end

	if firesignal and targetBtn.MouseButton1Click then
		pcall(function() firesignal(targetBtn.MouseButton1Click) end)
	end

	if getconnections and targetBtn.MouseButton1Click then
		for _, conn in pairs(getconnections(targetBtn.MouseButton1Click)) do
			pcall(function() conn:Fire() end)
		end
	end

	pcall(function()
		local pos = targetBtn.AbsolutePosition
		local size = targetBtn.AbsoluteSize
		local inset = GuiService:GetGuiInset()
		local centerX = pos.X + (size.X / 2)
		local centerY = pos.Y + (size.Y / 2) + inset.Y

		VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, true, game, 0)
		task.wait(0.01)
		VirtualInputManager:SendMouseButtonEvent(centerX, centerY, 0, false, game, 0)
	end)
end

-- STEAL EGGS LOGIC
local function getSafeZoneCFrame()
	local line = Workspace:FindFirstChild("Line")
	if not line then return nil end
	local myPlot = getMyPlot()
	local placeholder = getTrainingPlaceholder(myPlot)

	if placeholder then
		local linePos = line.Position
		local phPos = placeholder:IsA("Model") and placeholder:GetPivot().Position or placeholder.Position
		local dir = (Vector3.new(phPos.X, linePos.Y, phPos.Z) - linePos).Unit
		local targetPos = linePos + (dir * 14) + Vector3.new(0, 3, 0)
		return CFrame.new(targetPos, targetPos + line.CFrame.LookVector)
	end
	return line.CFrame * CFrame.new(0, 3, 14)
end

local function stealBestEgg()
	while stealEggEnabled do
		local safeCFrame = getSafeZoneCFrame()
		if safeCFrame then tweenTo(safeCFrame, 280) end
		if not stealEggEnabled then break end

		task.wait(0.2)
		-- Ładowanie i podkradanie jajek
		local spawnedItems = Workspace:FindFirstChild("SpawnedItems")
		if spawnedItems then
			for _, prompt in pairs(spawnedItems:GetDescendants()) do
				if not stealEggEnabled then break end
				if prompt:IsA("ProximityPrompt") and prompt.Parent and prompt.Parent:IsA("BasePart") then
					tweenTo(prompt.Parent.CFrame * CFrame.new(0, 3, 0), 280)
					pcall(function() fireproximityprompt(prompt) end)
					task.wait(0.1)
				end
			end
		end
		task.wait(0.5)
	end
end

-- GUI BUILD
local existingGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("VoidStealer_Pro")
if existingGui then existingGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "VoidStealer_Pro"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 330, 0, 380)
mainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
mainFrame.BackgroundColor3 = VoidTheme.Background
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = VoidTheme.Header
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -10, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "VOID HUB v2"
titleLabel.TextColor3 = VoidTheme.TextPrimary
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -16, 1, -48)
scrollFrame.Position = UDim2.new(0, 8, 0, 44)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 3
scrollFrame.Parent = mainFrame

local mainLayout = Instance.new("UIListLayout")
mainLayout.Padding = UDim.new(0, 8)
mainLayout.Parent = scrollFrame

local function createToggle(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 36)
	btn.BackgroundColor3 = VoidTheme.Card
	btn.Text = text .. ": OFF"
	btn.TextColor3 = VoidTheme.TextDark
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.Parent = scrollFrame

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = btn

	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.Text = text .. (state and ": ON" or ": OFF")
		btn.TextColor3 = state and VoidTheme.AccentGlow or VoidTheme.TextDark
		callback(state)
	end)
end

createToggle("Auto Train (x2 Speed)", function(val)
	autoTrainEnabled = val
	if not autoTrainEnabled then
		cancelCurrentTween()
	end
end)

createToggle("Auto Steal Eggs", function(val)
	stealEggEnabled = val
	if stealEggEnabled then
		task.spawn(stealBestEgg)
	else
		cancelCurrentTween()
	end
end)

-- PĘTLA GLÓWNA (AUTO-TRAIN)
task.spawn(function()
	while true do
		task.wait(0.1)
		if autoTrainEnabled and not stealEggEnabled then
			if not isPlayerInTrainingArea() then
				if not isTweening then
					tweenToTrainingArea()
				end
			else
				local targetBtn = getX2SpeedButton()
				if targetBtn then
					clickGuiObject(targetBtn)
				end
			end
		end
	end
end)
