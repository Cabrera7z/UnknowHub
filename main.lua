-- Unknown Hub - Blox Fruits | Auto Farm Completo
-- Com interface GUI, Auto Farm funcional e todos os mobs do Sea 1

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local screenGui

-- Configurações Globais
local config = {
    autoFarmEnabled = false,
    raidEnabled = false,
    selectedMob = "Bandit",
    selectedWeapon = "Melee",
    farmSpeed = 0.15,
    currentSection = "Home"
}

-- ============== DATABASE DE QUESTS - SEA 1 ==============
local questDatabase = {
    {Min = 1, Max = 9, Quest = "BanditQuest1", Mob = "Bandit", QuestLevel = 1, Area = "Starter Area"},
    {Min = 10, Max = 14, Quest = "JungleQuest", Mob = "Monkey", QuestLevel = 1, Area = "Jungle"},
    {Min = 15, Max = 29, Quest = "JungleQuest", Mob = "Gorilla", QuestLevel = 2, Area = "Jungle"},
    {Min = 30, Max = 39, Quest = "BuggyQuest1", Mob = "Pirate", QuestLevel = 1, Area = "Buggy Village"},
    {Min = 40, Max = 59, Quest = "BuggyQuest1", Mob = "Brute", QuestLevel = 2, Area = "Buggy Village"},
    {Min = 60, Max = 74, Quest = "DesertQuest", Mob = "Desert Bandit", QuestLevel = 1, Area = "Desert"},
    {Min = 75, Max = 89, Quest = "DesertQuest", Mob = "Desert Officer", QuestLevel = 2, Area = "Desert"},
    {Min = 90, Max = 99, Quest = "SnowQuest", Mob = "Snow Bandit", QuestLevel = 1, Area = "Snow"},
    {Min = 100, Max = 119, Quest = "SnowQuest", Mob = "Snowman", QuestLevel = 2, Area = "Snow"},
    {Min = 120, Max = 149, Quest = "MarineQuest2", Mob = "Chief Petty Officer", QuestLevel = 1, Area = "Marine"},
    {Min = 150, Max = 174, Quest = "SkyQuest", Mob = "Sky Bandit", QuestLevel = 1, Area = "Sky Island"},
    {Min = 175, Max = 189, Quest = "SkyQuest", Mob = "Dark Master", QuestLevel = 2, Area = "Sky Island"},
    {Min = 190, Max = 209, Quest = "PrisonerQuest", Mob = "Prisoner", QuestLevel = 1, Area = "Prison"},
    {Min = 210, Max = 249, Quest = "PrisonerQuest", Mob = "Dangerous Prisoner", QuestLevel = 2, Area = "Prison"},
    {Min = 250, Max = 274, Quest = "ColosseumQuest", Mob = "Toga Warrior", QuestLevel = 1, Area = "Colosseum"},
    {Min = 275, Max = 299, Quest = "ColosseumQuest", Mob = "Gladiator", QuestLevel = 2, Area = "Colosseum"},
    {Min = 300, Max = 324, Quest = "MagmaQuest", Mob = "Military Soldier", QuestLevel = 1, Area = "Magma"},
    {Min = 325, Max = 374, Quest = "MagmaQuest", Mob = "Military Spy", QuestLevel = 2, Area = "Magma"},
    {Min = 375, Max = 399, Quest = "FishmanQuest", Mob = "Fishman Warrior", QuestLevel = 1, Area = "Fishman"},
    {Min = 400, Max = 449, Quest = "FishmanQuest", Mob = "Fishman Commando", QuestLevel = 2, Area = "Fishman"},
    {Min = 450, Max = 474, Quest = "SkyExp1Quest", Mob = "God's Guard", QuestLevel = 1, Area = "Sky Exp Island"},
    {Min = 475, Max = 524, Quest = "SkyExp1Quest", Mob = "Shanda", QuestLevel = 2, Area = "Sky Exp Island"},
    {Min = 525, Max = 549, Quest = "SkyExp2Quest", Mob = "Royal Squad", QuestLevel = 1, Area = "Sky Island 2"},
    {Min = 550, Max = 624, Quest = "SkyExp2Quest", Mob = "Royal Soldier", QuestLevel = 2, Area = "Sky Island 2"},
    {Min = 625, Max = 649, Quest = "FountainQuest", Mob = "Galley Pirate", QuestLevel = 1, Area = "Fountain"},
    {Min = 650, Max = 700, Quest = "FountainQuest", Mob = "Galley Captain", QuestLevel = 2, Area = "Fountain"},
}

-- ============== FUNÇÕES PRINCIPAIS ==============

local function getPlayerLevel()
    local levelValue = player:FindFirstChild("Data")
    if levelValue then
        local level = levelValue:FindFirstChild("Level")
        if level then return level.Value end
    end
    return 1
end

local function getQuestByLevel(level)
    for _, data in pairs(questDatabase) do
        if level >= data.Min and level <= data.Max then
            return data
        end
    end
    return questDatabase[#questDatabase]
end

local function teleportTo(cframe)
    pcall(function()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = cframe
        end
    end)
end

local function getClosestMob(mobName)
    local closestMob = nil
    local closestDistance = math.huge
    
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob.Name == mobName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
            local distance = (mob.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestMob = mob
            end
        end
    end
    
    return closestMob
end

local function startQuest(questName, questLevel)
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questName, questLevel)
    end)
    wait(1)
end

local function attackMob(mob)
    if not mob or not mob:FindFirstChild("Humanoid") or mob.Humanoid.Health <= 0 then
        return false
    end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end
    
    -- Mover para perto do mob
    local targetCFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0, -5, 3)
    local distance = (targetCFrame.Position - character.HumanoidRootPart.Position).Magnitude
    local time = distance / 50
    
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(character.HumanoidRootPart, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    
    -- Atacar
    game:GetService("VirtualUser"):ClickButton1(Vector2.new(9e9, 9e9))
    
    return true
end

-- ============== LOOP DE AUTO FARM ==============

local function autoFarmLoop()
    while config.autoFarmEnabled do
        pcall(function()
            local level = getPlayerLevel()
            local questData = getQuestByLevel(level)
            
            if questData then
                -- Iniciar quest
                startQuest(questData.Quest, questData.QuestLevel)
                wait(0.5)
                
                -- Loop de ataque
                local farmTime = 0
                while config.autoFarmEnabled and farmTime < 120 do
                    local mob = getClosestMob(questData.Mob)
                    
                    if mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        attackMob(mob)
                    end
                    
                    wait(0.1)
                    farmTime = farmTime + 0.1
                end
            end
        end)
        
        wait(0.5)
    end
end

-- ============== INTERFACE GUI ==============

local function createGUI()
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "UnknownHub"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = player:WaitForChild("PlayerGui")

    -- Background Principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 700, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
    mainFrame.Parent = screenGui

    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 50)
    titleLabel.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    titleLabel.BorderSizePixel = 0
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 28
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "⚔️ Unknown Hub - Blox Fruits"
    titleLabel.Parent = mainFrame

    -- Painel Lateral
    local sidePanel = Instance.new("Frame")
    sidePanel.Name = "SidePanel"
    sidePanel.Size = UDim2.new(0, 180, 1, -50)
    sidePanel.Position = UDim2.new(0, 0, 0, 50)
    sidePanel.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    sidePanel.BorderSizePixel = 0
    sidePanel.Parent = mainFrame

    -- Conteúdo
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -180, 1, -50)
    contentFrame.Position = UDim2.new(0, 180, 0, 50)
    contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame

    -- ScrollingFrame para conteúdo
    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Name = "ContentScroll"
    contentScroll.Size = UDim2.new(1, -10, 1, -10)
    contentScroll.Position = UDim2.new(0, 5, 0, 5)
    contentScroll.BackgroundTransparency = 1
    contentScroll.ScrollBarThickness = 8
    contentScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
    contentScroll.Parent = contentFrame

    -- Layout para conteúdo
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = contentScroll

    -- Criando botões de seções
    local sections = {"Home", "Auto Farm", "Mobs", "Config"}
    
    for i, section in pairs(sections) do
        local button = Instance.new("TextButton")
        button.Name = section
        button.Size = UDim2.new(1, -10, 0, 45)
        button.Position = UDim2.new(0, 5, 0, 5 + (i - 1) * 55)
        button.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        button.BorderSizePixel = 0
        button.TextColor3 = Color3.fromRGB(200, 200, 200)
        button.TextSize = 14
        button.Font = Enum.Font.GothamSemibold
        button.Text = section
        button.Parent = sidePanel
        
        button.MouseButton1Click:Connect(function()
            config.currentSection = section
            updateContent(section, contentScroll)
            
            -- Highlight
            for _, btn in pairs(sidePanel:GetChildren()) do
                if btn:IsA("TextButton") then
                    if btn == button then
                        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    else
                        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
                        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                    end
                end
            end
        end)
    end

    -- Highlight inicial
    local firstButton = sidePanel:FindFirstChild("Home")
    if firstButton then
        firstButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        firstButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    -- Função helper para criar botão toggle
    function createToggleButton(parent, text, callback)
        local container = Instance.new("Frame")
        container.Size = UDim2.new(1, 0, 0, 45)
        container.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        container.BorderSizePixel = 0
        container.Parent = parent

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 300, 1, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 14
        label.Font = Enum.Font.Gotham
        label.Text = text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = container

        local toggle = Instance.new("TextButton")
        toggle.Size = UDim2.new(0, 50, 0, 25)
        toggle.Position = UDim2.new(1, -55, 0.5, -12)
        toggle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        toggle.BorderSizePixel = 0
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.TextSize = 12
        toggle.Font = Enum.Font.GothamBold
        toggle.Text = "OFF"
        toggle.Parent = container

        local toggleState = false
        toggle.MouseButton1Click:Connect(function()
            toggleState = not toggleState
            toggle.BackgroundColor3 = toggleState and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(100, 100, 100)
            toggle.Text = toggleState and "ON" or "OFF"
            callback(toggleState)
        end)
    end

    -- Função helper para criar botão de ação
    function createActionButton(parent, text, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 40)
        button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        button.BorderSizePixel = 0
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14
        button.Font = Enum.Font.GothamSemibold
        button.Text = text
        button.Parent = parent

        button.MouseButton1Click:Connect(callback)
        
        button.MouseEnter:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
        end)
        
        button.MouseLeave:Connect(function()
            button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        end)
    end

    return {
        mainFrame = mainFrame,
        contentScroll = contentScroll,
        contentFrame = contentFrame,
        sidePanel = sidePanel
    }
end

-- Função para atualizar conteúdo das seções
function updateContent(section, contentScroll)
    -- Limpar conteúdo anterior
    for _, child in pairs(contentScroll:GetChildren()) do
        if child:IsA("GuiObject") and child.Name ~= "UIListLayout" then
            child:Destroy()
        end
    end

    if section == "Home" then
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 50)
        title.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        title.BorderSizePixel = 0
        title.TextColor3 = Color3.fromRGB(0, 150, 255)
        title.TextSize = 20
        title.Font = Enum.Font.GothamBold
        title.Text = "Bem-vindo ao Unknown Hub!"
        title.Parent = contentScroll
        
        local info = Instance.new("TextLabel")
        info.Size = UDim2.new(1, 0, 0, 100)
        info.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        info.BorderSizePixel = 0
        info.TextColor3 = Color3.fromRGB(150, 150, 150)
        info.TextSize = 12
        info.Font = Enum.Font.Gotham
        info.TextWrapped = true
        info.Text = "Seu hub completo para Blox Fruits!\n\nLevel Atual: " .. getPlayerLevel() .. "\n\nUse as abas ao lado para controlar o farming!"
        info.Parent = contentScroll
        
    elseif section == "Auto Farm" then
        createToggleButton(contentScroll, "🤖 Ativar Auto Farm", function(state)
            config.autoFarmEnabled = state
            if state then
                spawn(autoFarmLoop)
            end
        end)
        
        local levelLabel = Instance.new("TextLabel")
        levelLabel.Size = UDim2.new(1, 0, 0, 40)
        levelLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        levelLabel.BorderSizePixel = 0
        levelLabel.TextColor3 = Color3.fromRGB(0, 150, 255)
        levelLabel.TextSize = 14
        levelLabel.Font = Enum.Font.GothamSemibold
        levelLabel.Text = "📊 Level: " .. getPlayerLevel()
        levelLabel.Parent = contentScroll
        
        local questInfo = getQuestByLevel(getPlayerLevel())
        local mobLabel = Instance.new("TextLabel")
        mobLabel.Size = UDim2.new(1, 0, 0, 40)
        mobLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
        mobLabel.BorderSizePixel = 0
        mobLabel.TextColor3 = Color3.fromRGB(150, 200, 255)
        mobLabel.TextSize = 12
        mobLabel.Font = Enum.Font.Gotham
        mobLabel.TextWrapped = true
        mobLabel.Text = "⚡ Mob: " .. questInfo.Mob .. " | Área: " .. questInfo.Area
        mobLabel.Parent = contentScroll
        
    elseif section == "Mobs" then
        local mobList = {}
        for _, quest in pairs(questDatabase) do
            if not table.find(mobList, quest.Mob) then
                table.insert(mobList, quest.Mob)
            end
        end
        
        for _, mob in pairs(mobList) do
            createActionButton(contentScroll, "🎯 Farm: " .. mob, function()
                config.selectedMob = mob
                print("Selecionado: " .. mob)
            end)
        end
        
    elseif section == "Config" then
        createActionButton(contentScroll, "🔄 Resetar GUI", function()
            screenGui:Destroy()
            createGUI()
        end)
        
        createActionButton(contentScroll, "❌ Sair do Hub", function()
            screenGui:Destroy()
        end)
    end
end

-- Inicializar GUI
local gui = createGUI()
updateContent("Home", gui.contentScroll)

-- Tornar GUI arrastável
local dragging = false
local dragStart = Vector2.new(0, 0)

gui.mainFrame.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = mouse.Position
    end
end)

gui.mainFrame.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

mouse.Move:Connect(function()
    if dragging then
        local delta = mouse.Position - dragStart
        gui.mainFrame.Position = gui.mainFrame.Position + UDim2.new(0, delta.X, 0, delta.Y)
        dragStart = mouse.Position
    end
end)

print("✅ Unknown Hub Carregado com sucesso!")
print("💡 Dica: Use a interface para controlar o Auto Farm")


