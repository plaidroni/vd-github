include("shared.lua")
VDMenu = {}
VDMenu.Listings = {}
VDMenu.Text = {}
VDMenu.Frame = {}
VDInventory = {}

-- copy over from server, too lazy to make dynamic updating. will add in future
VDInventory.Items = {"weapon_pistol", "weapon_357", "ls_sniper"} -- all prices, models, and items must be same index of corresponding item
VDInventory.Models = {"models/weapons/w_pist_usp.mdl", "models/weapons/w_pist_usp.mdl", "models/weapons/w_snip_sg550.mdl"} -- all prices, models, and items must be same index of corresponding item
VDInventory.Prices = {2500,500,7000} -- all prices, models, and items must be same index of corresponding item

VDInventory.numberOfItems = #VDInventory.Items
surface.CreateFont("LividityTEXT", {
    font = "Roboto",
    size = 23,
    weight = 500
})

surface.CreateFont("LividityTitle", {
    font = "Roboto",
    size = 80,
    weight = 500
})
 
surface.CreateFont("LividityBuy", {
    font = "Roboto",
    size = 50,
    weight = 500
})



LNBuyText = "text"
local menuOpen = false
local modelSet = false
local clickedItem = 0

 -- Made by plaidroni & Tobias

local function reRender()
        local mn, mx = VDMenu.Panel.Icon.Entity:GetRenderBounds()
        local size = mx.x * 2
        size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
        size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
        size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

        VDMenu.Panel.Icon:SetFOV( 45 )
        VDMenu.Panel.Icon:SetCamPos( Vector( size, size, size ) )
        VDMenu.Panel.Icon:SetLookAt( ( mn + mx ) * 0.5 )
    end
--initialization of the menu itself

function VDMenu.showMenu( )
-------------------------FRAME---------------------------------------
    --effects based on clicking on VDealer
    x,y,z = LocalPlayer():GetPos():Unpack()
    ParticleEffect( "generic_smoke", Vector(x,y,z) , Angle( 0, 0, 0 ) )
    ParticleEffect( "generic_smoke", Vector(x,y,z) , Angle( 0, 0, 0 ) )
    menuOpen = true

    VDMenu.Frame = vgui.Create("DFrame")
    VDMenu.Frame:SetPos(0,0)
    VDMenu.Frame:SetSize(ScrW(), ScrH())
    VDMenu.Frame:ShowCloseButton(false)
    VDMenu.Frame:SetDraggable(false)
    VDMenu.Frame:SetTitle("")
    VDMenu.Frame:MakePopup()
    countdown = 100
    VDMenu.Frame.Paint = function()
        VDMenu.blur( VDMenu.Frame, 10, 20, 255 )
    --grabs the number of items from the soon to be sql table
    
        surface.SetDrawColor( 50, 50, 50, 150 )
        surface.DrawRect( 0, 0, VDMenu.Frame:GetWide(), VDMenu.Frame:GetTall() )
        
        surface.SetDrawColor( 200, 200, 200, 255 )
        if VDInventory.numberOfItems > 1 then
            
            countdown = Lerp(FrameTime(), countdown, 0 )
            print(countdown)
            for i = 1, VDInventory.numberOfItems+1 do
                local x = ScrW()/2 + math.sin( math.rad( 360/VDInventory.numberOfItems * i +countdown ) + math.rad( 360/(VDInventory.numberOfItems)/2 ) ) * 100
                local y = ScrH()/2 - math.cos( math.rad( 360/VDInventory.numberOfItems * i +countdown) + math.rad( 360/(VDInventory.numberOfItems)/2 ) ) * 100
                local x2 = ScrW()/2 + math.sin( math.rad( 360/VDInventory.numberOfItems * i + countdown/2) + math.rad( 360/(VDInventory.numberOfItems)/2 ) ) * 300
                local y2 = ScrH()/2 - math.cos( math.rad( 360/VDInventory.numberOfItems * i + countdown/2) + math.rad( 360/(VDInventory.numberOfItems)/2 ) ) * 300
                       
                local ang1 = (i-1)*(360/VDInventory.numberOfItems) + (360/VDInventory.numberOfItems/2)
                local ang2 = (i-0)*(360/VDInventory.numberOfItems) + (360/VDInventory.numberOfItems/2)
                surface.SetDrawColor( 255, 255, 255, 255)
                surface.DrawLine(x,y,x2,y2)
                
            end
        end
    end
    timer.Simple(5,function()
            VDMenu.Frame:Close()
        end)
    for i = 1, VDInventory.numberOfItems do
        local Tool = vgui.Create("DButton", VDMenu.Frame)
        
        local x = ScrW()/2 + math.sin( math.rad( 360/VDInventory.numberOfItems * i + countdown) ) * 250 - 50
        local y = ScrH()/2 - math.cos( math.rad( 360/VDInventory.numberOfItems * i + countdown) ) * 250 - 15

        Tool:SetSize( 100, 30 )
        Tool:SetPos( x,y )
        Tool:SetTextColor(Color(255,255,255,255))
        Tool:SetFont("ToolsTextFont")
        Tool.DoClick = function()
        end
        Tool.Paint = function()
                surface.SetDrawColor( 68, 87, 101, 0 )
        end
    end
end
--[[
        --Setting the sizing to work with all resolutions, initialization
    VDMenu.Frame = vgui.Create("DFrame")
        VDMenu.Frame:SetSize( ScrW() / 1.5, ScrH() / 1.3)
        VDMenu.Frame:Center()
        VDMenu.Frame:SetTitle("")
        VDMenu.Frame:ShowCloseButton(true)
        VDMenu.Frame:SetDraggable(false)
        VDMenu.Frame:MakePopup()

        --honestly no fuckign clue but i think this sets tabs
        LNFx, LNFy = VDMenu.Frame:GetPos()
        VDMenu.Sheet = vgui.Create( "DPropertySheet", VDMenu.Frame)
        VDMenu.Sheet:Dock( FILL )

        --this adds a little boxy guy
    VDMenu.Text.Title = vgui.Create("DLabel", VDMenu.Frame)
        VDMenu.Text.Title:SetSize(VDMenu.Frame:GetWide() * .4, VDMenu.Frame:GetTall() * 0.234375)
        VDMenu.Text.Title:SetPos(VDMenu.Frame:GetWide() * 0.2, VDMenu.Frame:GetTall() * 0.7)
        VDMenu.Text.Title:SetFont("LividityTitle")
        VDMenu.Text.Title:SetText("")
        VDMenu.Text.Title:SetTextColor(Color(255,255,255,255))
        VDMenu.Text.Title:SetWrap(true)
        VDMenu.Text.Title:SetContentAlignment(8)


-------------------------ITEM LIST---------------------------------------

    --allows you to have the thing scroll
    VDMenu.Frame.Scroll = vgui.Create( "DScrollPanel", VDMenu.Frame )
        VDMenu.Frame.Scroll:SetPos(VDMenu.Frame:GetWide() * 0.5078125, VDMenu.Frame:GetWide() * 0.060)
        VDMenu.Frame.Scroll:SetSize(VDMenu.Frame:GetWide() * 0.46875, VDMenu.Frame:GetTall() * 0.8792)

    --this is setting up for icon creation
    VDMenu.Frame.List = vgui.Create( "DIconLayout", VDMenu.Frame.Scroll )
        VDMenu.Frame.List:SetSpaceY( VDMenu.Frame:GetWide() * 0.00390625 ) -- Sets the space in between the panels on the Y Axis by 5
        VDMenu.Frame.List:SetSpaceX( VDMenu.Frame:GetWide() * 0.00390625 ) -- Sets the space in between the panels on the X Axis by 5
        VDMenu.Frame.List:SetPos(VDMenu.Frame:GetWide() * 0.0390625, 0 )
        VDMenu.Frame.List:SetSize(VDMenu.Frame:GetWide() * 0.46875, VDMenu.Frame:GetWide() * 0.46875)
   
    --initialzation of button
    VDMenu.BuyButtonFrame = vgui.Create("DFrame")
        VDMenu.BuyButtonFrame:SetSize( ScrW() / 1.5, ScrH() / 15)
        VDMenu.BuyButtonFrame:SetPos( VDMenu.Frame:GetPos(), ScrH() * -1510/-1920)
        VDMenu.BuyButtonFrame:SetTitle("")
        VDMenu.BuyButtonFrame:ShowCloseButton(false)
        VDMenu.BuyButtonFrame:SetDraggable(false)
        VDMenu.BuyButtonFrame:MakePopup()

    VDMenu.BuyButton = vgui.Create( "DButton", VDMenu.BuyButtonFrame )
        VDMenu.BuyButton:SetText( "Sample Text UwU" )
        VDMenu.BuyButton:SetPos( 0,0 )
        VDMenu.BuyButton:SetSize( ScrW() / 1.5, ScrH() / 5 )
        LNBx, LNBy = VDMenu.BuyButton:GetSize()
        VDMenu.BuyButton.DoClick = function()
            net.Start("vectordealer_BuyWeapon")
            net.WriteInt(clickedItem, 24) --  [ERROR] lua/entities/vector dealer/cl_init.lua:106: bad argument #2 to 'WriteInt' (number expected, got no value)
            net.SendToServer()
        end
        VDMenu.Frame:MoveToFront()

    --making sure this shit ACTUALLY closes
    VDMenu.Frame.OnClose = function() 
        menuOpen = false
        VDMenu.BuyButtonFrame:Close()
    end

--dude what the fuck does any of this shit mean maybe when you click on the item?
    local function Inspect(k)
        modelSet=true
        VDMenu.Panel.Icon:SetModel(VDInventory.Models[k])

        reRender()
        VDMenu.BuyButtonFrame:MoveTo(LNFx, ScrH() * -1510/-1920,.5,0,-1)
        timer.Simple(.7,function()
            LNBuyText = "Buy for $"..VDInventory.Prices[k].."?"
            VDMenu.BuyButton:SetText("Buy for $"..VDInventory.Prices[k].."?")
            VDMenu.BuyButtonFrame:MoveTo(LNFx,ScrH() * -1690/-1920,.5,0,-1)
        end)
    end
    --yeah this shit is when you clikc on the item fuck man



    --looping through and adding the items
    for k,v in pairs(VDInventory.Items) do 

            icon = vgui.Create("SpawnIcon",VDMenu.Frame.List)
            icon:SetModel(VDInventory.Models[k])
            icon:SetSize( VDMenu.Frame:GetWide() * 0.06,  VDMenu.Frame:GetWide() * 0.06 )
            --VDMenu.Frame=VDMenu.Frame.List:Add(icon)
           
            --on click
            icon.DoClick = function(icon)
                clickedItem = k
                Inspect(k)
            end

            --popup menu on rightclick 
            icon.DoRightClick = function(icon)
                VDMenu.DropDown = DermaMenu()
                VDMenu.DropDown:MakePopup()
                VDMenu.DropDown:SetFontInternal("LividityTEXT")
                function VDMenu.DropDown:Paint(w, h)
                    draw.RoundedBoxEx(3, 0, 0, w, h, Color(255,92,0,125), true, true, true, true)
                end 
                VDMenu.DropDown:SetPos(gui.MousePos())
                VDMenu.DropDown:AddOption( "Inspect" , function() 
                    clickedItem = k
                    Inspect(k)
                end)
                end
        end


-------------------------D MODEL PANEL---------------------------------------
    
    --this is to make that little fucker pretty (づ｡◕‿‿◕｡)づ

    --panel creation for inventory
    VDMenu.Panel = vgui.Create( "DPanel" , VDMenu.Frame)
        VDMenu.Panel:SetPos( VDMenu.Frame:GetWide()*0.007, VDMenu.Frame:GetWide()*0.007 )
        VDMenu.Panel:SetSize( VDMenu.Frame:GetWide()* 0.546, VDMenu.Frame:GetWide()* 0.546 )
        VDMenu.Panel:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
        VDMenu.Sheet:AddSheet("",VDMenu.Panel,false,false,"Inventory")

    --model for the panel
    VDMenu.Panel.Icon = vgui.Create( "DModelPanel", VDMenu.Panel )
        VDMenu.Panel.Icon:SetSize( VDMenu.Frame:GetWide()* 0.546, VDMenu.Frame:GetWide()* 0.546 )
        VDMenu.Panel.Icon:SetModel( "models/props_c17/statue_horse.mdl" )
        reRender()

    --other panel creation for cosmetics
    VDMenu.Panel2 = vgui.Create( "DPanel" , VDMenu.Frame)
        VDMenu.Panel2:SetPos( VDMenu.Frame:GetWide()*0.007, VDMenu.Frame:GetWide()*0.007 )
        VDMenu.Panel2:SetSize( VDMenu.Frame:GetWide()* 0.546, VDMenu.Frame:GetWide()* 0.546 )
        VDMenu.Panel2:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
        VDMenu.Sheet:AddSheet("",VDMenu.Panel2,false,false,"Cosmetics")

    
    

----------------------Painting the Menu----------------------------------
       

--this is to make that little fucker pretty (づ｡◕‿‿◕｡)づ

--paint the main bitch
function VDMenu.Frame:Paint(w, h)
    draw.RoundedBoxEx(3, 0, 0, w, h, Color(150,0,0,225), true, true, true, true)
    VDMenu.blur( VDMenu.Frame, 10, 20, 255 )
end

--button frame pretty (づ｡◕‿‿◕｡)づ
function VDMenu.BuyButtonFrame:Paint(w, h)
    draw.RoundedBoxEx(3, 0, 0, w, h, Color(0,200,0,225), true, true, true, true)
    VDMenu.blur( VDMenu.BuyButtonFrame, 15, 20, 255 )
end

--buy button pretty (づ｡◕‿‿◕｡)づ
function VDMenu.BuyButton:Paint(w, h)
    draw.RoundedBoxEx(3, 0, 0, w, h, Color(0,200,0,0), true, true, true, true)
    VDMenu.blur( VDMenu.BuyButtonFrame, 15, 20, 255 )
    surface.SetFont("LividityBuy")
    draw.DrawText( LNBuyText, "LividityBuy", LNBx / 2 - surface.GetTextSize(LNBuyText) / 2, LNBy / 2 - 100, Color( 255, 255, 255, 255 ))
end
end
]]



-------------------------Blur--------------------------
    -- Panel based blur function by Chessnut from NutScript
    --make that bitch pretty (づ｡◕‿‿◕｡)づ
local blur = Material( "pp/blurscreen" )
function VDMenu.blur( panel, layers, density, alpha )
    -- Its a scientifically proven fact that blur improves a script
    local x, y = panel:LocalToScreen(0, 0)

    surface.SetDrawColor( 72,72,72, alpha )
    surface.SetMaterial( blur )

    for i = 1, 3 do
        blur:SetFloat( "$blur", ( i / layers ) * density )
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
    end
end





--open the menu
function VDMenu.KeyPress( ply , bind, pressed)
    if (bind == "gm_showspare2" && (not menuOpen)) then
        VDMenu.showMenu( )
    end
end
net.Receive("vectordealer_UsePanel", function( len )
    VDMenu.showMenu()
end)
hook.Add("PlayerBindPress", "VDMenu.KeyPress", VDMenu.KeyPress)


   
net.Receive("vectordealer_AlertPlayers", function()
   
end)
   
function ENT:Draw()
--made by me tobias too mother fucker most of this dogshit code is mine ):<
--MADE BY plaidroni (http://steamcommunity.com/id/plaidroni/)
    self:DrawModel()
   
    --------------------------------
 
end
