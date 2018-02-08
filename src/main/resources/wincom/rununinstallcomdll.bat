cscript managecomdll.vbs -app ${deployed.appName} -dll ${deployed.targetDirectory}\${deployed.targetFileName} -com ${deployed.componentName}
IF %ERRORLEVEL% NEQ 0 EXIT /b %ERRORLEVEL%
