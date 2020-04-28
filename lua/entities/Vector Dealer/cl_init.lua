include("shared.lua")


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

surface.CreateFont("VDBuyMenuText", {
    font = "TargetID",
    size = ScrW()*.007,
    weight = 500
})
surface.CreateFont("VDItemText", {
    font = "TargetID",
    size = ScrW()*.014,
    weight = 500
})


--------------------------------VARIABLES--------------------------------
VDMenu = {}
VDMenu.Listings = {}
VDMenu.Text = {}
VDMenu.Frame = {}
VDInventory = {}
VDInventory.Items = {} 
VDInventory.Models = {} 
VDInventory.Prices = {} 
VDInventory.Buylist = {}
VDInventory.Buylist.cart = {}
VDInventory.Buylist.index = {}

VDInventory.numberOfItems = #VDInventory.Items
VDInventory.CurName = ""
VDInventory.CurModel = ""
VDInventory.CurPrice = 0
LNBuyText = "text"
local menuOpen = false
local modelSet = false
local clickedItem = 0
local item = 0
local scrw9 = ScrW() / 9
local scrh16 = ScrH() / 16
local iconIndex = nil
local dictionary = {}
local shoppingCartList = {}
local shoppingCartListModels = {}
local shoppingCartListRef = {}
local VDPly = ""
--------------------------------VARIABLES--------------------------------







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
    



    ------------------------------MODEL OF THE GUY IN THE MIDDLE-------------------------------------
    local VDSit = vgui.Create( "DModelPanel", VDMenu.Frame )
        VDSit:SetSize( ScrH()/6, ScrW()/10.666)
        xz,yz = VDSit:GetSize()
        VDSit:SetPos((ScrW() / 2) - xz/2.05, (ScrH() / 2) - yz/1.5)
        VDSit:SetModel( "models/vector_orc.mdl" ) -- you can only change colors on playermodels
        function VDSit:LayoutEntity( Entity ) return end
    
    VDMenu.Frame.Paint = function()
        function VDSit.Entity:GetPlayerColor() return Vector ( 1, 0, 0 ) end --we need to set it to a Vector not a Color, so the values are normal RGB values divided by 255.
        eyecountdown = Lerp(FrameTime(), eyecountdown, 0 )
        local eyepos = Vector(0, 0, eyecountdown) + VDSit.Entity:GetBonePosition(VDSit.Entity:LookupBone("ValveBiped.Bip01_Head1"))
        VDSit:SetLookAt(eyepos)
        VDSit:SetCamPos(eyepos-Vector(-20, 0, 0)) -- Move cam in front of eyes
        VDSit.Entity:SetEyeTarget(eyepos-Vector(-12, 0, 0))
        VDMenu.blur( VDMenu.Frame, 10, 20, 255 )

    ------------------------------MODEL OF THE GUY IN THE MIDDLE-------------------------------------





 ----------------------------------CREATING INVENTORY-------------------------------------------------   
   
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
----------------------------------CREATING INVENTORY-------------------------------------------------



---------------------------------FOLLOW CURSOR-------------------------------------------------
    
    local followCursor = vgui.Create( "DPanel", VDMenu.Frame )
    followCursor:SetSize(ScrW(),ScrH())
    local mx, my = 0
    followCursor:SetVisible(false)

    function followCursor:Think()
        mx,my = input.GetCursorPos()
        followCursor:SetDrawOnTop()
        
    end
    function followCursor:Paint(w,h)
        local panel = vgui.GetHoveredPanel()
        model = panel:GetModel()
        index = indexof(VDInventory.Models,model)
        draw.DrawText(VDInventory.Names[index], "VDBuyMenuText", mx+55,my-65, Color(255,255,255,255), TEXT_ALIGN_LEFT)
        surface.SetDrawColor(255,255,255,255)
        surface.DrawLine(mx, my, (mx+50), (my-50))
        
    end
---------------------------------FOLLOW CURSOR-------------------------------------------------





--------------------------------FRAME FOR SHOPPING CART------------------------------------------

    VDMenu.ShoppingCartFrame = vgui.Create("DFrame", VDMenu.Frame)
    VDMenu.ShoppingCartFrame:SetPos(ScrW() * .8, (ScrH() * .5) - ((scrw9 * 2)/2))
    VDMenu.ShoppingCartFrame:SetSize(scrh16 * 2, scrw9 * 2)
    VDMenu.ShoppingCartFrame:ShowCloseButton(false)
    VDMenu.ShoppingCartFrame:SetDraggable(false)
    VDMenu.ShoppingCartFrame:SetTitle("")
    VDMenu.ShoppingCartFrame:MakePopup()
    local pmx, pmy = VDMenu.ShoppingCartFrame:GetSize()
    local toplineShop = 100
    local leftlineShop = 0
    local rightlineShop = 0
    local bottomlineShop = 100
    local restShop = false
    timer.Simple(1.5, function()
        restShop = true
    end)
    --VDMenu.PurchaseMenu:MoveTo(ScrW() - scrw9, scrh16, 1, .5)
    function VDMenu.ShoppingCartFrame:Paint(w,h)
        surface.SetDrawColor( Color( 255, 255, 255, 255 ) )

        rightlineShop = Lerp( 3 * FrameTime(), rightlineShop, h )
        surface.DrawLine(w-1, 0, w-1, rightlineShop)
        toplineShop = Lerp( 3 * FrameTime(), toplineShop, 0 )
        surface.DrawLine(w, 0, toplineShop, 0)
        surface.SetFont("VDBuyMenuText")
        draw.DrawText("$"..Subtotal(), "VDBuyMenuText", toplineShop + (pmx * .5), VDMenu.ShoppingCartFrame:GetTall() * .83, Color(255,255,255,255), TEXT_ALIGN_CENTER)
        if restShop then
            bottomlineShop = Lerp( 3 * FrameTime(), bottomlineShop, 0 )
            surface.DrawLine(w, h-1, bottomlineShop, h-1)
            leftlineShop = Lerp( 3 * FrameTime(), leftlineShop, h )
            surface.DrawLine(0, 0, 0, leftlineShop)
        end
    end
    VDMenu.ShoppingCartScroll = vgui.Create("DScrollPanel", VDMenu.ShoppingCartFrame)
    VDMenu.ShoppingCartScroll:SetPos(0,0)
    VDMenu.ShoppingCartScroll:SetSize(scrh16 * 2, scrw9 * 1.65)
    --VDMenu.PurchaseMenu:MoveTo(ScrW() - scrw9, scrh16, 1, .5)
    function VDMenu.ShoppingCartScroll:Paint(w,h)
        surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
    end
    VDMenu.ShoppingCartButton = vgui.Create("DButton", VDMenu.ShoppingCartFrame)
    VDMenu.ShoppingCartButton:SetSize(pmx * .80, pmy * .05)
    VDMenu.ShoppingCartButton:SetPos(pmx * 2, pmy * .93)
    VDMenu.ShoppingCartButton:SetText("")
    VDMenu.ShoppingCartButton:MoveTo(pmx * .1, pmy * .93, 1,1, .5)
    function VDMenu.ShoppingCartButton:Paint(w,h)
        surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
        surface.DrawOutlinedRect(0,0,w,h)
        draw.DrawText("CHECKOUT", "VDBuyMenuText", pmx*.5 - pmx * .10, VDMenu.ShoppingCartButton:GetTall() /4, Color(255,255,255,255), TEXT_ALIGN_CENTER)
    end
    function VDMenu.ShoppingCartButton:OnCursorEntered()

    end
    VDMenu.ShoppingCartButtonClear = vgui.Create("DButton", VDMenu.ShoppingCartFrame)
    VDMenu.ShoppingCartButtonClear:SetPos(pmx * 2, pmy * .87)
    VDMenu.ShoppingCartButtonClear:SetSize(pmx * .80, pmy * .05)
    VDMenu.ShoppingCartButtonClear:SetText("")
    VDMenu.ShoppingCartButtonClear:MoveTo(pmx * .1, pmy * .87, 1,1, .5)
    function VDMenu.ShoppingCartButtonClear:Paint(w,h)
        surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
        surface.DrawOutlinedRect(0,0,w,h)
        draw.DrawText("CLEAR CART", "VDBuyMenuText", pmx*.5 - pmx * .10, VDMenu.ShoppingCartButtonClear:GetTall() /4, Color(255,255,255,255), TEXT_ALIGN_CENTER)
    end
    function VDMenu.ShoppingCartButtonClear:DoClick()
        clearCart()
    end


    function clearCart() 
        VDInventory.Buylist.cart = {}
        VDInventory.Buylist.index = {}
        dictionary = {}
        VDMenu.ShoppingCartScroll:Clear()
        shoppingCartList = {}
        shoppingCartListModels = {}
        Subtotal()
    end

    function VDMenu.ShoppingCartButton:DoClick()
        --PrintTable(VDInventory.Buylist)
        net.Start("vectordealer_BuyWeapon")
        net.WriteTable(VDInventory.Buylist) --  [ERROR] lua/entities/vector dealer/cl_init.lua:106: bad argument #2 to 'WriteInt' (number expected, got no value)
        net.SendToServer()
        clearCart()
        VDMenu.Frame:Close()



    end


    --grabs the quantity and model
    function updateShoppingCartModel(item)
        --VDMenu.ShoppingCartScroll:Clear()
        

        local quantity = 0
        local shopmodel = ""
        local counter = 0
        --iterating
        
        counter = counter + 1
           
        shopmodel = VDInventory.Models[indexof(VDInventory.Items,item)] 
        quantity = dictionary[item]
        nilBool = indexof(shoppingCartListModels, shopmodel) == nil

            
        if(nilBool)then
            if(quantity <= 1)then
                ----------dont worry about most of this, just icon-------
                icon = vgui.Create( "DModelPanel", VDMenu.ShoppingCartScroll )
                icon:SetMouseInputEnabled( true )
                icon:SetSize( ScrH()/9, ScrW()/16)
                xz,yz = icon:GetSize()
                --the 2 lines below should be working but are kind of fucky
                icon:SetPos(xz, #shoppingCartList * (ScrW()/16))
                icon:MoveTo(0, #shoppingCartList * (ScrW()/16), 1, 1, 0.5)
                icon:SetModel( shopmodel ) -- you can only change colors on playermodels
                

                table.insert(shoppingCartListRef,shopmodel)
                shoppingCartListRef[shopmodel] = icon
                table.remove(shoppingCartListRef,1)



                function icon.Entity:GetPlayerColor() return Vector ( 1, 0, 0 ) end --we need to set it to a Vector not a Color, so the values are normal RGB values divided by 255.
                local mn, mx = icon.Entity:GetRenderBounds()
                local size = mx.x * 2

                size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
                size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
                size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

                icon:SetFOV( 45 )
                icon:SetCamPos( Vector( size, size, size ) )
                icon:SetLookAt( ( mn + mx ) * 0.5 )
                ----------dont worry about most of this, just icon-------
                
                table.insert(shoppingCartList, icon) -- putting the icon into a list, so that we can iterate over it later
                table.insert(shoppingCartListModels, shopmodel) -- for comparison\
               
            end


            
        elseif (not nilBool && quantity > 1) then
            ----------------creating the dlabel to go onto the dmodelpanel-----------------
            
            
            if not shoppingCartListRef[shopmodel]:HasChildren() then

                local iconlabel = vgui.Create("DLabel", icon)
                local x,y = VDMenu.ShoppingCartScroll:GetSize()
                iconlabel:SetSize(x, x)
                iconlabel:SetPos(10,10)
                iconlabel:SetColor(Color(255,255,255,255))
                iconlabel:SetFont("VDBuyMenuText")
                iconlabel:SetText("x2")
            ----------------creating the dlabel to go onto the dmodelpanel-----------------
           
            else
                child = shoppingCartListRef[shopmodel]:GetChildren()[1]
                child:SetText("x"..quantity) 
            end



            --clearing cart and then redoing the quantiies gives this erre ^_^

                --[[[ERROR] addons/vector dealer/lua/entities/vector dealer/cl_init.lua:276: attempt to index a nil value
                  1. updateShoppingCartModel - addons/vector dealer/lua/entities/vector dealer/cl_init.lua:276
                   2. DoClick - addons/vector dealer/lua/entities/vector dealer/cl_init.lua:449
                    3. unknown - lua/vgui/dlabel.lua:237


                    there is a max quantity if u add 3 and idk just mess with it but i couldnt go past q 7 on the 3rd item maybe ran out of mem bc too many obj? idk but it shouldnt

                    have fun retard i fixed ur shit code XD
                 ]]   
          
        end
        
    end
--------------------------------FRAME FOR SHOPPING CART------------------------------------------






    ----------------------DRAWING ITEMS---------------------------------------

    for i = 1, VDInventory.numberOfItems do

        
        local x = ScrW()/2 + math.sin( math.rad( 360/VDInventory.numberOfItems * i) ) * 250 - 50
        local y = ScrH()/2 - math.cos( math.rad( 360/VDInventory.numberOfItems * i) ) * 250 - 15
        local icon = vgui.Create( "DModelPanel", VDMenu.Frame )
        icon:SetMouseInputEnabled( true )
        icon:SetSize( ScrH()/9, ScrW()/16)
        xz,yz = icon:GetSize()
        icon:SetPos(x - xz/4, y - yz/2.25)
        icon:SetModel( VDInventory.Models[i] ) -- you can only change colors on playermodels
        local mn, mx = icon.Entity:GetRenderBounds()
        local size = mx.x * 2
        size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
        size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
        size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
        icon:SetFOV( 45 )
        icon:SetCamPos( Vector( size, size, size ) )
        icon:SetLookAt( ( mn + mx ) * 0.5 )


  ----------------------DRAWING ITEMS---------------------------------------



-----------------------------------ICON------------------------------------------
        --clicking on the item itself sets the next to whatever the curr clicked item
        icon.DoClick = function()
            VDInventory.CurName = VDInventory.Names[i]
            VDInventory.CurModel = VDInventory.Models[i]
            VDInventory.CurPrice = VDInventory.Prices[i]
            VDMenu.PurchaseMenuLabel:SetText("Add the "..VDInventory.CurName.." to the cart for "..VDInventory.CurPrice.."$?")
            item = VDInventory.Items[i]
            iconIndex = i
            if(VDInventory.CurModel ~= "")then
                VDMenu.iconPM:SetModel( VDInventory.CurModel ) -- you can only change colors on playermodels
                local mn, mx = VDMenu.iconPM.Entity:GetRenderBounds()
                local size = mx.x * 2
                size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
                size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
                size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )
                VDMenu.iconPM:SetFOV( 45 )
                VDMenu.iconPM:SetCamPos( Vector( size, size, size ) )
                VDMenu.iconPM:SetLookAt( ( mn + mx ) * 0.5 )
            end
            --VDMenu.ShoppingCart:SetText("Add "..item.. " To Shopping Cart?")
           -- updateModelBuy()
            --indexes to current shoppingcart
        end
        function icon:OnCursorEntered()
            followCursor:SetVisible(true)
        end
        function icon:OnCursorExited()
            followCursor:SetVisible(false)
        end



    
    
-----------------------------------ICON------------------------------------------




    -------------------------------PURCHASE MENU-------------------------------------------------------
    
    end
    
-------------------------------ADD TO CART--------------------------------------------------------
    
VDMenu.PurchaseMenu = vgui.Create("DFrame", VDMenu.Frame)
    VDMenu.PurchaseMenu:SetPos(ScrW() * .1, (ScrH() * .5) - ((scrw9 * 2)/2))
    VDMenu.PurchaseMenu:SetSize(scrh16 * 2, scrw9 * 2)
    VDMenu.PurchaseMenu:ShowCloseButton(false)
    VDMenu.PurchaseMenu:SetDraggable(false)
    VDMenu.PurchaseMenu:SetTitle("")
    VDMenu.PurchaseMenu:MakePopup()
    local pmx, pmy = VDMenu.PurchaseMenu:GetSize()
    local lerppos = .13
    local topline = 0
    local leftline = 0
    local rightline = 0
    local bottomline = 0
    local rest = false
    timer.Simple(1.5, function()
        rest = true
    end)
    VDMenu.iconPM = vgui.Create( "DModelPanel", VDMenu.PurchaseMenu )
    VDMenu.iconPM:SetMouseInputEnabled( true )
    VDMenu.iconPM:SetSize( ScrH()/9, ScrW()/16)
    function VDMenu.PurchaseMenu:Paint(w,h)
        surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
        lerppos = Lerp( 3 * FrameTime(), lerppos, .87 )
        surface.DrawLine((pmx * .13), (pmy * .30), (pmx *lerppos) , (pmy * .30))
        topline = Lerp( 3 * FrameTime(), topline, w )
        surface.DrawLine(0, 0, topline, 0)
        leftline = Lerp( 3 * FrameTime(), leftline, h )
        surface.DrawLine(0, 0, 0, leftline)
        if rest then
            rightline = Lerp( 3 * FrameTime(), rightline, h )
            surface.DrawLine(w-1, 0, w-1, rightline)
            bottomline = Lerp( 3 * FrameTime(), bottomline, w )
            surface.DrawLine(0, h-1, bottomline, h-1)
        end
        draw.DrawText(VDInventory.CurName, "VDBuyMenuText", pmx*.5,pmy*.33, Color(255,255,255,255), TEXT_ALIGN_CENTER)
    end

-------------------------------PURCHASE MENU-------------------------------------------------------
    
-------------------------------PURCHASE MENU LABEL-------------------------------------------------------
    VDMenu.PurchaseMenuLabel = vgui.Create("DLabel", VDMenu.PurchaseMenu)
    VDMenu.PurchaseMenuLabel:SetSize(pmx * .8, pmy * .2)
    VDMenu.PurchaseMenuLabel:SetPos( pmx*.1, pmy*.4 )
    VDMenu.PurchaseMenuLabel:SetText("")
    VDMenu.PurchaseMenuLabel:SetWrap(true)
    VDMenu.PurchaseMenuLabel:SetColor(Color(255,255,255,255))
    VDMenu.PurchaseMenuLabel:SetFont("VDBuyMenuText")
-------------------------------PURCHASE MENU LABEL-------------------------------------------------------

   
-------------------------------ADD TO CART--------------------------------------------------------
    VDMenu.ButtonPurchaseMenu = vgui.Create("DButton", VDMenu.PurchaseMenu)
    VDMenu.ButtonPurchaseMenu:SetPos(pmx * -1, pmy * .90)
    VDMenu.ButtonPurchaseMenu:SetSize(pmx * .80, pmy * .05)
    VDMenu.ButtonPurchaseMenu:SetText("")
    VDMenu.ButtonPurchaseMenu:MoveTo(pmx * .10, pmy * .90, 1, 1, 0.5)
    function VDMenu.ButtonPurchaseMenu:Paint(w,h)
        surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
        surface.DrawOutlinedRect(0,0,w,h)
        draw.DrawText("ADD", "VDBuyMenuText", pmx*.5 - pmx * .10, VDMenu.ButtonPurchaseMenu:GetTall() /4, Color(255,255,255,255), TEXT_ALIGN_CENTER)
    end


    VDMenu.ButtonPurchaseMenu.DoClick = function()
        
        table.insert(VDInventory.Buylist.cart, VDInventory.Items[iconIndex])
        table.insert(VDInventory.Buylist.index, iconIndex)
        UpdateCart(VDInventory.Buylist.cart,iconIndex)
        updateShoppingCartModel(item)
    end
        
------------------------------EXIT BUTTON--------------------------------------------------------
    VDMenu.ExitButton = vgui.Create("DButton", VDMenu.Frame)
    VDMenu.ExitButton:SetPos(ScrW() - scrw9, scrh16, 1, .5)
    VDMenu.ExitButton:SetSize(scrw9 * .3, scrw9 * .3)
    VDMenu.ExitButton:MakePopup()
    VDMenu.ExitButton:SetText("")
    function VDMenu.ExitButton:Paint(w, h)
        surface.SetDrawColor( 255, 255, 255, 255)
        surface.DrawLine(0,0,h,h)
        surface.DrawLine(h,0,0,h)
        --surface.DrawLine(w * .11,w*.6,)
    end
    function VDMenu.ExitButton.DoClick()
        VDMenu.Frame:Close()
    end
    function VDMenu.ExitButton:Think()
        VDMenu.ExitButton:MoveToFront()
        VDMenu.PurchaseMenu:MoveToFront()
        VDMenu.ShoppingCartFrame:MoveToFront()
    end
    VDMenu.Frame:MoveToFront() 

end

------------------------------EXIT BUTTON--------------------------------------------------------



----------------------------------UPDATING THE CART--------------------------------------
--Prints the Updated Cart When an item is added

function UpdateCart(tbl,index)
    subtotal = Subtotal(tbl)
    local hashmap = updateCartInPanel(VDInventory.Items[index])
end

--calculates the subtotal of the current shopping cart

function Subtotal()
    local subtotal = 0
    for k,v in pairs(VDInventory.Buylist.cart) do
        index = indexof(VDInventory.Items,v)
        price = VDInventory.Prices[index]
     
        subtotal = subtotal + price
    end
    return subtotal
end


--returns the index of the inputted value
function indexof(values,item)
    local index = {}
    for k,v in pairs(values) do
        index[v] = k
    end
    return index[item]
end

----------------------------------UPDATING THE CART--------------------------------------





---------------------------------MAPPING FOR QUANTITY---------------------------

--Attempts to make a map
function updateCartInPanel(item)
    --this checks if the item is in the dictionary

   if setContains(dictionary, item) then
        --if it does it indexes the quantity by 1
       dictionary[item] = dictionary[item] + 1
    else

        --if not it adds to the dictionary and puts the quantity to 1
       

       table.insert(dictionary,item)

          
       dictionary[item] = 1

       table.remove(dictionary,1)
            
    end
    
    return dictionary
end


function setContains(set, key)
    return set[key] ~= nil
end

---------------------------------MAPPING FOR QUANTITY---------------------------



----------------------------UPDATING MODEL------------------------------
function updateModelBuy()
    --VDMenu.IconPurchaseMenu:SetModel( VDInventory.CurName )
end

--??????
function updateList(item, index)
        for k,v in pairs(VDInventory.Buylist.cart) do
            surface.SetFont( "Default" )
            surface.SetTextColor( 255, 255, 255 )
            surface.SetTextPos( 128, 128 ) 
            surface.DrawText( "Hello World" )
        end
end

----------------------------UPDATING MODEL------------------------------





-------------------------BLUR--------------------------
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
-------------------------BLUR--------------------------



---------INITIALIZATION------------------------------

function ENT:Draw()

    self:DrawModel()
    
end

--opens the menu when pressed on
net.Receive("vectordealer_UsePanel", function( len )
    
    ply = net.ReadEntity()
    VDPly = ply
    
    VDMenu.showMenu()
end)

---------INITIALIZATION------------------------------


------------------------------------GRABBING INVENTORY------------------------------------------
--lol
net.Receive("vectordealer_TableSend", function()

    --resets last inventory cycle
    VDInventory.Names = {}
    VDInventory.Models = {} 
    VDInventory.Items = {}
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
                table.insert(VDInventory.Items, v)
                x = x + 1
            elseif x == 2 then
                table.insert(VDInventory.Models, v)
                x = x + 1
                   
            elseif x == 3 then
                table.insert(VDInventory.Names, v)
                x = x + 1   

            elseif x == 4 then
                        
                table.insert(VDInventory.Prices,  v)
                x = 1

            else return 
            end
        end
    end
    --this is so we can decide how to draw the menu based on the items
    VDInventory.numberOfItems = #VDInventory.Items
    VDInventory.CurName = VDInventory.Names[1]
    VDInventory.CurPrice = VDInventory.Prices[1]

end)

------------------------------------GRABBING INVENTORY------------------------------------------



