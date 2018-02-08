copy ${step.uploadedArtifactPath} ${deployed.targetDirectory}
IF %ERRORLEVEL% NEQ 0 EXIT /b %ERRORLEVEL%


REM Delete DLL component from Component Services

cscript uninstallcomdll.vbs -app ${deployed.appName} -dll ${deployed.targetFileName}
IF %ERRORLEVEL% NEQ 0 EXIT /b %ERRORLEVEL%


regsvr32 -u -s ${deployed.targetDirectory}\${deployed.targetFileName}
IF %ERRORLEVEL% EQU 4 exit /b 0
IF %ERRORLEVEL% NEQ 4 exit /b %ERRORLEVEL%

cscript installcomdll.vbs -app ${deployed.appName} -dll ${deployed.targetDirectory}\${deployed.targetFileName}
IF %ERRORLEVEL% NEQ 0 EXIT /b %ERRORLEVEL%


regsvr32 -s ${deployed.targetDirectory}\${deployed.targetFileName}
IF %ERRORLEVEL% EQU 4 exit /b 0
IF %ERRORLEVEL% NEQ 4 exit /b %ERRORLEVEL%
