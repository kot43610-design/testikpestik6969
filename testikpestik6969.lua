local Settings = {
    AutoFarm = true,       
    WalkSpeed = 50,        
    JumpPower = 100,       
    CollectRadius = 50
  local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
  Humanoid.WalkSpeed = Settings.WalkSpeed
Humanoid.JumpPower = Settings.JumpPower

Player.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    Humanoid.WalkSpeed = Settings.WalkSpeed
    Humanoid.JumpPower = Settings.JumpPower
end)
  spawn(function()
    while true do
        if Settings.AutoFarm then
            local success, err = pcall(function()
                -- Поиск объектов/мобов для получения опыта
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name == "ExpObject" and obj:IsA("BasePart") then
                        -- Телепортация к предмету опыта
                        local distance = (obj.Position - Character.PrimaryPart.Position).Magnitude
                        if distance < Settings.CollectRadius then
                            Character.PrimaryPart.CFrame = obj.CFrame
                            task.wait(0.1) -- Задержка для регистрации события игрой
                        end
                    end
                end
            end)
            if err then warn("Ошибка авто-фарма: " .. err) end
        end
        task.wait(0.5) -- Интервал проверки мира
    end
end)
