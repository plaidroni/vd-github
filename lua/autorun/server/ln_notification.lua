util.AddNetworkString("Currency_Notification")

local function SendIndividualNotif(ply, text)
    net.Start("Currency_Notification")
    net.WriteString(text)
    net.Send(ply)
end


local function SendNotifToClients( ply, cmd, args )
    net.Start("Currency_Notification")
    net.WriteString(args[1])
    net.Send(player.GetAll())
end


local function AdvertClients( text )
    net.Start("Currency_Notification")
    net.WriteString(text)
    net.Send(player.GetAll())
end


local function OnPlayerDeath( victim, weapon, attacker )
    if victim == attacker then
        SendIndividualNotif(victim, "Oh, you killed yourself. This is awkward.")
        SendIndividualNotif(victim, "Here's 4 Livbucks as.. Compensation?")
        AddLivbucks(victim, 4)
    end

    if (attacker:GetRole() == ROLE_TRAITOR && victim:GetRole() == ROLE_INNOCENT) || (attacker:GetRole() == ROLE_TRAITOR && victim:GetRole() == ROLE_DETECTIVE) then
        attacker:SetNWInt("Kills", attacker:GetNWInt("Kills", 0) + 1)
    end

    if attacker:GetRole() == ROLE_INNOCENT && victim:GetRole() == ROLE_TRAITOR then
        attacker:SetNWInt("Kills", attacler:GetNWInt("Kills", 0) + 1)
    end
end


local function AddFinalMoney()
    for k,v in pairs(player.GetAll()) do
        if v:GetNWInt("RoundMoney", 0) > 0 then
            v:SetNWInt("Money", (v:GetNWInt("Money",0) + v:GetNWInt("RoundMoney", 0)))
        end
    end
end


local function Reset()
    for k,v in pairs(player.getAll()) do
        v:SetNWInt( "RoundMoney" , 0 )
        v:SetNWInt( "Kills" , 0)
    end    
end


local function OnRoundEnd()
    for k,v in pairs(player.GetAll()) do
        if(v:GetNWInt( "Kills" ,0) > 0 && v:GetRole() == ROLE_INNOCENT) then
            SendIndividualNotif(v, "You earned " .. v:GetNWInt( "Kills" , 0) * 25 .. " LivBucks")
            v:SetNWInt("RoundMoney", (v:GetNWInt("Kills",0) * 25))
        end
        if (v:GetNWInt( "Kills" , 0 ) > 0 && v:GetRole() == ROLE_TRAITOR ) then
            SendIndividualNotif(v, "You earned " .. v:GetNWInt( "Kills" , 0) *5 .. " LivBucks")
            v:SetNWInt("RoundMoney", (v:GetNWInt("Kills",0) * 5))
        end
    end
    AddFinalMoney()
    Reset()
end

local function PlayerLeft( ply )
    if(ply:GetNWInt( "Kills" ,0) > 0 && ply:GetRole() == ROLE_INNOCENT) then
        SendIndividualNotif(ply, "You earned " .. ply:GetNWInt( "Kills" , 0) * 25 .. " LivBucks")
        ply:SetNWInt("RoundMoney", (ply:GetNWInt("Kills",0) * 25))
    end
     if (ply:GetNWInt( "Kills" , 0 ) > 0 && ply:GetRole() == ROLE_TRAITOR ) then
        SendIndividualNotif(ply, "You earned " .. ply:GetNWInt( "Kills" , 0) *5 .. " LivBucks")
         ply:SetNWInt("RoundMoney", (ply:GetNWInt("Kills",0) * 5))
    end
    AddFinalMoney()
    ply:SetNWInt( "RoundMoney" , 0 )
    ply:SetNWInt( "Kills" , 0)
end

-------------------------Hooks--------------------------------------

hook.Add("PlayerDeath","TTTKills", OnPlayerDeath)
hook.Add("TTTEndRound", "TTTEndRound", OnRoundEnd)
hook.Add( "PlayerDisconnected", "PlayerDisconnected", PlayerLeft)
-- Adding a console command
concommand.Add( "notificationadd", SendNotifToClients, nil, "Display an advert to the entire server using the custom Lividity Advert system", 0 )