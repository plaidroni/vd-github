
local vecd


----------------------------------------------------------POS------------------------------------------------



--[[---------------------------------------------------------
   Name:	VDSetPos
   Desc:	Allows admins to get current Pos and input into VDPos.
-----------------------------------------------------------]]  

local function VDSetPos( player, command, name)
	if ( !player:IsAdmin() ) then return end

	--Gets position and look position and makes a string
	x,y,z=player:GetPos():Unpack()
	pos = x.." "..y.." "..z
	x,y,z=player:EyeAngles():Unpack()
	x=0
	look = x.." "..y.." "..z

	--Checks if current map + name is already in the system
	result = sql.Query("SELECT Name FROM VDPos WHERE Map = '"..game.GetMap().."' AND Name = '".. name[1] .."';")
	if not result then
		--inputs pos, look angle, name, and map into sql table
		query = sql.Query("INSERT INTO VDPos(Positions,Angles,Name,Map) VALUES( '".. pos .."','"..look.."','"..name[1].."','"..game.GetMap().."');")
		if not query then print(sql.LastError())end
	else print("Position already logged under that name!")
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
	result = sql.Query("SELECT Name FROM VDPos WHERE Name = '".. name[1] .."' AND Map = '"..game.GetMap().."';")
	if result then
		--Deletes selected name
		query = sql.Query("DELETE FROM VDPos WHERE Name = '".. name[1] .."' AND Map = '"..game.GetMap().."';")
		if query then
			print(name[1].. " sucessfully deleted!")
		end
	else print("No such name exists!")
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
	res = sql.Query("SELECT row_number() OVER (ORDER BY Map) row_number,Name,Map FROM VDPos;")
	if res then 
		--prints to console
		PrintTable(res)
	else print(sql.LastError()) end
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




-----------------------------------------MODEL-------------------------------------------------------------


--[[---------------------------------------------------------
   Name:	VDAddModel
   Desc:	Allows admins to add a model
-----------------------------------------------------------]]  
local function VDAddModel(player, command, model)
	if( !player:IsAdmin()) then return end
	query = sql.Query("INSERT INTO VDModel(Model, Name) VALUES('"..model[1].."', '"..model[2].."');")
	if not query then print(sql.LastError())
	else print("Success!")
	end		
end
concommand.Add("VDAddModel", VDAddModel, nil, "", {FCVAR_DONTRECORD})


--[[---------------------------------------------------------
   Name:	VDSetModel
   Desc:	Allows admins to clear all Pos
-----------------------------------------------------------]]  
local function VDSetModel( player, command, model)
	if( !player:IsAdmin()) then return end
	
	res = sql.QueryValue("UPDATE VDModel SET Model = '"..model[1].."' WHERE Name = '"..model[1].."';")
	
end
concommand.Add( "VDSetModel", VDSetModel, nil, "", {FCVAR_DONTRECORD} )


--[[---------------------------------------------------------
   Name:	VDViewModel
   Desc:	Allows admins to add a model
-----------------------------------------------------------]]  
local function VDViewModel(player, command)
	if( !player:IsAdmin()) then return end
	curMod = sql.QueryValue("SELECT Model FROM VDSetModel;")
	curName = sql.QueryValue("SELECT Name FROM VDSetModel;")
	print("		Set Name  = "..curName)
	print("		Set Model = "..curMod)
	res = sql.Query("SELECT Name, Model from VDModel;")
	PrintTable(res)		
end
concommand.Add( "VDViewModel", VDViewModel, nil, "", {FCVAR_DONTRECORD} )


--[[---------------------------------------------------------
   Name:	VDClearModel
   Desc:	Allows admins to delete all models
-----------------------------------------------------------]]  
local function VDClearModel(player, command)
	if( !player:IsAdmin()) then return end
	sql.Query("DELETE FROM VDModel;")	
end
concommand.Add( "VDClearModel", VDClearModel, nil, "", {FCVAR_DONTRECORD} )






--[[---------------------------------------------------------
   Name:	VDDeleteModel
   Desc:	Allows admins to delete specific models
-----------------------------------------------------------]]  
local function VDDeleteModel(player, command, name)
	if( !player:IsAdmin()) then return end
	--Checks if inputted Model is in the db
	result = sql.Query("SELECT Name FROM VDModel WHERE Name = '".. name[1] .."';")
	if result then
		--Deletes selected name
		query = sql.Query("DELETE FROM VDModel WHERE Name = '".. name[1] .."';")
		if query then
			print(name[1].. " sucessfully deleted!")
		end
	else print("No such model exists!")
	end	
end
concommand.Add( "VDDeleteModel", VDDeleteModel, nil, "", {FCVAR_DONTRECORD} )



-----------------------------------------MODEL-------------------------------------------------------------


--------------------------------------------WEP-----------------------------------------------------------



--[[---------------------------------------------------------
   Name:	VDAddWep
   Desc:	Allows admins to add a model
-----------------------------------------------------------]]  
local function VDAddWep(player, command, model)
	if( !player:IsAdmin()) then return end
	query = sql.Query("INSERT INTO VDInventory(name,model,gun,price) VALUES('"..model[1].."', '"..model[2].."', '"..model[3].."','"..model[4].."');")
	if not query then print(sql.LastError())
	else print("Success!")
	end		
end
concommand.Add("VDAddWep", VDAddWep, nil, "", {FCVAR_DONTRECORD})



--[[---------------------------------------------------------
   Name:	VDViewWep
   Desc:	Allows admins to add a model
-----------------------------------------------------------]]  
local function VDViewWep( player, command)
	if ( !player:IsAdmin() ) then return end
	--returns all positions into a table
	res = sql.Query("SELECT row_number() OVER (ORDER BY gun) row_number,gun,model FROM VDInventory;")
	if res then 
		--prints to console
		PrintTable(res)
	else print(sql.LastError()) end
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
	result = sql.Query("SELECT gun FROM VDInventory WHERE Name = '".. name[1] .."';")
	if result then
		--Deletes selected name
		query = sql.Query("DELETE FROM VDInventory WHERE Name = '".. name[1] .."';")
		if query then
			print(name[1].. " sucessfully deleted!")
		end
	else print("No such model exists!")
	end	
end
concommand.Add( "VDDeleteWep", VDDeleteWep, nil, "", {FCVAR_DONTRECORD} )

--------------------------------------------WEP-----------------------------------------------------------






--[[---------------------------------------------------------
   Name:	VDInitialize
   Desc:	Allows admins to initialize the Vector Dealer
-----------------------------------------------------------]]  
local function VDInitialize(player, command, name)
	if( !player:IsAdmin()) then return end
	--Checks if inputted Model is in the db
	local randTime = math.Round(math.Rand(0, 14400))
	if(math.Round(RealTime()))then
		vecd = ents.Create("vector dealer")
		vecd:Spawn()
		local randTime = math.Round(math.Rand(0, 14400))
	end 
end
concommand.Add( "VDInitialize", VDInitialize, nil, "", {FCVAR_DONTRECORD} )

--[[---------------------------------------------------------
   Name:	VDRemove
   Desc:	Allows admins to remove the Vector Dealer
-----------------------------------------------------------]]  
local function VDRemove(ply, command)
	if( !ply:IsAdmin()) then return end
	if (vecd:IsValid()) then
		vecd:Remove()
	end
end
concommand.Add( "VDRemove", VDRemove, nil, "", {FCVAR_DONTRECORD} )

	



--[[---------------------------------------------------------
   Name:	VDHelp
   Desc:	Help
-----------------------------------------------------------]]  
local function VDHelp( player, command)
	--Pos
	print("")
	print("")

	print("")
	print("")
	print("Position:")
	print("")
	print("VDSetPos String Name -- Sets the position of the Vector Dealer with look angle and position")
	print("VDDeletePos String Name -- Deletes a specific position of the Vector Dealer")
	print("VDViewPos -- Displays a table of all positions according to map and name")
	print("VDClearPos -- Clears all of the positions in the table")
	--Model
	print("")
	print("")
	print("Model:")
	print("")
	print("VDAddModel String Path, String Name -- (format as 'models/MODEL.mdl') allows the admin to add a model")
	print("VDViewModel String Name -- displays all of the models in the DB")
	print("VDSetModel String Name -- sets the current model in accordance to the name")
	print("VDClearModel -- Deletes all models from the database")
	print("VDDeleteModel String Name -- Deletes model with specified name")
	--Gun
	print("")
	print("")
	print("Gun:")
	print("")
	print("VDAddWep String name, String model, String entity, Integer cost -- (EX: VDAddWep Famas models/weapons/w_tct_famas.mdl m9k_famas 15000) allows admins to add a weapon to the VDShop")
	print("VDViewWep -- Displays all guns in the shop")
	print("VDClearWep -- Deletes all guns from the database")
	print("VDDeleteWep String gun -- (EX: VDDeleteWep 'm9k_famas') Deletes the gun with specified name")

	--misc
	print("")
	print("")
	print("Misc:")
	print("")
	print("VDInitialize -- Starts the Vector Dealer")
	print("VDRemove -- Remove the Vector Dealer (when the periodic respawning of the vector dealer occurs undo will not work. This command is used to remove the vector dealer... ONLY WORKS IF VECTOR DEALER IS SPAWNED THROUGH VDInitialize)")

end
concommand.Add( "VDHelp", VDHelp, nil, "", {FCVAR_DONTRECORD} )