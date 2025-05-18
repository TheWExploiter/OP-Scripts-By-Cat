local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local stopAttack = false
local targetPlayer = nil

-- UI Creation
local function makeUI()
	local gui = Instance.new("ScreenGui", game.CoreGui)
	gui.Name = "TrashcanMovesetUI"

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 550, 0, 300)
	frame.Position = UDim2.new(0, 20, 0.5, -150)
	frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Draggable = true

	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, 0, 0, 45)
	title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	title.Text = "Trashcan Moveset"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextScaled = true
	title.Font = Enum.Font.GothamBlack
	title.BorderSizePixel = 0
	Instance.new("UICorner", title).CornerRadius = UDim.new(0, 15)

	local scroll = Instance.new("ScrollingFrame", frame)
	scroll.Size = UDim2.new(1, 0, 1, -45)
	scroll.Position = UDim2.new(0, 0, 0, 45)
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.ScrollBarThickness = 6
	scroll.BackgroundTransparency = 0.2
	scroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)

	local layout = Instance.new("UIListLayout", scroll)
	layout.Padding = UDim.new(0, 6)

	return scroll
end

local Scroll = makeUI()

local function lookAt(pos)
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.CFrame = CFrame.new(hrp.Position, Vector3.new(pos.X, hrp.Position.Y, pos.Z))
	end
end

local function teleportNear(pos, studs)
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if root then
		local offset = (root.CFrame.LookVector).Unit * -studs
		root.CFrame = CFrame.new(pos + Vector3.new(0, 2, 0) + offset)
	end
end

local function click()
	local comm = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Communicate")
	if comm then
		comm:FireServer({Goal = "LeftClick", Mobile = true})
	end
end

local function release()
	local comm = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Communicate")
	if comm then
		comm:FireServer({Goal = "LeftClickRelease", Mobile = true})
	end
end

local function throw()
	click()
	task.wait(0.1)
	release()
end

local function getRandomTrashcan()
	local trashFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Trash")
	if not trashFolder then return nil end

	local cans = {}
	for _, model in pairs(trashFolder:GetChildren()) do
		local trashcan = model:FindFirstChild("Trashcan")
		if trashcan and trashcan:IsA("MeshPart") then
			table.insert(cans, trashcan)
		end
	end

	if #cans == 0 then return nil end
	return cans[math.random(1, #cans)]
end

local function attackPlayer(target)
	stopAttack = false

	while target and not stopAttack and target.Character and target.Character:FindFirstChild("Humanoid") and target.Character.Humanoid.Health > 0 do
		local trashMesh = getRandomTrashcan()
		if not trashMesh then
			task.wait(1)
			continue
		end

		teleportNear(trashMesh.Position, 2)
		lookAt(trashMesh.Position)
		task.wait(0.4)
		click()

		task.wait(0.8)

		local root = target.Character:FindFirstChild("HumanoidRootPart")
		if root then
			teleportNear(root.Position, 2.5)
			lookAt(root.Position)
			task.wait(0.25)
			throw()
		end

		task.wait(1)
	end
end

-- STOP button
local function createStopButton()
	local stopButton = Instance.new("TextButton", Scroll)
	stopButton.Size = UDim2.new(1, -10, 0, 40)
	stopButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
	stopButton.TextColor3 = Color3.new(1, 1, 1)
	stopButton.Font = Enum.Font.GothamBlack
	stopButton.TextScaled = true
	stopButton.Text = "STOP Attacking"

	Instance.new("UICorner", stopButton).CornerRadius = UDim.new(0, 12)

	stopButton.MouseButton1Click:Connect(function()
		stopAttack = true
		targetPlayer = nil
	end)
end

-- Profile + Target button
local function createButton(player)
	local holder = Instance.new("Frame", Scroll)
	holder.Size = UDim2.new(1, -10, 0, 50)
	holder.BackgroundTransparency = 1

	local pfp = Instance.new("ImageLabel", holder)
	pfp.Size = UDim2.new(0, 40, 0, 40)
	pfp.Position = UDim2.new(0, 0, 0.5, -20)
	pfp.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
	pfp.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	pfp.BorderSizePixel = 0
	Instance.new("UICorner", pfp).CornerRadius = UDim.new(1, 0)

	local button = Instance.new("TextButton", holder)
	button.Size = UDim2.new(1, -50, 1, 0)
	button.Position = UDim2.new(0, 50, 0, 0)
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.Gotham
	button.TextScaled = true
	button.Text = "Target: " .. player.Name

	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 12)

	button.MouseButton1Click:Connect(function()
		targetPlayer = player
		attackPlayer(player)
	end)
end

for _, plr in pairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer then
		createButton(plr)
	end
end

Players.PlayerAdded:Connect(function(p)
	if p ~= LocalPlayer then
		createButton(p)
	end
end)

Players.PlayerRemoving:Connect(function(p)
	for _, frame in pairs(Scroll:GetChildren()) do
		if frame:IsA("Frame") then
			local btn = frame:FindFirstChildOfClass("TextButton")
			if btn and btn.Text == ("Target: " .. p.Name) then
				frame:Destroy()
			end
		end
	end
end)

createStopButton()

task.spawn(function()
	while true do
		task.wait(0.1)
		if targetPlayer and targetPlayer.Character then
			local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
			local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
			if humanoid and humanoid.Health > 0 and root then
				lookAt(root.Position)
			else
				targetPlayer = nil
			end
		end
	end
end)
