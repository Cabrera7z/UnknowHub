--[[
    SCRIPT: Blox Fruits Auto Farm Pro
    EXECUTOR: Delta / Arceus / Fluxus
    FUNÇÃO: Auto Farm com Tweening e Interface Aura Azul
    VERSÃO: 2.0
]]

-- Variáveis principais
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configurações do Auto Farm
local Config = {
    Enabled = true,
    FarmRadius = 250,
    AttackCooldown = 0.3,
    MoveToTarget = true,
    UseTweening = true,
    TweenSpeed = 50,
    CheckInterval = 0.1
}

-- Função para encontrar o NPC mais próximo
local function GetClosestNPC()
    local closestNPC = nil
    local shortestDistance = Config.FarmRadius
    
    -- Percorre todos os NPCs no jogo (Blox Fruits usa modelos com "NPC" ou "Boss")
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            -- Filtra apenas NPCs (não players)
            if not Players:GetPlayerFromCharacter(v) and v.Name ~= Character.Name then
                local distance = (RootPart.Position - v.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance and v.Humanoid.Health > 0 then
                    shortestDistance = distance
                    closestNPC = v
                end
            end
        end
    end
    
    return closestNPC, shortestDistance
end

-- Função para mover até o alvo usando Tweening (mais suave)
local function TweenToTarget(targetPosition)
    if not Config.UseTweening then
        RootPart.CFrame = CFrame.new(targetPosition)
        return
    end
    
    local tweenInfo = TweenInfo.new(
        (RootPart.Position - targetPosition).Magnitude / Config.TweenSpeed,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(RootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    tween:Play()
    
    -- Aguarda o tween completar ou ser interrompido
    tween.Completed:Wait()
end

-- Função para atacar o NPC (Hitbox Detection)
local function AttackNPC(target)
    if not target or not target:FindFirstChild("Humanoid") then return end
    
    local targetHumanoid = target.Humanoid
    if targetHumanoid.Health <= 0 then return end
    
    -- Verifica se tem uma espada ou equipamento de combate
    local tool = Character:FindFirstChildWhichIsA("Tool")
    local attackDamage = 20 -- Dano base do soco
    
    if tool then
        -- Ativa a ferramenta equipada
        local attackEvent = tool:FindFirstChild("AttackEvent") or tool:FindFirstChild("Remote")
        if attackEvent then
            -- Simula o clique da ferramenta
            tool.Parent = Character
            tool.Activated:FireServer()
        end
    end
    
    -- Aplica dano via Hitbox (método mais eficaz para Blox Fruits)
    local humanoidRootPart = target:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        -- Cria um hitbox falso para dano
        local hitbox = Instance.new("Part")
        hitbox.Size = Vector3.new(4, 4, 4)
        hitbox.CFrame = humanoidRootPart.CFrame
        hitbox.Anchored = true
        hitbox.CanCollide = false
        hitbox.Transparency = 1
        hitbox.Parent = workspace
        
        -- Aplica o dano (método antigo mas funcional)
        targetHumanoid:TakeDamage(attackDamage)
        
        -- Remove o hitbox após 0.1 segundos
        game:GetService("Debris"):AddItem(hitbox, 0.1)
    end
    
    -- Feedback visual de dano
    local damageIndicator = Instance.new("BillboardGui")
    damageIndicator.Size = UDim2.new(0, 50, 0, 20)
    damageIndicator.StudsOffset = Vector3.new(0, 2, 0)
    damageIndicator.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Text = tostring(attackDamage)
    textLabel.TextColor3 = Color3.new(1, 0, 0)
    textLabel.TextScaled = true
    textLabel.BackgroundTransparency = 1
    textLabel.Parent = damageIndicator
    
    damageIndicator.Parent = targetHumanoid.Parent
    
    game:GetService("Debris"):AddItem(damageIndicator, 0.5)
end

-- Loop principal do Auto Farm
local function AutoFarmLoop()
    while Config.Enabled and RunService:IsRunning() do
        local target, distance = GetClosestNPC()
        
        if target and distance <= Config.FarmRadius then
            -- Move até o alvo se necessário
            if distance > 10 and Config.MoveToTarget then
                local targetPosition = target.HumanoidRootPart.Position
                TweenToTarget(targetPosition)
            end
            
            -- Ataca o alvo
            AttackNPC(target)
            
            -- Cooldown entre ataques
            wait(Config.AttackCooldown)
        else
            -- Pequena pausa se não encontrar alvos
            wait(0.5)
        end
        
        wait(Config.CheckInterval)
    end
end

-- Interface Gráfica (Aura Azul com fundo preto/cinza)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmGUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.15)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(0.2, 0.5, 1)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Efeito Aura Azul
local AuraEffect = Instance.new("UICorner")
AuraEffect.CornerRadius = UDim.new(0, 12)
AuraEffect.Parent = MainFrame

-- Título
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.new(0.15, 0.3, 0.6)
TitleLabel.BackgroundTransparency = 0.3
TitleLabel.Text = "⚔️ AUTO FARM PRO ⚔️"
TitleLabel.TextColor3 = Color3.new(0.5, 0.8, 1)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

-- Botão Toggle (Ativar/Desativar)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0.8, 0, 0, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.15, 0)
ToggleButton.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
ToggleButton.Text = "✅ ATIVADO"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.TextScaled = true
ToggleButton.Font = Enum.Font.GothamSemibold
ToggleButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = ToggleButton

-- Slider Raio de Farm
local RadiusLabel = Instance.new("TextLabel")
RadiusLabel.Size = UDim2.new(0.8, 0, 0, 25)
RadiusLabel.Position = UDim2.new(0.1, 0, 0.25, 0)
RadiusLabel.BackgroundTransparency = 1
RadiusLabel.Text = "📡 Raio de Farm: " .. Config.FarmRadius
RadiusLabel.TextColor3 = Color3.new(0.7, 0.7, 0.9)
RadiusLabel.TextXAlignment = Enum.TextXAlignment.Left
RadiusLabel.TextSize = 14
RadiusLabel.Font = Enum.Font.Gotham
RadiusLabel.Parent = MainFrame

local RadiusSlider = Instance.new("TextBox")
RadiusSlider.Size = UDim2.new(0.6, 0, 0, 25)
RadiusSlider.Position = UDim2.new(0.3, 0, 0.32, 0)
RadiusSlider.BackgroundColor3 = Color3.new(0.2, 0.2, 0.25)
RadiusSlider.Text = tostring(Config.FarmRadius)
RadiusSlider.TextColor3 = Color3.new(1, 1, 1)
RadiusSlider.TextSize = 14
RadiusSlider.Parent = MainFrame

-- Toggle Tweening
local TweeningToggle = Instance.new("TextButton")
TweeningToggle.Size = UDim2.new(0.8, 0, 0, 35)
TweeningToggle.Position = UDim2.new(0.1, 0, 0.42, 0)
TweeningToggle.BackgroundColor3 = Config.UseTweening and Color3.new(0.2, 0.6, 0.2) or Color3.new(0.6, 0.2, 0.2)
TweeningToggle.Text = Config.UseTweening and "🎯 TWEENING: ON" or "🎯 TWEENING: OFF"
TweeningToggle.TextColor3 = Color3.new(1, 1, 1)
TweeningToggle.TextScaled = true
TweeningToggle.Font = Enum.Font.GothamSemibold
TweeningToggle.Parent = MainFrame

local TweenCorner = Instance.new("UICorner")
TweenCorner.CornerRadius = UDim.new(0, 8)
TweenCorner.Parent = TweeningToggle

-- Velocidade do Tweening
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.8, 0, 0, 25)
SpeedLabel.Position = UDim2.new(0.1, 0, 0.52, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "⚡ Velocidade Tween: " .. Config.TweenSpeed
SpeedLabel.TextColor3 = Color3.new(0.7, 0.7, 0.9)
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.TextSize = 14
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.Parent = MainFrame

local SpeedSlider = Instance.new("TextBox")
SpeedSlider.Size = UDim2.new(0.4, 0, 0, 25)
SpeedSlider.Position = UDim2.new(0.5, 0, 0.59, 0)
SpeedSlider.BackgroundColor3 = Color3.new(0.2, 0.2, 0.25)
SpeedSlider.Text = tostring(Config.TweenSpeed)
SpeedSlider.TextColor3 = Color3.new(1, 1, 1)
SpeedSlider.TextSize = 14
SpeedSlider.Parent = MainFrame

-- Status atual
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 40)
StatusLabel.Position = UDim2.new(0.05, 0, 0.7, 0)
StatusLabel.BackgroundColor3 = Color3.new(0, 0, 0)
StatusLabel.BackgroundTransparency = 0.5
StatusLabel.Text = "Status: 🟢 Procurando NPCs..."
StatusLabel.TextColor3 = Color3.new(0.5, 1, 0.5)
StatusLabel.TextScaled = true
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- Botão Fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.2, 0, 0.08, 0)
CloseButton.Position = UDim2.new(0.8, 0, 0.85, 0)
CloseButton.BackgroundColor3 = Color3.new(0.6, 0.2, 0.2)
CloseButton.Text = "FECHAR"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Sistema de arrastar a GUI
local dragging = false
local dragStartPos, startMousePos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStartPos = MainFrame.Position
        startMousePos = input.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - startMousePos
        MainFrame.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X, dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Controles da Interface
ToggleButton.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    ToggleButton.BackgroundColor3 = Config.Enabled and Color3.new(0.2, 0.6, 0.2) or Color3.new(0.6, 0.2, 0.2)
    ToggleButton.Text = Config.Enabled and "✅ ATIVADO" or "❌ DESATIVADO"
    StatusLabel.Text = Config.Enabled and "Status: 🟢 Auto Farm Ativo" or "Status: 🔴 Auto Farm Desativado"
end)

RadiusSlider.FocusLost:Connect(function()
    local newRadius = tonumber(RadiusSlider.Text)
    if newRadius and newRadius > 0 and newRadius <= 500 then
        Config.FarmRadius = newRadius
        RadiusLabel.Text = "📡 Raio de Farm: " .. Config.FarmRadius
    else
        RadiusSlider.Text = tostring(Config.FarmRadius)
    end
end)

TweeningToggle.MouseButton1Click:Connect(function()
    Config.UseTweening = not Config.UseTweening
    TweeningToggle.BackgroundColor3 = Config.UseTweening and Color3.new(0.2, 0.6, 0.2) or Color3.new(0.6, 0.2, 0.2)
    TweeningToggle.Text = Config.UseTweening and "🎯 TWEENING: ON" or "🎯 TWEENING: OFF"
end)

SpeedSlider.FocusLost:Connect(function()
    local newSpeed = tonumber(SpeedSlider.Text)
    if newSpeed and newSpeed >= 10 and newSpeed <= 200 then
        Config.TweenSpeed = newSpeed
        SpeedLabel.Text = "⚡ Velocidade Tween: " .. Config.TweenSpeed
    else
        SpeedSlider.Text = tostring(Config.TweenSpeed)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    Config.Enabled = false
end)

-- Atualiza status em tempo real
spawn(function()
    while ScreenGui and ScreenGui.Parent do
        if Config.Enabled then
            local target, distance = GetClosestNPC()
            if target then
                StatusLabel.Text = string.format("Status: 🎯 Atacando %s (%.1f studs)", target.Name, distance)
                StatusLabel.TextColor3 = Color3.new(1, 0.5, 0)
            else
                StatusLabel.Text = "Status: 🔍 Nenhum NPC no raio de " .. Config.FarmRadius .. " studs"
                StatusLabel.TextColor3 = Color3.new(0.5, 0.5, 1)
            end
        end
        wait(0.5)
    end
end)

-- Inicia o Auto Farm
spawn(function()
    while true do
        if Config.Enabled then
            AutoFarmLoop()
        end
        wait(0.1)
    end
end)

-- Mensagem de inicialização
print("✅ Script Auto Farm Blox Fruits carregado com sucesso!")
print("🎮 Interface criada por Developer Pro")
print("⚙️ Use a GUI para configurar o Auto Farm")
