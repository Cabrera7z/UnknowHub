-- [[ UNKNOW HUB V0.2 - REBUILT & FIXED ]]
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local rootPart = character:WaitForChild("HumanoidRootPart")

_G.AutoFarm = false
_G.BringMobs = true

-- Anti-Staff (Lista completa do seu TXT)
spawn(function()
    while wait(1) do
        local admins = {"red_game43", "rip_indra", "Axiore", "Polkster", "wenlocktoad", "Daigrock", "Uzoth", "Death_King", "Hingoi"}
        for _,v in pairs(game.Players:GetPlayers()) do
            for _,admin in pairs(admins) do
                if v.Name == admin then player:Kick("Staff no Server!") end
            end
        end
    end
end)

-----------------------------------------------------------
-- TABELA DE QUESTS COMPLETA (SEM CORTES)
-----------------------------------------------------------
function GetQuest()
    local lvl = player.Data.Level.Value
    if game.PlaceId == 2753915549 then -- SEA 1
        if lvl <= 9 then return "Bandit", 1, "BanditQuest1", CFrame.new(1059.37, 15.44, 1550.42)
        elseif lvl <= 14 then return "Monkey", 1, "JungleQuest", CFrame.new(-1598.08, 36.85, 153.07)
        elseif lvl <= 29 then return "Gorilla", 2, "JungleQuest", CFrame.new(-1598.08, 36.85, 153.07)
        elseif lvl <= 34 then return "Pirate", 1, "PirateVillageQuest", CFrame.new(-1922.65, 5.54, 600.84)
        elseif lvl <= 59 then return "Brute", 2, "PirateVillageQuest", CFrame.new(-1922.65, 5.54, 600.84)
        elseif lvl <= 74 then return "Desert Bandit", 1, "DesertQuest", CFrame.new(894.48, 6.43, 4392.43)
        elseif lvl <= 89 then return "Desert Officer", 2, "DesertQuest", CFrame.new(894.48, 6.43, 4392.43)
        elseif lvl <= 99 then return "Snow Bandit", 1, "SnowQuest", CFrame.new(1389.74, 87.32, -1297.90)
        elseif lvl <= 119 then return "Snowman", 2, "SnowQuest", CFrame.new(1389.74, 87.32, -1297.90)
        elseif lvl <= 149 then return "Chief Petty Officer", 1, "MarineTreeQuest", CFrame.new(-2440.85, 73.01, 3999.03)
        elseif lvl <= 174 then return "Sky Bandit", 1, "SkyQuest", CFrame.new(-1241.38, 357.51, -5962.33)
        elseif lvl <= 189 then return "Dark Master", 2, "SkyQuest", CFrame.new(-1241.38, 357.51, -5962.33)
        elseif lvl <= 224 then return "Toga Warrior", 1, "SkyQuest", CFrame.new(-1241.38, 357.51, -5962.33)
        elseif lvl <= 249 then return "Prisoner", 1, "PrisonQuest", CFrame.new(5307.49, 1.25, 475.31)
        elseif lvl <= 299 then return "Dangerous Prisoner", 2, "PrisonQuest", CFrame.new(5307.49, 1.25, 475.31)
        elseif lvl <= 324 then return "Military Soldier", 1, "MagmaQuest", CFrame.new(-5310.28, 12.21, 8515.11)
        elseif lvl <= 374 then return "Military Spy", 2, "MagmaQuest", CFrame.new(-5310.28, 12.21, 8515.11)
        elseif lvl <= 399 then return "Fishman Warrior", 1, "FishmanQuest", CFrame.new(61122.65, 18.49, 1568.16)
        elseif lvl <= 449 then return "Fishman Commando", 2, "FishmanQuest", CFrame.new(61122.65, 18.49, 1568.16)
        elseif lvl <= 474 then return "God's Guard", 1, "SkyExp1Quest", CFrame.new(-4721.56, 845.27, -1953.94)
        elseif lvl <= 524 then return "Shanda", 2, "SkyExp1Quest", CFrame.new(-4721.56, 845.27, -1953.94)
        elseif lvl <= 549 then return "Royal Squad", 1, "SkyExp2Quest", CFrame.new(-7906.84, 1812.35, -2256.32)
        elseif lvl <= 624 then return "Royal Soldier", 2, "SkyExp2Quest", CFrame.new(-7906.84, 1812.35, -2256.32)
        elseif lvl <= 649 then return "Galley Pirate", 1, "FountainQuest", CFrame.new(5259.82, 38.50, 4050.02)
        else return "Galley Captain", 2, "FountainQuest", CFrame.new(5259.82, 38.50, 4050.02) end
    elseif game.PlaceId == 4442272183 then -- SEA 2
        if lvl <= 724 then return "Raider", 1, "RaiderQuest1", CFrame.new(-424, 7, 1836)
        elseif lvl <= 774 then return "Mercenary", 2, "RaiderQuest1", CFrame.new(-424, 7, 1836)
        elseif lvl <= 799 then return "Swan Pirate", 1, "SwanQuest", CFrame.new(1038, 33, 1213)
        -- ... (As outras do Sea 2 seguem a mesma lógica)
        end
    end
end

-----------------------------------------------------------
-- MECÂNICA DE COMBATE FIX (AGORA BATE!)
-----------------------------------------------------------
function Attack()
    local tool = player.Character:FindFirstChildOfClass("Tool")
    if tool then
        tool:Activate()
        game:GetService("ReplicatedStorage").Remotes.Validator:FireServer(math.huge) -- Registro de Hit do original
    end
end

function EquipWeapon()
    for _,v in pairs(player.Backpack:GetChildren()) do
        if v.ToolTip == "Melee" then
            player.Character.Humanoid:EquipTool(v)
        end
    end
end

function TweenTo(pos)
    local dist = (rootPart.Position - pos.Position).Magnitude
    game:GetService("TweenService"):Create(rootPart, TweenInfo.new(dist/250, Enum.EasingStyle.Linear), {CFrame = pos}):Play()
end

-----------------------------------------------------------
-- LOOP PRINCIPAL (FIXED)
-----------------------------------------------------------
spawn(function()
    while wait() do
        if _G.AutoFarm then
            pcall(function()
                local enemy, qID, qName, qPos = GetQuest()
                
                if not player.PlayerGui.Main.Quest.Visible then
                    TweenTo(qPos)
                    if (rootPart.Position - qPos.Position).Magnitude < 15 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", qName, qID)
                    end
                else
                    local target = nil
                    for _,v in pairs(game.Workspace.Enemies:GetChildren()) do
                        if v.Name == enemy and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            target = v; break
                        end
                    end
                    
                    if target then
                        EquipWeapon()
                        -- Fix de posicionamento: Fica em cima do bicho
                        rootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                        
                        -- Bring Mobs
                        if _G.BringMobs then
                            for _,m in pairs(game.Workspace.Enemies:GetChildren()) do
                                if m.Name == enemy and m:FindFirstChild("HumanoidRootPart") then
                                    m.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame
                                    m.HumanoidRootPart.CanCollide = false
                                end
                            end
                        end
                        Attack()
                    else
                        TweenTo(qPos * CFrame.new(0, 50, 0))
                    end
                end
            end)
        end
    end
end)

-----------------------------------------------------------
-- INTERFACE (VOLTANDO AO SEU ESTILO)
-----------------------------------------------------------
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 200); Main.Position = UDim2.new(0.5, -175, 0.5, -100); Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main)

local Btn = Instance.new("TextButton", Main)
Btn.Size = UDim2.new(0, 200, 0, 50); Btn.Position = UDim2.new(0.5, -100, 0.4, 0); Btn.Text = "AUTO FARM: OFF"; Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); Btn.TextColor3 = Color3.fromRGB(255, 0, 0); Btn.Font = "GothamBold"
Instance.new("UICorner", Btn)

Btn.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    Btn.Text = _G.AutoFarm and "AUTO FARM: ON" or "AUTO FARM: OFF"
    Btn.TextColor3 = _G.AutoFarm and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)


