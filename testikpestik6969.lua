-- ЖЕСТКОЕ ОЖИДАНИЕ ЗАГРУЗКИ ИНТЕРФЕЙСА ДЛЯ МОБИЛЬНОЙ DELTA
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- ЗАГРУЗКА ИМПОРТНОЙ МОБИЛЬНОЙ БИБЛИОТЕКИ МЕНЮ (ОБХОД БЛОКИРОВОК)
local OrionLib = loadstring(game:HttpGet(('https://githubusercontent.com')))()

local Window = OrionLib:MakeWindow({
    Name = "DELTA MOBILE MENU", 
    HidePremium = true, 
    SaveConfig = false, 
    IntroEnabled = false
})

-- СОЗДАНИЕ ВКЛАДОК
local AuthTab = Window:MakeTab({ Name = "Авторизация", Icon = "rbxassetid://4483345998", Premium = false })
local MainTab = Window:MakeTab({ Name = "Функции", Icon = "rbxassetid://4483345998", Premium = false })

local menuUnlocked = false
local farmActive = false

-- ANTI-AFK (Защита от вылетов)
pcall(function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0,0))
    end)
end)

-- Функция обновления списка игроков для кнопок
local function refreshPlayerList()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(list, p.DisplayName)
        end
    end
    return list
end

-- ВЫКЛЮЧЕНИЕ КОЛЛИЗИИ ВО ВРЕМЯ ФАРМА
RunService.Stepped:Connect(function()
    if farmActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(11)
    end
end)

local function teleportTo(targetCFrame, speed)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") or not farmActive then return end
    local root = char.HumanoidRootPart
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local duration = distance / speed
    local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    pcall(function() tween.Completed:Wait() end)
end

-- ЦИКЛ АВТО-ФАРМА
task.spawn(function()
    while true do
        if farmActive and menuUnlocked then
            pcall(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = CFrame.new(-69, 108, 644)
                    task.wait(1)
                    if not farmActive then return end
                    teleportTo(CFrame.new(-41, 77, 8675), 250)
                    if not farmActive then return end
                    task.wait(0.5)
                    char.HumanoidRootPart.CFrame = CFrame.new(-55, -361, 9488)
                    task.wait(8)
                end
            end)
        end
        task.wait(1)
    end
end)

-- 1. СЕКЦИЯ АВТОРИЗАЦИИ (КЛЮЧ)
local KeyValue = ""
AuthTab:AddInput({
    Name = "Проверочный текст",
    PlaceholderText = "Вставьте текст...",
    Callback = function(Value)
        KeyValue = Value
    end
})

AuthTab:AddButton({
    Name = "Проверить ключ и открыть функции",
    Callback = function()
        if KeyValue == "Введите ник текст (170xe3)" then
            menuUnlocked = true
            OrionLib:MakeNotification({
                Name = "DELTA SYSTEM",
                Content = "Доступ Разрешен! Перейдите во вкладку 'Функции'.",
                Time = 4
            })
            
            -- ЗАПОЛНЕНИЕ ВКЛАДКИ ФУНКЦИЙ ПОСЛЕ РАЗБЛОКИРОВКИ
            MainTab:AddToggle({
                Name = "Авто-Фарм Сокровищ",
                Default = false,
                Callback = function(Value)
                    if menuUnlocked then farmActive = Value end
                end
            })

            MainTab:AddDropdown({
                Name = "Телепортироваться к Игроку",
                Default = "",
                Options = refreshPlayerList(),
                Callback = function(Value)
                    if not menuUnlocked or Value == "" then return end
                    pcall(function()
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p.DisplayName == Value and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                local myChar = LocalPlayer.Character
                                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                                    myChar.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, -3)
                                end
                            end
                        end
                    end)
                end
            })

            MainTab:AddDropdown({
                Name = "Украсть и Сохранить Лодку",
                Default = "",
                Options = refreshPlayerList(),
                Callback = function(Value)
                    if not menuUnlocked or Value == "" then return end
                    pcall(function()
                        local target = nil
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p.DisplayName == Value then target = p break end
                        end
                        if not target then return end
                        
                        local targetFolder = nil
                        for _, v in ipairs(workspace:GetDescendants()) do
                            if v.Name == "Blocks" and v.Parent:FindFirstChild("Owner") and v.Parent.Owner.Value == target then
                                targetFolder = v
                                break
                            end
                        end
                        if not targetFolder then
                            for _, v in ipairs(workspace:GetChildren()) do
                                if v.Name:find("Zone") and v:FindFirstChild("Owner") and v.Owner.Value == target then
                                    targetFolder = v:FindFirstChild("Blocks") or v
                                    break
                                end
                            end
                        end
                        
                        if targetFolder then
                            local StolenData = {}
                            local targetBase = targetFolder.Parent:FindFirstChild("Base") or targetFolder.Parent:FindFirstChild("Island")
                            for _, b in ipairs(targetFolder:GetChildren()) do
                                if b:IsA("BasePart") and b.Name ~= "Ice" and b.Name ~= "Water" then
                                    local offsetPos = targetBase and (b.Position - targetBase.Position) or Vector3.new(0,0,0)
                                    table.insert(StolenData, {
                                        Name = b.Name,
                                        Offset = {offsetPos.X, offsetPos.Y, offsetPos.Z},
                                        Size = {b.Size.X, b.Size.Y, b.Size.Z},
                                        Color = {b.Color.R, b.Color.G, b.Color.B},
                                        Material = b.Material.Name,
                                        Transparency = b.Transparency
                                    })
                                end
                            end
                            if writefile and #StolenData > 0 then
                                writefile("boat_" .. target.Name .. ".txt", HttpService:JSONEncode(StolenData))
                                OrionLib:MakeNotification({ Name = "УСПЕХ", Content = "Лодка скопирована в файл!", Time = 3 })
                            end
                        end
                    end)
                end
            })

            MainTab:AddDropdown({
                Name = "Загрузить Лодку на Слот",
                Default = "",
                Options = refreshPlayerList(),
                Callback = function(Value)
                    if not menuUnlocked or Value == "" then return end
                    pcall(function()
                        local target = nil
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p.DisplayName == Value then target = p break end
                        end
                        if not target then return end
                        
                        local filename = "boat_" .. target.Name .. ".txt"
                        if not isfile or not isfile(filename) then
                            OrionLib:MakeNotification({ Name = "ОШИБКА", Content = "Файл чертежа не найден!", Time = 3 })
                            return
                        end
                        
                        local blocksToBuild = HttpService:JSONDecode(readfile(filename))
                        local myZone = nil
                        for _, z in ipairs(workspace:GetChildren()) do
                            if z.Name:find("Zone") and z:FindFirstChild("Owner") and z.Owner.Value == LocalPlayer then
                                myZone = z
                                break
                            end
                        end
                        
                        local myBase = myZone and (myZone:FindFirstChild("Base") or myZone:FindFirstChild("Island"))
                        if myBase and #blocksToBuild > 0 then
                            for _, bData in ipairs(blocksToBuild) do
                                pcall(function()
                                    local p = Instance.new("Part")
                                    p.Name = bData.Name
                                    p.Size = Vector3.new(unpack(bData.Size))
                                    p.Color = Color3.new(unpack(bData.Color))
                                    p.Material = Enum.Material[bData.Material]
                                    p.Transparency = bData.Transparency
                                    p.CanCollide = true
                                    p.Anchored = true
                                    local offset = Vector3.new(unpack(bData.Offset))
                                    p.CFrame = myBase.CFrame * CFrame.new(offset)
                                    p.Parent = myZone:FindFirstChild("Blocks") or myZone
                                end)
                            end
                            OrionLib:MakeNotification({ Name = "ВЕРФЬ", Content = "Сборка завершена!", Time = 3 })
                        end
                    end)
                end
            })
        else
            OrionLib:MakeNotification({
                Name = "ОШИБКА",
                Content = "Неверный секретный текст!",
                Time = 3
            })
        end
    end
})
