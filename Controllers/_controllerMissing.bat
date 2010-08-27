@echo off
call ..\Views\Shared\_header Controller Missing
call ..\h\h1 Controller Missing
echo [p]Controller = %1[/p]
echo [p]Action = %2[/p]
echo [p]Parameters = %*[/p]
echo [p]Available controllers...[/p]
echo [blockquote][pre]
echo [OL]
   FOR /F "delims=~" %%A IN (' DIR /B/a:d') DO (
       echo [A href='%%A/']%%A[/A]
   )
echo [/OL]
echo [/blockquote][/pre]

exit 44