ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Vector Dealer"
ENT.Author = "plaidroni & tobias"
ENT.Category = "Vector Dealer"
ENT.AdminOnly = true



ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"price")
	self:NetworkVar("Entity",1,"owning_ent")
end


