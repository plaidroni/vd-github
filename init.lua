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
                    randomtable = {
                        Vector(1216.004639, 136.028549, 120.031250)- Vector(0,0,61),
                        Vector(1988.821167, -1978.840088, -431.968750)- Vector(0,0,61),
                        Vector(-1012.234314, -1984.007690, -363.968750)- Vector(0,0,61),
                        Vector(-2658.281494, -2137.575684, -431.968750)- Vector(0,0,61),
                        Vector(-1957.099243, -645.816101, -618.971191)- Vector(0,0,61),
                        Vector(-1743.968750, -339.423401, -391.969086)- Vector(0,0,61),
                        Vector(-1916.279053, -2804.495117, -887.969360)- Vector(0,0,61),
                    }
                    randomangletable = {
                        Angle(21.037445, 42.394558, 0.000000),
                        Angle(5.417387, 172.384521, 0.000000),
                        Angle(5.444870, 0.289598, 0.000000),
                        Angle(14.712353, 57.189461, 0.000000),
                        Angle(13.007330, -98.760818, 0.000000),
                        Angle(5.472243, 14.209239, 0.000000),
                        Angle(8.552035, -79.975777, 0.000000),
                    }
                    local randomvec = table.Random(randomtable)
                    local veckey = table.KeyFromValue(randomtable, randomvec)
                    local randomangle = randomangletable[veckey]
                    for g,gg in pairs(player.GetAll()) do
                        v:SetPos(randomvec)
                    end
                    self:SetPos(randomvec)
                    self:SetAngles(randomangle)
                    v:ScreenFade( SCREENFADE.IN, Color( 0,0,0,255 ), 3, 0 )
                end
                timer.Simple(1,disappearinn)
        end
    end 
end
function ENT:Initialize() 
    self:SetModel( "models/Combine_Super_Soldier.mdl" )
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
    self:Give("weapon_ak472")
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