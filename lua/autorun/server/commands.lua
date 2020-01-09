
--[[---------------------------------------------------------
   Name:	VDSetPos
   Desc:	Allows admins to get current Pos and input into VDPos.
-----------------------------------------------------------]]   
local function VDSetPos( player, command, name)
	if ( !player:IsAdmin() ) then return end
	
	--Gets position and look position and makes a string
	x,y,z=player:GetPos():Unpack()
	pos = x.." "..y.." "..z
	x,y,z=player:GetAngles():Unpack()
	look = x.." "..y.." "..z

	--Checks if current map + name is already in the system
	result = sql.Query("SELECT Name FROM VDPos WHERE Map = '"..game.GetMap().."' AND Name = '".. name[1] .."';")
	if not result then
		--inputs pos, look angle, name, and map into sql table
		query = sql.Query("INSERT INTO VDPos(Positions,Angles,Name,Map) VALUES( '".. pos .."','"..look.."','"..name[1].."','"..game.GetMap().."');")
		if not query then print(sql.LastError())end
		print(query)
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
	else print("No such name and map exists!")
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
	sql.Query("DElETE FROM VDPos;")
end
concommand.Add( "VDClearPos", VDClearPos, nil, "", {FCVAR_DONTRECORD} )


