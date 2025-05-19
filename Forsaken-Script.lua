local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "Forsaken Script V1",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "ForsakenConfig"
})

local Player = game.Players.LocalPlayer
local Humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")

local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Auto Generator Button
MainTab:AddButton({
    Name = "Auto Generator (Press Once)",
    Callback = function()
        spawn(function()
            while true do
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("RemoteEvent") and v.Name == "RE" then
                        v:FireServer()
                    end
                end
                task.wait(2.32)
            end
        end)
    end
})

-- Buff Loop Speed
MainTab:AddButton({
    Name = "Buff Loop WalkSpeed (to 38)",
    Callback = function()
        spawn(function()
            while true do
                local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.WalkSpeed = 38 end
                task.wait(0.1)
            end
        end)
    end
})

-- Buff Loop JumpPower
MainTab:AddButton({
    Name = "Buff Loop JumpPower (to 50)",
    Callback = function()
        spawn(function()
            while true do
                local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.JumpPower = 50 end
                task.wait(0.1)
            end
        end)
    end
})
