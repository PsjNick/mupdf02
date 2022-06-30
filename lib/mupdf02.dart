import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const MethodChannel channel = MethodChannel("mupdf2_method_channel");

enum Mupdf02ContentState {
  Content_View,
  Content_Draw,
  Content_Search_View,
}

class Mupdf02Controller {

  Function(String ? name)? _onTapDraw;
  Function(int newIndex)? _onPageIndexChange;
  Function(Mupdf02ContentState newState)? _onStateChange;


  bool isScrollHor;

  late String filePath;

  late _Mupdf02WidgetState state;

  Mupdf02Controller({
      this.isScrollHor = true,
    required String initFilePath,
  }) {

    filePath = initFilePath;

    //  设置 Android 端的回调
    channel.setMethodCallHandler((call) async {

      var arguments = call.arguments;
      String method = call.method;

      switch (method) {

        case "OnTapDraw":
          if (_onTapDraw == null) {
            return;
          }
          _onTapDraw!(arguments['Name']);
          break;
        case "PageIndexChange":
          if (_onPageIndexChange == null) {
            return;
          }
          _onPageIndexChange!(arguments['PageIndex']);
          break;
        case "StateChange":

          if (_onStateChange == null) {
            return;
          }

          var stateCode = arguments['StateCode'];

          switch (stateCode) {
            case 0:
              _onStateChange!(Mupdf02ContentState.Content_View);
              break;
            case 1:
              _onStateChange!(Mupdf02ContentState.Content_Draw);
              break;
            case 2:
              _onStateChange!(Mupdf02ContentState.Content_Search_View);
              break;
          }

          break;
      }
    });


  }

  //  切换文件
  switchFile({required String newFilePath}) async {

    if (newFilePath == filePath) {
      return;
    }

    filePath = newFilePath;
    state.setState(() {});
  }

  //   开始绘制
  beginDraw() async {
    await channel.invokeMethod("BeginDraw");
  }

  //   取消绘制
  cancelDraw() async {
    await channel.invokeMethod("CancelDraw");
  }

  // todo 删除绘制
  delDraw() async {
    await channel.invokeMethod("DelDraw");
  }

  //   保存绘制
  saveDraw() async {
    await channel.invokeMethod("SaveDraw");
  }

  //   设置画笔颜色
  setPenColor({required Color color}) async {

    String temp = color.value.toRadixString(16);
    String colorStr = "#${temp.substring(2, 8)}";

    await channel.invokeMethod("SetPenColor", {
      "Color": colorStr,
    });


  }

  //   设置画笔粗细
  setPenWidth({required double width}) async {
    await channel.invokeMethod("SepPenWidth", {
      "Width": width.toString(),
    });
  }

  //   保存文件
  saveFile() async {
    await channel.invokeMethod("SaveFile");
  }

  //   页面跳转
  jumpToPageIndex({required int pageIndex}) async {
    await channel.invokeMethod("SwitchPageIndex", {
      "PageIndex": pageIndex,
    });
  }

  //   页面总数
  Future<int?> totalPageNum() async {
    return await channel.invokeMethod("TotalPageNum");
  }

  // 当前页数
  Future<int?> currentPageNum() async {
    return await channel.invokeMethod("CurrentPageNum");
  }


  //  设置 点击 已绘制内容 监听
  setTapDrawedListener({required Function(String ? name) onTapDrawListener}) async {
    _onTapDraw = onTapDrawListener;
  }

  //   设置 页面改变 监听
  setPageIndexChangeListener(
      {required Function(int newIndex) onPageChangeListener}) {
    _onPageIndexChange = onPageChangeListener;
  }

  //   设置 页面 状态 改变 监听
  setStateChangeListener(
      {required Function(Mupdf02ContentState newState) stateChangeListener}) {
    _onStateChange = stateChangeListener;
  }

// todo ------------------------------ 稍后来做 ------------------------------

// todo 开始文字 搜索

// todo 退出文字 搜索

// todo 查询搜索 下一处

// todo 查询搜索 上一处

}

class Mupdf02Widget extends StatefulWidget {
  final Mupdf02Controller controller;

  const Mupdf02Widget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  State<Mupdf02Widget> createState() => _Mupdf02WidgetState();
}

class _Mupdf02WidgetState extends State<Mupdf02Widget> {
  @override
  void initState() {
    super.initState();
    widget.controller.state = this;
  }

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      key: ValueKey(widget.controller.filePath),
      viewType: "mupdf2_view",
      creationParams: {
        "FilePath": widget.controller.filePath,
        "IsScrollHor": widget.controller.isScrollHor,
      },
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (id) {
        // todo 暂时还不知道干什么用

      },
    );
  }
}
