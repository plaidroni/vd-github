ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Vector Dealer"
ENT.Author = "plaidroni"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"price")
	self:NetworkVar("Entity",1,"owning_ent")
end


