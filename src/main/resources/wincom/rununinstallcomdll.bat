cscript managecomdll.vbs -app ${deployed.appName} -dll ${deployed.targetDirectory}\${deployed.targetFileName} -com ${deployed.componentName} -remove
IF %ERRORLEVEL% NEQ 0 EXIT /b %ERRORLEVEL%
