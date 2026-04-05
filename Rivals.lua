local P = game:GetService("Players")
local R = game:GetService("RunService")
local C = workspace.CurrentCamera
local LP = P.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

-- // Settings
local _G = {
    A=true, At=false, SA=true, Wb=true, Sm=1, F=180, V=true, 
    Ch=true, Sk=true, Tr=true, Sp=false, Yw=false, Up=false, 
    Off=180, Circ=true, Spd=60, Ws=false, Jp=false, Fl=false, 
    Pd=true, Bv=800
}
local pE, fC = {}, 0

-- // UI SETUP (Cleaned up for mobile)
local G = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
G.Name = "Omega_Desync_Fixed"
G.IgnoreGuiInset = true

local D = Instance.new("Frame", G)
D.Size, D.Position, D.BackgroundColor3 = UDim2.new(0, 50, 0, 300), UDim2.new(0, 10, 0.5, -150), Color3.new(0, 0, 0)
Instance.new("UICorner", D)

-- // GHOST PILLAR (The Desync Visual)
-- I made this Neon and added a Highlight so you can actually see it!
local Ghost = Instance.new("Part", workspace)
Ghost.Name = "Desync_Ghost"
Ghost.Size = Vector3.new(4, 6, 2) -- Standard character size
Ghost.Anchored = true
Ghost.CanCollide = false
Ghost.Transparency = 0.3
Ghost.Material = Enum.Material.Neon
Ghost.Color = Color3.fromRGB(255, 0, 0) -- Bright Red so it stands out

local GhostHigh = Instance.new("Highlight", Ghost)
GhostHigh.FillColor = Color3.fromRGB(255, 0, 0)
GhostHigh.OutlineColor = Color3.new(1, 1, 1)
GhostHigh.FillTransparency = 0.4

-- // UI BUILDER
local function CreateP(y)
    local p = Instance.new("Frame", G)
    p.Size, p.Position, p.Visible, p.BackgroundColor3 = UDim2.new(0, 140, 0, 230), UDim2.new(0, 65, 0.5, y), false, Color3.new(0, 0, 0)
    Instance.new("UICorner", p)
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 4)
    return p 
end
local AimP, VisP, RageP = CreateP(-140), CreateP(-40), CreateP(50)

local function L(col)
    local l = Instance.new("Frame", G)
    l.BackgroundColor3, l.BorderSizePixel, l.Visible = col or Color3.new(1, 1, 1), 0, false
    return l 
end

local function draw(l, p1, p2)
    local d = (p1 - p2).Magnitude
    l.Size, l.Position, l.Rotation, l.Visible = UDim2.new(0, d, 0, 1), UDim2.new(0, (p1.X + p2.X)/2 - d/2, 0, (p1.Y + p2.Y)/2), math.deg(math.atan2(p2.Y - p1.Y, p2.X - p1.X)), true
end

local function Opt(n, v, p)
    local b = Instance.new("TextButton", p)
    b.Size, b.Text, b.BackgroundColor3, b.TextColor3 = UDim2.new(0.9, 0, 0, 25), n .. " [OFF]", Color3.new(0.1, 0.1, 0.1), Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G[v] = not _G[v]
        b.Text = n .. (_G[v] and " [ON]" or " [OFF]")
    end)
end

local function Ico(s, pn, y)
    local b = Instance.new("TextButton", D)
    b.Size, b.Position, b.Text, b.BackgroundColor3, b.TextColor3 = UDim2.new(0, 34, 0, 34), UDim2.new(0.5, -17, 0, y), s, Color3.new(0.1, 0.1, 0.1), Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() AimP.Visible, VisP.Visible, RageP.Visible = false, false, false; pn.Visible = not pn.Visible end)
end

Ico("🎯", AimP, 10) Ico("👁️", VisP, 70) Ico("😡", RageP, 130)
Opt("Aimbot","A",AimP) Opt("Silent Aim","SA",AimP) Opt("AutoShoot","At",AimP)
Opt("Master ESP","V",VisP) Opt("Chams","Ch",VisP) Opt("Bones","Sk",VisP)
Opt("Fake Lag/Desync","Fl",RageP) Opt("Spinbot","Sp",RageP) Opt("Speed","Ws",RageP)

-- // MAIN LOOP
R.RenderStepped:Connect(function()
    local char = LP.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local hum = char.Humanoid
        
        hum.WalkSpeed = _G.Ws and 60 or 16
        
        -- // IMPROVED DESYNC (FAKE LAG) LOGIC
        if _G.Fl then
            fC = fC + 1
            Ghost.Transparency = 0.2 -- Much more visible
            GhostHigh.Enabled = true
            
            -- Keep the ghost at the STARTING position of the lag spike
            if fC == 1 then 
                Ghost.CFrame = hrp.CFrame 
            end
            
            -- Spike the lag (This makes you "stay" at the ghost for others)
            if fC < 45 then -- Stay for 45 frames (~0.7 seconds)
                settings().Network.IncomingReplicationLag = 1000
            else
                -- Reset and teleport the ghost to your new real position
                settings().Network.IncomingReplicationLag = 0
                fC = 0 
            end
        else
            -- Turn off Desync
            Ghost.Transparency = 1
            GhostHigh.Enabled = false
            settings().Network.IncomingReplicationLag = 0
            fC = 0
        end

        -- Spinbot logic
        local rj = hrp:FindFirstChild("RootJoint")
        if rj and _G.Sp then
            rj.C0 = rj.C0 * CFrame.Angles(0, math.rad(_G.Spd/2), 0)
        end
    end

    -- Target selection for Silent Aim
    local target, minDistance = nil, _G.F
    local center = Vector2.new(C.ViewportSize.X / 2, C.ViewportSize.Y / 2)

    for _, p in pairs(P:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, vis = C:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if vis then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist < minDistance then
                    target = p.Character.HumanoidRootPart
                    minDistance = dist
                end
            end
        end
    end

    if target and _G.SA and _G.At then
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.01)
        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end
end)
