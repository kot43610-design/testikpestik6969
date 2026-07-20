local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local menuUnlocked = false
local farmActive = false

local function printToLocalChat(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
            Text = "[СЕКРЕТНЫЙ ЧАТ]: " .. text,
            Color = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.SourceSansBold,
            TextSize = 16
        })
    end)
end

pcall(function()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0,0))
    end)
end)

local function getTargetPlayer(text)
    if not text or text == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (p.Name:lower():find(text:lower()) or p.DisplayName:lower():find(text:lower())) then
            return p
        end
    end
    return nil
end

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

local ChatService = game:GetService("TextChatService")
if ChatService.ChatVersion == Enum.ChatVersion.TextChatService then
    -- Для новой системы чата Roblox
    ChatService.SendingMessage:Connect(function(textChatMessage)
        local msg = textChatMessage.Text
        
        if msg == "170" then
            textChatMessage.Text = "" -- Стираем, чтобы никто не увидел
            menuUnlocked = true
            printToLocalChat("Доступ Разрешен! Команды скрытого чата разблокированы.")
            return
        end
        
        if not menuUnlocked then return end
        
        local args = string.split(msg, " ")
        local cmd = args[1]:lower()
        local targetName = args[2]
        
        if cmd == "фарм" or cmd == "тп" or cmd == "кража" or cmd == "загрузка" then
            textChatMessage.Text = "" -- Полностью блокируем отправку сообщения в общий чат
            
            if cmd == "фарм" then
                farmActive = not farmActive
                printToLocalChat(farmActive and "Авто-фарм сокровищ запущен!" or "Авто-фарм остановлен.")
                
            elseif cmd == "тп" and targetName then
                local target = getTargetPlayer(targetName)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local myChar = LocalPlayer.Character
                    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, -3)
                        printToLocalChat("Вы скрытно телепортировались к " .. target.DisplayName)
                    end
                else
                    printToLocalChat("Игрок не найден.")
                end
                
            elseif cmd == "кража" and targetName then
                pcall(function()
                    local target = getTargetPlayer(targetName)
                    if not target then printToLocalChat("Игрок не найден.") return end
                    
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
                            printToLocalChat("Лодка успешно украдена и сохранена как boat_" .. target.Name .. ".txt")
                        else
                            printToLocalChat("Ошибка сохранения! Инжектор не поддерживает запись файлов.")
                        end
                    else
                        printToLocalChat("Постройки игрока не найдены.")
                    end
                end)
                
            elseif cmd == "загрузка" and targetName then
                pcall(function()
                    local target = getTargetPlayer(targetName)
                    if not target then printToLocalChat("Укажите ник игрока, чью лодку вы сохраняли.") return end
                    
                    local filename = "boat_" .. target.Name .. ".txt"
                    if not isfile or not isfile(filename) then printToLocalChat("Файл чертежа не найден.") return end
                    
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
                        printToLocalChat("Начинается скрытая сборка лодки...")
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
                        printToLocalChat("Сборка лодки успешно завершена!")
                    else
                        printToLocalChat("Ваша строительная зона не найдена.")
                    end
                end)
            end
        end
    end)
else
    LocalPlayer.Chatted:Connect(function(msg)
        if msg == "170" then
            menuUnlocked = true
            printToLocalChat("Доступ Разрешен! Команды скрытого чата разблокированы.")
            return
        end
        
        if not menuUnlocked then return end
        
        local args = string.split(msg, " ")
        local cmd = args[1]:lower()
        local targetName = args[2]
        
        if cmd == "фарм" then
            farmActive = not farmActive
            printToLocalChat(farmActive and "Авто-фарм сокровищ запущен!" or "Авто-фарм остановлен.")
        elseif cmd == "тп" and targetName then
            local target = getTargetPlayer(targetName)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, -3)
                printToLocalChat("Вы телепортировались к " .. target.DisplayName)
            end
        end
    end)
end
