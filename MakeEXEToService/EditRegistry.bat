@echo off
echo Windows Registry Editor Version 5.00>ExportRegistry.reg
echo.
echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\gRPC_SignalRecogniseServer]>>ExportRegistry.reg
echo "Description"="信号识别gPRC服务端">>ExportRegistry.reg
echo [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\gRPC_SignalRecogniseServer\Parameters]>>ExportRegistry.reg
echo "Application"="E:\\\\Debug\\\\SignalRecogniseServer.exe">>ExportRegistry.reg
echo "AppDirectory"="E:\\\\Debug">>ExportRegistry.reg
regedit/s ExportRegistry.reg
del/q ExportRegistry.reg