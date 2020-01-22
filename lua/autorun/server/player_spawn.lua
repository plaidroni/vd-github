function PlayerInitialSpawn( ply )
	
	res = sql.Query("SELECT Name FROM VDCOIN WHERE Name = '"..ply:GetSteamID().."';")
	if not res then
		sql.Query("INSERT INTO VDCOIN( Name, Money ) VALUES ('"..ply:GetSteamID().."', 0);")
	end
end
hook.Add( "AddToolMenuTabs", "myHookClass", function()
	spawnmenu.AddToolTab( "Tab name!", "#Unique_Name", "icon16/wrench.png" )
end )