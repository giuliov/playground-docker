# escape=` (backtick)

FROM microsoft/mssql-server-windows-developer as sqlraw

LABEL maintainer "Giulio Vian"

SHELL ["powershell", "-File"]

WORKDIR /work
# copy script
COPY ./restore.ps1 /work
# copy backup files inside throwaway container
COPY ./Tfs_Viewpoint.bak /work
COPY ./Tfs_Viewpoint.trn /work

RUN .\restore.ps1  -backupdir C:\work -datadir C:\data -dbname Tfs_Viewpoint




FROM microsoft/mssql-server-windows-developer

LABEL maintainer "Giulio Vian"

SHELL ["powershell", "-File"]

WORKDIR /work
# copy script
COPY ./setup_all.ps1 /work

# COPY --from=sqlraw ["C:\\data\\Tfs_Viewpoint.mdf","C:\\data\\Tfs_Viewpoint_log.ldf", "C:\\data"]
# COPY --from=sqlraw C:\data C:\data
# COPY --from=sqlraw ["C:\\data","C:\\data"]
# COPY --from=sqlraw C:\data\*.* /work
COPY --from=sqlraw ["C:\\data\\Tfs_Viewpoint.mdf","C:\\data\\Tfs_Viewpoint_log.ldf", "C:\\work\\"]

RUN .\setup_all.ps1 -datadir C:\\work -dbname Tfs_Viewpoint

# the base image assumes to be in root folder to start correctly
WORKDIR /

