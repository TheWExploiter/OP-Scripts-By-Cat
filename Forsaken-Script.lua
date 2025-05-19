loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

local OrionLib = OrionLib
local Window = OrionLib:MakeWindow({
    Name = "Forsaken Script By Cat",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "Forsaken Script"
})

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MainTab:AddButton({
    Name = "Auto Generator (Click Once)",
    Callback = function()
        task.spawn(function()
            while true do
                for i, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("RemoteEvent") and v.Name == "RE" then
                        v:FireServer()
                    end
                end
                task.wait(2.32)
            end
        end)
    end
})

MainTab:AddButton({
    Name = "Buff Loop Speed (38)",
    Callback = function()
        task.spawn(function()
            while true do
                Humanoid.WalkSpeed = 38
                task.wait(1)
            end
        end)
    end
})

MainTab:AddButton({
    Name = "Buff Loop JumpPower (50)",
    Callback = function()
        task.spawn(function()
            while true do
                Humanoid.JumpPower = 50
                task.wait(1)
            end
        end)
    end
})
