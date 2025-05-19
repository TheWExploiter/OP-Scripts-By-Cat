-- not made by me all the credits go to zyx

    while wait(0.1) do
         local E = Instance.new("Part")
         E.Name = "T0ad"
         E.Parent = workspace
         local M = Instance.new("SpecialMesh")
         M.Parent = E
         E.Position = Vector3.new(math.random(-500, 500), 120, math.random(-500, 500))
        E.Size = Vector3.new(30.551, 30.935, 33.358)
        M.MeshId = "rbxassetid://1009824073"
        M.TextureId="rbxassetid://1009824086"
        E.CanCollide = false
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://153752123"
        sound:Play()
        sound.Playing = true
        sound.Volume = 107
        sound.Parent = E
        local sky = Instance.new("Sky", game.Lighting)
        sky.SkyboxBk = "rbxassetid://201208408"
        sky.SkyboxDn = "rbxassetid://201208408"
        sky.SkyboxFt = "rbxassetid://201208408"
        sky.SkyboxLf = "rbxassetid://201208408"
        sky.SkyboxRt = "rbxassetid://201208408"
        sky.SkyboxUp = "rbxassetid://201208408"
        sky.SunTextureId = "rbxassetid://201208408"
        sky.MoonTextureId = "rbxassetid://201208408"
        local r = Instance.new("DistortionSoundEffect")
        r.Level = 0.3
        r.Parent = sound
        
        -- writen by ZyX0pkiddz
    end
end)
