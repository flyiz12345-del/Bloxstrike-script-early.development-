-- // OMEGA V6.1 - SIDEBAR (MOVEMENT FIX)
local P, R, C, LP = game:GetService("Players"), game:GetService("RunService"), workspace.CurrentCamera, game:GetService("Players").LocalPlayer
local U, VIM = game:GetService("UserInputService"), game:GetService("VirtualInputManager")

local _G = { 
    A = true, SA = true, At = true, F = 180, 
    V = true, Ch = true, Tr = true, Sk = true,
    Sp = false, Ws = false, Fly = false, KA = false,
    DesyncActive = false, DesyncMode = "None", StoredPos = nil 
}
local pE, jerkCounter = {}, 0

-- // UNIVERSAL DRAGGING (Fixed for Mobile Movement)
local function makeDraggable(main)
    local dragging, dragInput, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPos = true, input.Position, main.Position
            -- Ensures clicking the menu doesn't stop the joystick
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    U.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function GetCenter(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end

-- // UI SETUP
local G = Instance.new("ScreenGui", LP.PlayerGui); G.Name = "OmegaV61"; G.ResetOnSpawn = false

-- The Vertical Sidebar
local Sidebar = Instance.new("Frame", G)
Sidebar.Size, Sidebar.Position, Sidebar.BackgroundColor3 = UDim2.new(0, 50, 0, 250), UDim2.new(0, 20, 0.5, -125), Color3.new(0.05, 0.05, 0.05)
Sidebar.Active = true -- Allows dragging
Sidebar.Selectable = false -- Stops the "Mouse Mode" lock
Instance.new("UICorner", Sidebar)
Instance.new("UIStroke", Sidebar).Color = Color3.new(0, 0.7, 1)
makeDraggable(Sidebar)

-- Fly-out Panel Builder
local function CreatePanel(y)
    local p = Instance.new("Frame", Sidebar)
    p.Size, p.Position, p.Visible = UDim2.new(0, 140, 0, 220), UDim2.new(1, 10, 0, y), false
    p.BackgroundColor3, p.Active, p.Selectable = Color3.new(0, 0, 0), true, false
    Instance.new("UICorner", p)
    Instance.new("UIStroke", p).Color = Color3.new(0, 0.7, 1)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 4)
    p.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    return p 
end

local AimP, VisP, RageP = CreatePanel(-80), CreatePanel(0), CreatePanel(40)

local function Ico(s, pn, y)
    local b = Instance.new("TextButton", Sidebar)
    b.Size, b.Position, b.Text = UDim2.new(0, 36, 0, 36), UDim2.new(0.5, -18, 0, y), s
    b.BackgroundColor3, b.TextColor3 = Color3.new(0.1, 0.1, 0.1), Color3.new(1, 1, 1)
    b.Modal = false -- CRITICAL FIX: Stops camera/joystick locking
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() 
        AimP.Visible, VisP.Visible, RageP.Visible = false, false, false
        pn.Visible = not pn.Visible 
    end)
end

local function Opt(n, v, p)
    local b = Instance.new("TextButton", p)
    b.Size, b.Text = UDim2.new(0.9, 0, 0, 28), n
    b.BackgroundColor3, b.TextColor3 = Color3.new(0.1, 0.1, 0.1), Color3.new(1, 1, 1)
    b.Modal = false -- CRITICAL FIX
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G[v] = not _G[v]
        b.TextColor3 = _G[v] and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
    end)
end

Ico("🎯", AimP, 15) Ico("👁️", VisP, 70) Ico("😡", RageP, 125)

Opt("Aimbot", "A", AimP) Opt("Silent Aim", "SA", AimP) Opt("AutoShoot", "At", AimP)
Opt("Master ESP", "V", VisP) Opt("Chams", "Ch", VisP) Opt("Skeleton", "Sk", VisP) Opt("Tracers", "Tr", VisP)
Opt("Spinbot", "Sp", RageP) Opt("Fly", "Fly", RageP) Opt("Speed", "Ws", RageP)
Opt("Kill Aura", "KA", RageP)

local DSB = Instance.new("TextButton", Sidebar)
DSB.Size, DSB.Position, DSB.Text = UDim2.new(0, 36, 0, 36), UDim2.new(0.5, -18, 0, 180), "👻"
DSB.BackgroundColor3, DSB.TextColor3, DSB.Modal = Color3.new(0.1, 0.1, 0.1), Color3.new(1, 1, 1), false
Instance.new("UICorner", DSB)
DSB.MouseButton1Click:Connect(function()
    _G.DesyncActive = not _G.DesyncActive
    if _G.DesyncActive then
        local root = GetCenter(LP.Character)
        if root then _G.StoredPos = root.CFrame end
        DSB.TextColor3 = Color3.new(1, 0, 0)
    else
        DSB.TextColor3 = Color3.new(1, 1, 1)
        settings().Network.IncomingReplicationLag = 0
    end
end)

-- // MAIN RUNTIME
R.RenderStepped:Connect(function()
    local char = LP.Character
    local root = char and GetCenter(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local center = Vector2.new(C.ViewportSize.X/2, C.ViewportSize.Y/2)
    
    if _G.DesyncActive and root then
        jerkCounter = (jerkCounter + 1) % 60
        settings().Network.IncomingReplicationLag = (jerkCounter < 50) and 1000 or 0
    end

    if root and hum then
        if _G.Sp then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(50), 0) end
        hum.WalkSpeed = _G.Ws and 100 or 16
        if _G.Fly then root.Velocity = Vector3.new(0, 1.5, 0); root.CFrame = root.CFrame + (hum.MoveDirection * 2.5) end
    end

    local target, minD = nil, _G.F
    for _, p in pairs(P:GetPlayers()) do
        if p ~= LP and p.Character then
            local tR = GetCenter(p.Character)
            if tR and _G.V then
                local pos, vis = C:WorldToViewportPoint(tR.Position)
                if not pE[p] then pE[p] = {h = Instance.new("Highlight", G)} end
                pE[p].h.Enabled, pE[p].h.Adornee = _G.Ch, p.Character
                if vis then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < minD then target, minD = tR, dist end
                    if _G.KA and root and (tR.Position - root.Position).Magnitude < 50 then
                        VIM:SendMouseButtonEvent(0,0,0,true,game,0); task.wait(0.01); VIM:SendMouseButtonEvent(0,0,0,false,game,0)
                    end
                end
            end
        end
    end

    if target and (_G.A or _G.SA) then
        if _G.A then C.CFrame = CFrame.new(C.CFrame.Position, target.Position) end
        if _G.At then VIM:SendMouseButtonEvent(0,0,0,true,game,0); task.wait(0.01); VIM:SendMouseButtonEvent(0,0,0,false,game,0) end
    end
end)
