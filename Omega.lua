-- [[ OMEGA.CC | V27 TRUE SILENT ]]
local P,R,C,LP,U=game:GetService("Players"),game:GetService("RunService"),workspace.CurrentCamera,game:GetService("Players").LocalPlayer,game:GetService("UserInputService")
local _G,pE,tk={A=true,At=true,SA=true,Wb=true,Sm=1,F=170,V=true,Ch=true,Sk=true,Tr=true,Sp=true,Yw=true,Up=false,Off=180,Circ=true,Spd=45},{},0

task.wait(0.5)
local G=Instance.new("ScreenGui",LP.PlayerGui)G.Name="OmegaV27"G.IgnoreGuiInset=true
local D=Instance.new("Frame",G)D.Size,D.Position,D.BackgroundColor3=UDim2.new(0,50,0,260),UDim2.new(0,10,0.5,-130),Color3.new(0,0,0)Instance.new("UICorner",D)Instance.new("UIStroke",D).Color=Color3.new(0,0.6,1)
local Cir=Instance.new("Frame",G)Cir.Size,Cir.Position,Cir.BackgroundTransparency,Cir.Visible=UDim2.new(0,_G.F*2,0,_G.F*2),UDim2.new(0.5,-_G.F,0.5,-_G.F),1,_G.Circ Instance.new("UIStroke",Cir).Color,Instance.new("UICorner",Cir).CornerRadius=Color3.new(1,1,1),UDim.new(1,0)
local function CreateP(y)local p=Instance.new("Frame",G)p.Size,p.Position,p.Visible,p.BackgroundColor3=UDim2.new(0,135,0,165),UDim2.new(0,65,0.5,y),false,Color3.new(0,0,0)Instance.new("UICorner",p)Instance.new("UIListLayout",p).Padding=UDim.new(0,4)return p end
local AimP,VisP,RageP=CreateP(-110),CreateP(-20),CreateP(70)
local function L(col)local l=Instance.new("Frame",G)l.BackgroundColor3,l.BorderSizePixel,l.Visible=col or Color3.new(1,1,1),0,false return l end
local function draw(l,p1,p2)local d=(p1-p2).Magnitude l.Size,l.Position,l.Rotation,l.Visible=UDim2.new(0,d,0,1),UDim2.new(0,(p1.X+p2.X)/2-d/2,0,(p1.Y+p2.Y)/2),math.deg(math.atan2(p2.Y-p1.Y,p2.X-p1.X)),true end
local function Ico(s,pn,y)local b=Instance.new("TextButton",D)b.Size,b.Position,b.Text,b.BackgroundColor3,b.TextColor3=UDim2.new(0,34,0,34),UDim2.new(0.5,-17,0,y),s,Color3.new(0.1,0.1,0.1),Color3.new(1,1,1)Instance.new("UICorner",b)b.MouseButton1Click:Connect(function()AimP.Visible,VisP.Visible,RageP.Visible=false,false,false pn.Visible=not pn.Visible end)end
local function Opt(n,v,p)local b=Instance.new("TextButton",p)b.Size,b.Text,b.BackgroundColor3,b.TextColor3=UDim2.new(0.9,0,0,25),n.." ["..(tostring(_G[v]):sub(1,1)):upper().."]",Color3.new(0.1,0.1,0.1),Color3.new(1,1,1)Instance.new("UICorner",b)b.MouseButton1Click:Connect(function()_G[v]=not _G[v]b.Text=n.." ["..(tostring(_G[v]):sub(1,1)):upper().."]" if v=="Circ" then Cir.Visible=_G[v] end end)end
Ico("🎯",AimP,10)Ico("👁️",VisP,70)Ico("😡",RageP,130)Ico("-",G,190)
Opt("Aimbot","A",AimP)Opt("Silent Aim","SA",AimP)Opt("Wallbang","Wb",AimP)Opt("Circle","Circ",AimP)Opt("Auto","At",AimP)
Opt("Chams","Ch",VisP)Opt("Bones","Sk",VisP)Opt("Line","Tr",VisP)
Opt("Spin","Sp",RageP)Opt("Flip","Up",RageP)

local function Shoot()
    local v=game:GetService("VirtualInputManager")
    if v then v:SendMouseButtonEvent(0,0,0,true,game,0)task.wait(0.01)v:SendMouseButtonEvent(0,0,0,false,game,0)end 
end

local function getB(c)for _,n in{"Head","Torso","HumanoidRootPart"}do local p=c:FindFirstChild(n)if p then 
    if not _G.Wb then local r=Ray.new(C.CFrame.Position,(p.Position-C.CFrame.Position).Unit*500)local h=workspace:FindPartOnRayWithIgnoreList(r,{LP.Character,c})if h and h:IsA("Part") and h.Transparency<0.5 then continue end end
    return p end end end

local sA=0 R.RenderStepped:Connect(function()local t,m,ct=nil,_G.F,Vector2.new(C.ViewportSize.X/2,C.ViewportSize.Y/2)tk=(tk or 0+1)%2 Cir.Position=UDim2.new(0,ct.X-_G.F,0,ct.Y-_G.F)
local ch=LP.Character if ch and ch:FindFirstChild("HumanoidRootPart")then local hr,rj=ch.HumanoidRootPart,ch.HumanoidRootPart:FindFirstChild("RootJoint")if rj then local x=_G.Up and 90 or-90 if _G.Sp then sA=(sA+_G.Spd)%360 rj.C0=CFrame.new(0,0,0)*CFrame.Angles(math.rad(x),0,math.rad(sA+180))elseif _G.Yw then rj.C0=CFrame.new(0,0,0)*CFrame.Angles(math.rad(x),0,math.rad(_G.Off+180))else rj.C0=CFrame.new(0,0,0)*CFrame.Angles(math.rad(-90),3.14,0)end end end
for _,p in pairs(P:GetPlayers())do if p~=LP and p.Character and p.Character:FindFirstChild("Torso")then if not pE[p] then pE[p]={h=Instance.new("Highlight",G),s={ht=L(),la=L(),ra=L(),ll=L(),rl=L()},tr=L(Color3.new(0,0.6,1))}end local e,c=pE[p],p.Character e.h.Enabled,e.h.Adornee,e.h.FillColor=_G.V and _G.Ch,c,Color3.new(0,1,0.5)local ps,vis=C:WorldToViewportPoint(c.Torso.Position)for _,s in pairs(e.s)do s.Visible=false end e.tr.Visible=false if vis and _G.V then if _G.Tr then draw(e.tr,Vector2.new(ct.X,C.ViewportSize.Y),Vector2.new(ps.X,ps.Y))end if _G.Sk then local function g(pt)local o=c:FindFirstChild(pt)if o then local oP,oV=C:WorldToViewportPoint(o.Position)if oV then return Vector2.new(oP.X,oP.Y)end end end local h,t0,la,ra,ll,rl=g("Head"),g("Torso"),g("Left Arm"),g("Right Arm"),g("Left Leg"),g("Right Leg")if h and t0 and la and ra and ll and rl then draw(e.s.ht,h,t0)draw(e.s.la,t0,la)draw(e.s.ra,t0,ra)draw(e.s.ll,t0,ll)draw(e.s.rl,t0,rl)end end if(Vector2.new(ps.X,ps.Y)-ct).Magnitude<m then local b=getB(c)if b then t,m=b,(Vector2.new(ps.X,ps.Y)-ct).Magnitude end end end end end

-- [[ NEW SILENT LOGIC ]]
if t then 
    if _G.SA then
        -- Silent Aim: NO camera movement. Just trigger Autoshoot when hovering near circle.
        if _G.At then Shoot() end
    elseif _G.A then
        -- Normal Aimbot: Smooth camera movement
        C.CFrame=C.CFrame:Lerp(CFrame.lookAt(C.CFrame.Position,t.Position),1/_G.Sm)
        if _G.At then Shoot() end
    end
end end)
