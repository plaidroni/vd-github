include("shared.lua")
LNMenu = {}
LNMenu.Listings = {}
LNMenu.Text = {}
LNMenu.Frame = {}
LNInventory = {}

-- copy over from server, too lazy to make dynamic updating. will add in future
LNInventory.Items = {"weapon_pistol", "weapon_357", "ls_sniper"} -- all prices, models, and items must be same index of corresponding item
LNInventory.Models = {"models/weapons/w_pist_usp.mdl", "models/weapons/w_pist_usp.mdl", "models/weapons/w_snip_sg550.mdl"} -- all prices, models, and items must be same index of corresponding item
LNInventory.Prices = {2500,500,7000} -- all prices, models, and items must be same index of corresponding item


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
 -- Lividity TTT Menu system
 -- Made by plaidroni & Tobias

local function reRender()
        local mn, mx = LNMenu.Panel.Icon.Entity:GetRenderBounds()
        local size = mx.x * 2
        size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
        size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
        size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

        LNMenu.Panel.Icon:SetFOV( 45 )
        LNMenu.Panel.Icon:SetCamPos( Vector( size, size, size ) )
        LNMenu.Panel.Icon:SetLookAt( ( mn + mx ) * 0.5 )
    end

function LNMenu.showMenu( )
-------------------------FRAME---------------------------------------
        x,y,z = LocalPlayer():GetPos():Unpack()
        ParticleEffect( "generic_smoke", Vector(x,y,z) , Angle( 0, 0, 0 ) )
        ParticleEffect( "generic_smoke", Vector(x,y,z) , Angle( 0, 0, 0 ) )
    menuOpen = true

    LNMenu.Frame = vgui.Create("DFrame")
        LNMenu.Frame:SetSize( ScrW() / 1.5, ScrH() / 1.3)
        LNMenu.Frame:Center()
        LNMenu.Frame:SetTitle("")
        LNMenu.Frame:ShowCloseButton(true)
        LNMenu.Frame:SetDraggable(false)
        LNMenu.Frame:MakePopup()

        LNFx, LNFy = LNMenu.Frame:GetPos()
    LNMenu.Sheet = vgui.Create( "DPropertySheet", LNMenu.Frame)
        LNMenu.Sheet:Dock( FILL )

    LNMenu.Text.Title = vgui.Create("DLabel", LNMenu.Frame)
        LNMenu.Text.Title:SetSize(LNMenu.Frame:GetWide() * .4, LNMenu.Frame:GetTall() * 0.234375)
        LNMenu.Text.Title:SetPos(LNMenu.Frame:GetWide() * 0.2, LNMenu.Frame:GetTall() * 0.7)
        LNMenu.Text.Title:SetFont("LividityTitle")
        LNMenu.Text.Title:SetText("")
        LNMenu.Text.Title:SetTextColor(Color(255,255,255,255))
        LNMenu.Text.Title:SetWrap(true)
        LNMenu.Text.Title:SetContentAlignment(8)
-------------------------ITEM LIST---------------------------------------
    LNMenu.Frame.Scroll = vgui.Create( "DScrollPanel", LNMenu.Frame )
        LNMenu.Frame.Scroll:SetPos(LNMenu.Frame:GetWide() * 0.5078125, LNMenu.Frame:GetWide() * 0.060)
        LNMenu.Frame.Scroll:SetSize(LNMenu.Frame:GetWide() * 0.46875, LNMenu.Frame:GetTall() * 0.8792)

    LNMenu.Frame.List = vgui.Create( "DIconLayout", LNMenu.Frame.Scroll )
        LNMenu.Frame.List:SetSpaceY( LNMenu.Frame:GetWide() * 0.00390625 ) -- Sets the space in between the panels on the Y Axis by 5
        LNMenu.Frame.List:SetSpaceX( LNMenu.Frame:GetWide() * 0.00390625 ) -- Sets the space in between the panels on the X Axis by 5
        LNMenu.Frame.List:SetPos(LNMenu.Frame:GetWide() * 0.0390625, 0 )
        LNMenu.Frame.List:SetSize(LNMenu.Frame:GetWide() * 0.46875, LNMenu.Frame:GetWide() * 0.46875)
    -- Sliding Buy button Frame

    LNMenu.BuyButtonFrame = vgui.Create("DFrame")
        LNMenu.BuyButtonFrame:SetSize( ScrW() / 1.5, ScrH() / 15)
        LNMenu.BuyButtonFrame:SetPos( LNMenu.Frame:GetPos(), ScrH() * -1510/-1920)
        LNMenu.BuyButtonFrame:SetTitle("")
        LNMenu.BuyButtonFrame:ShowCloseButton(false)
        LNMenu.BuyButtonFrame:SetDraggable(false)
        LNMenu.BuyButtonFrame:MakePopup()

    LNMenu.BuyButton = vgui.Create( "DButton", LNMenu.BuyButtonFrame )
        LNMenu.BuyButton:SetText( "Sample Text UwU" )
        LNMenu.BuyButton:SetPos( 0,0 )
        LNMenu.BuyButton:SetSize( ScrW() / 1.5, ScrH() / 5 )
        LNBx, LNBy = LNMenu.BuyButton:GetSize()
        LNMenu.BuyButton.DoClick = function()
            net.Start("vectordealer_BuyWeapon")
            net.WriteInt(clickedItem, 24) --  [ERROR] lua/entities/vector dealer/cl_init.lua:106: bad argument #2 to 'WriteInt' (number expected, got no value)

            net.SendToServer()
        end
        LNMenu.Frame:MoveToFront()

    LNMenu.Frame.OnClose = function() 
        menuOpen = false
        LNMenu.BuyButtonFrame:Close()
    end
    local function Inspect(k)
        modelSet=true
        LNMenu.Panel.Icon:SetModel(LNInventory.Models[k])

        reRender()
        LNMenu.BuyButtonFrame:MoveTo(LNFx, ScrH() * -1510/-1920,.5,0,-1)
        timer.Simple(.7,function()
            LNBuyText = "Buy for $"..LNInventory.Prices[k].."?"
            LNMenu.BuyButton:SetText("Buy for $"..LNInventory.Prices[k].."?")
            LNMenu.BuyButtonFrame:MoveTo(LNFx,ScrH() * -1690/-1920,.5,0,-1)
        end)
    end
    for k,v in pairs(LNInventory.Items) do 

            icon = vgui.Create("SpawnIcon",LNMenu.Frame.List)
            icon:SetModel(LNInventory.Models[k])
            icon:SetSize( LNMenu.Frame:GetWide() * 0.06,  LNMenu.Frame:GetWide() * 0.06 )
            --LNMenu.Frame=LNMenu.Frame.List:Add(icon)
            icon.DoClick = function(icon)
                clickedItem = k
                Inspect(k)
            end
            icon.DoRightClick = function(icon)
                LNMenu.DropDown = DermaMenu()
                LNMenu.DropDown:MakePopup()
                LNMenu.DropDown:SetFontInternal("LividityTEXT")
                function LNMenu.DropDown:Paint(w, h)
                    draw.RoundedBoxEx(3, 0, 0, w, h, Color(255,92,0,125), true, true, true, true)
                end

                LNMenu.DropDown:SetPos(gui.MousePos())
                LNMenu.DropDown:AddOption( "Inspect" , function() 
                    clickedItem = k
                    Inspect(k)
                end)

                end

        end

    

-------------------------D MODEL PANEL---------------------------------------
    

    LNMenu.Panel = vgui.Create( "DPanel" , LNMenu.Frame)
        LNMenu.Panel:SetPos( LNMenu.Frame:GetWide()*0.007, LNMenu.Frame:GetWide()*0.007 )
        LNMenu.Panel:SetSize( LNMenu.Frame:GetWide()* 0.546, LNMenu.Frame:GetWide()* 0.546 )
        LNMenu.Panel:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
        LNMenu.Sheet:AddSheet("",LNMenu.Panel,false,false,"Inventory")

    LNMenu.Panel.Icon = vgui.Create( "DModelPanel", LNMenu.Panel )
        LNMenu.Panel.Icon:SetSize( LNMenu.Frame:GetWide()* 0.546, LNMenu.Frame:GetWide()* 0.546 )
        LNMenu.Panel.Icon:SetModel( "models/props_c17/statue_horse.mdl" )
        reRender()

    LNMenu.Panel2 = vgui.Create( "DPanel" , LNMenu.Frame)
        LNMenu.Panel2:SetPos( LNMenu.Frame:GetWide()*0.007, LNMenu.Frame:GetWide()*0.007 )
        LNMenu.Panel2:SetSize( LNMenu.Frame:GetWide()* 0.546, LNMenu.Frame:GetWide()* 0.546 )
        LNMenu.Panel2:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
        LNMenu.Sheet:AddSheet("",LNMenu.Panel2,false,false,"Cosmetics")

    
    

----------------------Painting the Menu----------------------------------


function LNMenu.Frame:Paint(w, h)
    draw.RoundedBoxEx(3, 0, 0, w, h, Color(150,0,0,225), true, true, true, true)
    LNMenu.blur( LNMenu.Frame, 10, 20, 255 )
end

function LNMenu.BuyButtonFrame:Paint(w, h)
    draw.RoundedBoxEx(3, 0, 0, w, h, Color(0,200,0,225), true, true, true, true)
    LNMenu.blur( LNMenu.BuyButtonFrame, 15, 20, 255 )
end
function LNMenu.BuyButton:Paint(w, h)
    draw.RoundedBoxEx(3, 0, 0, w, h, Color(0,200,0,0), true, true, true, true)
    LNMenu.blur( LNMenu.BuyButtonFrame, 15, 20, 255 )
    surface.SetFont("LividityBuy")
    draw.DrawText( LNBuyText, "LividityBuy", LNBx / 2 - surface.GetTextSize(LNBuyText) / 2, LNBy / 2 - 100, Color( 255, 255, 255, 255 ))
end
end




-------------------------Blur--------------------------
    -- Panel based blur function by Chessnut from NutScript
local blur = Material( "pp/blurscreen" )
function LNMenu.blur( panel, layers, density, alpha )
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

function LNMenu.KeyPress( ply , bind, pressed)

    if (bind == "gm_showspare2" && (not menuOpen)) then

        LNMenu.showMenu( )
    end
end

net.Receive("vectordealer_UsePanel", function( len )
    LNMenu.showMenu()
end)

hook.Add("PlayerBindPress", "LNMenu.KeyPress", LNMenu.KeyPress)


   
    net.Receive("vectordealer_AlertPlayers", function()
   
    end)
   
function ENT:Draw()
--MADE BY plaidroni (http://steamcommunity.com/id/plaidroni/)
    self:DrawModel()
   
    --------------------------------
 
end
