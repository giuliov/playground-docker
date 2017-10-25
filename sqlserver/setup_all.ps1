param(
    $datadir,
    $dbname
)

Write-Verbose "Setup starting"

# start SQL Server
Write-Verbose "Starting SQL Server"
Start-Service MSSQLSERVER


Write-Verbose "Attaching database ${dbname}"
sqlcmd -d master -Q "CREATE DATABASE [${dbname}] ON ( FILENAME = N'${datadir}\${dbname}.mdf' ), ( FILENAME = N'${datadir}\${dbname}_log.LDF' ) FOR ATTACH"


Write-Verbose "Stopping SQL Server"
Stop-Service MSSQLSERVER

Write-Verbose "Setup complete"
