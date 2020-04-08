include("shared.lua")
VDMenu = {}
VDMenu.Listings = {}
VDMenu.Text = {}
VDMenu.Frame = {}
VDInventory = {}


VDInventory.Items = {} 
VDInventory.Models = {} 
VDInventory.Prices = {} 
VDInventory.numberOfItems = #VDInventory.Items
--lol
net.Receive("TableSend", function()
    --resets last inventory cycle
    VDInventory.Items = {} 
    VDInventory.Models = {} 
    VDInventory.Prices = {}
    --grabs the inventory
    guns=net.ReadTable()
    num = #guns
    
    --for separating models,item,price
    x=1
    --loop through matrix
    for i=1, num do
        --loop through individual guns so we can split that bitch
        for k,v in pairs(guns[i]) do
               --[[
                format is this lol
                guns = {
                1 = {String model1, String item1, Int price1},
                2 = {String model2, String item2, Int price2},
                3 = {String model3, String item3, Int price3},
                4 = {String model4, String item4, Int price4},
                5 = {String model5, String item5, Int price5},
                6 = {String model6, String item6, Int price6}
                }
                so when we are looping below we can do it like this
                gun[1] == {String model1, String item1, Int price1} --> gun[1][1] == String model1
                this is so we can store the same index for the same gun but in differing tables
                so index 1 is always gun 1 for all tables
               ]]


            if x == 1 then
                table.insert(VDInventory.Models, v)
                x = x + 1
                   
            elseif x == 2 then
                table.insert(VDInventory.Items, v)
                x = x + 1   

            elseif x == 3 then
                        
                table.insert(VDInventory.Prices,  v)
                x = 1

            else return 
            end
        end
    end
    --this is so we can decide how to draw the menu based on the items
    VDInventory.numberOfItems = #VDInventory.Items
end)



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
    eyecountdown = 20
    buylist = {}
    VDbuylistLines = {}
    local VDSit = vgui.Create( "DModelPanel", VDMenu.Frame )

        VDSit:SetSize( ScrH()/6, ScrW()/10.666)
        xz,yz = VDSit:GetSize()
        VDSit:SetPos((ScrW() / 2) - xz/2.05, (ScrH() / 2) - yz/1.5)
        VDSit:SetModel( "models/vector_orc.mdl" ) -- you can only change colors on playermodels
        function VDSit:LayoutEntity( Entity ) return end
    VDMenu.Frame.Paint = function()
        
        --[[function VDSit:LayoutEntity( e )  
            e:SetSequence( 351 )
            if e:GetCycle() >= 0.98 then 
                e:SetCycle( 0.02 ) 
            end
            VDSit:RunAnimation()
        end ]]--

        function VDSit.Entity:GetPlayerColor() return Vector ( 1, 0, 0 ) end --we need to set it to a Vector not a Color, so the values are normal RGB values divided by 255.
        eyecountdown = Lerp(FrameTime(), eyecountdown, 0 )
        local eyepos = Vector(0, 0, eyecountdown) + VDSit.Entity:GetBonePosition(VDSit.Entity:LookupBone("ValveBiped.Bip01_Head1"))
        VDSit:SetLookAt(eyepos)
        VDSit:SetCamPos(eyepos-Vector(-20, 0, 0)) -- Move cam in front of eyes
        VDSit.Entity:SetEyeTarget(eyepos-Vector(-12, 0, 0))
        VDMenu.blur( VDMenu.Frame, 10, 20, 255 )
    --grabs the number of items from the soon to be sql table
        surface.SetDrawColor( 50, 50, 50, 150 )
        surface.DrawRect( 0, 0, VDMenu.Frame:GetWide(), VDMenu.Frame:GetTall() )
        surface.SetDrawColor( 200, 200, 200, 255 )

        --surface.DrawLine(((ScrW() / 2) - xz/2.05) + xz,((ScrH() / 2) - yz/1.5) + yz,((ScrW() / 2) - xz/2.05) + xz,((ScrH() / 2) - yz/1.5) + yz)
        if VDInventory.numberOfItems > 1 then
            countdown = Lerp(FrameTime(), countdown, 0 )
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
    function updateList(item, index)
        for k,v in pairs(buylist) do
            surface.SetFont( "Default" )
            surface.SetTextColor( 255, 255, 255 )
            surface.SetTextPos( 128, 128 ) 
            surface.DrawText( "Hello World" )
            print("hello")
        end
    end

    for i = 1, VDInventory.numberOfItems do
        
        local x = ScrW()/2 + math.sin( math.rad( 360/VDInventory.numberOfItems * i) ) * 250 - 50
        local y = ScrH()/2 - math.cos( math.rad( 360/VDInventory.numberOfItems * i) ) * 250 - 15

        local icon = vgui.Create( "DModelPanel", VDMenu.Frame )

        icon:SetSize( ScrH()/9, ScrW()/16)
        xz,yz = icon:GetSize()
        icon:SetPos(x - xz/4, y - yz/2.25)
        icon:SetModel( VDInventory.Models[i] ) -- you can only change colors on playermodels
        function icon.Entity:GetPlayerColor() return Vector ( 1, 0, 0 ) end --we need to set it to a Vector not a Color, so the values are normal RGB values divided by 255.
        local mn, mx = icon.Entity:GetRenderBounds()
        local size = mx.x * 2
        size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
        size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
        size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

        icon:SetFOV( 45 )
        icon:SetCamPos( Vector( size, size, size ) )
        icon:SetLookAt( ( mn + mx ) * 0.5 )

        icon.DoClick = function()
            LNBuyText = "Buy for $"..VDInventory.Prices[i].."?"
            --VDMenu.BuyButton:SetText(icon:GetModel())
            table.insert(buylist, VDInventory.Items[i])
            updateList(VDInventory.Items[i], i)
        end
        text = "Buy for $"..VDInventory.Prices[i].."?"
        VDMenu.BuyButton = vgui.Create( "DButton", VDMenu.Frame )
        VDMenu.BuyButton:SetText( text )
        VDMenu.BuyButton:SetPos( 0,0 )
        VDMenu.BuyButton:SetSize( ScrW() / 15, ScrH() / 25 )
        VDMenu.BuyButton.DoClick = function()
            net.Start("vectordealer_BuyWeapon")
            net.WriteInt(clickedItem, 1) --  [ERROR] lua/entities/vector dealer/cl_init.lua:106: bad argument #2 to 'WriteInt' (number expected, got no value)
            net.SendToServer()
        end
    end

    VDMenu.Frame:MoveToFront() 
end




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
--made by me tobias too mother fucker some of this dogshit code is mine ):<
--MADE BY plaidroni (http://steamcommunity.com/id/plaidroni/)
    self:DrawModel()
   
    --------------------------------
 
end

