
function tables_exist()
    
    
-----------------------------MIN AMT--------------------------------
    if (sql.TableExists("VDMinAmt")) then
        Msg("Table already exist!\n")
    elseif (!sql.TableExists("VDMinAmt")) then
        query = "CREATE TABLE VDMinAmt ( Money INTEGER )"
        result = sql.Query(query)
        --print(result)
        sql.Query("INSERT INTO VDMinAmt(Money) Values(50000)")



        if (sql.TableExists("VDMinAmt")) then
            Msg("Success! table created \n")

        else
            Msg("Something went wrong with the VDMinAmt query! \n")
            Msg( sql.LastError( result ) .. "\n")
        end
    end
    -----------------------------MIN AMT--------------------------------
  


    -----------------------------CONFIG--------------------------------

    if (sql.TableExists("VDDespawnInterval")) then
        Msg("Table already exist!\n")
    elseif (!sql.TableExists("VDDespawnInterval")) then
        query = "CREATE TABLE VDDespawnInterval ( DespawnInterval INTEGER )"
        result = sql.Query(query)
        --print(result)
        sql.Query("INSERT INTO VDDespawnInterval(DespawnInterval) Values(1200)")




        if (sql.TableExists("VDDespawnInterval")) then
            Msg("Success! table created \n")

        else
            Msg("Something went wrong with the VDDespawnInterval query! \n")
            Msg( sql.LastError( result ) .. "\n")
        end
    end


    if (sql.TableExists("VDSpawnInterval")) then
        Msg("Table already exist!\n")
    elseif (!sql.TableExists("VDSpawnInterval")) then
        query = "CREATE TABLE VDSpawnInterval ( SpawnInterval INTEGER)"
        result = sql.Query(query)
        --print(result)
        sql.Query("INSERT INTO VDSpawnInterval(SpawnInterval) Values(3600)")
        sql.Query("INSERT INTO VDSpawnInterval(SpawnInterval) Values(7200)")
        sql.Query("INSERT INTO VDSpawnInterval(SpawnInterval) Values(10800)")
        sql.Query("INSERT INTO VDSpawnInterval(SpawnInterval) Values(14400)")




        if (sql.TableExists("VDSpawnInterval")) then
            Msg("Success! table created \n")

        else
            Msg("Something went wrong with the VDSpawnInterval query! \n")
            Msg( sql.LastError( result ) .. "\n")
        end
    end
    -----------------------------CONFIG--------------------------------


-------------------------------POS-----------------------------------

    if (sql.TableExists("VDPos")) then
        Msg("Table already exist!\n")
    elseif (!sql.TableExists("VDPos")) then
        query = "CREATE TABLE VDPos ( Positions TEXT, Angles TEXT, Name TEXT, Map TEXT)"
        result = sql.Query(query)
        --print(result)
 
        if (sql.TableExists("VDPos")) then
            Msg("Success! table created \n")
        else
            Msg("Something went wrong with the VDPos query! \n")
            Msg( sql.LastError( result ) .. "\n")
        end
    end
-------------------------------POS-----------------------------------



------------------------MODEL-------------------------------------


    if (sql.TableExists("VDModel")) then
        Msg("Table already exist!\n")
    elseif (!sql.TableExists("VDModel")) then
        query = "CREATE TABLE VDModel ( Model TEXT, Name TEXT)"
        result = sql.Query(query)
        --print(result)
 
        if (sql.TableExists("VDModel")) then
            Msg("Success! table created \n")
        else
            Msg("Something went wrong with the VDModel query! \n")
            Msg( sql.LastError( result ) .. "\n")
        end
    end


    if (sql.TableExists("VDSetModel")) then
        Msg("Table already exist!\n")
    elseif (!sql.TableExists("VDSetModel")) then
        query = "CREATE TABLE VDSetModel ( Model TEXT, Name TEXT)"
        result = sql.Query(query)
        sql.Query("INSERT INTO VDSetModel(Model, Name) VALUES('models/vector_orc.mdl', 'Vector');")
        --print(result)
 
        if (sql.TableExists("VDSetModel")) then
            Msg("Success! table created \n")
        else
            Msg("Something went wrong with the VDSetModel query! \n")
            Msg( sql.LastError( result ) .. "\n")
        end
    end
    ------------------------MODEL-------------------------------------



    ----------------------INVENTORY-----------------------------------------------------

    if (sql.TableExists("VDInventory")) then
        Msg("Table already exist!\n")
    elseif (!sql.TableExists("VDInventory")) then
        query = "CREATE TABLE VDInventory ( name TEXT, gun TEXT, model TEXT, price INTEGER )"
        result = sql.Query(query)
        sql.Query("INSERT INTO VDInventory(name,gun,model,price) VALUES('Sniper','ls_sniper','models/weapons/w_snip_sg550.mdl',50);")
        sql.Query("INSERT INTO VDInventory(name,gun,model,price) VALUES('Pistol','weapon_pistol','models/weapons/w_pistol.mdl',50);")
        sql.Query("INSERT INTO VDInventory(name,gun,model,price) VALUES('Bug Bait','weapon_bugbait','models/weapons/w_bugbait.mdl',50);")
        sql.Query("INSERT INTO VDInventory(name,gun,model,price) VALUES('Crossbow','weapon_crossbow','models/weapons/w_crossbow.mdl',50);")
        sql.Query("INSERT INTO VDInventory(name,gun,model,price) VALUES('Crowbar','weapon_crowbar','models/weapons/w_crowbar.mdl',50);")
        sql.Query("INSERT INTO VDInventory(name,gun,model,price) VALUES('Frag Grenade','weapon_frag','models/weapons/w_eq_fraggrenade.mdl',50);")

        --print(result)
 
        if (sql.TableExists("VDInventory")) then
            Msg("Success! table created \n")
        else
            Msg("Something went wrong with the VDInventory query! \n")
            Msg( sql.LastError( result ) .. "\n")
        end
    end
     ----------------------INVENTORY-----------------------------------------------------

end

 
function Initialize()
    tables_exist()
end

 
------------------------Hooks--------------------------------------------------
 
hook.Add( "Initialize", "Initialize", Initialize)
