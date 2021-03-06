# How does it work? 
## How *does* it work!?
## HOW does IT work!?
## (how can it work?)

In DosOnDope all URLs are constructed like this:

`http://YourSite.com/Controller/Action/*id`

Where:

 * `"Controller"` is the name of a **folder** in the Controllers folder.
 * `"Action"` is the name of a **batch file** in the relevant controller folder.
 * `"*id"` is an optional set of **parameters** passed to the batch file.

(Turning a URL into a batch file call is performed by a custom C# router, `DosOnDopeRouteHandler` which hands off to the http handler `DosOnDopeHttpHandler`)

If the subfolder "`Controller`" in the `Controllers` folder is not found, `_controllerMissing.bat` is called.

This is the default `_controllerMissing` batch file included in every DosOnDope application. It sits in the `Controllers` folder. It returns a web page telling you what controllers are available, and you will usually customize it to suit your own purposes.

If there is no batch file matching the name of the `action` that was called, then the `_actionMissing` batch file is executed.

This is the default `_actionMissing` batch file included in every DosOnDope application. It returns a web page telling you what actions are available for the controller you requested. You are free to customize it however you wish.

* If the request is a `GET` method, the handler looks for a `.bat` batch file.
* If the request is a `POST` method, the handler looks for a `.cmd` batch file. 

So for example a `GET` request to `http://YourSite.com/Blog/Add` would cause the handler to execute a batch file located at

	C:\Temp\YourSite\Controllers\Blog\Add.bat

A `POST` to `http://YourSite.com/Blog/Add` would cause the handler to execute a batch file located at:

	C:\Temp\YourSite\Controllers\Blog\Add.cmd

A `GET` to `http://YourSite.com/Blog/View/Yes` would cause the handler to execute a batch file `View.bat` with the parameter "Yes"

	C:\Temp\YourSite\Controllers\Blog\View.bat Yes

So, inside the `View.bat` script, you could say:

	@echo [p]Hello! You said %1.[/p]
Which would be converted into:

	<p>Hello! You said Yes.</p>

And be rendered by a browser as:

> Hello! You said Yes.

(By the way, echoing user input from a URL to the screen is a very safe and wise thing to do. Do that any chance you can.)

Why not read about [Getting started](GettingStarted.md)

Dave's not here currently. Man. etc.

Maybe read the original blog post about this nonsense at [secretGeek: dos on dope](http://secretgeek.net/dod_intro)

