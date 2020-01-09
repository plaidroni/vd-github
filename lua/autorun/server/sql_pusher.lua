
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
end

 
function Initialize()
    tables_exist()
end

 
------------------------Hooks--------------------------------------------------
 
hook.Add( "Initialize", "Initialize", Initialize)
