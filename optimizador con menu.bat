@echo off
title OPTIMIZADOR DE SISTEMA - MENU PRINCIPAL
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: ===== VARIABLES DE LOG =====
set "LOG_DIR=%~dp0logs"
set "PRE_LOG=%LOG_DIR%\pre_optimización.log"
set "POST_LOG=%LOG_DIR%\post_optimización.log"
set "FLAG_FILE=%LOG_DIR%\post_reinicio.flag"

if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

:: ===== DETECTAR POST REINICIO =====
if exist "%FLAG_FILE%" (
    echo ==============================================
    echo     POST OPTIMIZACIÓN - EJECUTANDO DIAGNÓSTICO
    echo ==============================================
    echo [%date% %time%] Diagnóstico post optimización >> "%POST_LOG%"
    call :DIAGNOSTICO >> "%POST_LOG%"
    del "%FLAG_FILE%"
    echo Log guardado en "%POST_LOG%"
    echo.
    pause
    exit /b
)

:: ===== MENU PRINCIPAL =====
:MENU_PRINCIPAL
cls
echo ============================================================
echo              OPTIMIZADOR DE SISTEMA - MENU PRINCIPAL
echo ============================================================
echo.
echo   [1] Optimizacion MANUAL (por fases)
echo   [2] Optimizacion AUTOMÁTICA (con reinicio)
echo   [3] Salir
echo.
set /p opcion=Selecciona una opcion (1-3): 

if "%opcion%"=="1" goto MENU_FASES
if "%opcion%"=="2" goto OPTIMIZACION_AUTOMATICA
if "%opcion%"=="3" goto SALIR

echo.
echo Opcion invalida. Intenta de nuevo.
pause
goto MENU_PRINCIPAL


:: ============================================================
:: MENU DE FASES MANUAL (sin diagnostico ni "todas las fases")
:: ============================================================
:MENU_FASES
cls
echo ============================================================
echo        OPTIMIZADOR DE SISTEMA - MODO MANUAL POR FASES
echo ============================================================
echo.
echo   [1] Fase 1 - Borrar archivos temporales
echo   [2] Fase 2 - Desactivar servicios innecesarios
echo   [3] Fase 3 - Ajustar apariencia para rendimiento
echo   [4] Fase 4 - Desactivar aplicaciones en segundo plano
echo   [5] Fase 5 - Mantenimiento profundo
echo   [6] Volver al menú principal
echo.
set /p opcion=Selecciona una opcion (1-6): 

if "%opcion%"=="1" goto FASE1
if "%opcion%"=="2" goto FASE2
if "%opcion%"=="3" goto FASE3
if "%opcion%"=="4" goto FASE4
if "%opcion%"=="5" goto FASE5
if "%opcion%"=="6" goto MENU_PRINCIPAL

echo.
echo Opcion invalida. Intenta de nuevo.
pause
goto MENU_FASES


:: ============================================================
:: OPTIMIZACIÓN AUTOMÁTICA (con diagnóstico)
:: ============================================================
:OPTIMIZACION_AUTOMATICA
cls
echo ============================================================
echo         INICIANDO OPTIMIZACION AUTOMÁTICA
echo ============================================================
echo.

:: Guardar diagnóstico previo
echo [%date% %time%] Diagnóstico pre optimización >> "%PRE_LOG%"
call :DIAGNOSTICO >> "%PRE_LOG%"
echo Diagnóstico previo guardado en "%PRE_LOG%"
echo.

:: Ejecutar todas las fases automáticas
call :FASE1AUTOMATICA
call :FASE2AUTOMATICA
call :FASE3AUTOMATICA
call :FASE4AUTOMATICA
call :FASE5AUTOMATICA

:: Crear flag para diagnóstico post-reinicio
echo flag > "%FLAG_FILE%"

echo.
echo Optimizacion completada. El sistema se reiniciará en 10 segundos...
shutdown /r /t 10 /c "Optimizacion completada. El sistema se reiniciará para finalizar."
exit /b


:: ============================================================
:: FUNCIÓN DE DIAGNÓSTICO
:: ============================================================
:DIAGNOSTICO
echo ==============================================
echo INFORME DE DIAGNÓSTICO DEL SISTEMA
echo Fecha: %date% - Hora: %time%
echo ==============================================
echo.
echo --- INFORMACIÓN DE CPU ---
wmic cpu get Name,NumberOfCores,NumberOfLogicalProcessors,LoadPercentage /format:list
echo.
echo --- INFORMACIÓN DE MEMORIA ---
wmic OS get TotalVisibleMemorySize,FreePhysicalMemory /format:list
echo.
echo --- DISCO ---
wmic logicaldisk get name,description,freespace,size
echo.
echo --- LECTURA/ESCRITURA DISCO ---
wmic path Win32_PerfFormattedData_PerfDisk_PhysicalDisk get Name,DiskReadsPerSec,DiskWritesPerSec,PercentDiskTime
echo.
echo --- PROCESOS PRINCIPALES ---
tasklist /nh | sort
echo.
echo --- SERVICIOS EN EJECUCIÓN ---
sc query | find "RUNNING"
echo.
echo --- CONEXIONES ACTIVAS ---
netstat -an | find "ESTABLISHED"
echo.
exit /b


::============================================================
:: FASE 1 - LIMPIEZA DE TEMPORALES
::============================================================
:FASE1
cls
echo =================================================
echo ======= INICIANDO FASE 1 BORRANDO TEMPORALES ====
echo =================================================
echo.

echo ============[1/4] limpiando: %%TEMP%% ================
RD /S /Q "%TEMP%" 2>nul
DEL /F /S /Q "%TEMP%\*" 2>nul

echo ============[2/4] limpiando: C:\Windows\Temp =========
RD /S /Q "C:\Windows\Temp" 2>nul
DEL /F /S /Q "C:\Windows\Temp\*" 2>nul

echo ============[3/4] limpiando: Prefetch ===============
RD /S /Q "C:\Windows\Prefetch" 2>nul
DEL /F /S /Q "C:\Windows\Prefetch\*" 2>nul

echo ============[4/4] limpiando: Spool\Printers =========
net stop spooler >nul 2>&1
RD /S /Q "%systemroot%\System32\spool\PRINTERS" 2>nul
DEL /F /S /Q "%systemroot%\System32\spool\PRINTERS\*" 2>nul
net start spooler >nul 2>&1

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

echo ===[1/2]Programando verificación de disco...
chkdsk C: /r
echo.
echo ===[2/2]Ejecutando comprobación de archivos del sistema...
sfc /scannow

echo.
echo Mantenimiento completado.
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

echo ============[1/4] limpiando: %%TEMP%% ================
RD /S /Q "%TEMP%" 2>nul
DEL /F /S /Q "%TEMP%\*" 2>nul

timeout /t 4

echo ============[2/4] limpiando: C:\Windows\Temp =========
RD /S /Q "C:\Windows\Temp" 2>nul
DEL /F /S /Q "C:\Windows\Temp\*" 2>nul

timeout /t 4

echo ============[3/4] limpiando: Prefetch ===============
RD /S /Q "C:\Windows\Prefetch" 2>nul
DEL /F /S /Q "C:\Windows\Prefetch\*" 2>nul

timeout /t 4

echo ============[4/4] limpiando: Spool\Printers =========
net stop spooler >nul 2>&1
timeout /t 4
RD /S /Q "%systemroot%\System32\spool\PRINTERS" 2>nul
DEL /F /S /Q "%systemroot%\System32\spool\PRINTERS\*" 2>nul
timeout /t 4
net start spooler >nul 2>&1


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

timeout /t 4
net stop SysMain 2>nul
sc config SysMain start= disabled

timeout /t 4
net stop Diagtrack 2>nul
sc config DiagTrack start= disabled

timeout /t 4
for %%S in (XblAuthManager XblGameSave XboxNetApiSvc XboxGipSvc) do (
    net stop %%S 2>nul
    sc config %%S start= disabled
)
timeout /t 4
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
timeout /t 4
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "VisualFXSetting" /t REG_DWORD /d "2" /f >nul
for %%K in (CursorShadow DWM_Animations FontSmoothing HotTracking ListviewAlphaSelect ListviewShadow ShowApps ShowTaskbarThumbal SlideTaskbar TaskbarAnimations Themes VisualStyles AnimateOpen EnableAnimations Shadows SmoothScroll AnimateWindows) do (
    REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v "%%K" /t REG_DWORD /d "0" /f >nul
)
timeout /t 4
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

echo ===[1/2] Programando verificación de disco...
echo S | chkdsk C: /r
echo.
echo ===[1/2]Ejecutando comprobación de archivos del sistema...
sfc /scannow

echo.
echo Mantenimiento completado.


::============================================================
:: SALIR
::============================================================
:SALIR
echo Saliendo del programa...
timeout /t 2 >nul
exit
