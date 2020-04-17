util.AddNetworkString("Currency_Notification")
playerTable = player.GetAll()

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

concommand.Add( "notificationadd", SendNotifToClients, nil, "Display an advert to the entire server using the custom Lividity Advert system", 0 )
concommand.Add( "notificationsendto", SendIndividualNotif, nil, "Send a message to a specified player", 0 )

