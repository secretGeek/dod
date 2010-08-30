@echo off
echo [html]
echo [head]
echo [style]body{background-color:#000;color:#C0C0C0;font-family:"fixed sys","Lucida console",monospace}input,textarea{background-color:#222;color:#FFF}h1,h2,h3,h4{font-size:medium}h1{color:white}strong{font-size:medium;color:yellow}pre{font-family:"fixed sys","Lucida console"}em{font-style:normal;color:#808080}ul{list-style-image: url(Content/li.png);}a{text-decoration:none;color:008080}[/style]

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