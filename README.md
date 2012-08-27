arduino_ios_remote
==================

arduino wifi智能小车ios控制端

功能：

>可以wifi查看小车摄像头视频

>可以控制小车方向

>可以控制摄像头云台的方向


源代码是as3手机项目，请使用flash builder 4.6 编译生成ipa文件

当然同样可以生成apk文件给andorid手机使用

release目录下的ipa文件是我生成好的，可以使用itunes同步到已经越狱后的ios设备当真


配置信息目前还在代码里面改：

```actionscript

private var cfg_VideoUrl:String = 'http://192.168.1.1:8080/?action=snapshot';
private var cfg_ControlHost:String = '192.168.1.1';
private var cfg_ControlPort:uint = 2001;
private var cfg_keyMaps:Object = {

	qian: 'q', hou: 'h', zuo: 'z', you: 'y', ting: 's'

	, up: 't', down: 'd', left: 'l', right: 'r', stop: 's'

};

```


![Alt text](https://raw.github.com/play175/arduino_ios_remote/master/snap.jpg)