import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const MethodChannel channel = MethodChannel("mupdf2_method_channel");
const EventChannel channelEvent = EventChannel("mupdf2_method_channel_event");

enum Mupdf02ContentState {
  Content_View,
  Content_Draw,
  Content_Search_View,
}

class Mupdf02Controller {

  Function(String? name)? _onTapDraw;
  Function(int newIndex, int allIndex)? _onPageIndexChange;
  Function(Mupdf02ContentState newState)? _onStateChange;

  int initPageIndex = 0;

  bool isScrollHor;

  String ? InitFrameEyeColor;

  late String filePath;

  late _Mupdf02WidgetState state;

  Mupdf02Controller({
    this.isScrollHor = true,
    this.initPageIndex = 0,
    required String initFilePath,
    Color ? initFrameEyeColor,
  }) {

    if(initFrameEyeColor != null){
      InitFrameEyeColor = _colorStr(color: initFrameEyeColor);
    }

    filePath = initFilePath;

    channelEvent.receiveBroadcastStream().listen((event) {
      if (event == null || event is! Map) {
        return;
      }

      String method = event['Method'];
      var arguments = event['Data'];

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
          _onPageIndexChange!(arguments['PageIndex'], arguments['AllIndex']);
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

  //  ????????????
  switchFile({required String newFilePath,int initPageIndex = 0,}) async {

    if (newFilePath == filePath) {
      return;
    }

    this.initPageIndex = initPageIndex;
    filePath = newFilePath;
    state.setState(() {});

  }

  // ??????????????????
  openFileAgain({int initPageIndex = 0}) async {

    this.initPageIndex = initPageIndex;

    state.setState(() {
      state.showPdf = false;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    state.setState(() {
      state.showPdf = true;
    });

  }

  //   ????????????
  beginDraw() async {
    await channel.invokeMethod("BeginDraw");
  }

  //   ????????????
  cancelDraw() async {
    await channel.invokeMethod("CancelDraw");
  }

  //  ????????????
  delDraw() async {
    await channel.invokeMethod("DelDraw");
  }

  //   ????????????
  saveDraw() async {
    await channel.invokeMethod("SaveDraw");
  }

  //   ??????????????????
  setPenColor({required Color color}) async {
    await channel.invokeMethod("SetPenColor", {
      "Color":  _colorStr(color: color),
    });
  }

  //   ??????????????????
  setPenWidth({required double width}) async {
    await channel.invokeMethod("SepPenWidth", {
      "Width": width.toString(),
    });
  }

  //   ????????????
  saveFile() async {
    await channel.invokeMethod("SaveFile");
  }

  //   ????????????
  jumpToPageIndex({required int pageIndex}) async {
    await channel.invokeMethod("SwitchPageIndex", {
      "PageIndex": pageIndex,
    });
  }

  //   ?????????
  jumpToNextPageIndex() async {
    await channel.invokeMethod("SwitchToNextPage");
  }


  //   ?????????
  jumpToUpPageIndex() async {
    await channel.invokeMethod("SwitchToUpPage");
  }


  //   ????????????
  Future<int?> totalPageNum() async {
    return await channel.invokeMethod("TotalPageNum");
  }

  // ????????????
  Future<int?> currentPageNum() async {
    return await channel.invokeMethod("CurrentPageNum");
  }


  //   ??????????????????
  setFrameEyeColor({required Color color})async{


    InitFrameEyeColor = _colorStr(color: color);

    return await channel.invokeMethod("FrameEyeColor",{
      "Color": _colorStr(color: color),
    });

  }


  //  ?????? ?????? ??????????????? ??????
  setTapDrawedListener(
      {required Function(String? name) onTapDrawListener}) async {
    _onTapDraw = onTapDrawListener;
  }

  //   ?????? ???????????? ??????
  setPageIndexChangeListener(
      {required Function(int newIndex, int allIndex) onPageChangeListener}) {
    _onPageIndexChange = onPageChangeListener;
  }

  //   ?????? ?????? ?????? ?????? ??????
  setStateChangeListener(
      {required Function(Mupdf02ContentState newState) stateChangeListener}) {
    _onStateChange = stateChangeListener;
  }



  String _colorStr({required Color color}){
    String temp = color.value.toRadixString(16);
    String colorStr = "";

    if(temp == "0"){
      colorStr = "#00000000";
    }else{
      colorStr = "#${temp.substring(0, 8)}";
    }

    return colorStr;
  }

// todo ------------------------------ ???????????? ------------------------------

// todo ???????????? ??????

// todo ???????????? ??????

// todo ???????????? ?????????

// todo ???????????? ?????????

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

  bool showPdf = true;

  @override
  void initState() {
    super.initState();
    widget.controller.state = this;
  }

  @override
  Widget build(BuildContext context) {
    return showPdf ? AndroidView(
      key: ValueKey(widget.controller.filePath),
      viewType: "mupdf2_view",
      creationParams: {
        "FilePath": widget.controller.filePath,
        "IsScrollHor": widget.controller.isScrollHor,
        "InitPageIndex":widget.controller.initPageIndex,
        "InitFrameEyeColor":widget.controller.InitFrameEyeColor,
      },
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (id) {
        // todo ??????????????????????????????
      },
    ) : Container(color: Colors.transparent,);
  }
}
