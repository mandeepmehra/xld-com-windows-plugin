regsvr32 -u -s ${deployed.targetDirectory}\${deployed.targetFileName}
IF %ERRORLEVEL% EQU 4 echo "Error in unregistering DLL"


