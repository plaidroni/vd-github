AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
-- CONFIG

LNInventory = {}
LNInventory.Items = {"weapon_pistol", "weapon_357", "ls_sniper"} -- all prices, models, and items must be same index of corresponding item
LNInventory.Models = {"models/weapons/w_pist_usp.mdl", "models/weapons/w_pist_usp.mdl", "models/weapons/w_snip_sg550.mdl"} -- all prices, models, and items must be same index of corresponding item
LNInventory.Prices = {2500,500,7000} -- all prices, models, and items must be same index of corresponding item



-- END CONFIG

util.AddNetworkString("vectordealer_UsePanel")
util.AddNetworkString("vectordealer_BuyWeapon")
util.AddNetworkString("vectordealer_TeleportCasino")
util.AddNetworkString("vectordealer_AlertPlayers")
util.AddNetworkString("vectordealer_TimerOut")
util.AddNetworkString("vectordealer_CloseFrame")
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
                    self:SetPos(randomvec)
                    self:SetAngles(randomangle)
                    print(randomangle)
                    v:ScreenFade( SCREENFADE.IN, Color( 0,0,0,255 ), 3, 0 )
                end
                timer.Simple(1,disappearinn)
        end
    end 
end
function ENT:Initialize() 
    self:SetModel( "models/vector_orc.mdl" )
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
    BroadcastLua([[chat.AddText(Color(72,72,72), "The Dealer has Arrived.")]])
    self:Give("m9k_svu")
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

        moneyAmount = Name:getDarkRPVar("money")
        if moneyAmount > 50000 then
            
            net.Start("vectordealer_UsePanel")
            net.Send(Name)
        else
        self:disappear()
        end
    end
end
 
net.Receive("vectordealer_BuyWeapon", function(len, ply, wepindex)
    wepindex = net.ReadInt(24)
    moneyamount = ply:getDarkRPVar("money")
    if moneyAmount >= LNInventory.Prices[wepindex] then    
        if moneyAmount - LNInventory.Prices[wepindex] > 0 then
            ply:setDarkRPVar( "money", moneyamount - LNInventory.Prices[wepindex])
            local gun = ents.Create( LNInventory.Items[wepindex] )
            gun:SetPos( ply:GetPos() + Vector(0,0,100))
            local function up( ply, ent )
            return true
            end
            hook.Add( "PlayerCanPickupWeapon", "monkey_has_a_chode", function( ply, wep )
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
    str=string.sub(str,13,string.len(str)-3)
    --splitting to vector
    str=string.Split(str, " ")
    table.insert(posang,Angle(str[1],str[2],str[3]))
    return posang
end