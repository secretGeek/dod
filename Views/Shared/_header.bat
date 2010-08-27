@echo off
echo [html]
echo [head]
echo [style]body{background-color:#000;color:#AAA;font-family:monospace}input,textarea{background-color:#222;color:#FFF}[/style]

IF x"%*"==x""  	GOTO DEFAULT

echo [title]%*[/title]

goto END

:DEFAULT
echo [title]DosOnDope[/title]
goto END

:END
echo [/head]
echo [body]
echo [img src='Content/Logo.png' style='float:right' /]