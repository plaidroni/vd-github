AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--Network Strings--

util.AddNetworkString("vectordealer_UsePanel")
util.AddNetworkString("vectordealer_BuyWeapon")
util.AddNetworkString("vectordealer_CloseFrame")
util.AddNetworkString("vectordealer_TableSend")

--Network Strings--

VDInventory = {}
VDTimer = {}

-- CONFIG

VDInventory.Items = {} 
VDInventory.Models = {} 
VDInventory.Prices = {}
VDTimer.Times = {3600, 7200, 10800, 14400}
local VD_ply = ""
local VD_moneyAmount
local model = sql.QueryValue("SELECT Model FROM VDSetModel;")
local inUse = false

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
    self.sound = CreateSound(self, Sound("ambient/wind/wind_bass.wav"))
    self.sound:SetSoundLevel(52)
    self.sound:PlayEx(1, 100)  
    RunConsoleCommand( "notificationadd", "The Vector Dealer has arrived." )
    PosAngTbl = grabPosAngle()
    local randomvec = PosAngTbl[1]
    local randomangle = PosAngTbl[2]
    self:SetPos(randomvec)
    self:SetAngles(randomangle)  
    sound.Play( "npc/combine_soldier/vo/phantom.wav", self:GetPos())
    timer.Create("VD_disappear", DespawnInterval , 1, function()
        RunConsoleCommand( "notificationadd", "The Vector Dealer has left." )
        if (self:IsValid()) then
            self:Remove()
        end
        if(#SpawnInterval == 1)then
            timer.Create("respawn", SpawnInterval[1] , 1, function()
                RunConsoleCommand("VDInitialize")
            end)
        else
            timer.Create("respawn", table.Random(SpawnInterval) , 1, function()
                RunConsoleCommand("VDInitialize")
            end)
        end
    end)
end

function ENT:Think()
    self:AddGestureSequence( 351,false )
end



function ENT:Use( Name )
        if Name:IsPlayer() then
            VD_moneyAmount = Name:getDarkRPVar("money")
            local minamt = tonumber(sql.QueryValue("SELECT Money FROM VDMinAmt;"))
            local x,y,z  = Name:GetPos():Unpack()
            local z = z + 60
             
            ParticleEffect( "generic_smoke", Vector(x,y,z) , Angle( 0, 0, 0 ) )
            ParticleEffect( "generic_smoke", Vector(x,y,z) , Angle( 0, 0, 0 ) )
                     
            if VD_moneyAmount > minamt then
                if not inUse then
                    inUse = true

                    Name:Freeze(false)
                    --PUT ANIMATION HERE
                    sendName(Name)

                    inUse = false

                end
            
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
    local randtbl = {}
    local guns = {{}}
    local randInventory = nil
    local res = sql.QueryValue("SELECT COUNT(*) FROM VDInventory;")
    if not res then return end
    res = tonumber(res)

    if res < 6 then 
         randInventory = math.Rand(3,res)
    elseif res < 3 then
         randInventory = math.Rand(1,res)
    else
        randInventory = math.Rand(3, 6)
    end
    for i = 1,res do
        table.insert(randtbl, i)
    end
    for i=1,randInventory do
        res = randtbl[math.random( 1, #randtbl )]
        table.RemoveByValue(randtbl, res)
        guns[i] = sql.QueryRow("SELECT * FROM VDInventory;",res)
    end
    appendToInv(guns)
    net.Start("vectordealer_TableSend")
    net.WriteTable(guns)
    net.Send(player.GetAll())
end

function appendToInv(guns)
     VDInventory.Names = {}
     VDInventory.Models = {} 
     VDInventory.Items = {}
     VDInventory.Prices = {}
    local num = #guns
    local x=1
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
    for k,v in pairs(buylist.cart) do

        index = indexof(VDInventory.Items,v)
        price = VDInventory.Prices[index]
        currentprice = currentprice + price
        
    end

    if VD_moneyAmount then

        if VD_moneyAmount >= currentprice then    
            ply:setDarkRPVar("money", money - currentprice)
            


            for k,v in pairs(buylist.cart)do  

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


function sendName(Name)
    --timer.Create("creationOfPanel", 3, 1, function()      
        net.Start("vectordealer_UsePanel")
        
        net.WriteEntity(Name)

        net.Send(Name)
   -- end)
end
