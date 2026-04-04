local P,R,C,LP,U=game:GetService("Players"),game:GetService("RunService"),workspace.CurrentCamera,game:GetService("Players").LocalPlayer,game:GetService("UserInputService")
local _G,pE,tk={A=true,At=true,Ds=true,Sm=1,F=180,Wb=true,V=true,Ch=true,Sk=true,Tr=true,Tm=true,Sp=false,Yw=true,Up=false,Off=180,Circ=true},{},0

task.wait(0.5)

-- // UI CONSTRUCTION (DOCK)
local G=Instance.new("ScreenGui",LP.PlayerGui)G.Name="OmegaV18"G.IgnoreGuiInset=true
local Dock=Instance.new("Frame",G)Dock.Size,Dock.Position,Dock.BackgroundColor3=UDim2.new(0,55,0,255),UDim2.new(0,10,0.5,-125),Color3.fromRGB(5,5,10)
Instance.new("UICorner",Dock).CornerRadius=UDim.new(0,12)
local St=Instance.new("UIStroke",Dock)St.Color,St.Thickness=Color3.fromRGB(0,160,255),1.8

-- // FOV CIRCLE (Locked to Center)
local Cir=Instance.new("Frame",G)Cir.Size,Cir.Position=UDim2.new(0,_G.F*2,0,_G.F*2),UDim2.new(0.5,-_G.F,0.5,-_G.F)
Cir.BackgroundColor3,Cir.BackgroundTransparency,Cir.Visible=Color3.new(1,1,1),1,_G.Circ
local CS=Instance.new("UIStroke",Cir)CS.Color,CS.Thickness,CS.Transparency=Color3.new(1,1,1),1.5,0.5
Instance.new("UICorner",Cir).CornerRadius=UDim.new(1,0)

-- // TAB SYSTEM
local function CreatePanel(y)
    local p=Instance.new("Frame",G)p.Size,p.Position,p.Visible=UDim2.new(0,150,0,140),UDim2.new(0,75,0.5,y),false
    p.BackgroundColor3=Color3.fromRGB(10,10,15)Instance.new("UICorner",p)
    Instance.new("UIStroke",p).Color=Color3.fromRGB(0,160,255)
    Instance.new("UIListLayout",p).Padding,p.UIListLayout.HorizontalAlignment=UDim.new(0,6),1
    return p
end
local AimP,VisP,RageP=CreatePanel(-120),CreatePanel(-30),CreatePanel(60)

local function L(col)local l=Instance.new("Frame",G)l.BackgroundColor3,l.BorderSizePixel,l.Visible,l.ZIndex=col or Color3.new(1,1,1),0,false,99 return l end
local function draw(l,p1,p2)local d=(p1-p2).Magnitude l.Size,l.Position,l.Rotation,l.Visible=UDim2.new(0,d,0,1),UDim2.new(0,(p1.X+p2.X)/2-d/2,0,(p1.Y+p2.Y)/2),math.deg(math.atan2(p2.Y-p1.Y,p2.X-p1.X)),true end

local function Ico(sym,panel,y)
    local b=Instance.new("TextButton",Dock)b.Size,b.Position=UDim2.new(0,38,0,38),UDim2.new(0.5,-19,0,y)
    b.Text,b.BackgroundColor3,b.TextColor3=sym,Color3.fromRGB(25,25,30),Color3.new(1,1,1)
    Instance.new("UICorner",b)
    b.MouseButton1Click:Connect(function() AimP.Visible,VisP.Visible,RageP.Visible=false,false,false panel.Visible=not panel.Visible end)
end

local function Opt(n,v,p)
    local b=Instance.new("TextButton",p)b.Size,b.Text=UDim2.new(0.9,0,0,28),n.." ["..(tostring(_G[v]):sub(1,1)):upper().."]"
    b.BackgroundColor3,b.TextColor3,b.Font=Color3.fromRGB(35,35,40),Color3.new(1,1,1),3
    Instance.new("UICorner",b)
    b.MouseButton1Click:Connect(function() _G[v]=not _G[v] b.Text=n.." ["..(tostring(_G[v]):sub(1,1)):upper().."]" if v=="Circ" then Cir.Visible=_G[v] end end)
end

Ico("🎯",AimP,35)Ico("👁️",VisP,95)Ico("😡",RageP,155)
Opt("Aimbot","A",AimP)Opt("FOV Circle","Circ",AimP)Opt("Autoshoot","At",AimP)
Opt("Chams","Ch",VisP)Opt("Skeletons","Sk",VisP)Opt("Tracers","Tr",VisP)
Opt("Desync","Ds",RageP)Opt("Anti-Aim","Yw",RageP)Opt("UpsideDown","Up",RageP)

-- // VIRTUAL SHOOT ENGINE (Anti-PC Flip)
local function VirtualShoot()
    -- Use VirtualInputManager if executor supports it, else fall back to a safer click
    local vim = game:GetService("VirtualInputManager")
    if vim then
        vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.05)
        vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    else
        -- Safest fall back for "shit" executors
        keypress(0x01) task.wait(0.05) keyrelease(0x01)
    end
end

-- // TARGETING ENGINE
local function getB(c)for _,n in{"Head","Torso"}do local p=c:FindFirstChild(n)if p then local r=Ray.new(C.CFrame.Position,(p.Position-C.CFrame.Position).Unit*500)local h=workspace:FindPartOnRayWithIgnoreList(r,{LP.Character,c})if not h or(_G.Wb and(h.Transparency>0.5 or h.Material==Enum.Material.Wood))then return p end end end end

R.RenderStepped:Connect(function()
    local t,m,ct=nil,_G.F,Vector2.new(C.ViewportSize.X/2,C.ViewportSize.Y/2)tk=(tk or 0+1)%2
    Cir.Position=UDim2.new(0,ct.X-_G.F,0,ct.Y-_G.F)
    
    -- Anti-Aim
    local ch=LP.Character if ch and ch:FindFirstChild("HumanoidRootPart")then local hr,rj=ch.HumanoidRootPart,ch.HumanoidRootPart:FindFirstChild("RootJoint")if _G.Ds and tk==0 then hr.CFrame=hr.CFrame*CFrame.new(0,0,0.06)end if rj then local x=_G.Up and 90 or-90 if _G.Yw then rj.C0=CFrame.new(0,0,0)*CFrame.Angles(math.rad(x),0,math.rad(_G.Off+180))else rj.C0=CFrame.new(0,0,0)*CFrame.Angles(math.rad(-90),3.14,0)end end end

    for _,p in pairs(P:GetPlayers()) do
        if p~=LP and p.Character and p.Character:
