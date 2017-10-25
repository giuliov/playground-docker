# escape=` (backtick)

FROM microsoft/mssql-server-windows-developer

LABEL maintainer "Giulio Vian"

SHELL ["powershell", "-File"]

WORKDIR /work
ADD . /work

RUN .\setup_all.ps1 -datadir C:\data -dbname prova

# the base image assumes to be in root folder to start correctly
WORKDIR /