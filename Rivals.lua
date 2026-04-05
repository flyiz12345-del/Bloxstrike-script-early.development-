local P = game:GetService("Players")
local R = game:GetService("RunService")
local C = workspace.CurrentCamera
local LP = P.LocalPlayer
local U = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

-- // Settings
local _G = {
    A=true, At=false, SA=true, Wb=true, Sm=1, F=180, V=true, 
    Ch=true, Sk=true, Tr=true, Sp=false, Yw=false, Up=false, 
    Off=180, Circ=true, Spd=60, Ws=false, Jp=false, Fl=false, 
    Pd=true, Bv=800
}
local pE, tk, fC, sA = {}, 0, 0, 0

-- // UI SETUP
local G = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
G.Name = "OmegaV3_Fixed"
G.IgnoreGuiInset = true

local D = Instance.new("Frame", G)
D.Size, D.Position, D.BackgroundColor3 = UDim2.new(0, 50, 0, 300), UDim2.new(0, 10, 0.5, -150), Color3.new(0, 0, 0)
Instance.new("UICorner", D)
local St = Instance.new("UIStroke", D)
St.Color, St.Thickness = Color3.new(0, 0.6, 1), 1.8

local Cir = Instance.new("Frame", G)
Cir.Size, Cir.Position, Cir.BackgroundTransparency = UDim2.new(0, _G.F*2, 0, _G.F*2), UDim2.new(0.5, -_G.F, 0.5, -_G.F), 1
Cir.Visible = _G.Circ
Instance.new("UIStroke", Cir).Color = Color3.new(1, 1, 1)
Instance.new("UICorner", Cir).CornerRadius = UDim.new(1, 0)

-- // GHOST PILLAR (Fake Lag Visual)
local Ghost = Instance.new("Part", workspace)
Ghost.Size, Ghost.Anchored, Ghost.CanCollide, Ghost.Transparency = Vector3.new(4,6,4), true, false, 1
Ghost.Material, Ghost.Color = Enum.Material.ForceField, Color3.fromRGB(0, 160, 255)

-- // UI HELPER FUNCTIONS
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

local function Ico(s, pn, y)
    local b = Instance.new("TextButton", D)
    b.Size, b.Position, b.Text, b.BackgroundColor3, b.TextColor3 = UDim2.new(0, 34, 0, 34), UDim2.new(0.5, -17, 0, y), s, Color3.new(0.1, 0.1, 0.1), Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() AimP.Visible, VisP.Visible, RageP.Visible = false, false, false; pn.Visible = not pn.Visible end)
end

local function Opt(n, v, p)
    local b = Instance.new("TextButton", p)
    b.Size, b.Text, b.BackgroundColor3, b.TextColor3 = UDim2.new(0.9, 0, 0, 25), n .. " [OFF]", Color3.new(0.1, 0.1, 0.1), Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function()
        _G[v] = not _G[v]
        b.Text = n .. (_G[v] and " [ON]" or " [OFF]")
        if v == "Circ" then Cir.Visible = _G[v] end
    end)
end

Ico("🎯", AimP, 10) Ico("👁️", VisP, 70) Ico("😡", RageP, 130)

Opt("Aimbot","A",AimP) Opt("Predict","Pd",AimP) Opt("Silent Aim","SA",AimP) 
Opt("Wallbang","Wb",AimP) Opt("AutoShoot","At",AimP) Opt("Circle","Circ",AimP)
Opt("Master ESP","V",VisP) Opt("Chams","Ch",VisP) Opt("Bones","Sk",VisP) Opt("Line","Tr",VisP)
Opt("Fake Lag","Fl",RageP) Opt("Spinbot","Sp",RageP) Opt("Speed","Ws",RageP) Opt("Jump","Jp",RageP) Opt("Flip","Up",RageP)

-- // COMBAT FUNCTIONS
local function Shoot()
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait(0.01)
    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

local function getB(c)
    -- Fixed part detection for R6 and R15
    local targets = {"Head", "HumanoidRootPart", "UpperTorso", "Torso"}
    for _, name in pairs(targets) do
        local p = c:FindFirstChild(name)
        if p then
            if not _G.Wb then
                local parts = C:GetPartsObscuringTarget({p.Position}, {LP.Character, c})
                if #parts > 0 then continue end
            end
            return p
        end
    end
end

-- // MAIN LOOP
R.RenderStepped:Connect(function()
    local target, minDistance = nil, _G.F
    local center = Vector2.new(C.ViewportSize.X / 2, C.ViewportSize.Y / 2)
    Cir.Position = UDim2.new(0, center.X - _G.F, 0, center.Y - _G.F)

    local char = LP.Character
    if char and char:FindFirstChild("Humanoid") then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char.Humanoid
        if hrp then
            hum.WalkSpeed = _G.Ws and 60 or 16
            hum.JumpPower = _G.Jp and 100 or 50
            
            -- Fake Lag Logic
            if _G.Fl then
                fC = fC + 1
                Ghost.Transparency = 0.5
                if fC == 1 then Ghost.CFrame = hrp.CFrame end
                if fC > 30 then fC = 0 end
                settings().Network.IncomingReplicationLag = 1000
            else
                Ghost.Transparency = 1
                settings().Network.IncomingReplicationLag = 0
            end

            -- Universal Rig Spin/Flip Fix
            local rj = hrp:FindFirstChild("RootJoint")
            if rj and (_G.Sp or _G.Up) then
                local isR15 = (hum.RigType == Enum.HumanoidRigType.R15)
                local x = isR15 and (_G.Up and 180 or 0) or (_G.Up and 90 or -90)
                local y = _G.Sp and (tick() * _G.Spd * 5) % 360 or 0
                rj.C0 = CFrame.new() * CFrame.Angles(math.rad(x), math.rad(y), 0)
            end
        end
    end

    -- ESP & Target Selection
    for _, p in pairs(P:GetPlayers()) do
        if p ~= LP and p.Character then
            local c = p.Character
            if not pE[p] then
                pE[p] = {
                    h = Instance.new("Highlight", G),
                    s = {ht=L(), la=L(), ra=L(), ll=L(), rl=L()},
                    tr = L(Color3.new(0, 0.6, 1))
                }
            end

            local e = pE[p]
            local torso = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")
            
            if torso then
                local pos, onScreen = C:WorldToViewportPoint(torso.Position)
                e.h.Enabled = _G.V and _G.Ch
                e.h.Adornee = c
                
                if onScreen and _G.V then
                    if _G.Tr then draw(e.tr, Vector2.new(center.X, C.ViewportSize.Y), Vector2.new(pos.X, pos.Y)) else e.tr.Visible = false end
                    
                    -- Bone ESP Logic (Simplified to prevent lag)
                    if _G.Sk then
                        local head = c:FindFirstChild("Head")
                        if head then
                            local hP = C:WorldToViewportPoint(head.Position)
                            draw(e.s.ht, Vector2.new(hP.X, hP.Y), Vector2.new(pos.X, pos.Y))
                        end
                    else
                        for _, v in pairs(e.s) do v.Visible = false end
                    end

                    -- Target Check
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < minDistance then
                        local b = getB(c)
                        if b then target, minDistance = b, dist end
                    end
                else
                    e.h.Enabled = false
                    e.tr.Visible = false
                    for _, v in pairs(e.s) do v.Visible = false end
                end
            end
        end
    end

    -- Aimbot Execution
    if target then
        local aimPos = target.Position
        if _G.Pd then
            local travelTime = (C.CFrame.Position - aimPos).Magnitude / _G.Bv
            aimPos = aimPos + (target.AssemblyLinearVelocity * travelTime)
        end

        if _G.SA then
            if _G.At then Shoot() end
        elseif _G.A then
            C.CFrame = CFrame.new(C.CFrame.Position, aimPos)
            if _G.At then Shoot() end
        end
    end
end)
