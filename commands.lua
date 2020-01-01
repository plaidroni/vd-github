--[[---------------------------------------------------------
   Name:	VDSetPos
   Desc:	Allows admins to get current Pos and input into VDPos.
-----------------------------------------------------------]]   
local function VDSetPos( player, command)

	if ( !player:IsAdmin() ) then return end
	pos={}
	look={}
	pos=player:GetPos()
	look=player:GetAimVector()
	print(look)
end

concommand.Add( "VDSetPos", VDSetPos, nil, "", { FCVAR_DONTRECORD } )