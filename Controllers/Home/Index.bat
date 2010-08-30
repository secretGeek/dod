@echo off
call ..\..\Views\Shared\_header DoD Congratulations
call ..\..\h\h1 Congratulations
echo [p]You've put [strong]DOS on DOPE[/strong][/p]
echo.
echo [p]Available controllers...[/p]
echo [blockquote]
echo [ul]   
pushd %cd%
cd ..
   FOR /F "delims=~" %%A IN (' DIR /B/a:d') DO (
      echo [li][a href='%%A/']%%A[/a][/li]
   )
echo [/ul]
echo [/blockquote]
echo [p]To Add a controller, navigate to:[/p]
echo [blockquote][pre]%cd%] [/pre][/blockquote]
popd

echo [p]and type:[/p]

echo [blockquote][pre]Dope Controller [em]ControllerName[/em][/pre][/blockquote]
echo.
echo [p]To change this default controller, edit:[/p]
echo [blockquote][pre]"%cd%\Index.bat"[/pre][/blockquote]

echo [p]To create new actions, add batchfiles to this folder, e.g. [/p]
echo [blockquote][pre]%cd%]Copy con About.bat
echo echo [[p]]Hello world![[/p]]
echo [[ctrl-Z]][/pre][/blockquote]


