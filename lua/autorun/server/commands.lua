
local vecd


----------------------------------------------------------POS------------------------------------------------



--[[---------------------------------------------------------
   Name:	VDSetPos
   Desc:	Allows admins to get current Pos and input into VDPos.
-----------------------------------------------------------]]  

local function VDSetPos( player, command, name)
	if ( !player:IsAdmin() ) then return end

	--Gets position and look position and makes a string
	local x,y,z=player:GetPos():Unpack()
	local pos = x.." "..y.." "..z
	x,y,z=player:EyeAngles():Unpack()
	x=0
	local look = x.." "..y.." "..z

	--Checks if current map + name is already in the system
	
	local n = sql.SQLStr(name[1],true)
	print(n)
	
	local result = sql.Query("SELECT Name FROM VDPos WHERE Map = '"..game.GetMap().."' AND Name = '".. n .."';")

	if not result then
		--inputs pos, look angle, name, and map into sql table

		local query = sql.Query("INSERT INTO VDPos(Positions,Angles,Name,Map) VALUES( '".. pos .."','"..look.."','"..n.."','"..game.GetMap().."');")
		if not query then player:PrintMessage(HUD_PRINTCONSOLE,sql.LastError())end



	else player:PrintMessage(HUD_PRINTCONSOLE,"Position already logged under that name!")
	end

end

concommand.Add( "VDSetPos", VDSetPos, nil, "", { FCVAR_DONTRECORD } )

--[[---------------------------------------------------------
   Name:	VDDeletePos
   Desc:	Allows admins to Delete Pos
-----------------------------------------------------------]]   

local function VDDeletePos( player, command, name)
	if ( !player:IsAdmin() ) then return end
	--Checks if inputted name and map is in the db
	local n = sql.SQLStr(name[1],true)
	local result = sql.Query("SELECT Name FROM VDPos WHERE Name = '".. n .."' AND Map = '"..game.GetMap().."';")
	if result then
		--Deletes selected name
		local query = sql.Query("DELETE FROM VDPos WHERE Name = '".. n .."' AND Map = '"..game.GetMap().."';")
		if query then
			player:PrintMessage(HUD_PRINTCONSOLE,name[1].. " sucessfully deleted!")
		end
	else player:PrintMessage(HUD_PRINTCONSOLE,"No such name exists!")
	end
end

concommand.Add( "VDDeletePos", VDDeletePos, nil, "", {FCVAR_DONTRECORD} )

--[[---------------------------------------------------------
   Name:	VDViewPos
   Desc:	Allows admins to see all Pos
-----------------------------------------------------------]]  

local function VDViewPos( player, command)
	if ( !player:IsAdmin() ) then return end
	--returns all positions into a table
	local res = sql.Query("SELECT row_number() OVER (ORDER BY Map) row_number,Name,Map FROM VDPos;")
	
	if res then 
		for k,v in pairs(res) do
			for gk,gv in pairs(v) do
		    	player:PrintMessage(HUD_PRINTCONSOLE,gv)
			end
		end
		--player:PrintMessages to console
	else 
		player:PrintMessage(HUD_PRINTCONSOLE,sql.LastError()) 

	end
end
concommand.Add( "VDViewPos", VDViewPos, nil, "", {FCVAR_DONTRECORD} )

--[[---------------------------------------------------------
   Name:	VDClearPos
   Desc:	Allows admins to clear all Pos
-----------------------------------------------------------]]  
local function VDClearPos( player, command)
	if ( !player:IsAdmin() ) then return end
	sql.Query("DELETE FROM VDPos;")
end
concommand.Add( "VDClearPos", VDClearPos, nil, "", {FCVAR_DONTRECORD} )

----------------------------------------------------------POS------------------------------------------------



--------------------------------------------WEP-----------------------------------------------------------



--[[---------------------------------------------------------
   Name:	VDAddWep
   Desc:	Allows admins to add a model
-----------------------------------------------------------]]  
local function VDAddWep(player, command, model)
	if( !player:IsAdmin()) then return end
	
	local m1 = sql.SQLStr(model[1],true) 
	local m2 = sql.SQLStr(model[2],true) 
	local m3 = sql.SQLStr(model[3],true) 
	local m4 = sql.SQLStr(model[4],true) 
	local query = sql.Query("INSERT INTO VDInventory(name,model,gun,price) VALUES('"..m1.."', '"..m2.."', '"..m3.."','"..m4.."');")
	--[[
	if not query then 
		player:PrintMessage(HUD_PRINTCONSOLE,sql.LastError())
	else 
		player:PrintMessage(HUD_PRINTCONSOLE,"Success!")
	end	]]	
end
concommand.Add("VDAddWep", VDAddWep, nil, "", {FCVAR_DONTRECORD})



--[[---------------------------------------------------------
   Name:	VDViewWep
   Desc:	Allows admins to add a model
-----------------------------------------------------------]]  
local function VDViewWep( player, command)
	if ( !player:IsAdmin() ) then return end
	--returns all positions into a table
	local res = sql.Query("SELECT row_number() OVER (ORDER BY gun) row_number,gun,model FROM VDInventory;")
	if res then 
		--player:PrintMessages to console
		PrintTable(res)
	else player:PrintMessage(HUD_PRINTCONSOLE,sql.LastError()) end
end
concommand.Add( "VDViewWep", VDViewWep, nil, "", {FCVAR_DONTRECORD} )

--[[---------------------------------------------------------
   Name:	VDClearWep
   Desc:	Allows admins to delete all models
-----------------------------------------------------------]]  
local function VDClearWep(player, command)
	if( !player:IsAdmin()) then return end
	sql.Query("DELETE FROM VDInventory;")	
end
concommand.Add( "VDClearWep", VDClearWep, nil, "", {FCVAR_DONTRECORD} )


--[[---------------------------------------------------------
   Name:	VDDeleteWep
   Desc:	Allows admins to delete specific models
-----------------------------------------------------------]]  
local function VDDeleteWep(player, command, name)
	if( !player:IsAdmin()) then return end
	--Checks if inputted Model is in the db
	
	local n = sql.SQLStr(name[1],true)

	local result = sql.Query("SELECT gun FROM VDInventory WHERE Name = '".. n .."';")
	if result then
		--Deletes selected name
		local query = sql.Query("DELETE FROM VDInventory WHERE Name = '".. n .."';")
		
		if query then
			player:PrintMessage(HUD_PRINTCONSOLE,name[1].. " sucessfully deleted!")
		end

	else 
		player:PrintMessage(HUD_PRINTCONSOLE,"No such model exists!")
	end	

end
concommand.Add( "VDDeleteWep", VDDeleteWep, nil, "", {FCVAR_DONTRECORD} )

--------------------------------------------WEP-----------------------------------------------------------






--[[---------------------------------------------------------
   Name:	VDInitialize
   Desc:	Allows admins to initialize the Vector Dealer
-----------------------------------------------------------]]  
local function VDInitialize(player, command, name)
	if( !SERVER ) then if(!player:IsAdmin())then return end else 
		--Checks if inputted Model is in the db
		local randTime = math.Round(math.Rand(0, 14400))
		if(math.Round(RealTime()))then
			--localized at the top
			vecd = ents.Create("vector dealer")
			vecd:Spawn()
		end 
	end
end
concommand.Add( "VDInitialize", VDInitialize, nil, "", {FCVAR_DONTRECORD} )


--[[---------------------------------------------------------
   Name:	VDRemove
   Desc:	Allows admins to remove the Vector Dealer
-----------------------------------------------------------]]  
local function VDRemove(player, command)
	if( !SERVER ) then if(!player:IsAdmin())then return end else 
		--localized at the top
		if (vecd:IsValid()) then
			vecd:Remove()
		end
	end
end
concommand.Add( "VDRemove", VDRemove, nil, "", {FCVAR_DONTRECORD} )




--[[---------------------------------------------------------
   Name:	VDViewInterval
   Desc:	Allows admins to change see Spawn and Depawn Interval
-----------------------------------------------------------]]  


local function VDViewInterval( player, command)
	if ( !player:IsAdmin() ) then return end
	--returns all intervals into a table

	local res = sql.Query("SELECT DespawnInterval FROM VDDespawnInterval;")

	if res then
		for k,v in pairs(res) do
			for gk,gv in pairs(v) do
		    	player:PrintMessage(HUD_PRINTCONSOLE,gv)
			end
		end
	else 
		player:PrintMessage(HUD_PRINTCONSOLE,sql.LastError()) 
	end
	
	res =  sql.Query("SELECT * FROM VDSpawnInterval")

	if res then
		for k,v in pairs(res) do
			for gk,gv in pairs(v) do
		    	player:PrintMessage(HUD_PRINTCONSOLE,gv)
			end
		end
	else player:PrintMessage(HUD_PRINTCONSOLE,sql.LastError()) end


end
concommand.Add( "VDViewInterval", VDViewInterval, nil, "", {FCVAR_DONTRECORD} )


--[[---------------------------------------------------------
   Name:	VDChangeSpawnInterval
   Desc:	Allows admins to change the interval for how long the VD is active
-----------------------------------------------------------]]  
local function VDChangeSpawnInterval(player, command, num)
	if( !player:IsAdmin()) then return end
	

	sql.Query("DELETE FROM VDSpawnInterval;")	

	local cur

	for k,v in pairs(num) do
		cur = sql.SQLStr(v)
		sql.Query("INSERT INTO VDSpawnInterval(SpawnInterval) VALUES('"..cur.."');")
	end

end
concommand.Add( "VDChangeSpawnInterval", VDChangeSpawnInterval, nil, "", {FCVAR_DONTRECORD} )



--[[---------------------------------------------------------
   Name:	VDChangeDespawnInterval
   Desc:	Allows admins to change the interval for how long the VD is active
-----------------------------------------------------------]]  
local function VDChangeDespawnInterval(player, command, num)
	if( !player:IsAdmin()) then return end
	
	local n = sql.SQLStr(num[1],true)

	sql.QueryValue("UPDATE VDDespawnInterval SET DespawnInterval = '"..n.."';")

end
concommand.Add( "VDChangeDespawnInterval", VDChangeDespawnInterval, nil, "", {FCVAR_DONTRECORD} )





--[[---------------------------------------------------------
   Name:	VDHelp
   Desc:	Help
-----------------------------------------------------------]]  
local function VDHelp( player, command)
	if( !player:IsAdmin() ) then return end
	--Pos
	
	player:PrintMessage(HUD_PRINTCONSOLE," ")
	player:PrintMessage(HUD_PRINTCONSOLE," ")
	player:PrintMessage(HUD_PRINTCONSOLE,"Position:")
	player:PrintMessage(HUD_PRINTCONSOLE," ")
	player:PrintMessage(HUD_PRINTCONSOLE,"VDSetPos String Name -- Sets the position of the Vector Dealer with look angle and position")
	player:PrintMessage(HUD_PRINTCONSOLE,"VDDeletePos String Name -- Deletes a specific position of the Vector Dealer")
	player:PrintMessage(HUD_PRINTCONSOLE,"VDViewPos -- Displays a table of all positions according to map and name")
	player:PrintMessage(HUD_PRINTCONSOLE,"VDClearPos -- Clears all of the positions in the table")
	
	--Gun
	player:PrintMessage(HUD_PRINTCONSOLE," ")
	player:PrintMessage(HUD_PRINTCONSOLE," ")
	player:PrintMessage(HUD_PRINTCONSOLE,"Inventory:")
	player:PrintMessage(HUD_PRINTCONSOLE," ")
	player:PrintMessage(HUD_PRINTCONSOLE,"VDAddWep String name, String model, String entity, Integer cost -- (EX: VDAddWep Famas models/weapons/w_tct_famas.mdl m9k_famas 15000) allows admins to add a weapon to the VDShop")
	player:PrintMessage(HUD_PRINTCONSOLE,"VDViewWep -- Displays all guns in the shop")
	player:PrintMessage(HUD_PRINTCONSOLE,"VDClearWep -- Deletes all guns from the database")
	player:PrintMessage(HUD_PRINTCONSOLE,"VDDeleteWep String gun -- (EX: VDDeleteWep 'm9k_famas') Deletes the gun with specified name")


	--SpawnInterval

	player:PrintMessage(HUD_PRINTCONSOLE," ")
	player:PrintMessage(HUD_PRINTCONSOLE," ")
	player:PrintMessage(HUD_PRINTCONSOLE,"Spawn and Despawn Intervals:")
	player:PrintMessage(HUD_PRINTCONSOLE," ")
	player:PrintMessage(HUD_PRINTCONSOLE,"VDChangeSpawnInterval Int num -- Allows admins to change the interval for how long the VD is dormant (can support any amount of numbers.. just separate by spaces ex. VDChangeSpawnInterval 1 2 3 4")
	player:PrintMessage(HUD_PRINTCONSOLE,"VDChangeDespawnInterval Int num -- Allows admins to change the interval for how long the VD is active")
	player:PrintMessage(HUD_PRINTCONSOLE,"VDViewInterval -- Shows all Spawn and Despawn Intervals")




	--misc
	player:PrintMessage(HUD_PRINTCONSOLE," ")
	player:PrintMessage(HUD_PRINTCONSOLE," ")
	player:PrintMessage(HUD_PRINTCONSOLE,"Misc:")	
	player:PrintMessage(HUD_PRINTCONSOLE," ")
	player:PrintMessage(HUD_PRINTCONSOLE,"VDInitialize -- Starts the Vector Dealer ( AUTO STARTS )")
	player:PrintMessage(HUD_PRINTCONSOLE,"VDRemove -- Remove the Vector Dealer (when the periodic respawning of the vector dealer occurs undo will not work. This command is used to remove the vector dealer... ONLY WORKS IF VECTOR DEALER IS SPAWNED THROUGH VDInitialize)")

end
concommand.Add( "VDHelp", VDHelp, nil, "", {FCVAR_DONTRECORD} )
hook.Add( "InitPostEntity", "spawnvecdealerafterinitpost", function()
    VDInitialize()
    VDRemove()
end)
