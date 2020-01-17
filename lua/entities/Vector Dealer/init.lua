AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("vectordealer_UsePanel")
util.AddNetworkString("vectordealer_BuyWeapon")
util.AddNetworkString("vectordealer_TeleportCasino")
util.AddNetworkString("vectordealer_AlertPlayers")
util.AddNetworkString("vectordealer_TimerOut")
util.AddNetworkString("vectordealer_CloseFrame")
util.AddNetworkString("TableSend")
-- CONFIG

VDInventory = {}
VDInventory.Items = {"weapon_pistol", "weapon_357", "ls_sniper"} -- all prices, models, and items must be same index of corresponding item
VDInventory.Models = {"models/weapons/w_pist_usp.mdl", "models/weapons/w_pist_usp.mdl", "models/weapons/w_snip_sg550.mdl"} -- all prices, models, and items must be same index of corresponding item
VDInventory.Prices = {2500,500,7000} -- all prices, models, and items must be same index of corresponding item
model = sql.QueryValue("SELECT Model FROM VDSetModel;")
game.AddParticles( "gmod_effects.pcf" )
PrecacheParticleSystem( "generic_smoke" )

-- END CONFIG


function ENT:disappear()
    sound.Play( "npc/combine_soldier/vo/phantom.wav", self:GetPos() )
    local closeplayers = ents.FindInSphere( self:GetPos(), 500 )
    for k,v in pairs(closeplayers) do
        if v:IsPlayer() then
            v:ScreenFade( SCREENFADE.OUT, Color( 0,0,0,255 ), 1, 0 )
                function disappearinn()
                    PosAngTbl = grabPosAngle()
                    
                    local randomvec = PosAngTbl[1]
                    local randomangle = PosAngTbl[2]
                    for g,gg in pairs(player.GetAll()) do
                        v:SetPos(randomvec)
                    end
                    self:SetModel( model )
                    self:SetPos(randomvec)
                    self:SetAngles(randomangle)
                    
                    v:ScreenFade( SCREENFADE.IN, Color( 0,0,0,255 ), 3, 0 )
                   
                    self:AddGestureSequence(351,false)
                end
                timer.Simple(1,disappearinn)
        end
    end 
end

function ENT:Initialize() 
    getVDInventory()
    self:SetModel( model )
    self:CapabilitiesAdd( CAP_ANIMATEDFACE )
    self:CapabilitiesAdd( CAP_TURN_HEAD )
    self:SetSchedule( SCHED_NPC_FREEZE )
    
    self:SetHullType( HULL_HUMAN )
    self:SetHullSizeNormal( )
    self:SetNPCState( NPC_STATE_IDLE )
    self:StartEngineSchedule( SCHED_IDLE_STAND )
    self:SetSolid(  SOLID_BBOX )
    self:SetUseType( SIMPLE_USE )
    self:DropToFloor()
    RunConsoleCommand( "notificationadd", "The Vector Dealer has arrived." )
    self.sound = CreateSound(self, Sound("ambient/wind/wind_bass.wav"))
    self.sound:SetSoundLevel(52)
    self.sound:PlayEx(1, 100)
    playersincasino = {}
    self:disappear()
    timer.Create("Deletion",3600,1,function()
        sound.Play( "npc/combine_soldier/vo/phantom.wav", self:GetPos())
        for keys,players in pairs(playersincasino) do
            playersincasino = ents.FindInSphere( Vector(1851.474609, -7117.328613, -134.968750), 500 )
            for pici,picv in pairs(playersincasino) do
                if picv == players then
                    players:Kill()
                end
            end
        end
        RunConsoleCommand( "notificationadd", "The Vector Dealer has left." )
        self:Remove()
    end)
end
function ENT:Think()
    self:SetColor(Color(0,0,0,155))
end
net.Receive("vectordealer_TeleportCasino", function(len, ply)
    ply:ScreenFade( SCREENFADE.OUT, Color( 0,0,0,255 ), 1, 0 )
    function teleport()
        ply:SetPos(Vector(1641.712646, -7108.523438, -134.968750))
        ply:ScreenFade( SCREENFADE.IN, Color( 0,0,0,255 ), 3, 0 )
    end
    timer.Simple(1,teleport)
    table.insert( playersincasino, ply )
 
end)
 
function ENT:Use( Name, Caller )
    if Name:IsPlayer() then
        x,y,z  = Name:GetPos():Unpack()
     
        z = z + 60
        Name:Freeze(true)
        ParticleEffect( "generic_smoke", Vector(x,y,z) , Angle( 0, 0, 0 ) )
        ParticleEffect( "generic_smoke", Vector(x,y,z) , Angle( 0, 0, 0 ) )
      
        Name:ScreenFade( SCREENFADE.OUT, Color( 0,0,0,255 ), 3, 0.2 )
        Name:Freeze(false)
        timer.Create("beepboop", 3, 1, function()
            net.Start("vectordealer_UsePanel")
            net.Send(Name)


            --uncomment later


            --[[moneyAmount = Name:getDarkRPVar("money")
            if moneyAmount > 50000 then
                
                net.Start("vectordealer_UsePanel")
                net.Send(Name)
            else
            self:disappear()
            end]]
        end)
    end
end
 



net.Receive("vectordealer_BuyWeapon", function(len, ply, wepindex)
    wepindex = net.ReadInt(24)
    moneyamount = ply:getDarkRPVar("money")
    --fucking dumbshit
    if moneyAmount >= VDInventory.Prices[wepindex] then    
        if moneyAmount - VDInventory.Prices[wepindex] > 0 then
            ply:setDarkRPVar( "money", moneyamount - VDInventory.Prices[wepindex])
            local gun = ents.Create( VDInventory.Items[wepindex] )
            gun:SetPos( ply:GetPos() + Vector(0,0,100))
            hook.Add( "PlayerCanPickupWeapon", "PlayerCanPickupWeapon", function( ply, wep )
                if ( ply:HasWeapon( wep:GetClass() ) ) then return false end
            end )
            
            gun:Spawn()
            
            net.Start("vectordealer_CloseFrame")
            net.Send(ply)
        end
    end
   
end)





function grabPosAngle()
    posang = {}
    res = sql.QueryValue("SELECT COUNT(*) FROM VDPos WHERE Map = '"..game.GetMap().."';")
    --incase some shit breaks
    if not res then print(sql.LastError()) return end
    
    --grab random integer from 1 - max row of sql
    rand = math.random(res)
    --grabs pos from selected row
    res = sql.QueryRow("SELECT Positions FROM VDPos WHERE Map = '"..game.GetMap().."';",rand)
    str = table.ToString(res)
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
    model = sql.QueryValue("SELECT Model FROM VDSetModel;")
    return posang
end




function getVDInventory()
   --this is really stupid
    randtbl = {}
    guns = {{}}
    res = sql.QueryValue("SELECT COUNT(*) FROM VDInventory;")
    if not res then return end

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
    net.Start("TableSend")
    net.WriteTable(guns)
    net.Send(player.GetAll()[1])
end

--updates tables ^^^^^^^^^^^^^^^^^^^^^^
--this shit is explained in cl_init.lua its a copy paste lol
function appendToInv(guns)
    VDInventory.Items = {} 
    VDInventory.Models = {} 
    VDInventory.Prices = {}
    num = #guns
    x=1
    for i=1, num do
        for k,v in pairs(guns[i]) do
                
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
    VDInventory.numberOfItems = #VDInventory.Items
end


