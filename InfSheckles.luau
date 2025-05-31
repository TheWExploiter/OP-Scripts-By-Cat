-- this script is open source skidder kys

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    local sellEvent = ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("SellPet_RE")
                    for i = 1, 5 do
                        sellEvent:FireServer(tool)
                    end
                end
            end
        end
    end
end)
