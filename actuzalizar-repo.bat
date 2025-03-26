@echo off
echo ====================================
echo   Actualizando Repositorio Git
echo ====================================

:: Cambiar al directorio donde está el repositorio (útil si el script se ejecuta desde otro lugar)
cd /d %~dp0

:: Verificar si estamos en un repositorio Git
git rev-parse --is-inside-work-tree >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: No estás dentro de un repositorio Git.
    goto :end
)

:: Comprobar si hay cambios
echo Verificando cambios...
git diff --quiet --exit-code
if %ERRORLEVEL% neq 0 (
    :: Hay cambios sin commitear
    echo Cambios detectados en el repositorio!
    
    :: Añadir todos los cambios
    git add -A
    
    :: Generar mensaje de commit automático con fecha, hora y nombre de usuario
    set commit_msg=Actualización por %USERNAME% - %date% %time%
    
    :: Hacer commit con el mensaje automático
    echo Haciendo commit: "%commit_msg%"
    git commit -m "%commit_msg%"
    
    :: Si hay errores en el commit, abortar
    if %ERRORLEVEL% neq 0 (
        echo ERROR: No se pudo hacer commit de los cambios.
        goto :end
    )
    
    echo Commit realizado con éxito!
) else (
    echo No se detectaron cambios locales.
)

:: Obtener cambios remotos
echo Obteniendo cambios del repositorio remoto...
git pull
if %ERRORLEVEL% neq 0 (
    echo ADVERTENCIA: No se pudieron obtener los cambios remotos.
    echo Puede haber conflictos que requieran resolución manual.
)

:: Enviar cambios locales al remoto
echo Enviando cambios al repositorio remoto...
git push
if %ERRORLEVEL% neq 0 (
    echo ADVERTENCIA: No se pudieron enviar los cambios al repositorio remoto.
    echo Verifica tu conexión y permisos.
)

echo ====================================
echo   Repositorio actualizado!
echo ====================================

:end
:: Pausa para ver los resultados
pause
