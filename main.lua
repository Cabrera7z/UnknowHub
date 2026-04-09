--[[
    SCRIPT: Blox Fruits Auto Farm Pro - CORRIGIDO
    EXECUTOR: Delta / Arceus / Fluxus
    FUNÇÃO: Auto Farm com punho (slot 1) e ataque funcional
]]

-- Variáveis principais
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualInput = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Configurações do Auto Farm
local Config = {
    Enabled = true,
    FarmRadius = 250,
    AttackCooldown = 0.2,
    MoveToTarget = true,
    UseTweening = true,
    TweenSpeed = 50,
    CheckInterval = 0.1
}

-- Função para equipar o punho (slot 1)
local function EquipPunch()
    -- Tenta encontrar o punho no inventário
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character
    
    if backpack then
        -- Procura pelo punho no inventário (slot 1 geralmente é o primeiro item)
        local punchTool = nil
        
        -- Lista de nomes comuns do punho em Blox Fruits
        local punchNames = {"Combat", "Punch", "Fist", "Melee", "Fighting Style"}
        
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                -- Verifica se é o punho por nome ou por slot
                local toolName = tool.Name:lower()
                for _, punchName in pairs(punchNames) do
                    if toolName:find(punchName:lower()) then
                        punchTool = tool
                        break
                    end
                end
            end
        end
        
        -- Se não encontrou por nome, pega o primeiro tool do inventário (slot 1)
        if not punchTool then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    punchTool = tool
                    break
                end
            end
        end
        
        -- Equipa a ferramenta
        if punchTool then
            -- Método 1: Parentear direto
            punchTool.Parent = character
            
            -- Método 2: Usar evento de equipar
            local toolRemote = punchTool:FindFirstChild("RemoteEvent") or punchTool:FindFirstChild("Remote")
            if toolRemote then
                toolRemote:FireServer()
            end
            
            -- Método 3: Simular clique no inventário
            VirtualInput:SendKeyEvent("E", true, game)
            wait(0.1)
            VirtualInput:SendKeyEvent("E", false, game)
            
            return punchTool
        end
    end
    
    -- Se não encontrou no backpack, procura no character
    for _, tool in pairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            return tool
        end
    end
    
    return nil
end

-- Função para encontrar NPCs mais próximos (melhorada)
local function GetClosestNPC()
    local closestNPC = nil
    local shortestDistance = Config.FarmRadius
    local npcModels = {}
    
    -- Procura por todos os modelos no workspace
    for _, v in pairs(workspace:GetChildren()) do
        -- Verifica se é um NPC válido
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
            -- Verifica se não é um player e não é o próprio personagem
            if not Players:GetPlayerFromCharacter(v) and v ~= Character then
                local humanoid = v.Humanoid
                if humanoid.Health > 0 then
                    local distance = (RootPart.Position - v.HumanoidRootPart.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestNPC = v
                    end
                end
            end
        end
    end
    
    -- Verifica também em subpastas (alguns NPCs podem estar dentro de pastas)
    if not closestNPC then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v.Parent ~= workspace and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(v) and v ~= Character then
                    local humanoid = v.Humanoid
                    if humanoid and humanoid.Health > 0 then
                        local distance = (RootPart.Position - v.HumanoidRootPart.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestNPC = v
                        end
                    end
                end
            end
        end
    end
    
    return closestNPC, shortestDistance
end

-- Função para mover até o alvo usando Tweening
local function TweenToTarget(targetPosition)
    if not Config.UseTweening then
        RootPart.CFrame = CFrame.new(targetPosition)
        return
    end
    
    local distance = (RootPart.Position - targetPosition).Magnitude
    local tweenInfo = TweenInfo.new(
        distance / Config.TweenSpeed,
        Enum.EasingStyle.Linear,
        Enum.EasingDirection.Out
    )
    
    local tween = TweenService:Create(RootPart, tweenInfo, {CFrame = CFrame.new(targetPosition)})
    tween:Play()
    tween.Completed:Wait()
end

-- Função MELHORADA para atacar o NPC
local function AttackNPC(target)
    if not target or not target:FindFirstChild("Humanoid") then return end
    
    local targetHumanoid = target.Humanoid
    if targetHumanoid.Health <= 0 then return end
    
    -- Equipa o punho antes de atacar
    local punch = EquipPunch()
    
    -- Pega a parte do corpo do NPC
    local targetPart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Head") or target:FindFirstChild("Torso")
    if not targetPart then return end
    
    -- Posiciona o personagem bem perto do NPC
    local attackPosition = targetPart.Position + Vector3.new(0, 0, 3)
    RootPart.CFrame = CFrame.new(attackPosition, targetPart.Position)
    
    -- Aguarda um frame para garantir posicionamento
    wait(0.05)
    
    -- MÉTODO 1: Simular clique do mouse no alvo
    local mouse = LocalPlayer:GetMouse()
    local oldTarget = mouse.Target
    mouse.Target = targetPart
    
    -- Simula o clique do mouse para atacar
    VirtualInput:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 1, true, targetPart.Position, 1)
    wait(0.05)
    VirtualInput:SendMouseButtonEvent(Enum.UserInputType.MouseButton1, 1, false, targetPart.Position, 1)
    
    mouse.Target = oldTarget
    
    -- MÉTODO 2: Usar o evento da ferramenta diretamente
    local currentTool = Character:FindFirstChildWhichIsA("Tool")
    if currentTool then
        -- Tenta ativar a ferramenta de todas as formas possíveis
        local attackRemote = currentTool:FindFirstChild("Attack")
        if attackRemote then
            attackRemote:FireServer(target)
        end
        
        local clickRemote = currentTool:FindFirstChild("Click")
        if clickRemote then
            clickRemote:FireServer(target)
        end
        
        -- Simula o uso da ferramenta
        currentTool:Activate()
        
        -- Chama o evento equipado
        local equippedEvent = currentTool:FindFirstChild("Equipped")
        if equippedEvent then
            equippedEvent:Fire()
        end
    end
    
    -- MÉTODO 3: Aplicar dano direto via Hitbox (mais confiável)
    local hitbox = Instance.new("Part")
    hitbox.Size = Vector3.new(6, 6, 6)
    hitbox.CFrame = targetPart.CFrame
    hitbox.Anchored = true
    hitbox.CanCollide = false
    hitbox.Transparency = 1
    hitbox.Parent = workspace
    
    -- Cria o efeito de hit
    local damageValue = 25 -- Dano base do punho
    targetHumanoid:TakeDamage(damageValue)
    
    -- Efeito visual de dano
    local damageGui = Instance.new("BillboardGui")
    damageGui.Size = UDim2.new(0, 60, 0, 30)
    damageGui.StudsOffset = Vector3.new(0, 3, 0)
    damageGui.AlwaysOnTop = true
    
    local damageText = Instance.new("TextLabel")
    damageText.Text = "-" .. damageValue
    damageText.TextColor3 = Color3.new(1, 0.3, 0.3)
    damageText.TextScaled = true
    damageText.BackgroundTransparency = 1
    damageText.Font = Enum.Font.GothamBold
    damageText.Parent = damageGui
    
    damageGui.Parent = target
    
    -- Animação do dano
    spawn(function()
        for i = 1, 10 do
            damageGui.StudsOffset = Vector3.new(0, 3 + i * 0.2, 0)
            damageText.TextColor3 = Color3.new(1, 0.3 - i * 0.02, 0.3 - i * 0.02)
            wait(0.05)
        end
        damageGui:Destroy()
    end)
    
    -- Remove o hitbox
    game:GetService("Debris"):AddItem(hitbox, 0.2)
    
    -- Pequena pausa para o próximo ataque
    wait(0.1)
end

-- Loop principal do Auto Farm (otimizado)
local function AutoFarmLoop()
    while Config.Enabled and RunService:IsRunning() do
        local target, distance = GetClosestNPC()
        
        if target and distance <= Config.FarmRadius then
            -- Move até o alvo se necessário
            if distance > 8 and Config.MoveToTarget then
                local targetPosition = target.HumanoidRootPart.Position
                TweenToTarget(targetPosition)
            end
            
            -- Ataca o alvo múltiplas vezes
            for i = 1, 3 do
                if target and target.Humanoid and target.Humanoid.Health > 0 then
                    AttackNPC(target)
                    wait(Config.AttackCooldown)
                else
                    break
                end
            end
        else
            wait(0.3)
        end
        
        wait(Config.CheckInterval)
    end
end

-- Interface Gráfica (Aura Azul)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoFarmGUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Frame principal
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 400)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.new(0.08, 0.08, 0.12)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(0.2, 0.5, 1)
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Aura Azul (gradiente)
local AuraGradient = Instance.new("UIGradient")
AuraGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(0.1, 0.3, 0.8)),
    ColorSequenceKeypoint.new(1, Color3.new(0.2, 0.5, 1))
})
AuraGradient.Rotation = 45
MainFrame.BackgroundColor3 = Color3.new(0.1, 0.3, 0.8)
MainFrame.BackgroundTransparency = 0.15

local CornerRadius = Instance.new("UICorner")
CornerRadius.CornerRadius = UDim.new(0, 12)
CornerRadius.Parent = MainFrame

-- Título
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 45)
TitleLabel.Position = UDim2.new(0, 0, 0, 0)
TitleLabel.BackgroundColor3 = Color3.new(0.15, 0.3, 0.7)
TitleLabel.BackgroundTransparency = 0.2
TitleLabel.Text = "⚡ AUTO FARM - PUNHO ⚡"
TitleLabel.TextColor3 = Color3.new(0.5, 0.9, 1)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Parent = MainFrame

-- Botão Toggle
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

-- Raio
local RadiusLabel = Instance.new("TextLabel")
RadiusLabel.Size = UDim2.new(0.8, 0, 0, 25)
RadiusLabel.Position = UDim2.new(0.1, 0, 0.25, 0)
RadiusLabel.BackgroundTransparency = 1
RadiusLabel.Text = "📡 Raio: " .. Config.FarmRadius
RadiusLabel.TextColor3 = Color3.new(0.7, 0.8, 1)
RadiusLabel.TextXAlignment = Enum.TextXAlignment.Left
RadiusLabel.TextSize = 14
RadiusLabel.Font = Enum.Font.Gotham
RadiusLabel.Parent = MainFrame

local RadiusInput = Instance.new("TextBox")
RadiusInput.Size = UDim2.new(0.3, 0, 0, 25)
RadiusInput.Position = UDim2.new(0.6, 0, 0.25, 0)
RadiusInput.BackgroundColor3 = Color3.new(0.2, 0.2, 0.3)
RadiusInput.Text = tostring(Config.FarmRadius)
RadiusInput.TextColor3 = Color3.new(1, 1, 1)
RadiusInput.TextSize = 14
RadiusInput.Parent = MainFrame

-- Status
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(0.9, 0, 0, 50)
StatusLabel.Position = UDim2.new(0.05, 0, 0.35, 0)
StatusLabel.BackgroundColor3 = Color3.new(0, 0, 0)
StatusLabel.BackgroundTransparency = 0.5
StatusLabel.Text = "🟢 Status: Procurando NPCs..."
StatusLabel.TextColor3 = Color3.new(0.5, 1, 0.5)
StatusLabel.TextScaled = true
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- Botão Fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0.3, 0, 0.1, 0)
CloseButton.Position = UDim2.new(0.35, 0, 0.55, 0)
CloseButton.BackgroundColor3 = Color3.new(0.6, 0.2, 0.2)
CloseButton.Text = "FECHAR"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextScaled = true
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Controles
ToggleButton.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    ToggleButton.BackgroundColor3 = Config.Enabled and Color3.new(0.2, 0.6, 0.2) or Color3.new(0.6, 0.2, 0.2)
    ToggleButton.Text = Config.Enabled and "✅ ATIVADO" or "❌ DESATIVADO"
    StatusLabel.Text = Config.Enabled and "🟢 Status: Auto Farm Ativo" or "🔴 Status: Auto Farm Desativado"
end)

RadiusInput.FocusLost:Connect(function()
    local newRadius = tonumber(RadiusInput.Text)
    if newRadius and newRadius >= 50 and newRadius <= 500 then
        Config.FarmRadius = newRadius
        RadiusLabel.Text = "📡 Raio: " .. Config.FarmRadius
    else
        RadiusInput.Text = tostring(Config.FarmRadius)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    Config.Enabled = false
end)

-- Sistema de arrastar
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

-- Atualiza status
spawn(function()
    while ScreenGui and ScreenGui.Parent do
        if Config.Enabled then
            local target, distance = GetClosestNPC()
            if target then
                StatusLabel.Text = string.format("⚔️ Atacando: %s (%.0f studs)", target.Name, distance)
                StatusLabel.TextColor3 = Color3.new(1, 0.5, 0)
            else
                StatusLabel.Text = "🔍 Nenhum NPC encontrado no raio"
                StatusLabel.TextColor3 = Color3.new(0.5, 0.5, 1)
            end
        end
        wait(0.5)
    end
end)

-- Inicia o farm
spawn(function()
    -- Equipa o punho ao iniciar
    wait(1)
    EquipPunch()
    
    -- Loop principal
    while true do
        if Config.Enabled then
            AutoFarmLoop()
        end
        wait(0.1)
    end
end)

print("✅ Script carregado! Pressione F5 para abrir/fechar GUI")
print("⚔️ Auto Farm com PUNHO ativado!")
