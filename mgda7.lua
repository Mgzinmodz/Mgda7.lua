-- // SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local PlayerGui = Player:WaitForChild("PlayerGui")

-- // GUI PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MGCHEATS_ARENA"
ScreenGui.Parent = PlayerGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999

-- ==============================================
-- // BOTÃO FLUTUANTE VERMELHO
-- ==============================================
local ButtonMG = Instance.new("TextButton")
ButtonMG.Name = "ButtonMG"
ButtonMG.Parent = ScreenGui
ButtonMG.BackgroundColor3 = Color3.new(0, 0, 0)
ButtonMG.BorderColor3 = Color3.new(1, 0, 0)
ButtonMG.BorderSizePixel = 3
ButtonMG.Size = UDim2.new(0, 70, 0, 70)
ButtonMG.Position = UDim2.new(0.02, 0, 0.45, 0)
ButtonMG.Font = Enum.Font.GothamBold
ButtonMG.Text = "MG"
ButtonMG.TextColor3 = Color3.new(1, 0, 0)
ButtonMG.TextSize = 28
ButtonMG.Active = true
ButtonMG.Draggable = true

local UICornerBtn = Instance.new("UICorner")
UICornerBtn.CornerRadius = UDim.new(1, 0)
UICornerBtn.Parent = ButtonMG

local UIStrokeBtn = Instance.new("UIStroke")
UIStrokeBtn.Thickness = 3
UIStrokeBtn.Color = Color3.new(1, 0, 0)
UIStrokeBtn.Parent = ButtonMG

-- ==============================================
-- // CIRCULO DO FOV BRANCO (SÓ A LINHA)
-- ==============================================
local FOVCircle = Instance.new("Frame")
FOVCircle.Name = "FOVCircle"
FOVCircle.Parent = ScreenGui
FOVCircle.BackgroundTransparency = 1
FOVCircle.Size = UDim2.new(0, 300, 0, 300)
FOVCircle.Position = UDim2.new(0.5, -150, 0.5, -150)
FOVCircle.Visible = false

-- BORDA BRANCA
local Border = Instance.new("UIStroke")
Border.Thickness = 2
Border.Color = Color3.new(1, 1, 1)
Border.Parent = FOVCircle

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = FOVCircle

-- ==============================================
-- // MENU PRINCIPAL
-- ==============================================
local MainMenu = Instance.new("Frame")
MainMenu.Name = "MainMenu"
MainMenu.Parent = ScreenGui
MainMenu.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
MainMenu.BorderColor3 = Color3.new(0.5, 0, 1)
MainMenu.BorderSizePixel = 3
MainMenu.Size = UDim2.new(0, 400, 0, 400)
MainMenu.Position = UDim2.new(0.05, 0, 0.1, 0)
MainMenu.Active = true
MainMenu.Draggable = true
MainMenu.Visible = false

local UICornerMenu = Instance.new("UICorner")
UICornerMenu.CornerRadius = UDim.new(0, 12)
UICornerMenu.Parent = MainMenu

-- ==============================================
-- // TOPO
-- ==============================================
local TopBar = Instance.new("Frame")
TopBar.Parent = MainMenu
TopBar.BackgroundColor3 = Color3.new(0,0,0)
TopBar.BorderColor3 = Color3.new(0.5, 0, 1)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.Position = UDim2.new(0,0,0,0)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1, -80, 1, 0)
Title.Position = UDim2.new(0,10,0,0)
Title.Font = Enum.Font.GothamBold
Title.Text = "★ MGCHEATS ★"
Title.TextColor3 = Color3.new(0.2, 1, 1)
Title.TextSize = 20

local BtnMinimize = Instance.new("TextButton")
BtnMinimize.Parent = TopBar
BtnMinimize.Size = UDim2.new(0, 35, 0, 30)
BtnMinimize.Position = UDim2.new(1, -75, 0, 2)
BtnMinimize.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
BtnMinimize.BorderColor3 = Color3.new(1,1,1)
BtnMinimize.Text = "-"
BtnMinimize.TextColor3 = Color3.new(1,1,1)
BtnMinimize.Font = Enum.Font.GothamBold
BtnMinimize.TextSize = 18

local BtnClose = Instance.new("TextButton")
BtnClose.Parent = TopBar
BtnClose.Size = UDim2.new(0, 35, 0, 30)
BtnClose.Position = UDim2.new(1, -40, 0, 2)
BtnClose.BackgroundColor3 = Color3.new(0.5, 0, 0)
BtnClose.BorderColor3 = Color3.new(1,0,0)
BtnClose.Text = "X"
BtnClose.TextColor3 = Color3.new(1,1,1)
BtnClose.Font = Enum.Font.GothamBold
BtnClose.TextSize = 18

-- ==============================================
-- // VARIAVEIS
-- ==============================================
_G.Aimbot = false
_G.ShowFOV = false
_G.FOV_Size = 300
_G.ESP_Box = false
_G.ESP_Line = false
_G.MenuVisible = true

local Y = 55
local ESPObjects = {}

-- ==============================================
-- // FUNÇÕES UI
-- ==============================================
local function CreateOption(Name, VarName, Emoji)
    local Frame = Instance.new("Frame")
    Frame.Parent = MainMenu
    Frame.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
    Frame.BorderColor3 = Color3.new(0.5, 0, 1)
    Frame.BorderSizePixel = 2
    Frame.Size = UDim2.new(0.9, 0, 0, 45)
    Frame.Position = UDim2.new(0.05, 0, 0, Y)
    Y = Y + 55

    local UICornerOpt = Instance.new("UICorner")
    UICornerOpt.CornerRadius = UDim.new(0, 8)
    UICornerOpt.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Parent = Frame
    Label.BackgroundTransparency = 1
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.Font = Enum.Font.GothamBold
    Label.Text = Emoji.."  "..Name
    Label.TextColor3 = Color3.new(1,1,1)
    Label.TextSize = 16
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Toggle = Instance.new("TextButton")
    Toggle.Parent = Frame
    Toggle.Size = UDim2.new(0, 30, 0, 30)
    Toggle.Position = UDim2.new(0.85, 0, 0.5, -15)
    Toggle.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    Toggle.BorderColor3 = Color3.new(1,1,1)
    Toggle.Text = ""

    local UICornerToggle = Instance.new("UICorner")
    UICornerToggle.CornerRadius = UDim.new(1, 0)
    UICornerToggle.Parent = Toggle

    Toggle.MouseButton1Click:Connect(function()
        _G[VarName] = not _G[VarName]
        if _G[VarName] then
            Toggle.BackgroundColor3 = Color3.new(0, 1, 0)
        else
            Toggle.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
        end
    end)
end

-- ==============================================
-- // OPÇÕES
-- ==============================================
CreateOption("Aimbot", "Aimbot", "🎯")
CreateOption("Exibir círculo FOV", "ShowFOV", "⚪")
CreateOption("ESP LINE", "ESP_Line", "🟢")
CreateOption("ESP Caixa", "ESP_Box", "🟩")

-- ==============================================
-- // LOGICA DO MENU
-- ==============================================
ButtonMG.MouseButton1Click:Connect(function()
    MainMenu.Visible = not MainMenu.Visible
end)

BtnClose.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

BtnMinimize.MouseButton1Click:Connect(function()
    MainMenu.Visible = false
end)

-- ==============================================
-- // SISTEMA 3 DEDOS (CERTO)
-- ==============================================
local touches = {}

UserInputService.TouchStarted:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    touches[input] = true
    
    local count = 0
    for _ in pairs(touches) do
        count = count + 1
    end
    
    if count >= 3 then
        _G.MenuVisible = not _G.MenuVisible
        ScreenGui.Enabled = _G.MenuVisible
        touches = {}
    end
end)

UserInputService.TouchEnded:Connect(function(input)
    touches[input] = nil
end)

-- ==============================================
-- // AIMBOT (PROTEÇÃO TOTAL)
-- ==============================================
RunService.RenderStepped:Connect(function()
    -- FOV BRANCO
    FOVCircle.Visible = _G.ShowFOV
    FOVCircle.Size = UDim2.new(0, _G.FOV_Size, 0, _G.FOV_Size)
    FOVCircle.Position = UDim2.new(0.5, -_G.FOV_Size/2, 0.5, -_G.FOV_Size/2)
    
    -- AIMBOT
    if _G.Aimbot and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local Closest = nil
        local MaxDistance = 200
        
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
                local Dist = (Player.Character.HumanoidRootPart.Position - v.Character.Head.Position).Magnitude
                if Dist < MaxDistance then
                    MaxDistance = Dist
                    Closest = v
                end
            end
        end
        
        if Closest and Closest.Character and Closest.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Closest.Character.Head.Position)
        end
    end
end)

-- ==============================================
-- // ESP CAIXA E LINHA (EXATAMENTE COMO NA FOTO)
-- ==============================================
local function CreateESP(player)
    if player == Player then return end
    
    local esp = {
        Box = nil,
        Line = nil
    }
    
    -- CAIXA VERDE DO TAMANHO DO PLAYER
    esp.Box = Instance.new("BoxHandleAdornment")
    esp.Box.Name = "ESP_Box_"..player.Name
    esp.Box.Parent = Workspace
    esp.Box.Thickness = 2
    esp.Box.Transparency = 1
    esp.Box.AlwaysOnTop = true -- VÊ ATRÁS DE PAREDE
    esp.Box.ZIndex = 10
    esp.Box.Color3 = Color3.new(0, 1, 0)
    
    -- LINHA VERDE DO TOPO ATÉ A CABEÇA
    esp.Line = Instance.new("LineHandleAdornment")
    esp.Line.Name = "ESP_Line_"..player.Name
    esp.Line.Parent = Workspace
    esp.Line.Thickness = 2
    esp.Line.Transparency = 1
    esp.Line.AlwaysOnTop = true -- VÊ ATRÁS DE PAREDE
    esp.Line.ZIndex = 10
    esp.Line.Color3 = Color3.new(0, 1, 0)
    
    ESPObjects[player] = esp
end

local function UpdateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player then
            if not ESPObjects[player] then
                CreateESP(player)
            end
            
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                local hrp = char.HumanoidRootPart
                local head = char.Head
                
                -- CAIXA NO CORPO INTEIRO
                ESPObjects[player].Box.Size = Vector3.new(2, 3, 1)
                ESPObjects[player].Box.CFrame = hrp.CFrame * CFrame.new(0, 1.5, 0)
                ESPObjects[player].Box.Visible = _G.ESP_Box
                
                -- LINHA RETA DO TOPO ATÉ A CABEÇA
                ESPObjects[player].Line.From = Vector3.new(Camera.CFrame.Position.X, Camera.CFrame.Position.Y + 10, Camera.CFrame.Position.Z)
                ESPObjects[player].Line.To = head.Position
                ESPObjects[player].Line.Visible = _G.ESP_Line
            else
                if ESPObjects[player] then
                    ESPObjects[player].Box.Visible = false
                    ESPObjects[player].Line.Visible = false
                end
            end
        end
    end
end

-- ==============================================
-- // LIMPEZA AUTOMATICA
-- ==============================================
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        if ESPObjects[player].Box then
            ESPObjects[player].Box:Destroy()
        end
        if ESPObjects[player].Line then
            ESPObjects[player].Line:Destroy()
        end
        ESPObjects[player] = nil
    end
end)

RunService.Heartbeat:Connect(UpdateESP)

print("✅ MGCHEATS CARREGADO!")
