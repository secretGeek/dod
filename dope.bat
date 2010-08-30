@echo off

SET LOCN="%~dp0"

if x'%2'==x'/?' goto COMMAND_HELP
if x'%2'==x'?'goto COMMAND_HELP
if x'%2'==x'-?'goto COMMAND_HELP
if x'%2'==x'--?'goto COMMAND_HELP

if x'%1'==x'' goto UNKNOWN
if '%1'=='site' goto SITE
if '%1'=='controller' goto CONTROLLER
if '%1'=='gen' goto GEN
if '%1'=='help' goto HELP
if '%1'=='?' goto HELP
if '%1'=='/?' goto HELP
if '%1'=='-?' goto HELP
if '%1'=='--?' goto HELP
if '%1'=='SITE' goto SITE
if '%1'=='CONTROLLER' goto CONTROLLER
if '%1'=='GEN' goto GEN
if '%1'=='HELP' goto HELP
if '%1'=='Help' goto HELP

goto UNKNOWN

:COMMAND_HELP
if '%1'=='site' goto HELP_SITE
if '%1'=='controller' goto HELP_CONTROLLER
if '%1'=='model' goto HELP_MODEL
if '%1'=='gen' goto HELP_GEN
if '%1'=='help' goto HELP
if '%1'=='SITE' goto HELP_SITE
if '%1'=='CONTROLLER' goto HELP_CONTROLLER
if '%1'=='MODEL' goto HELP_MODEL
if '%1'=='GEN' goto HELP_GEN
if '%1'=='HELP' goto HELP

ECHO Unknown command %1
GOTO HELP

:HELP_SITE

echo dope SITE [[name]] 
echo   will create a SITE named 'name'
echo   in the current folder.
echo e.g:
echo dope SITE Blog
echo   will create a site named 'Blog'
echo.
echo The site will, by default, include
echo sufficient files (styles, helpers etc)
echo to get you started.
echo.
echo A good next step is to create a controller
echo using the 'dope CONTROLLER' command

goto EXIT
:HELP_CONTROLLER

echo dope CONTROLLER [[name]] 
echo   Create a CONTROLLER named 'name'
echo   in the SITE\Controllers\ folder
echo e.g.
echo dope CONTROLLER About
echo   Creates a controller folder named 'About'
echo   in the current site's 'Controllers' folder
echo   containing a default action, 'Index.bat'
echo   To navigate to the new action goto
echo     http://YourSite/About/
echo   or 
echo     http://YourSite/About/Index
echo.
echo To create more actions, navigate into
echo the newly created folder and create more
echo batch files. No wiring required.
goto EXIT
:HELP_GEN

echo dope GEN [[name]] [[controller]]
echo   Generate actions for the model named 'name'
echo   (singular) in the controller specified.
echo.
echo (The controller name is optional. If no 
echo controller is specified, the default 
echo controller, 'home', will be used.)
echo.
echo Before generating the actions, you need
echo to create the model file.
goto HELP_MODEL


goto EXIT

:HELP_MODEL
echo.
echo A model file is a CSV file in the models
echo folder. The first line of the file is a 
echo lists of fields, separated with backtick `
echo characters, e.g. Emails.csv might contain:
echo ID`FirstName`LastName`Age`Email
echo. 
echo The file name is plural.

goto EXIT
:SITE
echo Creating SITE... %2
if not exist %2 MD %2
echo ...Created Content folder (for CSS and images)
if not exist %2\Content MD %2\Content
echo ...Created Controllers folder (for Controllers)
if not exist %2\Controllers MD %2\Controllers
echo ...Created Controllers\Home folder (Default Controller)
if not exist %2\Controllers\Home MD %2\Controllers\Home
echo ...Created h folder (for html helpers)
if not exist %2\h MD %2\h
echo ...Created Models folder (for Models)
if not exist %2\Models MD %2\Models
echo ...Created Scripts folder (for javascript)
if not exist %2\Scripts MD %2\Scripts
echo ...Created Views folder (for views)
if not exist %2\Views MD %2\Views
echo ...Created Views\Shared folder (for Shared views)
if not exist %2\Views\Shared MD %2\Views\Shared
echo ...Created bin folder 
if not exist %2\bin MD %2\bin

echo ...adding Web.config
Copy %LOCN%Web.config %2%\web.config

echo ...adding Default.aspx
Copy %LOCN%Default.aspx %2%\Default.aspx

echo ...adding Global.asax
Copy %LOCN%Global.asax %2%\Global.asax

echo ...adding logo and favicon
Copy %LOCN%Content\logo.png %2%\Content\logo.png
Copy %LOCN%Content\li.png %2%\Content\li.png
Copy %LOCN%favicon.ico %2%\favicon.ico

echo ...adding partial for header 
Copy %LOCN%Views\Shared\_header.bat %2%\Views\Shared\_header.bat

echo ...adding handlers for 'action missing' and 'controller missing'
Copy %LOCN%Controllers\_actionMissing.bat %2%\Controllers\_actionMissing.bat
Copy %LOCN%Controllers\_controllerMissing.bat %2%\Controllers\_controllerMissing.bat

echo ...adding default action (Index)
Copy %LOCN%Controllers\Home\Index.bat %2%\Controllers\Home\Index.bat

echo ...adding binaries
Copy %LOCN%bin\*.dll %2%\bin\


echo ...adding html helper functions
Copy %LOCN%h\*.bat %2%\h\

echo Registering http://localhost/%2 with webserver

echo SITE created.

goto EXIT

:CONTROLLER

REM First determine our location... tricky!

pushd %cd%

if NOT EXIST ..\Controllers goto NOT_IN_CONTROLLERS
if NOT EXIST ..\Models goto NOT_IN_CONTROLLERS
if NOT EXIST ..\Views goto NOT_IN_CONTROLLERS

cd ..\Controllers

goto Make_Controller

:NOT_IN_CONTROLLERS

if EXIST Controllers goto IN_ROOT
if EXIST Models goto IN_ROOT
if EXIST Views goto IN_ROOT

ECHO This command must be run from the root
ECHO of your website, or from the Controllers
ECHO folder. 
popd 
goto :EOF

goto Make_Controller

:IN_ROOT

cd Controllers
goto Make_Controller

:Make_Controller

echo Creating CONTROLLER %2...
IF NOT EXIST %2 md %2

echo Creating default action (index.bat)...

Copy %LOCN%\Controllers\Home\Index.bat %2%\Index.bat

popd

goto EXIT

:GEN


SET controller=%3
if x%3==x SET controller=Home


echo Generating actions for MODEL %2 in Controller %controller%...

REM First determine our location... tricky!

pushd %cd%

if NOT EXIST ..\..\Controllers goto KeepLooking
if NOT EXIST ..\..\Models goto KeepLooking
if NOT EXIST ..\..\Views goto KeepLooking

cd ..\..\Models

goto Gen_Model

:KeepLooking

if NOT EXIST ..\Controllers goto NOT_IN_MODELS
if NOT EXIST ..\Models goto NOT_IN_MODELS
if NOT EXIST ..\Views goto NOT_IN_MODELS

cd ..\Models

goto Gen_Model

:NOT_IN_MODELS

if EXIST Controllers goto IN_ROOT2
if EXIST Models goto IN_ROOT2
if EXIST Views goto IN_ROOT2

ECHO This command must be run from the root
ECHO of your website, or from the Models
ECHO or Controllers folder

popd 

goto :EOF

goto Gen_Model

:IN_ROOT2

cd Models

goto Gen_Model

:Gen_Model

FOR /F "eol=; tokens=1,* delims=`" %%A in (%2s.csv)  DO (
  (SET FIELDS=%%B)
  GOTO DETAILS
)

:DETAILS

cscript /nologo split.vbs %FIELDS% > "%2s.fields"

echo @echo off > ..\Controllers\%controller%\add.bat
echo call ..\..\Views\Shared\_header New %2 >> ..\Controllers\%controller%\add.bat
echo call ..\..\h\h1 New %2 >> ..\Controllers\%controller%\add.bat
echo echo [form method='POST' action='add'] >> ..\Controllers\%controller%\add.bat
echo echo [input type='hidden' id='title' name='ID' value='%2'][/input] >> ..\Controllers\%controller%\add.bat

SET /A ID=1
SET outy=".."
for /F %%C in (%2s.fields) do (
  echo echo %%C >> ..\Controllers\%controller%\add.bat
  echo echo [br /] >> ..\Controllers\%controller%\add.bat
  echo echo [input type='textbox' id='%%C' name='%%C' value='%2' style='width:350px'][/input] >> ..\Controllers\%controller%\add.bat
  echo echo [br /] >> ..\Controllers\%controller%\add.bat
  SET /A ID=%ID+1
  (SET outy=%outy%+""+%ID%)
)

echo echo [input type='submit' value='submit' /] >> ..\Controllers\%controller%\add.bat
echo echo [/form] >> ..\Controllers\%controller%\add.bat
echo echo [hr /] >> ..\Controllers\%controller%\add.bat
echo echo [a href='index']back[/a] >> ..\Controllers\%controller%\add.bat

echo @echo off > ..\Controllers\%controller%\add.cmd
echo REM Determine the next ID value... >> ..\Controllers\%controller%\add.cmd 
echo SET /A ID=1 >> ..\Controllers\%controller%\add.cmd 
echo FOR /F "eol=; tokens=1,2,3,* skip=1 delims=`" %%%%i in (..\..\Models\Posts.csv) do ( >> ..\Controllers\%controller%\add.cmd 
echo   (SET /A ID=%%ID+1) >> ..\Controllers\%controller%\add.cmd 
echo ) >> ..\Controllers\%controller%\add.cmd 

set rst=%%ID%%
SET /A UPPER=(%ID%-1)*2+1

for /L %%i in (3,2,%UPPER%) do call :Loop2 %%i 

goto :EchoResults
:Loop2
Set RST=%RST%`%%~%1
goto :EOF

:EchoResults
echo ECHO %RST% ^>^> ..\..\Models\%2s.csv >> ..\Controllers\%controller%\add.cmd
echo ECHO View/%%ID%% >> ..\Controllers\%controller%\add.cmd 
echo EXIT 31 >> ..\Controllers\%controller%\add.cmd 

echo @echo off > ..\Controllers\%controller%\view.bat
echo IF x"%%1"==x"" GOTO EMPTY >> ..\Controllers\%controller%\view.bat
echo FOR /F "eol=; tokens=1-20 skip=1 delims=`" %%%%1 in (..\..\Models\%2s.csv) do ( >> ..\Controllers\%controller%\view.bat
echo   IF %%%%1==%%1 ( >> ..\Controllers\%controller%\view.bat
echo     call ..\..\Views\Shared\_header %%%%2 >> ..\Controllers\%controller%\view.bat
echo     call ..\..\h\h1 %%%%2 >> ..\Controllers\%controller%\view.bat
for /L %%i in (3,1,%ID%) do (
echo     ECHO [p]%%%%%%i[/p] >> ..\Controllers\%controller%\view.bat 
)

echo  ) >> ..\Controllers\%controller%\view.bat
echo ) >> ..\Controllers\%controller%\view.bat
echo GOTO EXIT >> ..\Controllers\%controller%\view.bat
echo :EMPTY >> ..\Controllers\%controller%\view.bat
echo     call ..\..\Views\Shared\_header Invalid ID >> ..\Controllers\%controller%\view.bat
echo     call ..\..\h\h1 Invalid ID >> ..\Controllers\%controller%\view.bat
echo GOTO EXIT >> ..\Controllers\%controller%\view.bat
echo :EXIT >> ..\Controllers\%controller%\view.bat
echo ECHO [a href='/%controller%/index']back...[/a] >> ..\Controllers\%controller%\view.bat

echo @echo off > ..\Controllers\%controller%\index.bat
echo call ..\..\Views\Shared\_header %controller% %2s >> ..\Controllers\%controller%\index.bat
echo call ..\..\h\h1 %controller% %2s >> ..\Controllers\%controller%\index.bat
echo echo [blink][em]Built with DOS on Dope[/em][/blink] >> ..\Controllers\%controller%\index.bat
echo FOR /F "eol=; tokens=1-20 skip=1 delims=`" %%%%1 in (..\..\Models\%2s.csv) do ( >> ..\Controllers\%controller%\index.bat

echo   call ..\..\h\h1 %%%%2 >> ..\Controllers\%controller%\index.bat
for /L %%i in (3,1,%ID%) do (
echo   ECHO [p]%%%%%%i[/p] >> ..\Controllers\%controller%\index.bat 
)
echo   ECHO [a href='view/%%%%1']more...[/a] >> ..\Controllers\%controller%\index.bat
echo   ECHO [hr /] >> ..\Controllers\%controller%\index.bat
echo ) >> ..\Controllers\%controller%\index.bat
echo echo. >> ..\Controllers\%controller%\index.bat
echo echo [a href='add']Add[/a] >> ..\Controllers\%controller%\index.bat

popd 

goto EXIT

:HELP


if '%2'=='site' goto HELP_SITE
if '%2'=='controller' goto HELP_CONTROLLER
if '%2'=='model' goto HELP_MODEL
if '%2'=='gen' goto HELP_GEN

echo.
echo *******************
echo *** DOS ON DOPE ***
echo *** The MVC web ***
echo *** frame  work ***
echo *** built    on ***
echo *** batch files ***
echo *******************
echo.
echo Commands are:
echo   dope SITE [[name]] -- to create a SITE named 'name'
echo   dope CONTROLLER [[name]] -- to create a CONTROLLER named 'name'
echo   dope GEN [[name]] -- to generate controllers and action for a model named 'name' (singular)
echo   dope HELP [[command]] -- to request HELP on 'command'

echo ** Always keep Dope in your Path. **

goto exit

:UNKNOWN

echo ERROR: Unknown command. %1
GOTO HELP

goto EXIT

:EXIT