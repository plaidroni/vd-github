
function tables_exist()
    
    
    if (sql.TableExists("VDPos")) then
        Msg("Table already exist!\n")
    elseif (!sql.TableExists("VDPos")) then
        query = "CREATE TABLE VDPos ( Positions TEXT, Angles TEXT, Name TEXT, Map TEXT)"
        result = sql.Query(query)
        print(result)
 
        if (sql.TableExists("VDPos")) then
            Msg("Success! table created \n")
        else
            Msg("Something went wrong with the VDPos query! \n")
            Msg( sql.LastError( result ) .. "\n")
        end
    end


    if (sql.TableExists("VDModel")) then
        Msg("Table already exist!\n")
    elseif (!sql.TableExists("VDModel")) then
        query = "CREATE TABLE VDModel ( Model TEXT, Name TEXT)"
        result = sql.Query(query)
        print(result)
 
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
        print(result)
 
        if (sql.TableExists("VDSetModel")) then
            Msg("Success! table created \n")
        else
            Msg("Something went wrong with the VDSetModel query! \n")
            Msg( sql.LastError( result ) .. "\n")
        end
    end

    if (sql.TableExists("VDCoin")) then
        Msg("Table already exist!\n")
    elseif (!sql.TableExists("VDCoin")) then
        query = "CREATE TABLE VDCoin ( Name TEXT, Money INTEGER )"
        result = sql.Query(query)
        print(result)
 
        if (sql.TableExists("VDCoin")) then
            Msg("Success! table created \n")
        else
            Msg("Something went wrong with the VDCoin query! \n")
            Msg( sql.LastError( result ) .. "\n")
        end
    end

    if (sql.TableExists("VDInventory")) then
        Msg("Table already exist!\n")
    elseif (!sql.TableExists("VDInventory")) then
        query = "CREATE TABLE VDInventory ( gun TEXT, model TEXT, price INTEGER )"
        result = sql.Query(query)
        sql.Query("INSERT INTO VDInventory(gun,model,price) VALUES('ls_sniper','models/weapons/w_snip_sg550.mdl',50);")
        sql.Query("INSERT INTO VDInventory(gun,model,price) VALUES('ls_sniper','models/weapons/w_snip_sg550.mdl',50);")
        sql.Query("INSERT INTO VDInventory(gun,model,price) VALUES('ls_sniper','models/weapons/w_snip_sg550.mdl',50);")
        sql.Query("INSERT INTO VDInventory(gun,model,price) VALUES('ls_sniper','models/weapons/w_snip_sg550.mdl',50);")
        sql.Query("INSERT INTO VDInventory(gun,model,price) VALUES('ls_sniper','models/weapons/w_snip_sg550.mdl',50);")
        sql.Query("INSERT INTO VDInventory(gun,model,price) VALUES('ls_sniper','models/weapons/w_snip_sg550.mdl',50);")

        print(result)
 
        if (sql.TableExists("VDInventory")) then
            Msg("Success! table created \n")
        else
            Msg("Something went wrong with the VDInventory query! \n")
            Msg( sql.LastError( result ) .. "\n")
        end
    end


end

 
function Initialize()
    tables_exist()
end

function PlayerInitialSpawn( ply )
    
    res = sql.Query("SELECT Name FROM VDCOIN WHERE Name = '"..ply:SteamID().."';")
    if not res then
        sql.Query("INSERT INTO VDCOIN( Name, Money ) VALUES ('"..ply:SteamID().."', 0);")
    end

end

 
------------------------Hooks--------------------------------------------------
 
hook.Add( "Initialize", "Initialize", Initialize)
hook.Add("PlayerInitialSpawn", "PlayerInitialSpawn", PlayerInitialSpawn)
