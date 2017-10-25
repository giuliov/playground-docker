param(
    $datadir,
    $dbname
)

Write-Verbose "Setup starting"

# start SQL Server
Write-Verbose "Starting SQL Server"
Start-Service MSSQLSERVER

# silent mkdir
New-Item $datadir -ItemType Directory | Out-Null

# let's have fun
Write-Verbose "Creating database ${dbname}"
sqlcmd -Q "CREATE DATABASE [${dbname}] ON PRIMARY ( NAME = N'${dbname}', FILENAME = N'${datadir}\${dbname}.mdf' , SIZE = 8192KB , FILEGROWTH = 65536KB ) LOG ON ( NAME = N'${dbname}_log', FILENAME = N'${datadir}\${dbname}_log.ldf' , SIZE = 8192KB , FILEGROWTH = 65536KB )"

# the real fun
Write-Verbose "Creating ${dbname} schema"
sqlcmd -d $dbname -i create_tables.sql
Write-Verbose "Populating ${dbname} table(s)"
sqlcmd -d $dbname -i populate_data.sql

Write-Verbose "Stopping SQL Server"
Stop-Service MSSQLSERVER

Write-Verbose "Setup complete"
