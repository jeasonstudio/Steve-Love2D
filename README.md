# Steve-Love2D
A Game By Lua &amp; Love2D Engine. Steve is a little Dragon in Chrome offline.


为了运行iOS的LÖVE，必须首先编译和安装。要做到这一点，您将需要Mac OS X，Xcode 7或更新版本，以及可从主页上下载的LÖVEfor iOS源代码。 

打开在 love/platform/xcode/love.xcodeproj找到的Xcode项目，并在窗口顶部的下拉菜单中选择 love-ios 目标。 

您可能希望通过从相同的下拉列表中打开“编辑方案...”菜单，将“构建配置”从“调试”更改为“释放”以获得更好的性能。 

在上一个右侧的下拉列表中选择一个iOS模拟器设备或插入的iOS设备，然后单击左侧的Build-and-Run▶︎按钮，编译后将在目标设备上安装LÖVE它。 

iOS上的LÖVE包括安装的游戏的简单列表界面（直到您将.love保存到其中进行发行）。 

在安装LÖVE后，将.love文件放在iOS模拟器上，将其打开时将文件拖动到iOS Simulator的窗口上。

如果没有运行，LÖVE将会启动。如果另一个游戏当前处于活动状态，您可能需要退出LÖVE才能显示新游戏（按Shift-Command-H两次以在iOS Simulator上打开“应用程序切换器”菜单）。 

在安装LÖVE后，将.love文件或游戏文件夹放在iOS设备上，您可以使用Safari下载，也可以在设备连接时通过iTunes从计算机传输：打开iTunes，转到iOS设备安装了LÖVE，转到“应用程序”部分，向下滚动并找到LÖVE，并将.love文件或游戏文件夹添加到LÖVE的“文档”部分。 请参阅游戏分发页面，在iOS上创建FusedLÖVE游戏并进行分发。