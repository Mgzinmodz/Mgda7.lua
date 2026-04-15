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
-- // BOTÃO FLUTUANTE
-- ==============================================
local ButtonMG = Instance.new("TextButton")
ButtonMG.Parent = ScreenGui
ButtonMG.Size = UDim2.new(0,70,0,70)
ButtonMG.Position = UDim2.new(0.02,0,0.45,0)
ButtonMG.BackgroundColor3 = Color3.new(0,0,0)
ButtonMG.BorderColor3 = Color3.new(1,0,0)
ButtonMG.BorderSizePixel = 3
ButtonMG.Text = "MG"
ButtonMG.TextColor3 = Color3.new(1,0,0)
ButtonMG.Font = Enum.Font.GothamBold
ButtonMG.TextSize = 28
ButtonMG.Active = true
ButtonMG.Draggable = true

Instance.new("UICorner", ButtonMG).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", ButtonMG).Color = Color3.new(1,0,0)

-- ==============================================
-- // FOV
-- ==============================================
local FOVCircle = Instance.new("Frame")
FOVCircle.Parent = ScreenGui
FOVCircle.Size = UDim2.new(0,300,0,300)
FOVCircle.Position = UDim2.new(0.5,-150,0.5,-150)
FOVCircle.BackgroundTransparency = 1
FOVCircle.Visible = false

Instance.new("UICorner", FOVCircle).CornerRadius = UDim.new(1,0)
local stroke = Instance.new("UIStroke", FOVCircle)
stroke.Color = Color3.new(1,1,1)
stroke.Thickness = 2

-- ==============================================
-- // MENU
-- ==============================================
local MainMenu = Instance.new("Frame")
MainMenu.Parent = ScreenGui
MainMenu.Size = UDim2.new(0,400,0,400)
MainMenu.Position = UDim2.new(0.05,0,0.1,0)
MainMenu.BackgroundColor3 = Color3.new(0.15,0.15,0.15)
MainMenu.BorderColor3 = Color3.new(0.5,0,1)
MainMenu.BorderSizePixel = 3
MainMenu.Visible = false
MainMenu.Active = true
MainMenu.Draggable = true

Instance.new("UICorner", MainMenu)

-- TOPO
local TopBar = Instance.new("Frame", MainMenu)
TopBar.Size = UDim2.new(1,0,0,40)
TopBar.BackgroundColor3 = Color3.new(0,0,0)

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1,-80,1,0)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.Text = "★ MGCHEATS ★"
Title.TextColor3 = Color3.new(0,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

local BtnClose = Instance.new("TextButton", TopBar)
BtnClose.Size = UDim2.new(0,35,0,30)
BtnClose.Position = UDim2.new(1,-40,0,5)
BtnClose.Text = "X"

-- ==============================================
-- // VARIAVEIS
-- ==============================================
_G.Aimbot = false
_G.ShowFOV = false
_G.FOV_Size = 300
_G.ESP_Box = false
_G.ESP_Line = false

local ESPObjects = {}

-- ==============================================
-- // MENU BOTÃO
-- ==============================================
ButtonMG.MouseButton1Click:Connect(function()
	MainMenu.Visible = not MainMenu.Visible
end)

BtnClose.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- ==============================================
-- // AIMBOT
-- ==============================================
RunService.RenderStepped:Connect(function()
	FOVCircle.Visible = _G.ShowFOV
	FOVCircle.Size = UDim2.new(0,_G.FOV_Size,0,_G.FOV_Size)
	FOVCircle.Position = UDim2.new(0.5,-_G.FOV_Size/2,0.5,-_G.FOV_Size/2)

	if _G.Aimbot and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
		local closest, dist = nil, 200

		for _,v in pairs(Players:GetPlayers()) do
			if v ~= Player and v.Character and v.Character:FindFirstChild("Head") then
				local d = (Player.Character.HumanoidRootPart.Position - v.Character.Head.Position).Magnitude
				if d < dist then
					dist = d
					closest = v
				end
			end
		end

		if closest and closest.Character then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Character.Head.Position)
		end
	end
end)

-- ==============================================
-- // ESP
-- ==============================================
local function CreateESP(player)
	if player == Player then return end

	local box = Instance.new("BoxHandleAdornment")
	box.Parent = Workspace
	box.AlwaysOnTop = true
	box.Color3 = Color3.new(0,1,0)
	box.Transparency = 1
	box.Thickness = 2

	local line = Instance.new("LineHandleAdornment")
	line.Parent = Workspace
	line.AlwaysOnTop = true
	line.Color3 = Color3.new(0,1,0)
	line.Transparency = 1
	line.Thickness = 2

	ESPObjects[player] = {Box = box, Line = line}
end

local function UpdateESP()
	for _,player in pairs(Players:GetPlayers()) do
		if player ~= Player then
			if not ESPObjects[player] then
				CreateESP(player)
			end

			local data = ESPObjects[player]
			local char = player.Character

			if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") then
				local hrp = char.HumanoidRootPart
				local head = char.Head

				-- BOX
				data.Box.Size = Vector3.new(2,3,1)
				data.Box.CFrame = hrp.CFrame * CFrame.new(0,1.5,0)
				data.Box.Visible = _G.ESP_Box

				-- LINE (ARRUMADO)
				data.Line.From = Camera.CFrame.Position
				data.Line.To = head.Position
				data.Line.Visible = _G.ESP_Line
			else
				data.Box.Visible = false
				data.Line.Visible = false
			end
		end
	end
end

RunService.Heartbeat:Connect(UpdateESP)

-- LIMPEZA
Players.PlayerRemoving:Connect(function(p)
	if ESPObjects[p] then
		if ESPObjects[p].Box then ESPObjects[p].Box:Destroy() end
		if ESPObjects[p].Line then ESPObjects[p].Line:Destroy() end
		ESPObjects[p] = nil
	end
end)

print("✅ MGCHEATS CORRIGIDO!")
