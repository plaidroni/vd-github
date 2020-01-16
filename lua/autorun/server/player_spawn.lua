function GM:PlayerInitialSpawn( ply )
	res = sql.Query("SELECT Name FROM VDCOIN WHERE Name = '"..ply:GetSteamID().."';")
	if not res then
		sql.Query("INSERT INTO VDCOIN( Name, Money ) VALUES ('"..ply:GetSteamID().."', 0);")
	end
end