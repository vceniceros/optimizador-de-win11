@echo off
title OPTIMIZADOR DE SISTEMA - MENU DE FASES
setlocal ENABLEEXTENSIONS

:MENU
cls
echo ============================================================
echo              OPTIMIZADOR DE SISTEMA - MENU PRINCIPAL
echo ============================================================
echo.
echo   [0] Fase 0 - Diagnostico del sistema
echo   [1] Fase 1 - Borrar archivos temporales
echo   [2] Fase 2 - Desactivar servicios innecesarios
echo   [3] Fase 3 - Ajustar apariencia para rendimiento
echo   [4] Fase 4 - Desactivar aplicaciones en segundo plano
echo   [5] Fase 5 - Mantenimiento profundo
echo   [6] Ejecutar TODAS las fases (1-5)
echo   [7] Salir
echo.
set /p opcion=Selecciona una opcion (0-7): 

if "%opcion%"=="0" goto FASE0
if "%opcion%"=="1" goto FASE1
if "%opcion%"=="2" goto FASE2
if "%opcion%"=="3" goto FASE3
if "%opcion%"=="4" goto FASE4
if "%opcion%"=="5" goto FASE5
if "%opcion%"=="6" goto TODO
if "%opcion%"=="7" goto SALIR

echo.
echo Opcion invalida. Intenta de nuevo.
pause
goto MENU


::============================================================
:: FASE 0 - DIAGNOSTICO DEL SISTEMA
::============================================================
:FASE0
cls
echo ============================================================
echo                 FASE 0 - DIAGNOSTICO DEL SISTEMA
echo ============================================================
echo.

echo === INFORMACION DE CPU ===
wmic cpu get Name,NumberOfCores,NumberOfLogicalProcessors,LoadPercentage /format:list
echo.
echo === INFORMACION DE MEMORIA (RAM) ===
wmic OS get TotalVisibleMemorySize,FreePhysicalMemory /format:list
echo.
echo === USO DE DISCO ===
wmic logicaldisk get name,description,freespace,size
echo.
echo === LECTURA / ESCRITURA DE DISCO (aproximado) ===
wmic path Win32_PerfFormattedData_PerfDisk_PhysicalDisk get Name,DiskReadsPerSec,DiskWritesPerSec,PercentDiskTime
echo.
echo Diagnostico completado.
pause
goto MENU


::============================================================
:: FASE 1 - LIMPIEZA DE TEMPORALES
::============================================================
:FASE1
cls
echo =================================================
echo ======= INICIANDO FASE 1 BORRANDO TEMPORALES ====
echo =================================================
echo.

echo ============[1/6] limpiando: %%TEMP%% ================
RD /S /Q "%TEMP%" 2>nul
DEL /F /S /Q "%TEMP%\*" 2>nul
timeout /t /nobreak 4 /nobreak

echo ============[2/6] limpiando: C:\Windows\Temp =========
RD /S /Q "C:\Windows\Temp" 2>nul
DEL /F /S /Q "C:\Windows\Temp\*" 2>nul
timeout /t /nobreak 4 /nobreak

echo ============[3/6] limpiando: Prefetch ===============
RD /S /Q "C:\Windows\Prefetch" 2>nul
DEL /F /S /Q "C:\Windows\Prefetch\*" 2>nul
timeout /t /nobreak 4 /nobreak

echo ============[4/6] limpiando: Spool\Printers =========
net stop spooler >nul 2>&1
RD /S /Q "%systemroot%\System32\spool\PRINTERS" 2>nul
DEL /F /S /Q "%systemroot%\System32\spool\PRINTERS\*" 2>nul
timeout /t /nobreak 4 /nobreak
net start spooler >nul 2>&1
timeout /t /nobreak 4 /nobreak

echo ============[5/6] limpiando temporales de actualizacion ===
RD /S /Q "C:\Windows\SoftwareDistribution\Download" 2>nul
DEL /F /S /Q "C:\Windows\SoftwareDistribution\Download\*" 2>nul
timeout /t /nobreak 4 /nobreak


echo ============[6/6] ejecutando clean mgr =================
cleanmgr /d C
timeout /t /nobreak 4 /nobreak


echo Limpieza de temporales completada correctamente.

pause
goto MENU


::============================================================
:: FASE 2 - DESACTIVAR SERVICIOS
::============================================================
:FASE2
cls
echo =================================================
echo ======= INICIANDO FASE 2 DESACTIVANDO SERVICIOS ===
echo =================================================
echo.

net stop SysMain 2>nul
sc config SysMain start= disabled
net stop Diagtrack 2>nul
sc config DiagTrack start= disabled

for %%S in (XblAuthManager XblGameSave XboxNetApiSvc XboxGipSvc) do (
    net stop %%S 2>nul
    sc config %%S start= disabled
)

echo Servicios innecesarios deshabilitados correctamente.
pause
goto MENU


::============================================================
:: FASE 3 - AJUSTAR APARIENCIA
::============================================================
:FASE3
cls
echo =================================================
echo ======= INICIANDO FASE 3 AJUSTES VISUALES ========
echo =================================================
echo.

REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "2" /f >nul
for %%K in (CursorShadow DWM_Animations FontSmoothing HotTracking ListviewAlphaSelect ListviewShadow ShowApps ShowTaskbarThumbal SlideTaskbar TaskbarAnimations Themes VisualStyles AnimateOpen EnableAnimations Shadows SmoothScroll AnimateWindows) do (
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "%%K" /t REG_DWORD /d "0" /f >nul
)
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 5 /nobreak >nul
start explorer.exe

echo Ajuste visual completado con exito.
pause
goto MENU


::============================================================
:: FASE 4 - DESACTIVAR APPS EN SEGUNDO PLANO
::============================================================
:FASE4
cls
echo =================================================
echo ======= FASE 4 DESACTIVAR APPS EN SEGUNDO PLANO ===
echo =================================================
echo.

REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f >nul

echo Aplicaciones en segundo plano deshabilitadas correctamente.
pause
goto MENU


::============================================================
:: FASE 5 - MANTENIMIENTO PROFUNDO
::============================================================
:FASE5
cls
echo =================================================
echo ======= FASE 5 MANTENIMIENTO PROFUNDO ============
echo =================================================
echo.

echo ===[1/3]Programando verificación de disco...
chkdsk C: /r
echo ===[2/3]Defragmentando disco
defrag c: /w  
echo.
echo ===[3/3]Ejecutando comprobación de archivos del sistema...
sfc /scannow

echo.
echo Mantenimiento completado.
call :FIN
pause
goto MENU

::============================================================
:: OPTIMIZACION AUTOMATICAMENTE LA PC
::============================================================


::============================================================
:: FASE 1 - LIMPIEZA DE TEMPORALES
::============================================================
:FASE1AUTOMATICA
cls
echo =================================================
echo ======= INICIANDO FASE 1 BORRANDO TEMPORALES ====
echo =================================================
echo.

echo ============[1/6] limpiando: %%TEMP%% ================
RD /S /Q "%TEMP%" 2>nul
DEL /F /S /Q "%TEMP%\*" 2>nul
timeout /t /nobreak 4 /nobreak

echo ============[2/6] limpiando: C:\Windows\Temp =========
RD /S /Q "C:\Windows\Temp" 2>nul
DEL /F /S /Q "C:\Windows\Temp\*" 2>nul
timeout /t /nobreak 4 /nobreak

echo ============[3/6] limpiando: Prefetch ===============
RD /S /Q "C:\Windows\Prefetch" 2>nul
DEL /F /S /Q "C:\Windows\Prefetch\*" 2>nul
timeout /t /nobreak 4 /nobreak

echo ============[4/6] limpiando: Spool\Printers =========
net stop spooler >nul 2>&1
RD /S /Q "%systemroot%\System32\spool\PRINTERS" 2>nul
DEL /F /S /Q "%systemroot%\System32\spool\PRINTERS\*" 2>nul
timeout /t /nobreak 4 /nobreak
net start spooler >nul 2>&1
timeout /t /nobreak 4 /nobreak

echo ============[5/6] limpiando temporales de actualizacion ===
RD /S /Q "C:\Windows\SoftwareDistribution\Download" 2>nul
DEL /F /S /Q "C:\Windows\SoftwareDistribution\Download\*" 2>nul
timeout /t /nobreak 4 /nobreak


echo ============[6/6] ejecutando clean mgr =================
cleanmgr /d C
timeout /t /nobreak 4 /nobreak


echo Limpieza de temporales completada correctamente.




::============================================================
:: FASE 2 - DESACTIVAR SERVICIOS
::============================================================
:FASE2AUTOMATICA
cls
echo =================================================
echo ======= INICIANDO FASE 2 DESACTIVANDO SERVICIOS ===
echo =================================================
echo.

timeout /t /nobreak 4
net stop SysMain 2>nul
sc config SysMain start= disabled

timeout /t /nobreak 4
net stop Diagtrack 2>nul
sc config DiagTrack start= disabled

timeout /t /nobreak 4
for %%S in (XblAuthManager XblGameSave XboxNetApiSvc XboxGipSvc) do (
    net stop %%S 2>nul
    sc config %%S start= disabled
)
timeout /t /nobreak 4
echo Servicios innecesarios deshabilitados correctamente.


::============================================================
:: FASE 3 - AJUSTAR APARIENCIA
::============================================================
:FASE3AUTOMATICA
cls
echo =================================================
echo ======= INICIANDO FASE 3 AJUSTES VISUALES ========
echo =================================================
echo.
timeout /t /nobreak 4
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "2" /f >nul
for %%K in (CursorShadow DWM_Animations FontSmoothing HotTracking ListviewAlphaSelect ListviewShadow ShowApps ShowTaskbarThumbal SlideTaskbar TaskbarAnimations Themes VisualStyles AnimateOpen EnableAnimations Shadows SmoothScroll AnimateWindows) do (
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "%%K" /t REG_DWORD /d "0" /f >nul
)
timeout /t /nobreak 4
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 5 /nobreak >nul
start explorer.exe

echo Ajuste visual completado con exito.


::============================================================
:: FASE 4 - DESACTIVAR APPS EN SEGUNDO PLANO
::============================================================
:FASE4AUTOMATICA
cls
echo =================================================
echo ======= FASE 4 DESACTIVAR APPS EN SEGUNDO PLANO ===
echo =================================================
echo.

REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f >nul

echo Aplicaciones en segundo plano deshabilitadas correctamente.



::============================================================
:: FASE 5 - MANTENIMIENTO PROFUNDO
::============================================================
:FASE5AUTOMATICA
cls
echo =================================================
echo ======= FASE 5 MANTENIMIENTO PROFUNDO ============
echo =================================================
echo.

echo ===[1/3] Programando verificación de disco...
echo S | chkdsk C: /r
echo ===[2/3]Defragmentando disco
defrag c: /w  
echo.
echo ===[3/3]Ejecutando comprobación de archivos del sistema...
sfc /scannow

echo.
echo Mantenimiento completado.
call :FIN



::============================================================
:: EJECUTAR TODAS LAS FASES (1–5)
::============================================================
:TODO
call :FASE1AUTOMATICA
call :FASE2AUTOMATICA
call :FASE3AUTOMATICA
call :FASE4AUTOMATICA
call :FASE5AUTOMATICA
call :FIN 


::============================================================
:: SALIR
::============================================================
:SALIR
echo Saliendo del programa...
timeout /t 2 >nul
exit


::============================================================
:: FIN
::============================================================
:FIN
echo.
echo ========================================================
echo ===OPTIMIZACION Y MANTENIMIENTO COMPLETADO CON EXITO===
echo ========================================================
echo.
echo El sistema se reiniciara automaticamente en 10 segundos.
echo Presione CTRL+C para cancelar.
shutdown /r /t 10
pause
exit

