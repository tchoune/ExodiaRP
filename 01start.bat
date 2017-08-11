@echo off
cls

TIMEOUT /T 1
cd C:\Serveur-GTA
TIMEOUT /T 1
run.cmd +exec server.cfg
pause >nul