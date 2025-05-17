local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()
local Window = OrionLib:MakeWindow({
	Name = "OP Dead Rails Script (By Cat)",
	HidePremium = false,
	IntroText = "OP Dead Rails Script",
	SaveConfig = false
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local speedLoop = false
local jumpLoop = false
local auraOn = false
local espOn = false
local collectOn = false
local brightOn = false
local auraThread, espThread, collectThread
local wsConnection, jpConnection

local rs = game:GetService("ReplicatedStorage")
local remote = rs:WaitForChild("Shared"):WaitForChild("Network")
	:WaitForChild("RemotePromise"):WaitForChild("Remotes"):WaitForChild("C_ActivateObject")

local function createBillboard(obj, txt)
	if obj:FindFirstChild("ESP") then return end
	local bill = Instance.new("BillboardGui", obj)
	bill.Name = "ESP"
	bill.AlwaysOnTop = true
	bill.Size = UDim2.new(0, 200, 0, 50)
	bill.StudsOffset = Vector3.new(0, 2, 0)
	local label = Instance.new("TextLabel", bill)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = txt
	label.TextColor3 = Color3.new(1, 0, 0)
	label.TextScaled = true
end

local Tab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddToggle({
	Name = "Loop Max Speed",
	Default = false,
	Callback = function(state)
		speedLoop = state
		if speedLoop and not wsConnection then
			wsConnection = RunService.Heartbeat:Connect(function()
				local hum = player.Character and player.Character:FindFirstChild("Humanoid")
				if hum then hum.WalkSpeed = 18.9 end
			end)
		elseif wsConnection then
			wsConnection:Disconnect()
			wsConnection = nil
		end
	end
})

Tab:AddToggle({
	Name = "Loop Max JumpPower",
	Default = false,
	Callback = function(state)
		jumpLoop = state
		if jumpLoop and not jpConnection then
			jpConnection = RunService.Heartbeat:Connect(function()
				local hum = player.Character and player.Character:FindFirstChild("Humanoid")
				if hum then hum.JumpPower = 13 end
			end)
		elseif jpConnection then
			jpConnection:Disconnect()
			jpConnection = nil
		end
	end
})

Tab:AddToggle({
	Name = "Bond Aura",
	Default = false,
	Callback = function(state)
		auraOn = state
		if auraOn then
			auraThread = task.spawn(function()
				while auraOn do
					task.wait(0.1)
					for _, obj in ipairs(workspace:GetDescendants()) do
						if obj:IsA("Model") and (obj.Name == "Bond" or obj.Name == "Treasure Bond") then
							local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
							local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
							if part and hrp and (hrp.Position - part.Position).Magnitude <= 25 then
								remote:FireServer(obj)
							end
						end
					end
				end
			end)
		elseif auraThread then
			task.cancel(auraThread)
		end
	end
})

Tab:AddToggle({
	Name = "ESP: Buildings/Enemies/Entities",
	Default = false,
	Callback = function(state)
		espOn = state
		if espOn then
			espThread = task.spawn(function()
				while espOn do
					local folders = {
						workspace:FindFirstChild("RandomBuildings"),
						workspace:FindFirstChild("NightEnemies"),
						workspace:FindFirstChild("RuntimeEnemies"),
						workspace:FindFirstChild("RuntimeEntities")
					}
					for _, folder in ipairs(folders) do
						if folder then
							for _, obj in ipairs(folder:GetDescendants()) do
								if obj:IsA("BasePart") and obj.Parent then
									createBillboard(obj, obj.Parent.Name)
								end
							end
						end
					end
					task.wait(1)
				end
			end)
		elseif espThread then
			task.cancel(espThread)
		end
	end
})

Tab:AddToggle({
	Name = "Auto Collect MoneyBag",
	Default = false,
	Callback = function(state)
		collectOn = state
		if collectOn then
			collectThread = task.spawn(function()
				while collectOn do
					task.wait(0.2)
					local bagFolder = workspace:FindFirstChild("RuntimeItems")
					if bagFolder and bagFolder:FindFirstChild("Moneybag") then
						local bag = bagFolder.Moneybag:FindFirstChild("MoneyBag")
						local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
						if bag and bag:IsA("MeshPart") and hrp and (hrp.Position - bag.Position).Magnitude <= 20 then
							if bag:FindFirstChild("CollectPrompt") then
								fireproximityprompt(bag.CollectPrompt)
							end
						end
					end
				end
			end)
		elseif collectThread then
			task.cancel(collectThread)
		end
	end
})

Tab:AddButton({
	Name = "No Fog",
	Callback = function()
		lighting.FogStart = 0
		lighting.FogEnd = 999999
		lighting.Changed:Connect(function()
			lighting.FogStart = 0
			lighting.FogEnd = 999999
		end)
	end
})

Tab:AddToggle({
	Name = "Full Bright",
	Default = false,
	Callback = function(state)
		brightOn = state
		if brightOn then
			lighting.Brightness = 2
			lighting.ClockTime = 14
			lighting.FogEnd = 1000000
			lighting.GlobalShadows = false
		else
			lighting.Brightness = 1
			lighting.ClockTime = 12
			lighting.FogEnd = 1000
			lighting.GlobalShadows = true
		end
	end
})
