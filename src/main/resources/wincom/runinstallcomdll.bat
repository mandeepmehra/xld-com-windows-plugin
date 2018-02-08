copy ${step.uploadedArtifactPath} ${deployed.targetDirectory}
IF %ERRORLEVEL% NEQ 0 EXIT /b %ERRORLEVEL%

cscript managecomdll.vbs -app ${deployed.appName} -dll ${deployed.targetFileName} -com ${deployed.componentName} -remove
IF %ERRORLEVEL% NEQ 0 EXIT /b %ERRORLEVEL%

regsvr32 -u -s ${deployed.targetDirectory}\${deployed.targetFileName}
IF %ERRORLEVEL% EQU 4 echo "Error in unregistering DLL"

cscript managecomdll.vbs -app ${deployed.appName} -dll ${deployed.targetDirectory}\${deployed.targetFileName} -com ${deployed.componentName}
IF %ERRORLEVEL% NEQ 0 EXIT /b %ERRORLEVEL%


regsvr32 -s ${deployed.targetDirectory}\${deployed.targetFileName}
IF %ERRORLEVEL% EQU 4 exit /b 0
IF %ERRORLEVEL% NEQ 4 exit /b %ERRORLEVEL%
