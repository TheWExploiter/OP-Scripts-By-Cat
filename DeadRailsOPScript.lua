-- hello skidder :3 
-- what are u doing here if i may ask?
-- tell me.

-- Orion UI by jensonhirst
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

-- Create Window
local Window = OrionLib:MakeWindow({
	Name = "OP Dead Rails Script (Made By Cat)",
	HidePremium = false,
	IntroText = "OP Dead Rails Script (Made By Cat)",
	SaveConfig = false
})

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local lighting = game:GetService("Lighting")

-- Loop Control
local speedLoop = false
local jumpLoop = false
local auraOn = false
local auraThread
local brightOn = false

-- Aura Remote
local rs = game:GetService("ReplicatedStorage")
local remote = rs:WaitForChild("Shared"):WaitForChild("Network")
	:WaitForChild("RemotePromise"):WaitForChild("Remotes"):WaitForChild("C_ActivateObject")

-- GUI Tab
local Tab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Extend Speed",
	Callback = function()
		speedLoop = true
		task.spawn(function()
			while speedLoop do
				if player.Character and player.Character:FindFirstChild("Humanoid") then
					player.Character.Humanoid.WalkSpeed = 18.5
				end
				task.wait()
			end
		end)
	end
})

Tab:AddToggle({
	Name = "Noclip",
	Default = false,
	Callback = function(state)
		if state then
			noclipConnection = game:GetService("RunService").Stepped:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					for _, part in pairs(player.Character:GetDescendants()) do
						if part:IsA("BasePart") and part.CanCollide == true then
							part.CanCollide = false
						end
					end
				end
			end)
		else
			if noclipConnection then
				noclipConnection:Disconnect()
			end
		end
	end
})

Tab:AddButton({
	Name = "Extend JumpPower",
	Callback = function()
		jumpLoop = true
		task.spawn(function()
			while jumpLoop do
				if player.Character and player.Character:FindFirstChild("Humanoid") then
					player.Character.Humanoid.JumpPower = 13
				end
				task.wait()
			end
		end)
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
							if part and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
								local distance = (player.Character.HumanoidRootPart.Position - part.Position).Magnitude
								if distance <= 25 then
									remote:FireServer(obj)
								end
							end
						end
					end
				end
			end)
		else
			if auraThread then
				task.cancel(auraThread)
			end
		end
	end
})

Tab:AddButton({
	Name = "No Fog",
	Callback = function()
		lighting.FogEnd = 999999
		lighting.FogStart = 0
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
