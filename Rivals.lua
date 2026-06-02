I'm-- // SERVICES
local P = game:GetService("Players")
local R = game:GetService("RunService")
local C = workspace.CurrentCamera
local LP = P.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

-- // CONFIGURATION
local _G = {
    A = false,       -- Aimbot
    At = false,      -- Auto Shoot
    SA = false,      -- Silent Aim
    Wb = false,      -- Wallbang
    F = 180,        -- FOV Circle Size
    V = false,       -- Master ESP
    Ch = false,      -- Chams
    Sk = false,      -- Bones (Skeletons)
    Tr = false,      -- Tracer Lines
    Sp = false,     -- Spinbot
    Ws = false,     -- Speed
    Fl = false,     -- Desync / Fake Lag
    Pd = false,      -- Prediction
    Bv = 900        -- Bullet Velocity (Adjust for game)
}

local pE, fC, sA = {}, 0, 0

-- // UI SETUP
local G = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
G.Name = "Omega_V4_Mobile"
G.IgnoreGuiInset = true

local D = Instance.new("Frame", G)
D.Size, D.Position, D.BackgroundColor3 = UDim2.new(0, 55, 0, 300), UDim2.new(0, 15, 0.5, -150), Color3.new(0.05, 0.05, 0.05)
Instance.new("UICorner", D).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", D).Color = Color3.new(0, 0.7, 1)

local Cir = Instance.new("Frame", G)
Cir.Size, Cir.BackgroundTransparency = UDim2.new(0, _G.F*2, 0, _G.F*2), 1
Instance.new("UIStroke", Cir).Color = Color3.new(1, 1, 1)
Instance.new("UICorner", Cir).CornerRadius = UDim.new(1, 0)

-- // THE GHOST (DESYNC VISUAL)
local Ghost = Instance.new("Part", workspace)
Ghost.Name = "Desync_Ghost_Visual"
Ghost.Size, Ghost.Anchored, Ghost.CanCollide = Vector3.new(3.5, 5, 1.5), true, false
Ghost.Material, Ghost.Color, Ghost.Transparency = Enum.Material.Neon, Color3.fromRGB(255, 0, 0), 1

local GhostHigh = Instance.new("Highlight", Ghost)
GhostHigh.FillColor, GhostHigh.OutlineColor = Color3.fromRGB(255, 0, 0), Color3.new(1, 1, 1)
GhostHigh.Enabled = false

-- // HELPER FUNCTIONS
local function CreateMenu(y)
    local p = Instance.new("Frame", G)
    p.Size, p.Position, p.Visible, p.BackgroundColor3 = UDim2.new(0, 150, 0, 240), UDim2.new(0, 75, 0.5, y), false, Color3.new(0, 0, 0)
    Instance.new("UICorner", p)
    local l = Instance.new("UIListLayout", p)
    l.Padding, l.HorizontalAlignment = UDim.new(0, 5), Enum.HorizontalAlignment.Center
    return p 
end

local AimP, VisP, RageP = CreateMenu(-120), CreateMenu(-40), CreateMenu(40)

local function L(col)
    local l = Instance.new("Frame", G)
    l.BackgroundColor3, l.BorderSizePixel, l.Visible = col or Color3.new(1, 1, 1), 0, false
    return l 
end

local function draw(l, p1, p2)
    local d = (p1 - p2).Magnitude
    l.Size, l.Position, l.Rotation, l.Visible = UDim2.new(0, d, 0, 1.5), UDim2.new(0, (p1.X + p2.X)/2 - d/2, 0, (p1.Y + p2.Y)/2), math.deg(math.atan2(p2.Y - p1.Y, p2.X - p1.X)), true
end

local function Opt(n, v, p)
    local b = Instance.new("TextButton", p)
    b.Size, b.Text, b.BackgroundColor3, b.TextColor3 = UDim2.new(0.9, 0, 0, 30), n.." [OFF]", Color3.new(0.1, 0.1, 0.1), Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G[v] = not _G[v]
        b.Text = n .. (_G[v] and " [ON]" or " [OFF]")
        b.TextColor3 = _G[v] and Color3.new(0, 1, 0) or Color3.new(1, 1, 1)
    end)
end

local function Ico(s, pn, y)
    local b = Instance.new("TextButton", D)
    b.Size, b.Position, b.Text, b.BackgroundColor3, b.TextColor3 = UDim2.new(0, 40, 0, 40), UDim2.new(0.5, -20, 0, y), s, Color3.new(0.15, 0.15, 0.15), Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() AimP.Visible, VisP.Visible, RageP.Visible = false, false, false; pn.Visible = not pn.Visible end)
end

Ico("🎯", AimP, 15) Ico("👁️", VisP, 75) Ico("😡", RageP, 135)
Opt("Aimbot", "A", AimP) Opt("Silent Aim", "SA", AimP) Opt("AutoShoot", "At", AimP) Opt("Prediction", "Pd", AimP)
Opt("Master ESP", "V", VisP) Opt("Chams", "Ch", VisP) Opt("Skeleton", "Sk", VisP) Opt("Tracers", "Tr", VisP)
Opt("Desync", "Fl", RageP) Opt("Spinbot", "Sp", RageP) Opt("Speed", "Ws", RageP)

-- // MOBILE PACKET-FLUSH SHOOT
local function ProShoot()
    local oldLag = settings().Network.IncomingReplicationLag
    settings().Network.IncomingReplicationLag = 0 -- Flush lag to hit target
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait(0.03) -- Small delay for mobile networks
    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    if _G.Fl then settings().Network.IncomingReplicationLag = oldLag end
end

-- // GET TARGET
local function GetClosest()
    local target, minD = nil, _G.F
    local center = Vector2.new(C.ViewportSize.X/2, C.ViewportSize.Y/2)
    for _, p in pairs(P:GetPlayers()) do
        if p ~= LP and p.Character then
            local root = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
            if root then
                local pos, vis = C:WorldToViewportPoint(root.Position)
                if vis then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < minD then
                        if not _G.Wb then
                            if #C:GetPartsObscuringTarget({root.Position}, {LP.Character, p.Character}) > 0 then continue end
                        end
                        target, minD = root, dist
                    end
                end
            end
        end
    end
    return target
end

-- // MAIN RUNTIME
R.RenderStepped:Connect(function()
    local center = Vector2.new(C.ViewportSize.X/2, C.ViewportSize.Y/2)
    Cir.Position = UDim2.new(0, center.X - _G.F, 0, center.Y - _G.F)
    
    local char = LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local hum = char:FindFirstChild("Humanoid")
        
        -- Speed & Movement
        if hum then hum.WalkSpeed = _G.Ws and 65 or 16 end
        
        -- DESYNC LOGIC
        if _G.Fl then
            fC = fC + 1
            Ghost.Transparency = 0.3
            GhostHigh.Enabled = true
            if fC == 1 then Ghost.CFrame = hrp.CFrame end
            if fC < 50 then 
                settings().Network.IncomingReplicationLag = 1000 -- Maximum Desync
            else 
                settings().Network.IncomingReplicationLag = 0
                fC = 0 
            end
        else
            Ghost.Transparency = 1
            GhostHigh.Enabled = false
            settings().Network.IncomingReplicationLag = 0
        end

        -- Spinbot
        if _G.Sp then hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(25), 0) end
    end

    -- ESP & Combat Execution
    local target = GetClosest()
    for _, p in pairs(P:GetPlayers()) do
        if p ~= LP and p.Character then
            if not pE[p] then 
                pE[p] = {h = Instance.new("Highlight", G), tr = L(Color3.new(0, 0.7, 1)), sk = L(Color3.new(1,1,1))} 
            end
            local e = pE[p]
            local root = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
            
            if root and _G.V then
                local pos, vis = C:WorldToViewportPoint(root.Position)
                e.h.Enabled = _G.Ch
                e.h.Adornee = p.Character
                
                if vis then
                    if _G.Tr then draw(e.tr, Vector2.new(center.X, C.ViewportSize.Y), Vector2.new(pos.X, pos.Y)) else e.tr.Visible = false end
                    if _G.Sk then
                        local head = p.Character:FindFirstChild("Head")
                        if head then
                            local hP = C:WorldToViewportPoint(head.Position)
                            draw(e.sk, Vector2.new(hP.X, hP.Y), Vector2.new(pos.X, pos.Y))
                        end
                    else e.sk.Visible = false end
                else
                    e.tr.Visible, e.sk.Visible = false, false
                end
            else
                e.h.Enabled, e.tr.Visible, e.sk.Visible = false, false, false
            end
        end
    end

    if target then
        local aimPos = target.Position
        if _G.Pd then aimPos = aimPos + (target.AssemblyLinearVelocity * ((C.CFrame.Position - aimPos).Magnitude / _G.Bv)) end

        if _G.SA then
            if _G.At then ProShoot() end
        elseif _G.A then
            C.CFrame = CFrame.new(C.CFrame.Position, aimPos)
            if _G.At then ProShoot() end
        end
    end
end)
