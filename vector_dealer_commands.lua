--Commands for placing and interacting with the Vector Dealer
--Vector Dealer = VD
--TODO:
--Add pos command to sql
--VD get pos from sql
--Add cmd to delete pos
--pos is calculated by getpos of curr player and push that table to sql then on random call it cycles through pos to get random spawn local
function AddVDPos(ply)
	v={}
	v=ply.GetPos()
	print(v)
end
hood.Add("KeyPress", "IN_FORWARD", AddVDPos)