local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer


local espEnabled = true
local aimbotActive = false
local espData = {}
local noclipEnabled = false
local FOV = 100
local FOV_MIN, FOV_MAX = 50, 300
local flySpeed = 50
local flyDirection = Vector3.new(0,0,0)
local SPEED_MIN, SPEED_MAX = 10, 300


local ignoredTeams = { ["Neutral"] = true, ["Lobby"] = true }
local function shouldIgnore(p)
    return (p.Team and ignoredTeams[p.Team.Name]) or (p.Team == LocalPlayer.Team)
end


local toggleText = Drawing.new("Text")
toggleText.Text, toggleText.Size = "[ESP: ON] (Clique aqui)", 16
toggleText.Position = Vector2.new(20,40)
toggleText.Color = Color3.fromRGB(0,255,0)
toggleText.Outline, toggleText.Visible = true, true

toggleText.MouseButton1Click = function()
    espEnabled = not espEnabled
    toggleText.Text = "[ESP: " .. (espEnabled and "ON" or "OFF") .. "] (Clique aqui)"
    toggleText.Color = espEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
end


local fovCircle = Drawing.new("Circle")
fovCircle.Color, fovCircle.Thickness = Color3.fromRGB(0,255,0), 1
fovCircle.Filled, fovCircle.Transparency, fovCircle.Visible = false, 1, true

RunService.RenderStepped:Connect(function()
    fovCircle.Position = UserInputService:GetMouseLocation()
    fovCircle.Radius = FOV
end)


local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "AdvancedCheatUI"


local mainColor = Color3.fromRGB(25,25,25)
local accentColor = Color3.fromRGB(0,255,100)


local espAtivo = true
local FOV = 100
local FOV_MIN, FOV_MAX = 50, 300
local flySpeed = 50
local SPEED_MIN, SPEED_MAX = 10, 300
local hitboxAtivo, boneAtivo, rangeAtivo = false, false, false


local abaAtual = "ESP"


local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 300, 0, 360)
mainFrame.Position = UDim2.new(0, 20, 0, 100)
mainFrame.BackgroundColor3 = mainColor
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.1
mainFrame.ClipsDescendants = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)


mainFrame.Size = UDim2.new(0, 0, 0, 360)
TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 300, 0, 360)
}):Play()


local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "🔧 Menu de Cheats"
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextXAlignment = Enum.TextXAlignment.Center


local abas = {"ESP", "Aimbot", "Fly"}
local botoesAbas = {}

for i, nome in ipairs(abas) do
    local btn = Instance.new("TextButton", mainFrame)
    btn.Size = UDim2.new(0, 80, 0, 30)
    btn.Position = UDim2.new(0, 10 + ((i-1)*90), 0, 45)
    btn.Text = nome
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        abaAtual = nome
        for _, frame in pairs(mainFrame:GetChildren()) do
            if frame:IsA("Frame") and frame.Name:match("Painel") then
                frame.Visible = false
            end
        end
        mainFrame:FindFirstChild("Painel"..nome).Visible = true
    end)

    botoesAbas[nome] = btn
end


local function criarPainel(nome)
    local p = Instance.new("Frame", mainFrame)
    p.Name = "Painel"..nome
    p.Size = UDim2.new(1, -20, 0, 260)
    p.Position = UDim2.new(0, 10, 0, 80)
    p.BackgroundTransparency = 1
    p.Visible = (nome == abaAtual)
    return p
end

local espPainel = criarPainel("ESP")
local aimbotPainel = criarPainel("Aimbot")
local flyPainel = criarPainel("Fly")


local espToggle = Instance.new("TextButton", espPainel)
espToggle.Size = UDim2.new(0, 240, 0, 30)
espToggle.Position = UDim2.new(0, 0, 0, 0)
espToggle.Text = "🟢 ESP: ON (clique para alternar)"
espToggle.Font = Enum.Font.GothamBold
espToggle.TextSize = 14
espToggle.BackgroundColor3 = Color3.fromRGB(35,35,35)
espToggle.TextColor3 = accentColor
Instance.new("UICorner", espToggle).CornerRadius = UDim.new(0, 8)

espToggle.MouseButton1Click:Connect(function()
    espAtivo = not espAtivo
    espToggle.Text = (espAtivo and "🟢 ESP: ON" or "🔴 ESP: OFF") .. " (clique para alternar)"
    espToggle.TextColor3 = espAtivo and accentColor or Color3.fromRGB(255,0,0)
end)


local aimLabel = Instance.new("TextLabel", aimbotPainel)
aimLabel.Size = UDim2.new(1, 0, 0, 30)
aimLabel.Position = UDim2.new(0, 0, 0, 0)
aimLabel.Text = "🎯 Pressione E para ativar Aimbot"
aimLabel.Font = Enum.Font.Gotham
aimLabel.TextColor3 = Color3.fromRGB(255,255,255)
aimLabel.BackgroundTransparency = 1

local function toggleOption(parent, label, stateRef)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 240, 0, 28)
    btn.Position = UDim2.new(0, 0, 0, #parent:GetChildren()*30)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    local function updateText()
        btn.Text = (stateRef and "✅ " or "❌ ")..label
    end

    updateText()
    btn.MouseButton1Click:Connect(function()
        _G[stateRef] = not _G[stateRef]
        updateText()
    end)
end

toggleOption(aimbotPainel, "Hitbox", "hitboxAtivo")
toggleOption(aimbotPainel, "Bone Tracking", "boneAtivo")
toggleOption(aimbotPainel, "Range Check", "rangeAtivo")


local fovLabel = Instance.new("TextLabel", aimbotPainel)
fovLabel.Position = UDim2.new(0, 0, 0, 130)
fovLabel.Size = UDim2.new(0, 240, 0, 20)
fovLabel.Text = "FOV: "..FOV
fovLabel.BackgroundTransparency = 1
fovLabel.TextColor3 = Color3.fromRGB(255,255,255)
fovLabel.Font = Enum.Font.Gotham
fovLabel.TextSize = 14

local fovSlider = Instance.new("TextButton", aimbotPainel)
fovSlider.Position = UDim2.new(0, 0, 0, 155)
fovSlider.Size = UDim2.new(0, 240, 0, 10)
fovSlider.BackgroundColor3 = Color3.fromRGB(50,50,50)

local fovHandle = Instance.new("Frame", fovSlider)
fovHandle.Size = UDim2.new(0, 10, 0, 10)
fovHandle.BackgroundColor3 = accentColor
Instance.new("UICorner", fovHandle).CornerRadius = UDim.new(0,5)

fovSlider.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        local con; con = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local x = math.clamp((input.Position.X - fovSlider.AbsolutePosition.X)/fovSlider.AbsoluteSize.X,0,1)
                FOV = math.floor(FOV_MIN + (FOV_MAX - FOV_MIN)*x)
                fovHandle.Position = UDim2.new(x, -5, 0, 0)
                fovLabel.Text = "FOV: "..FOV
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                con:Disconnect()
            end
        end)
    end
end)


local flyInfo = Instance.new("TextLabel", flyPainel)
flyInfo.Size = UDim2.new(1, 0, 0, 30)
flyInfo.Position = UDim2.new(0, 0, 0, 0)
flyInfo.Text = "🚀 Fly: Q para ativar / WASD + SPACE"
flyInfo.Font = Enum.Font.Gotham
flyInfo.TextColor3 = Color3.fromRGB(255,255,255)
flyInfo.BackgroundTransparency = 1


local speedLabel = Instance.new("TextLabel", flyPainel)
speedLabel.Position = UDim2.new(0, 0, 0, 40)
speedLabel.Size = UDim2.new(0, 240, 0, 20)
speedLabel.Text = "Velocidade: "..flySpeed
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 14

local speedSlider = Instance.new("TextButton", flyPainel)
speedSlider.Position = UDim2.new(0, 0, 0, 65)
speedSlider.Size = UDim2.new(0, 240, 0, 10)
speedSlider.BackgroundColor3 = Color3.fromRGB(50,50,50)

local speedHandle = Instance.new("Frame", speedSlider)
speedHandle.Size = UDim2.new(0, 10, 0, 10)
speedHandle.BackgroundColor3 = accentColor
Instance.new("UICorner", speedHandle).CornerRadius = UDim.new(0,5)

speedSlider.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        local con; con = UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local x = math.clamp((input.Position.X - speedSlider.AbsolutePosition.X)/speedSlider.AbsoluteSize.X,0,1)
                flySpeed = math.floor(SPEED_MIN + (SPEED_MAX - SPEED_MIN)*x)
                speedHandle.Position = UDim2.new(x, -5, 0, 0)
                speedLabel.Text = "Velocidade: "..flySpeed
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                con:Disconnect()
            end
        end)
    end
end)





UserInputService.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.E then aimbotActive = true end
    if i.KeyCode == Enum.KeyCode.Q then noclipEnabled = true end
    if i.KeyCode == Enum.KeyCode.W then flyDirection += Vector3.new(0,0,-1) end
    if i.KeyCode == Enum.KeyCode.S then flyDirection += Vector3.new(0,0,1) end
    if i.KeyCode == Enum.KeyCode.A then flyDirection += Vector3.new(-1,0,0) end
    if i.KeyCode == Enum.KeyCode.D then flyDirection += Vector3.new(1,0,0) end
    if i.KeyCode == Enum.KeyCode.Space then flyDirection += Vector3.new(0,1,0) end
    if i.KeyCode == Enum.KeyCode.R then magicBullet() end
    if i.KeyCode == Enum.KeyCode.Insert then
        menuVisible = not menuVisible
        setMenuVisibility(menuVisible)
    end
    if i.UserInputType == Enum.UserInputType.MouseButton1 then toggleText:MouseButton1Click() end
end)


UserInputService.InputEnded:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.E then aimbotActive = false end
    if i.KeyCode == Enum.KeyCode.Q then noclipEnabled = false; flyDirection = Vector3.new(0,0,0) end
    if i.KeyCode == Enum.KeyCode.W then flyDirection -= Vector3.new(0,0,-1) end
    if i.KeyCode == Enum.KeyCode.S then flyDirection -= Vector3.new(0,0,1) end
    if i.KeyCode == Enum.KeyCode.A then flyDirection -= Vector3.new(-1,0,0) end
    if i.KeyCode == Enum.KeyCode.D then flyDirection -= Vector3.new(1,0,0) end
    if i.KeyCode == Enum.KeyCode.Space then flyDirection -= Vector3.new(0,1,0) end
end)


RunService.Heartbeat:Connect(function(delta)
    local char = LocalPlayer.Character
    if noclipEnabled and char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hrp and hum then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
            hum.PlatformStand = true
            local cam = Camera.CFrame
            if flyDirection.Magnitude > 0 then
                local move = (cam.RightVector * flyDirection.X + cam.LookVector * flyDirection.Z + Vector3.new(0, flyDirection.Y, 0)).Unit
                hrp.Velocity = move * flySpeed
            else
                hrp.Velocity = Vector3.new(0,0,0)
            end
        end
    else
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid").PlatformStand = false
        end
    end
end)


local function createESP(p)
    if p == LocalPlayer or espData[p] then return end
    espData[p] = {
        box = Drawing.new("Square"),
        name = Drawing.new("Text"),
        health = Drawing.new("Square")
    }
    local d = espData[p]
    d.box.Thickness, d.box.Filled, d.box.Color, d.box.Visible = 2,false,Color3.fromRGB(255,0,0),false
    d.name.Size, d.name.Center, d.name.Outline, d.name.Color, d.name.Visible = 14,true,true,Color3.fromRGB(255,255,255),false
    d.health.Thickness, d.health.Filled, d.health.Visible = 1,true,false
end

local function removeESP(p)
    if espData[p] then 
        for _,o in pairs(espData[p]) do if o.Remove then o:Remove() end end
        espData[p] = nil
    end
end

local function updateESP()
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
            createESP(p)
            local d = espData[p]
            local h = p.Character:FindFirstChildWhichIsA("Humanoid")
            if espEnabled and h and h.Health>0 and not shouldIgnore(p) then
                local cf,size = p.Character:GetBoundingBox()
                local pts, on = {}, false
                for _,c in ipairs({Vector3.new(-1,-1,-1), Vector3.new(1,1,1)}) do
                    local wp = cf.Position + cf.Rotation*(c*(size/2))
                    local sp,vis = Camera:WorldToViewportPoint(wp)
                    if vis then on=true end
                    table.insert(pts, sp)
                end
                if on then
                    local minX,minY, maxX,maxY = math.huge,math.huge, -math.huge,-math.huge
                    for _,pt in ipairs(pts) do
                        minX,minY = math.min(minX,pt.X), math.min(minY,pt.Y)
                        maxX,maxY = math.max(maxX,pt.X), math.max(maxY,pt.Y)
                    end
                    local bs = Vector2.new(maxX-minX, maxY-minY)
                    d.box.Size, d.box.Position, d.box.Visible = bs, Vector2.new(minX,minY), true
                    d.name.Text = string.format("%s [%.0f%%]", p.Name, (h.Health/h.MaxHealth)*100)
                    d.name.Position, d.name.Visible = Vector2.new(minX+bs.X/2, minY-16), true

                    local r = math.clamp(h.Health/h.MaxHealth,0,1)
                    d.health.Color = Color3.fromRGB(255-(255*r),255*r,0)
                    d.health.Size = Vector2.new(4, bs.Y*r)
                    d.health.Position = Vector2.new(minX-6, minY+(bs.Y*(1-r)))
                    d.health.Visible = true
                else
                    d.box.Visible, d.name.Visible, d.health.Visible = false,false,false
                end
            else
                d.box.Visible, d.name.Visible, d.health.Visible = false,false,false
            end
        elseif espData[p] then
            espData[p].box.Visible, espData[p].name.Visible, espData[p].health.Visible = false,false,false
        end
    end
end


local function getClosestVisibleHead()
    local best,short, mpos = nil, math.huge, UserInputService:GetMouseLocation()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer and not shouldIgnore(p) and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local sp,vis = Camera:WorldToViewportPoint(head.Position)
            if vis then
                local dir = (head.Position-Camera.CFrame.Position).Unit*1000
                local r = RaycastParams.new()
                r.FilterType = Enum.RaycastFilterType.Blacklist
                r.FilterDescendantsInstances = {LocalPlayer.Character}
                local res = workspace:Raycast(Camera.CFrame.Position,dir,r)
                if res and res.Instance:IsDescendantOf(p.Character) then
                    local dist = (Vector2.new(sp.X,sp.Y)-mpos).Magnitude
                    if dist < short and dist <= FOV then best,short = head,dist end
                end
            end
        end
    end
    return best
end

local function aimAt(t)
    if t then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, t.Position)
    end
end


local function magicBullet()
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not shouldIgnore(p) and p.Character and p.Character:FindFirstChild("Head") then
            local head = p.Character.Head
            local screenPos, visible = Camera:WorldToViewportPoint(head.Position)
            local mousePos = UserInputService:GetMouseLocation()
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
            if distance <= FOV then
                local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.Health > 0 then
                    humanoid:TakeDamage(humanoid.MaxHealth)
                    print("Magic Bullet usado em: " .. p.Name)
                end
            end
        end
    end
end


Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    updateESP()
    if aimbotActive then
        local t = getClosestVisibleHead()
        if t then aimAt(t) end
    end
end)
