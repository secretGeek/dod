@echo off
FOR %%B IN ("%~1") DO (
    FOR /F "delims=~" %%A IN ('ECHO %%B^> ~%%B ^& DIR /L /B ~%%B') DO (
        SET LoCaseText=%%A
        DEL /Q ~%%B
    )
)
ECHO %LoCaseText%