

# Windows下VS2019调用MongoDB服务

## 安装MongoDB服务

### 下载MongoDB

官网下载地址：https://www.mongodb.com/try/download/communit

![](.\pic\download.png)

点击**Download**开始下载，得到安装文件**mongodb-windows-x86_64-6.0.0-signed.msi**。

### 安装MongoDB

双击下载的**mongodb-windows-x86_64-6.0.0-signed.msi**开始安装，按照提示依次下一步即可。

其中，安装类型选择**Custom**：

![](.\pic\setType.png)根据需要选择安装路径：

![](.\pic\setPath.png)

根据实际情况配置数据存储目录、日志存储目录：

![](.\pic\installConfig.png)

依次下一步完成安装。

### 检查安装

安装完成后，**计算机右键->管理->服务和应用程序->服务**，查看MongoDB Server服务是否注册和启动成功。

![](.\pic\services.png)

在浏览器中输入地址：[localhost:27017](http://localhost:27017/) 出现以下内容说明服务已经安装成功，并运行正常！

![](.\pic\localHost.png)

### 修改配置项

如果需要修改mongodb的IP端口、数据目录、日志目录等信息，则需要修改mongodb安装目录：E:\software\develop\mongoDB\bin中的配置文件mongod.cfg，配置文件中信息如下：

![](.\pic\configFile.png)

至此，windows下安装启动mongodb就完成了。

## 搭建MongoDB的运行环境

### 准备

下载安装Cmake，官网下载地址：https://cmake.org/download/，本例版本为Cmake 3.22.0。

下载安装Boost库，官网下载地址：https://www.boost.org/users/history/，本例版本为Boost 1.74.0。

### 编译mongo-c-driver

#### 下载mongo-c-driver

官网下载地址：https://github.com/mongodb/mongo-c-driver/releases，本例版本为mongo-c-driver-1.17.6。下载并解压后文件内容如下：

![](.\pic\mongo-c-driver.png)

#### Cmake构建工程

打开CMake，设置源码目录和build目录，点击**Configure**并配置如下：

![](E:\SelfStudy\工作收藏\Windows下VS2019调用mongoDB服务\pic\c_cmakeConfig.png)

点击**Finish**完成配置。根据需要修改以下两项的值：

BUILD_VERSION为版本号，设置为1.17.6。

**CMAKE_INSTALL_PREFIX**为安装头文件和库的路径，本例设置为E:\mongodb\Install\c-driver-1.17.6。

![](.\pic\mongo-c-driver-cmake.png)

点击**Configure**，完成配置。

点击**Generate**，在**mongo-c-driver-1.17.6\build**文件夹下生成VS2019工程文件：

![](.\pic\c_sln.png)

#### 安装库

**以管理员身份运行**VS2019，打开解决方案mongo-c-driver.sln，直接点击Build编译**INSTALL**即可：

![](.\pic\c_build.png)

编译成功后相关的头文件、动态库等文件会复制到前面 CMAKE_INSTALL_PREFIX 指定的目录下:

![](.\pic\c_install.png)

### 编译mongo-cxx-driver

#### 下载mongo-cxx-driver

官网下载地址：https://github.com/mongodb/mongo-cxx-driver/releases，本例版本为mongo-cxx-driver-r3.6.5。下载并解压后文件内容如下：

![](.\pic\mongo-cxx-driver.png)

#### Cmake构建工程

打开CMake，设置源码目录和build目录，点击**Configure**并配置如下：

![](.\pic\cxx_cmakeConfig.png)

点击**Finish**进行配置。如果出现如下错误：

![](.\pic\cxx_version_erro.png)

则需要修改设置BUILD_VERSION的值3.6.5。

**CMAKE_INSTALL_PREFIX**为安装头文件和库的路径，本例设置为E:\mongodb\Install\cxx-driver-r3.6.5。

点击**Configure**，如果出现如下错误，原因是找不到库路径导致。

![](.\pic\cxx_prefix_path.png)

则点击**Add Entry**，设置CMAKE_PREFIX_PATH 为上一步编译结果的目录，本例为E:\mongodb\Install\c-driver-1.17.6，点击**OK**即可。

点击**Configure**，如果出现如下错误，原因是找不到Boost库路径导致。

![](E:\SelfStudy\工作收藏\Windows下VS2019调用mongoDB服务\pic\boost_erro.png)

则设置Boost_INCLUDE_DIR为安装Boost库的路径，本例为D:\boost\boost_1_74_0。

![](.\pic\boost_include.png)

点击**Configure**，完成配置。

点击**Generate**，在**mongo-cxx-driver-r3.6.5\build**文件夹下生成VS2019工程文件：

![](.\pic\cxx_sln.png)

#### 安装库

**以管理员身份运行**VS2019，打开解决方案MONGO_CXX_DRIVER.sln，直接点击Build编译**INSTALL**即可：

![](.\pic\cxx.png)

编译成功后相关的头文件、动态库等文件会复制到前面 CMAKE_INSTALL_PREFIX 指定的目录下:

![](.\pic\cxx_install.png)

至此，MongoDB的运行环境就搭建完成了。

## VS2019调用实例

### 新建工程

新建C++工程：MongoDBTest。

### 配置属性

工程上右键->Properties->C/C++->General->Additional include Directions，添加安装的头文件路径和Boost库头文件路径，本例为D:\boost\boost_1_74_0：

![](.\pic\Test_includeDir.png)

工程上右键->Properties->Linker->General->Additional Library Directions，添加安装的库路径：

![](.\pic\Test_libDir.png)

程上右键->Properties->Linker->Input->Additional Dependencies，添加库文件：

![](.\pic\Test_lib.png)

### 添加源码

在MongoDBTest.cpp中输入如下代码：

```c++
#include <iostream>
#include "bsoncxx/builder/stream/document.hpp"
#include "mongocxx/instance.hpp"
#include "mongocxx/uri.hpp"
#include "mongocxx/client.hpp"

using namespace mongocxx;
using namespace bsoncxx::builder::stream;

int main()
{
instance instance{};
uri uri("mongodb://127.0.0.1:27017");
client client(uri);
// 数据库
database db = client["mytestdb"];
// 集合
collection coll = db["testcoll"];
// 插入
try
{
	for (int i = 1; i <= 10; ++i)
	{
		auto builder = document{};
		builder << "userid" << i<< "name" << "username";
		coll.insert_one(builder.view());
		std::cout << "insert : " << i << "\n";
	}
}
catch (const std::exception& e)
{
	std::cout << "insert error : " << e.what();
}
// 查找
try
{
	auto cursor = coll.find(document{} << "name" << "username" << finalize);
	if (cursor.begin() != cursor.end())
	{
		for (auto& doc : cursor)
		{
			std::string Name = doc["name"].get_utf8().value.to_string();
			std::cout << "find : userid[" << doc["userid"].get_int32() << "] name[" << Name << "]\n";
		}
	}
}
catch (const std::exception& e)
{
	std::cout << "find error : " << e.what();
}
// 更新
try
{
	coll.update_one(document{} <<
		"userid" << 3 << finalize,
		document{} << "$set" << open_document
		<< "name" << "username3333333"
		<< close_document
		<< finalize);
	std::cout << "update : userid[3] name[username3333333]" << "\n";
}
catch (const std::exception& e)
{
	std::cout << "update error : " << e.what();
}
// 删除数据
try
{
	auto filter_builder = document{};
	bsoncxx::document::value filter_value = filter_builder << "userid" << 7 << finalize;
	coll.delete_one(filter_value.view());
	std::cout << "delete : userid[7]" << "\n";
}
catch (const std::exception& e)
{
	std::cout << "delete error : " << e.what();
}
// 再次查找
try
{
	auto cursor = coll.find(document{} << finalize);
	if (cursor.begin() != cursor.end())
	{
		for (auto& doc : cursor)
		{
			std::string Name = doc["name"].get_utf8().value.to_string();
			std::cout << "find again : userid[" << doc["userid"].get_int32() << "] name[" << Name << "]\n";
		}
	}
}
catch (const std::exception& e)
{
	std::cout << "find error : " << e.what();
}
system("pause");
}
```

### 编译运行

编译成功后运行程序，如果出现以下错误：

![](.\pic\Test_run_erro.png)

原因是MongoDB服务没有启动导致。**计算机右键->管理->服务和应用程序->服务**，查看MongoDB Server服务是否启动，如果未启动，则鼠标右键启动即可。

![](.\pic\start_server.png)

运行程序，结果为：

![](.\pic\Test_run.png)

则运行成功。至此，VS2019调用MongoDB服务就完成了。

## 参考链接

Windows 安装部署MongoDB详细步骤：https://www.cnblogs.com/jiangcong/p/15060091.html

VS2019编译mongo-cxx-driver：https://blog.csdn.net/aqtata/article/details/118530015

windows下VS2017编译mongoDB c、c++API ：https://www.likecs.com/show-204087734.html

MongoDB VS2015 windows10下的C++开发环境搭建——亲妈级教程：https://blog.csdn.net/u011326153/article/details/125205602