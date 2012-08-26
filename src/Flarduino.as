package
{
	import com.bit101.components.*;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.text.TextFormat;
	import flash.utils.*;
	
	/**
	 * ...
	 * @author yoyo
	 */
	[SWF(backgroundColor=0x555555,frameRate=24,width=480,height=640)]
	
	public class Flarduino extends Sprite
	{
		private var cfg_VideoUrl:String = 'http://192.168.1.1:8080/?action=snapshot';
		private var cfg_ControlHost:String = '192.168.1.1';
		private var cfg_ControlPort:uint = 2001;
		private var cfg_keyMaps:Object = {
			
			qian: 'q', hou: 'h', zuo: 'z', you: 'y', ting: 's'
			
			, up: 't', down: 'd', left: 'l', right: 'r', stop: 's'
			
		};
		
		private var socket:Socket;
		private var videoLoader:Loader;
		private var lastLoad:uint;
		private var time1:uint;
		
		private var bmpVideo:Bitmap;
		private var bmdVideo:BitmapData = new BitmapData(480, 320, false, 0x333333);
		private var btnVideo:PushButton;
		private var lbTitle:Label;
		private var lbLoading:Label;
		private var btnsDc:Array = [];
		private var btnsServ:Array = [];
		
		private var btnConnect:PushButton;
		private var lbSocketLog:Label;
		
		private var txtLog:TextArea;
		
		public function Flarduino():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point		
			
			socket = new Socket();
			socket.addEventListener(Event.CONNECT, onSocketEvent);
			socket.addEventListener(Event.CLOSE, onSocketEvent);
			socket.addEventListener(IOErrorEvent.IO_ERROR, onSocketEvent);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSocketEvent);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketEvent);
			
			stage.showDefaultContextMenu = false;
			
			videoLoader = new Loader();
			
			Style.setStyle(Style.DARK);
			
			bmpVideo = new Bitmap(bmdVideo);
			bmpVideo.x = (stage.stageWidth - bmdVideo.width) / 2;
			bmpVideo.y = 23;
			addChild(bmpVideo);
			
			//videoLoader.width = bmpVideo.width;
			//videoLoader.height = bmpVideo.height;
			//videoLoader.x = bmpVideo.x;
			//videoLoader.y = bmpVideo.y;
			//addChild(videoLoader);
			videoLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderEvent);
			videoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoaderEvent);
			videoLoader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, onLoaderEvent);
			videoLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoaderEvent);
			
			btnVideo = new PushButton(this, 0, 0, '开启视频', onBtnEvent);
			btnVideo.setSize(130, 50);
			btnVideo.toggle = true;
			btnVideo.x = (stage.stageWidth - btnVideo.width) / 2;
			btnVideo.y = bmpVideo.y + bmpVideo.height + 10;
			
			lbTitle = new Label(this, 0, 0, "WIFI智能小车手机控制端");
			//lbTitle.textField.setTextFormat(new TextFormat(null, 15) );
			
			lbLoading = new Label(this, 0, 0, "视频未连接");
			lbLoading.y = bmpVideo.y + bmpVideo.height - lbLoading.height - 5;
			lbLoading.visible = true;
			
			btnConnect = new PushButton(this, 0, 0, '连接控制端口', onBtnEvent);
			btnConnect.toggle = true;
			btnConnect.setSize(130,50);
			btnConnect.x = stage.stageWidth - btnConnect.width - 3;
			btnConnect.y = btnVideo.y;
			
			var btnQian:PushButton = new PushButton(this, 0, 0, '前', onBtnEvent);
			btnQian.tag = 'qian';
			//btnQian.toggle = true;
			btnQian.setSize(60, 50);
			btnQian.x = 90;
			btnQian.y = btnVideo.y + btnVideo.height + 30;
			
			var btnHou:PushButton = new PushButton(this, 0, 0, '后', onBtnEvent);
			btnHou.tag = 'hou';
			//btnHou.toggle = true;
			btnHou.setSize(60, 50);
			btnHou.x = btnQian.x;
			btnHou.y = btnQian.y + 120;
			
			var btnZuo:PushButton = new PushButton(this, 0, 0, '左', onBtnEvent);
			btnZuo.tag = 'zuo';
			//btnZuo.toggle = true;
			btnZuo.setSize(60, 50);
			btnZuo.x = btnQian.x - 70;
			btnZuo.y = btnQian.y + 60;
			
			var btnYou:PushButton = new PushButton(this, 0, 0, '右', onBtnEvent);
			btnYou.tag = 'you';
			//btnYou.toggle = true;
			btnYou.setSize(60, 50);
			btnYou.x = btnQian.x + 70;
			btnYou.y = btnQian.y + 60;
			
			var btnTing:PushButton = new PushButton(this, 0, 0, '停', onBtnEvent);
			btnTing.tag = 'ting';
			//btnTing.toggle = true;
			btnTing.setSize(60, 50);
			btnTing.x = btnQian.x;
			btnTing.y = btnQian.y + 60;
			
			btnsDc.push(btnQian, btnHou, btnZuo, btnYou, btnTing);
			
			var btnUp:PushButton = new PushButton(this, 0, 0, '上', onBtnEvent);
			btnUp.tag = 'up';
			//btnUp.toggle = true;
			btnUp.setSize(60, 50);
			btnUp.x = 340;
			btnUp.y = btnVideo.y + btnVideo.height + 30;
			
			var btnDown:PushButton = new PushButton(this, 0, 0, '下', onBtnEvent);
			btnDown.tag = 'down';
			//btnDown.toggle = true;
			btnDown.setSize(60, 50);
			btnDown.x = btnUp.x;
			btnDown.y = btnUp.y + 120;
			
			var btnLeft:PushButton = new PushButton(this, 0, 0, '左', onBtnEvent);
			btnLeft.tag = 'left';
			//btnLeft.toggle = true;
			btnLeft.setSize(60, 50);
			btnLeft.x = btnUp.x - 70;
			btnLeft.y = btnUp.y + 60;
			
			var btnRight:PushButton = new PushButton(this, 0, 0, '右', onBtnEvent);
			btnRight.tag = 'right';
			//btnRight.toggle = true;
			btnRight.setSize(60, 50);
			btnRight.x = btnUp.x + 70;
			btnRight.y = btnUp.y + 60;
			
			var btnStop:PushButton = new PushButton(this, 0, 0, '停', onBtnEvent);
			btnStop.tag = 'stop';
			//btnStop.toggle = true;
			btnStop.setSize(60, 50);
			btnStop.x = btnUp.x;
			btnStop.y = btnUp.y + 60;
			
			btnsDc.push(btnUp, btnDown, btnLeft, btnRight, btnStop);
			
			var lb1:Label = new Label(this, 0, btnQian.y - 30, "电机控制");
			lb1.x = btnQian.x + btnQian.width / 2 - lb1.width / 2;
			var lb2:Label = new Label(this, 300, btnQian.y - 30, "云台控制");
			lb2.x = btnUp.x + btnUp.width / 2 - lb2.width / 2;
			
			var lbLog:Label = new Label(this, 0, btnDown.y + 50, "接收数据区：");
			txtLog = new TextArea(this, 0, 0, '');
			txtLog.setSize(480, 75);
			txtLog.y = lbLog.y + lbLog.height + 6;
			txtLog.autoHideScrollBar = true;
			
			lbSocketLog = new Label(this, 0, lbLog.y, "尚未连接控制端口");
			lbSocketLog.x = stage.stageWidth - lbSocketLog.width - 3;
		}
		
		private function onSocketEvent(e:Event):void
		{
			if (e.type == Event.CLOSE)
			{
				lbSocketLog.text = '尚未连接控制端口';
				btnConnect.selected = false;
			}
			else if (e.type == Event.CONNECT)
			{
				lbSocketLog.text = '控制端口已连接';
			}
			else if (e.type == ProgressEvent.SOCKET_DATA)
			{
				var data:String = socket.readMultiByte(socket.bytesAvailable, 'utf8');
				txtLog.text += data + '\n';
				txtLog.textField.scrollV = txtLog.textField.maxScrollV;
			}
			else
			{
				lbSocketLog.text = '连接失败...';
				btnConnect.selected = false;
			}
		}
		
		private function onBtnEvent(e:Event):void
		{
			var btn:Component = e.currentTarget as Component;
			
			if (btnsDc.indexOf(btn) >= 0)
			{
				/*
				for each(var btn1:PushButton in btnsDc)
				{
				if (btn1 != btn)
				{
				btn1.selected = false;
				}
				}*/
				if (cfg_keyMaps[btn.tag])
				{
					if (socket.connected)
					{
						socket.writeMultiByte(cfg_keyMaps[btn.tag], 'utf8');
						socket.flush();
					}
					else
					{
						lbSocketLog.text = '未连接，不能控制';
					}
				}
				else
				{
					lbSocketLog.text = '没有指令找到配置';
				}
			}
			/*
			if (btnsServ.indexOf(btn) >= 0)
			{
			for each(var btn2:PushButton in btnsServ)
			{
			if (btn2 != btn)
			{
			btn2.selected = false;
			}
			}
			}*/
			
			switch (btn)
			{
				case btnVideo: 
					if (btnVideo.selected)
					{
						lbLoading.visible = true;
						lbLoading.text = '正在连接视频...';
					}
					else
					{
						lbLoading.text = '视频未连接';
						lbLoading.visible = true;
					}
					setVideo();
					break;
				
				case btnConnect: 
					if (!btnConnect.selected)
					{
						socket.close();
						lbSocketLog.text = '尚未连接控制端口';
					}
					else
					{
						if (!socket.connected)
						{
							lbSocketLog.text = '正在建立连接...';
							socket.connect(cfg_ControlHost, cfg_ControlPort);
						}
					}
					break;
			}
		}
		
		private function onLoaderEvent(e:Event):void
		{
			if (e.type == Event.COMPLETE)
			{
				if(null!=videoLoader.contentLoaderInfo.content)
				{
					lbLoading.visible = false;
					bmpVideo.bitmapData = (videoLoader.contentLoaderInfo.content as Bitmap).bitmapData;
					bmpVideo.width = 480;
					bmpVideo.height = 320;
				}
			}
			else
			{
				lbLoading.text = '连接视频失败，正在重试...';
				lbLoading.visible = true;
			}
			setVideo();
		}
		
		private function setVideo():void
		{
			clearTimeout(time1);
			if (!btnVideo.selected)
				return;
			var curTime:int = getTimer();
			if (curTime - lastLoad < 50)
			{
				time1 = setTimeout(setVideo, curTime - lastLoad);
				return;
			}
			lastLoad = curTime;
			videoLoader.load(new URLRequest(cfg_VideoUrl));
			log(cfg_VideoUrl);
		}
		
		private function log(... args):void
		{
			trace('>>' + new Date().toString() + '：' + args.join());
		}
	}
	
}