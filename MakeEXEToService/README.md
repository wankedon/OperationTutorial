**1.将srvany.exe和instsrv.exe两个文件拷贝到"C:\Windows\System32"或者"C:\Windows"目录下**

**2.修改AddServer.bat文件**
  将gRPC_SignalRecogniseServer替换为服务名称
  将"C:\Windows\System32\"替换为srvany.exe和instsrv.exe所在路径

**3.修改EditRegistry.bat文件**
  将"信号识别gPRC服务端"替换为服务描述
  将gRPC_SignalRecogniseServer替换为换服务名称
  将"E:\\\\Debug\\\\SignalRecogniseServer.exe"替换为要作为服务运行的程序的路径
  将"E:\\\\Debug"替换为程序运行的初始目录

**4.修改DeleteServer.bat文件**
  将gRPC_SignalRecogniseServer替换为服务名称

**5.添加Windows服务**
  以管理员身份运行AddServer.bat，添加Windows服务

**6.修改注册表**
  以管理员身份运行EditRegistry.bat，修改注册表

**7.删除Windows服务**
  不需要添加的服务时，以管理员身份运行DeleteServer.bat，删除添加的Windows服务

