AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("vectordealer_UsePanel")
util.AddNetworkString("vectordealer_BuyWeapon")
util.AddNetworkString("vectordealer_CloseFrame")
util.AddNetworkString("vectordealer_TableSend")


-- CONFIG

VDInventory = {}
VDInventory.Items = {} 
VDInventory.Models = {} 
VDInventory.Prices = {}
VDTimer = {3600, 7200, 10800, 14400}
local VD_ply = ""
local VD_moneyAmount
local model = sql.QueryValue("SELECT Model FROM VDSetModel;")

game.AddParticles( "gmod_effects.pcf" )
PrecacheParticleSystem( "generic_smoke" )

-- END CONFIG



function ENT:Initialize()
    
    local SpawnInterval = sql.Query("SELECT * FROM VDSpawnInterval")
    local DespawnInterval = sql.QueryValue("SELECT DespawnInterval FROM VDDespawnInterval;")
    

    getVDInventory()
    self:SetModel( model )
    self:DropToFloor()
    self:DropToFloor()
    self:DropToFloor()



    self:CapabilitiesAdd( CAP_ANIMATEDFACE )
    self:SetSchedule( SCHED_NPC_FREEZE )
    self:SetHullType( HULL_HUMAN )
    self:SetHullSizeNormal( )
    self:SetNPCState( NPC_STATE_IDLE )
    

    self:StartEngineSchedule( SCHED_IDLE_STAND )
    self:SetSolid(  SOLID_BBOX )
    self:SetUseType( SIMPLE_USE )
    

    RunConsoleCommand( "notificationadd", "The Vector Dealer has arrived." )
    self.sound = CreateSound(self, Sound("ambient/wind/wind_bass.wav"))
    self.sound:SetSoundLevel(52)
    self.sound:PlayEx(1, 100)


            
    PosAngTbl = grabPosAngle()
    
    local randomvec = PosAngTbl[1]
    local randomangle = PosAngTbl[2]
  
    self:SetPos(randomvec)
     
    self:SetAngles(randomangle)  

    sound.Play( "npc/combine_soldier/vo/phantom.wav", self:GetPos())



    
    timer.Create("disappear", DespawnInterval , 1, function()
        RunConsoleCommand( "notificationadd", "The Vector Dealer has left." )
        
        if (self:IsValid()) then
            self:Remove()
        end  

        timer.Create("respawn", table.Random(SpawnInterval) , 1, function()
        
            RunConsoleCommand("VDInitialize")

        end)
    end)

end

--ulx.fancyLogAdmin( calling_ply, "#A gave #T $#i", target_ply, amount )


function ENT:Think()
    self:AddGestureSequence( 351,false )
end


 
function ENT:Use( Name )
    
    --Name:setDarkRpVar("money", 33)
  
    if Name:IsPlayer() then

    
        VD_moneyAmount = Name:getDarkRPVar("money")
        local minamt = tonumber(sql.QueryValue("SELECT Money FROM VDMinAmt;"))
        local x,y,z  = Name:GetPos():Unpack()
        local canbuy = VD_moneyAmount > minamt
        z = z + 60
        
        Name:Freeze(true)

        ParticleEffect( "generic_smoke", Vector(x,y,z) , Angle( 0, 0, 0 ) )
        ParticleEffect( "generic_smoke", Vector(x,y,z) , Angle( 0, 0, 0 ) )
      
        Name:ScreenFade( SCREENFADE.OUT, Color( 0,0,0,255 ), 3, 0.2 )
        Name:Freeze(false)
       
        if canbuy then
            timer.Create("beepboop", 3, 1, function()
                net.Start("vectordealer_UsePanel")
                
                net.WriteEntity(Name)
                
                net.Send(Name)
                end)

        else
            timer.Create("fadein", 3, 1, function()
                Name:ScreenFade( SCREENFADE.IN, Color( 0,0,0,255 ), 3, 0.2)
            end)
        end

    end
end
 








function grabPosAngle()
    local posang = {}
    local res = sql.QueryValue("SELECT COUNT(*) FROM VDPos WHERE Map = '"..game.GetMap().."';")
    --incase some shit breaks
    if not res then Msg(sql.LastError()) return end
    
    --grab random integer from 1 - max row of sql
    local rand = math.random(res)
    --grabs pos from selected row
    res = sql.QueryRow("SELECT Positions FROM VDPos WHERE Map = '"..game.GetMap().."';",rand)
    local str = table.ToString(res)
    --trim
    str=string.sub(str,13,string.len(str)-3)
    --splitting to vector
    str=string.Split(str, " ")
    table.insert(posang,Vector(str[1],str[2],str[3]))

   
    --grabs Angle from selected row
    res = sql.QueryRow("SELECT Angles FROM VDPos WHERE Map = '"..game.GetMap().."';",rand)
    str = table.ToString(res)
    --trim
    str=string.sub(str,10,string.len(str)-3)
    --splitting to vector
    str=string.Split(str, " ")
    table.insert(posang,Angle(str[1],str[2],str[3]))
    local model = sql.QueryValue("SELECT Model FROM VDSetModel;")
    return posang
end






function getVDInventory()
   --this is really stupid
    local randtbl = {}
    local guns = {{}}
    local randInventory = nil
    

    local res = sql.QueryValue("SELECT COUNT(*) FROM VDInventory;")
    if not res then return end
    res = tonumber(res)
    


    --this lets us have differing sizes if they dont want a lot of items
    if res < 6 then 
         randInventory = math.Rand(3,res)
    elseif res < 3 then
         randInventory = math.Rand(1,res)
    else
        randInventory = math.Rand(3, 6)
    end



    
   
   --creating a table of possible selections
    for i = 1,res do
        table.insert(randtbl, i)
    end
    




    for i=1,randInventory do
        --gives me a random value from created table
        res = randtbl[math.random( 1, #randtbl )]
        --removes value to not repeat
        table.RemoveByValue(randtbl, res)
        --stores the selected gun
        guns[i] = sql.QueryRow("SELECT * FROM VDInventory;",res)
    end
    


    --updates tables ^^^^^^^^^^^^^^^^^^^^^^
    appendToInv(guns)
    --sends so we can interact w/ the menu
    net.Start("vectordealer_TableSend")
    net.WriteTable(guns)
    net.Send(player.GetAll())
end





--updates tables ^^^^^^^^^^^^^^^^^^^^^^
--this shit is explained in cl_init.lua its a copy paste lol
function appendToInv(guns)
     VDInventory.Names = {}
     VDInventory.Models = {} 
     VDInventory.Items = {}
     VDInventory.Prices = {}

   

    local num = #guns
    x=1
    for i=1, num do
        for k,v in pairs(guns[i]) do
         
            if x == 1 then
                
                table.insert(VDInventory.Prices,  tonumber(v))
                

                x = x + 1    
            elseif x == 2 then
                table.insert(VDInventory.Models, v)

                x = x + 1
                   
            elseif x == 3 then
                table.insert(VDInventory.Names, v)
                x = x + 1   

            elseif x == 4 then
                        
                table.insert(VDInventory.Items, v)
                x = 1

            else return 
            end
        end
    end
    VDInventory.numberOfItems = #VDInventory.Items

    
end








net.Receive("vectordealer_BuyWeapon", function( len, ply)    
    if not ply:IsPlayer() then return end
    

    local buylist = net.ReadTable()
    local currentprice = 0
    local index = ""
    local price = 0
    local money = ply:getDarkRPVar("money")




    --OKAY SO BASICALLY THIS WHOLE THING IS LIKE REALLY NEAT SO WHAT THIS DOES IS RECIEVES THE SHOPPING CART TABLE AND THEN FINDS THE INDEX OF THE SPECIFIC ITEM IN THE
    --SYSTEM THAT WE HAVE AND THEN CREATES AN ITEM PER ONE AND SUBTRACTS THE MONEY FROM IT AUTOMATICALLY ITS BEAUTIFUL




    for k,v in pairs(buylist.cart) do
        
        --Variables
        index = indexof(VDInventory.Items,v)
        price = VDInventory.Prices[index]
        currentprice = currentprice + price
        --Checks to see if sql works
        

    end


    if VD_moneyAmount then
        --Checks to see if u have a balance


        if VD_moneyAmount >= currentprice then    
            ply:setDarkRPVar("money", money - currentprice)
            


            for k,v in pairs(buylist.cart)do
                --creates the gun to spawn
                

                local gun = ents.Create( buylist.cart[k] )
                gun:SetPos( ply:GetPos() + Vector(0,0,100))
                hook.Add( "PlayerCanPickupWeapon", "PlayerCanPickupWeapon", function( ply, wep )
                
                    if ( ply:HasWeapon( wep:GetClass() ) ) then return false end

                end )

                gun:Spawn()
                
            end
            

            net.Start("vectordealer_CloseFrame")
            net.Send(ply)


        end
    end
end)





function indexof(values,item)
    local index = {}
    for k,v in pairs(values) do
        index[v] = k
    end
    return index[item]
end

