cscript managecomdll.vbs -app ${deployed.appName} -dll ${deployed.targetFileName} -com ${deployed.componentName} -remove
IF %ERRORLEVEL% NEQ 0 (EXIT /b %ERRORLEVEL%) ELSE (ECHO "COM component removed")

regsvr32 -u -s ${deployed.targetDirectory}\${deployed.targetFileName}
IF %ERRORLEVEL% EQU 0 echo "Error in unregistering DLL"

copy /Y ${step.uploadedArtifactPath} ${deployed.targetDirectory}
IF %ERRORLEVEL% NEQ 0 EXIT /b %ERRORLEVEL%

cscript managecomdll.vbs -app ${deployed.appName} -dll ${deployed.targetDirectory}\${deployed.targetFileName} -com ${deployed.componentName}
IF %ERRORLEVEL% NEQ 0 EXIT /b %ERRORLEVEL%


regsvr32 -s ${deployed.targetDirectory}\${deployed.targetFileName}
IF %ERRORLEVEL% NEQ 0 exit /b %ERRORLEVEL%
