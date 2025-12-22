@echo off
title OPTIMIZADOR DE SISTEMA V3 - PRO EDITION
setlocal ENABLEEXTENSIONS

:MENU_PRINCIPAL
cls
echo ============================================================
echo          OPTIMIZADOR DE SISTEMA - MENU PRINCIPAL
echo ============================================================
echo.
echo   [1] OPTIMIZACION LITE (usar para limpieza rapida)
echo       * Limpieza temporal basica, servicios, visuales y apps.
echo       * usar preferentemente remotamente.
echo.
echo   [2] OPTIMIZACION PROFUNDA (idealmente usar en la oficina)
echo       * Todo lo anterior + Limpieza de Windows Update +
echo       * Reparacion de imagen (DISM) + SFC + CHKDSK.
echo       * Tarda entorno a 1 hora o mas.
echo.
echo   [3] MODO DEV (NO USAR)
echo       * Menu de pruebas.
echo.
echo   [4] SALIR
echo.
set /p opcion=Selecciona una opcion (1-4): 

if "%opcion%"=="1" goto AUTO_LITE
if "%opcion%"=="2" goto AUTO_PROFUNDA
if "%opcion%"=="3" goto MENU_DEV
if "%opcion%"=="4" goto SALIR

echo Opcion invalida.
pause
goto MENU_PRINCIPAL

::============================================================
:: RUTINAS AUTOMATICAS
::============================================================

:AUTO_LITE
cls
echo INICIANDO MODO LITE...
call :FASE1_BASIC
call :FASE2
call :FASE3
call :FASE4
goto FIN_REINICIO

:AUTO_PROFUNDA
cls
echo INICIANDO MODO PROFUNDO...
call :FASE1_BASIC
call :FASE1_ADVANCED
call :FASE2
call :FASE3
call :FASE4
call :FASE5
goto FIN_REINICIO


::============================================================
:: MENU DEV
::============================================================
:MENU_DEV
cls
echo =================================================
echo             MODO DESARROLLADOR
echo =================================================
echo.
echo   [0] Fase 0 - Diagnostico 
echo   [1] Fase 1 - Limpieza Basica 
echo   [2] Fase 1 - Limpieza Avanzada
echo   [3] Fase 2 - Servicios 
echo   [4] Fase 3 - Visuales 
echo   [5] Fase 4 - Apps en Segundo Plano
echo   [6] Fase 5 - Reparacion 
echo   [7] VOLVER AL MENU PRINCIPAL
echo.
set /p devop=Selecciona fase a probar: 

if "%devop%"=="0" ( call :FASE0 & pause & goto MENU_DEV )
if "%devop%"=="1" ( call :FASE1_BASIC & pause & goto MENU_DEV )
if "%devop%"=="2" ( call :FASE1_ADVANCED & pause & goto MENU_DEV )
if "%devop%"=="3" ( call :FASE2 & pause & goto MENU_DEV )
if "%devop%"=="4" ( call :FASE3 & pause & goto MENU_DEV )
if "%devop%"=="5" ( call :FASE4 & pause & goto MENU_DEV )
if "%devop%"=="6" ( call :FASE5 & pause & goto MENU_DEV )
if "%devop%"=="7" goto MENU_PRINCIPAL

goto MENU_DEV


::============================================================
:: BLOQUES DE FUNCIONES 
::============================================================

:FASE0
echo.
echo === DIAGNOSTICO DE SISTEMA ===
wmic cpu get Name,LoadPercentage /format:list
wmic OS get FreePhysicalMemory /format:list
wmic logicaldisk get name,freespace,size
goto :EOF

:FASE1_BASIC
echo.
echo === FASE 1: LIMPIEZA BASICA DE ARCHIVOS ===
echo ...Limpiando %%TEMP%%
RD /S /Q "%TEMP%" 2>nul
DEL /F /S /Q "%TEMP%\*" 2>nul
timeout /t 3 /nobreak >nul
echo ...Limpiando Windows Temp
RD /S /Q "C:\Windows\Temp" 2>nul
DEL /F /S /Q "C:\Windows\Temp\*" 2>nul
timeout /t 3 /nobreak >nul
echo ...Limpiando Prefetch
RD /S /Q "C:\Windows\Prefetch" 2>nul
DEL /F /S /Q "C:\Windows\Prefetch\*" 2>nul
timeout /t 3 /nobreak >nul
echo ...Limpiando Spooler
net stop spooler >nul 2>&1
RD /S /Q "%systemroot%\System32\spool\PRINTERS" 2>nul
DEL /F /S /Q "%systemroot%\System32\spool\PRINTERS\*" 2>nul
net start spooler >nul 2>&1
echo Limpieza basica terminada.
goto :EOF

:FASE1_ADVANCED
echo.
echo === FASE 1: LIMPIEZA BASICA DE ARCHIVOS ===
echo ...Limpiando %%TEMP%%
RD /S /Q "%TEMP%" 2>nul
DEL /F /S /Q "%TEMP%\*" 2>nul
timeout /t 3 /nobreak >nul
echo ...Limpiando Windows Temp
RD /S /Q "C:\Windows\Temp" 2>nul
DEL /F /S /Q "C:\Windows\Temp\*" 2>nul
timeout /t 3 /nobreak >nul
echo ...Limpiando Prefetch
RD /S /Q "C:\Windows\Prefetch" 2>nul
DEL /F /S /Q "C:\Windows\Prefetch\*" 2>nul
timeout /t 3 /nobreak >nul
echo ...Limpiando Spooler
net stop spooler >nul 2>&1
RD /S /Q "%systemroot%\System32\spool\PRINTERS" 2>nul
DEL /F /S /Q "%systemroot%\System32\spool\PRINTERS\*" 2>nul
net start spooler >nul 2>&1echo 
echo ...Inyectando claves de registro para automatizacion
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Update Cleanup" /v StateFlags0001 /t REG_DWORD /d 2 /f >nul 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Upgrade Discarded Files" /v StateFlags0001 /t REG_DWORD /d 2 /f >nul 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Internet Cache Files" /v StateFlags0001 /t REG_DWORD /d 2 /f >nul 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Recycle Bin" /v StateFlags0001 /t REG_DWORD /d 2 /f >nul 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Temporary Files" /v StateFlags0001 /t REG_DWORD /d 2 /f >nul 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\Thumbnail Cache" /v StateFlags0001 /t REG_DWORD /d 2 /f >nul 2>&1
REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches\DirectX Shader Cache" /v StateFlags0001 /t REG_DWORD /d 2 /f >nul 2>&1
echo ...Ejecutando CleanMgr (esto puede tardar)
cleanmgr /sagerun:1
timeout /t 3 /nobreak >nul
echo Limpieza avanzada terminada.
goto :EOF

:FASE2
echo.
echo === FASE 2: OPTIMIZACION DE SERVICIOS ===
net stop SysMain 2>nul
sc config SysMain start= disabled
net stop Diagtrack 2>nul
sc config DiagTrack start= disabled
for %%S in (XblAuthManager XblGameSave XboxNetApiSvc XboxGipSvc) do (
    net stop %%S 2>nul
    sc config %%S start= disabled
)
echo Servicios ajustados.
goto :EOF

:FASE3
echo.
echo === FASE 3: AJUSTES VISUALES ===
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "2" /f >nul
for %%K in (CursorShadow DWM_Animations FontSmoothing HotTracking ListviewAlphaSelect ListviewShadow ShowApps ShowTaskbarThumbal SlideTaskbar TaskbarAnimations Themes VisualStyles AnimateOpen EnableAnimations Shadows SmoothScroll AnimateWindows) do (
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "%%K" /t REG_DWORD /d "0" /f >nul
)
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 3 /nobreak >nul
start explorer.exe
echo Visuales ajustados.
goto :EOF

:FASE4
echo.
echo === FASE 4: APPS EN SEGUNDO PLANO ===
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "GlobalUserDisabled" /t REG_DWORD /d "1" /f >nul
echo Apps segundo plano desactivadas.
goto :EOF

:FASE5
echo.
echo === FASE 5: REPARACION PROFUNDA ===
echo ...Programando CHKDSK para reinicio
echo S | chkdsk C: /r >nul
echo ...Defragmentando (rapido)
defrag c: /w
echo ...Restaurando imagen de Windows (DISM) - Paciencia...
DISM /Online /Cleanup-Image /RestoreHealth
echo ...Verificando integridad (SFC)
sfc /scannow
echo Mantenimiento profundo terminado.
goto :EOF

::============================================================
:: SALIDA Y REINICIO
::============================================================

:FIN_REINICIO
echo.
echo ========================================================
echo        OPTIMIZACION COMPLETADA CON EXITO
echo ========================================================
echo El sistema se reiniciara en 15 segundos.
echo Presione CTRL+C para cancelar o cierre la ventana.
shutdown /r /t 15
pause
exit

:SALIR
echo Saliendo...
timeout /t 1 >nul
exit
