local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local stopAttack = false
local targetPlayer = nil

local function makeUI()
	local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
	ScreenGui.Name = "TrashcanMoveset"

	local Frame = Instance.new("Frame", ScreenGui)
	Frame.Size = UDim2.new(0, 550, 0, 220)
	Frame.Position = UDim2.new(0, 20, 0.5, -110)
	Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	Frame.BorderSizePixel = 0
	Frame.Active = true
	Frame.Draggable = true
	Frame.ClipsDescendants = true

	local UICorner = Instance.new("UICorner", Frame)
	UICorner.CornerRadius = UDim.new(0, 15)

	local Title = Instance.new("TextLabel", Frame)
	Title.Size = UDim2.new(1, 0, 0, 45)
	Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Title.Text = "Trashcan Moveset"
	Title.TextColor3 = Color3.new(1, 1, 1)
	Title.TextScaled = true
	Title.Font = Enum.Font.GothamBlack
	Title.BorderSizePixel = 0

	local TitleUICorner = Instance.new("UICorner", Title)
	TitleUICorner.CornerRadius = UDim.new(0, 15)

	local Scroll = Instance.new("ScrollingFrame", Frame)
	Scroll.Size = UDim2.new(1, 0, 1, -45)
	Scroll.Position = UDim2.new(0, 0, 0, 45)
	Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	Scroll.ScrollBarThickness = 6
	Scroll.BackgroundTransparency = 0.2
	Scroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

	local ScrollUICorner = Instance.new("UICorner", Scroll)
	ScrollUICorner.CornerRadius = UDim.new(0, 10)

	return Scroll
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

local function createStopButton()
	local stopButton = Instance.new("TextButton", Scroll)
	stopButton.Size = UDim2.new(1, -10, 0, 40)
	stopButton.Position = UDim2.new(0, 5, 0, (#Scroll:GetChildren()) * 45)
	stopButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
	stopButton.TextColor3 = Color3.new(1, 1, 1)
	stopButton.Font = Enum.Font.GothamBlack
	stopButton.TextScaled = true
	stopButton.Text = "STOP Attacking"

	local corner = Instance.new("UICorner", stopButton)
	corner.CornerRadius = UDim.new(0, 12)

	stopButton.MouseButton1Click:Connect(function()
		stopAttack = true
		targetPlayer = nil
	end)

	Scroll.CanvasSize = UDim2.new(0, 0, 0, #Scroll:GetChildren() * 45)
end

local function createButton(player)
	local Button = Instance.new("TextButton", Scroll)
	Button.Size = UDim2.new(1, -10, 0, 40)
	Button.Position = UDim2.new(0, 5, 0, (#Scroll:GetChildren()) * 45)
	Button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	Button.TextColor3 = Color3.new(1, 1, 1)
	Button.Font = Enum.Font.Gotham
	Button.TextScaled = true
	Button.Text = "Target: " .. player.Name

	local corner = Instance.new("UICorner", Button)
	corner.CornerRadius = UDim.new(0, 12)

	Button.MouseButton1Click:Connect(function()
		targetPlayer = player
		attackPlayer(player)
	end)

	Scroll.CanvasSize = UDim2.new(0, 0, 0, #Scroll:GetChildren() * 45)
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
	for _, child in pairs(Scroll:GetChildren()) do
		if child:IsA("TextButton") and child.Text == ("Target: " .. p.Name) then
			child:Destroy()
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
