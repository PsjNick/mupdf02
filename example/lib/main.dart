import 'package:flutter/material.dart';
import 'package:mupdf02/mupdf02.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowMaterialGrid: false,
      home: PageHome(),
    );
  }
}

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  late Mupdf02Controller mupdf02controller;

  @override
  void initState() {
    super.initState();
    mupdf02controller = Mupdf02Controller(
      initFilePath:
          '/data/data/com.paj.mupdf02_example/cache/2021.12英语四级解析第3套.pdf',
      isScrollHor: false,
    );

    mupdf02controller.setPageIndexChangeListener(
        onPageChangeListener: (int newPageIndex, int totalPageIndex) {
      print('当前页面为：$newPageIndex');
      print('总页数为：$totalPageIndex');
    });

    mupdf02controller.setStateChangeListener(
        stateChangeListener: (Mupdf02ContentState state) {
      print("当前Pdf状态：${state.name}");

      switch (state) {
        case Mupdf02ContentState.Content_View:
          break;
        case Mupdf02ContentState.Content_Draw:
          break;
        case Mupdf02ContentState.Content_Search_View:
          break;
      }
    });

    mupdf02controller.setTapDrawedListener(onTapDrawListener: (String? name) {
      print("点击了绘制：$name");

      if (name != "Annotation") {
        return;
      }

      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('删除此绘制?'),
              actions: [
                TextButton(
                  onPressed: () {
                    mupdf02controller.delDraw();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '是',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '否',
                  ),
                ),
              ],
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Material(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),

                  TextButton(
                    onPressed: () async {
                      mupdf02controller.switchFile(
                        newFilePath:
                            "/data/data/com.paj.mupdf02_example/cache/2021.12英语四级解析第3套.pdf",
                      );
                    },
                    child: const Text('打开文件1'),
                  ),
                  TextButton(
                    onPressed: () async {
                      mupdf02controller.switchFile(
                        newFilePath:
                            "/data/data/com.paj.mupdf02_example/cache/pdf_t1.pdf",
                      );
                    },
                    child: const Text('打开文件2'),
                  ),
                  TextButton(
                    onPressed: () async {
                      mupdf02controller.beginDraw();
                    },
                    child: const Text('开始绘制'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await mupdf02controller.saveDraw();

                      await mupdf02controller.setPenColor(
                        color: Colors.red,
                      );

                      await mupdf02controller.beginDraw();
                    },
                    child: const Text('画笔为红色'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await mupdf02controller.saveDraw();
                      await mupdf02controller.setPenColor(
                        color: Colors.black,
                      );
                      await mupdf02controller.beginDraw();
                    },
                    child: const Text('画笔为黑色'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await mupdf02controller.saveDraw();
                      await mupdf02controller.setPenWidth(width: 10);
                      await mupdf02controller.beginDraw();
                    },
                    child: const Text('粗画笔'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await mupdf02controller.saveDraw();
                      await mupdf02controller.setPenWidth(width: 3);
                      await mupdf02controller.beginDraw();
                    },
                    child: const Text('细画笔'),
                  ),
                  TextButton(
                    onPressed: () async {
                      mupdf02controller.cancelDraw();
                    },
                    child: const Text('取消绘制'),
                  ),
                  TextButton(
                    onPressed: () async {
                      mupdf02controller.saveDraw();
                    },
                    child: const Text('保存绘制'),
                  ),
                  TextButton(
                    onPressed: () async {
                      mupdf02controller.saveFile();
                    },
                    child: const Text('保存文件'),
                  ),
                  TextButton(
                    onPressed: () async {
                      mupdf02controller.jumpToPageIndex(pageIndex: 2);
                    },
                    child: const Text('跳转到第二页'),
                  ),

                  TextButton(
                    onPressed: () async {
                      mupdf02controller.jumpToUpPageIndex();
                    },
                    child: const Text('上一页'),
                  ),

                  TextButton(
                    onPressed: () async {
                      mupdf02controller.jumpToNextPageIndex();
                    },
                    child: const Text('下一页'),
                  ),

                  TextButton(
                    onPressed: () async {
                      int? totalNum = await mupdf02controller.totalPageNum();

                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                '页面总数为: $totalNum',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('消失'),
                                ),
                              ],
                            );
                          },);
                    },
                    child: const Text('页面总数'),
                  ),

                  TextButton(
                    onPressed: () async {
                      await mupdf02controller.openFileAgain(initPageIndex: 2);
                    },
                    child: const Text('重新打开文件\n并定位到第2页'),
                  ),


                  TextButton(
                    onPressed: () async {
                      await mupdf02controller.setFrameEyeColor(color: Colors.yellow.withAlpha(30));
                    },
                    child: const Text('护眼模式'),
                  ),

                  TextButton(
                    onPressed: () async {
                      await mupdf02controller.setFrameEyeColor(color: Colors.black.withAlpha(30));
                    },
                    child: const Text('夜间模式'),
                  ),



                  // TextButton(
                  //   onPressed: () async {
                  //     // todo
                  //   },
                  //   child: const Text('搜索'),
                  // ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Mupdf02Widget(
              controller: mupdf02controller,
            ),
          ),
        ],
      ),
    );
  }
}
