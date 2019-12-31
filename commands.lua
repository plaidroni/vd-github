--[[---------------------------------------------------------
   Name:	VDGetPos
   Desc:	Allows admins to get current Pos and input into VDPos.
-----------------------------------------------------------]]   
local function VDGetPos( player, command)

	if ( !player:IsAdmin() ) then return end
	v=player:GetPos()
	print(v)
end

concommand.Add( "VDGetPos", VDGetPos, nil, "", { FCVAR_DONTRECORD } )