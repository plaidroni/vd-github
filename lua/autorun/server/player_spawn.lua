function PlayerInitialSpawn( ply )
	
	res = sql.Query("SELECT Name FROM VDCOIN WHERE Name = '"..ply:GetSteamID().."';")
	if not res then
		sql.Query("INSERT INTO VDCOIN( Name, Money ) VALUES ('"..ply:GetSteamID().."', 0);")
	end
end
hook.Add( "PopulatePropMenu", "Vector Dealer", function()

	local contents = {}


	
	-- Entities
	table.insert( contents, {
		type = "header",
		text = "Vector Dealer"
	} )
	table.insert( contents, {
		type = "entity",
		spawnname = "vectordealer",
		nicename = "Vector Dealer",
		material = "models/vector_orc.mdl"
	} )
	


	spawnmenu.AddPropCategory( "VectorDealer", "Vector Dealer", contents, "icon16/box.png" )
end )