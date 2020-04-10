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


--------------------------------VARIABLES--------------------------------
VDMenu = {}
VDMenu.Listings = {}
VDMenu.Text = {}
VDMenu.Frame = {}
VDInventory = {}
VDInventory.CurName = ""

VDInventory.Items = {} 
VDInventory.Models = {} 
VDInventory.Prices = {} 
VDInventory.numberOfItems = #VDInventory.Items


LNBuyText = "text"
local menuOpen = false
local modelSet = false
local clickedItem = 0
local currMoney = 0
local item = 0
local scrw9 = ScrW() / 9
local scrh16 = ScrH() / 16
local iconIndex = nil

--------------------------------VARIABLES--------------------------------







--initialization of the menu itself

function VDMenu.showMenu( )
-------------------------FRAME---------------------------------------
    --effects based on clicking on VDealer
   
    net.Receive("MoneySend",function(ply,money)
        currMoney = Money
    end)

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
    buylist.cart = {}
    buylist.index = {}



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
    --VDMenu.PurchaseMenu:MoveTo(ScrW() - scrw9, scrh16, 1, .5)
    function VDMenu.ShoppingCartFrame:Paint(w,h)
        surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    VDMenu.ShoppingCartScroll = vgui.Create("DScrollPanel", VDMenu.ShoppingCartFrame)
    VDMenu.ShoppingCartScroll:SetPos(0,0)
    VDMenu.ShoppingCartScroll:SetSize(scrh16 * 2, scrw9 * 1.8)
    --VDMenu.PurchaseMenu:MoveTo(ScrW() - scrw9, scrh16, 1, .5)
    function VDMenu.ShoppingCartScroll:Paint(w,h)
        surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    VDMenu.ShoppingCartButton = vgui.Create("DButton", VDMenu.ShoppingCartFrame)
    VDMenu.ShoppingCartButton:SetPos(pmx * .10, pmy * .90)
    VDMenu.ShoppingCartButton:SetSize(pmx * .80, pmy * .05)
    VDMenu.ShoppingCartButton:SetText("")
    function VDMenu.ShoppingCartButton:Paint(w,h)
        surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
        surface.DrawOutlinedRect(0,0,w,h)
        draw.DrawText("BUY FOR ".."", "VDBuyMenuText", pmx*.5 - pmx * .10, VDMenu.ButtonPurchaseMenu:GetTall() /4, Color(255,255,255,255), TEXT_ALIGN_CENTER)
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
        function icon.Entity:GetPlayerColor() return Vector ( 1, 0, 0 ) end --we need to set it to a Vector not a Color, so the values are normal RGB values divided by 255.
        local mn, mx = icon.Entity:GetRenderBounds()
        local size = mx.x * 2
        size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
        size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
        size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

        icon:SetFOV( 45 )
        icon:SetCamPos( Vector( size, size, size ) )
        icon:SetLookAt( ( mn + mx ) * 0.5 )

  ----------------------DRAWING ITEMS---------------------------------------






-------------------------------------CHECKOUT-----------------------------------

        ----------------this needs to be in a separate checkout screen-------------------------------------------------
        ---text = "Buy for $"..VDInventory.Prices[i].."?"
        VDMenu.BuyButton = vgui.Create( "DButton", VDMenu.Frame )
        VDMenu.BuyButton:SetText( "ur mom" )
        VDMenu.BuyButton:SetPos( 0,0 )
        VDMenu.BuyButton:SetSize( ScrW() / 15, ScrH() / 25 )

        VDMenu.BuyButton.DoClick = function()
            PrintTable(buylist)
            net.Start("vectordealer_BuyWeapon")
            net.WriteTable(buylist) --  [ERROR] lua/entities/vector dealer/cl_init.lua:106: bad argument #2 to 'WriteInt' (number expected, got no value)
            net.SendToServer()
        end
         ---text = "Buy for $"..VDInventory.Prices[i].."?"
-------------------------------------CHECKOUT-----------------------------------
       


-----------------------------------ICON------------------------------------------
        --clicking on the item itself sets the next to whatever the curr clicked item
        icon.DoClick = function()
            VDInventory.CurName = VDInventory.Names[i]
            item = VDInventory.Items[i]
            iconIndex = i
            
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
    VDMenu.PurchaseMenu = vgui.Create("DFrame", VDMenu.Frame)
    VDMenu.PurchaseMenu:SetPos(ScrW() * .1, (ScrH() * .5) - ((scrw9 * 2)/2))
    VDMenu.PurchaseMenu:SetSize(scrh16 * 2, scrw9 * 2)
    VDMenu.PurchaseMenu:ShowCloseButton(false)
    VDMenu.PurchaseMenu:SetDraggable(false)
    VDMenu.PurchaseMenu:SetTitle("")
    VDMenu.PurchaseMenu:MakePopup()
    local pmx, pmy = VDMenu.PurchaseMenu:GetSize()
    --VDMenu.PurchaseMenu:MoveTo(ScrW() - scrw9, scrh16, 1, .5)
    function VDMenu.PurchaseMenu:Paint(w,h)
        surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
        surface.DrawOutlinedRect( 0, 0, w, h )
        surface.DrawLine((pmx * .13), (pmy * .30), (pmx * .87), (pmy * .30))
        draw.DrawText(VDInventory.CurName, "VDBuyMenuText", pmx*.5,pmy*.33, Color(255,255,255,255), TEXT_ALIGN_CENTER)
    end

-------------------------------PURCHASE MENU-------------------------------------------------------





   
-------------------------------ADD TO CART--------------------------------------------------------
    VDMenu.ButtonPurchaseMenu = vgui.Create("DButton", VDMenu.PurchaseMenu)
    VDMenu.ButtonPurchaseMenu:SetPos(pmx * .10, pmy * .90)
    VDMenu.ButtonPurchaseMenu:SetSize(pmx * .80, pmy * .05)
    VDMenu.ButtonPurchaseMenu:SetText("")
    function VDMenu.ButtonPurchaseMenu:Paint(w,h)
        surface.SetDrawColor( Color( 255, 255, 255, 255 ) )
        surface.DrawOutlinedRect(0,0,w,h)
        draw.DrawText("ADD", "VDBuyMenuText", pmx*.5 - pmx * .10, VDMenu.ButtonPurchaseMenu:GetTall() /4, Color(255,255,255,255), TEXT_ALIGN_CENTER)
    end


    VDMenu.ButtonPurchaseMenu.DoClick = function()
        
        table.insert(buylist.cart, VDInventory.Items[iconIndex])
      
     -- updateList(VDInventory.Items[i], i)
        table.insert(buylist.index, iconIndex)
        UpdateCart(buylist.cart,iconIndex, currMoney)

    end
    end
-------------------------------ADD TO CART--------------------------------------------------------
    




------------------------------EXIT BUTTON--------------------------------------------------------
    VDMenu.ExitButton = vgui.Create("DFrame", VDMenu.Frame)
    VDMenu.ExitButton:SetPos(ScrW() - (scrw9 * .2), scrh16)
    VDMenu.ExitButton:SetSize(scrw9, scrh16)
    VDMenu.ExitButton:ShowCloseButton(false)
    VDMenu.ExitButton:SetDraggable(false)
    VDMenu.ExitButton:SetTitle("")
    VDMenu.ExitButton:MakePopup()
    function VDMenu.ExitButton:Paint(w, h)
        surface.SetDrawColor( 255, 255, 255, 255)
        surface.DrawLine(w * .10,0,w * .10,h)
        draw.DrawText( "CLOSE", "LividityTEXT", w*.2, h*.1, Color(255,255,255,255), TEXT_ALIGN_LEFT )
        --surface.DrawLine(w * .11,w*.6,)
    end
    VDMenu.ExitButton:MoveTo(ScrW() - scrw9, scrh16, 1, .5)
    function VDMenu.ExitButton:OnCursorEntered()
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

function UpdateCart(tbl,index, money)
    
    --PrintTable(tbl)
   
    subtotal = Subtotal(tbl)
   
    hashmap = updateCartInPanel(VDInventory.Items[index])

    --print(hashmap[VDInventory.Items[index]])

   -- print("Balance: $"..""..money)
   -- print("Subtotal: $"..subtotal)
   -- print("New Balance: $"..money-subtotal)
   -- print("")
   -- print("")
end

--calculates the subtotal of the current shopping cart

function Subtotal()
    subtotal = 0
    for k,v in pairs(buylist.cart) do
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
local dictionary = {}
function updateCartInPanel(item)
    --this checks if the item is in the dictionary
   if setContains(dictionary, item) then
        --if it does it indexes the quantity by 1
       dictionary[item] = dictionary[item] + 1
    else

        --if not it adds to the dictionary and puts the quantity to 1
       

        table.insert(dictionary,item)

        dictionary[item] = 1
    end
    return dictionary
end


function setContains(set, key)
    return set[key] ~= nil
end

---------------------------------MAPPING FOR QUANTITY---------------------------



----------------------------UPDATING MODEL------------------------------
--[[
function updateModelBuy()
    --VDMenu.IconPurchaseMenu:SetModel( VDInventory.CurName )
end

--??????
function updateList(item, index)
        for k,v in pairs(buylist.cart) do
            surface.SetFont( "Default" )
            surface.SetTextColor( 255, 255, 255 )
            surface.SetTextPos( 128, 128 ) 
            surface.DrawText( "Hello World" )
        end
end
--]]

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
    VDMenu.showMenu()
end)

---------INITIALIZATION------------------------------




------------------------------------GRABBING INVENTORY------------------------------------------
--lol
net.Receive("TableSend", function()

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

    

end)

------------------------------------GRABBING INVENTORY------------------------------------------




    --[[VDMenu.IconPurchaseMenu = vgui.Create( "DModelPanel", VDMenu.PurchaseMenu )

    VDMenu.IconPurchaseMenu:SetSize( ScrH()/9, ScrW()/16)
    VDMenu.IconPurchaseMenu.xv, VDMenu.IconPurchaseMenu.yv = VDMenu.IconPurchaseMenu:GetSize()
    VDMenu.IconPurchaseMenu:SetPos(0,0)
    VDMenu.IconPurchaseMenu:SetModel( VDInventory.CurName ) -- you can only change colors on playermodels
    function VDMenu.IconPurchaseMenu.Entity:GetPlayerColor() return Vector ( 1, 0, 0 ) end --we need to set it to a Vector not a Color, so the values are normal RGB values divided by 255.
    local mn, mx = VDMenu.IconPurchaseMenu.Entity:GetRenderBounds()
    local size = mx.x * 2
    size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
    size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
    size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

    VDMenu.IconPurchaseMenu:SetFOV( 45 )
    VDMenu.IconPurchaseMenu:SetCamPos( Vector( size, size, size ) )
    VDMenu.IconPurchaseMenu:SetLookAt( ( mn + mx ) * 0.5 )]]--