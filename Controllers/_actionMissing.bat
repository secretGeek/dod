@echo off
call ..\Views\Shared\_header Action Missing
call ..\h\h1 Action Missing
echo [p]Controller = %1[/p]
echo [p]Action = %2[/p]
echo [p]Parameters = %*[/p]
echo [p]Available Actions to GET for this controller...[p]
echo [blockquote][pre]
echo [OL]
   FOR /F "delims=~" %%A IN (' DIR %1\*.bat /B/a:-d') DO (
       echo [A href='%%~nA']%%~nA[/A]
   )
echo [/OL]
echo [/blockquote][/pre]

echo [p]Available Actions to POST for this controller...[p]
echo [blockquote][pre]
echo [OL]
   FOR /F "delims=~" %%A IN (' DIR %1\*.cmd /B/a:-d') DO (
       echo [A href='%%~nA']%%~nA[/A]
   )
echo [/OL]
echo [/blockquote][/pre]

exit 44