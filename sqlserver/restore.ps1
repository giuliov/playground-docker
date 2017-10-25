param(
    $backupdir,
    $datadir,
    $dbname
)

Write-Verbose "Phase 1 starting"

# start SQL Server
Write-Verbose "Starting SQL Server"
Start-Service MSSQLSERVER

# silent mkdir
New-Item $datadir -ItemType Directory | Out-Null

# let's have fun
Write-Verbose "Restoring database ${dbname}"
sqlcmd -d master -Q "RESTORE DATABASE [${dbname}] FROM  DISK = N'${backupdir}\${dbname}.bak' WITH  FILE = 1,  MOVE N'${dbname}' TO N'${datadir}\${dbname}.mdf',  MOVE N'${dbname}_log' TO N'${datadir}\${dbname}_log.ldf',  NORECOVERY,  NOUNLOAD,  STATS = 5"
Write-Verbose "Restoring database ${dbname} transaction log"
sqlcmd -d master -Q "RESTORE LOG [${dbname}] FROM  DISK = N'${backupdir}\${dbname}.trn' WITH  FILE = 1,  NOUNLOAD,  STATS = 5"

Write-Verbose "Detaching database ${dbname}"
sqlcmd -d master -Q "EXEC master.dbo.sp_detach_db @dbname = N'${dbname}', @skipchecks = 'false'"

$acl = Get-Acl C:\
Get-ChildItem ${datadir} | Set-Acl -AclObject $acl

Write-Verbose "Stopping SQL Server"
Stop-Service MSSQLSERVER

Write-Verbose "Phase 1 complete"
