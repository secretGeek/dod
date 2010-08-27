using System;
using System.Diagnostics;
using System.IO;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace DosOnDope
{
    public class MvcApplication : System.Web.HttpApplication
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");
            routes.IgnoreRoute("favicon.ico");
            routes.IgnoreRoute("Content/{*pathInfo}");

            routes.Add(new Route("{controller}/{action}/{*id}", new DosOnDopeRouteHandler())
            {
                Defaults = new RouteValueDictionary(new
                {
                    controller = "Home",
                    action = "Index",
                    id = ""
                })
            });
        }

        protected void Application_Start()
        {
            RegisterRoutes(RouteTable.Routes);
        }
    }

    public class DosOnDopeRouteHandler : IRouteHandler
    {
        public IHttpHandler GetHttpHandler(RequestContext requestContext)
        {
            return new DosOnDopeHttpHandler(requestContext);
        }
    }

    public class DosOnDopeHttpHandler : IHttpHandler
    {
        public RequestContext requestContext { get; set; }
        public DosOnDopeHttpHandler(RequestContext requestContext)
        {
            this.requestContext = requestContext;
        }
        
        public bool IsReusable {get { return false; } }

        public void ProcessRequest(HttpContext context)
        {
            var controller = this.requestContext.RouteData.Values["controller"] as string;
            var action = this.requestContext.RouteData.Values["action"] as string;
            string[] args = { this.requestContext.RouteData.Values["id"] as string };
            int httpStatus;
            if (context.Request.RequestType == "POST")
            {
                var result = Execute(controller, action, context.Request.Form.ToString().Split('&'), out httpStatus, true);
                if (httpStatus == 301)
                    context.Response.Redirect(result.Trim("\r\n".ToCharArray()));
                else
                    context.Response.Write(result);                
            }
            else
            {
                context.Response.Write(Execute(controller, action, args, out httpStatus, false ));      
            }
            context.Response.StatusCode = httpStatus;
        }

        public string Execute(string controllerName, string actionName, string[] newArgs, out int httpStatus, bool isPost)
        {
            var controllerPath = Path.Combine(requestContext.HttpContext.Server.MapPath("~/Controllers"), controllerName);

            if (!Directory.Exists(controllerPath))
            {
                return ControllerNotFound(controllerName, actionName, newArgs, out httpStatus, isPost);
            }

            var actionFileName = Path.Combine(controllerPath, actionName + ".bat");

            if (!File.Exists(actionFileName))
            {
                return ActionNotFound(controllerName, actionName, newArgs, out httpStatus, isPost);
            }
            
            return Execute(controllerPath, actionName, Join(" ", newArgs), out httpStatus, isPost);
        }

        private string Execute(string path, string file, string args, out int httpStatus, bool isPost)
        {
            var errorLevel = 50;
            var result = string.Empty;

            using (var proc = new Process())
            {
                proc.EnableRaisingEvents = false;

                proc.StartInfo.FileName = Path.Combine(path, file + (isPost? ".cmd" : ".bat"));
                if (args != null)
                {
                    proc.StartInfo.Arguments = args;
                }
                proc.StartInfo.WorkingDirectory = path;
                proc.StartInfo.UseShellExecute = false;
                proc.StartInfo.CreateNoWindow = true;// false;
                proc.StartInfo.RedirectStandardOutput = true;
                proc.Start();
                string output = proc.StandardOutput.ReadToEnd();
                result = Dope(output);
                proc.WaitForExit();
                errorLevel = proc.ExitCode;
            }
            httpStatus = ConvertErrorlevelToHttpStatus(errorLevel);
            return result;
        }

        private string ActionNotFound(string controllerName, string actionName, string[] newArgs, out int httpStatus, bool isPost)
        {
            var controllerPath = Path.Combine(requestContext.HttpContext.Server.MapPath("~/Controllers"), controllerName);

            if (!File.Exists(Path.Combine(controllerPath, "_actionMissing" + ".bat")))
            {
                controllerPath = requestContext.HttpContext.Server.MapPath("~/Controllers");
            }

            return Execute(controllerPath, "_ActionMissing", controllerName + " " + actionName + " " + Join(" ", newArgs), out httpStatus, false);
        }

        private string ControllerNotFound(string controllerName, string actionName, string[] newArgs, out int httpStatus, bool isPost)
        {
            var controllerPath = requestContext.HttpContext.Server.MapPath("~/Controllers");
            return Execute(controllerPath, "_ControllerMissing", controllerName + " " + actionName + " " + Join(" ", newArgs), out httpStatus, false);
        }


        private int ConvertErrorlevelToHttpStatus(int errorLevel)
        {
            if (errorLevel == 0) return 200;
            return ((errorLevel / 10) * 100) + (errorLevel % 10);
        }


        private string Join(string separator, params string[] strings)
        {
            if (strings == null) return string.Empty;
            return string.Join(separator, strings);
        }

        /// <summary>
        /// Dopes the input.
        /// i.e:
        ///   Turns square brackets into angle brackets
        ///   Turns pluses into spaces.
        ///   Escapes angle brackets
        ///   Turns escaped square brackets into regular square brackets
        ///   Turns url encoded CR/LF into spaces
        /// </summary>
        /// <param name="undoped">The undoped.</param>
        /// <returns></returns>
        private string Dope(string undoped)
        {
            if (undoped.IndexOf("[[") >= 0 || undoped.IndexOf("]]") >= 0)
            {
                var gOpen = Guid.NewGuid().ToString();
                var gClose = Guid.NewGuid().ToString();
                undoped = undoped.Replace("[[", gOpen).Replace("]]", gClose);
                undoped = Dope(undoped);
                return undoped.Replace(gOpen, "[").Replace(gClose, "]");
            }
            return undoped.Replace("<","&lt").Replace(">","&gt;").Replace("[", "<").Replace("]", ">").Replace("+"," ").Replace("%0d"," ").Replace("%0a"," ");
        }
    }
}