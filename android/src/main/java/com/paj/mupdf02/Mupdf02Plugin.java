package com.paj.mupdf02;

import android.graphics.Color;

import androidx.annotation.NonNull;

import com.artifex.mupdfdemo.MuPDFReaderView;
import com.artifex.mupdfdemo.MuPDFView;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


public class Mupdf02Plugin implements FlutterPlugin, MethodCallHandler {

    public static MethodChannel channel;
    private MuPdfViewFactory muPdfViewFactory;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {

        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "mupdf2_method_channel");

        channel.setMethodCallHandler(this);
        muPdfViewFactory = new MuPdfViewFactory();

        flutterPluginBinding.getPlatformViewRegistry().registerViewFactory("mupdf2_view", muPdfViewFactory);

    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

        String method = call.method;
        Map<String,Object> arguments = (Map<String, Object>) call.arguments;

        if(muPdfViewFactory == null || muPdfViewFactory.muPdfView == null){
            result.success(null);
            return;
        }

        switch (method){
            case "BeginDraw":   // 开始绘制

                if(muPdfViewFactory.muPdfView.currentModel == MuPDFReaderView.Mode.Drawing){
                    result.success(false);
                }

                muPdfViewFactory.muPdfView.currentModel = MuPDFReaderView.Mode.Drawing;
                muPdfViewFactory.muPdfView.muPDFReaderView.setMode(muPdfViewFactory.muPdfView.currentModel);

                Map resArg = new HashMap();
                resArg.put("StateCode",1);


                channel.invokeMethod("StateChange",resArg);
                result.success(true);

                break;
            case "CancelDraw":  // 取消绘制

                MuPDFView pageView = (MuPDFView) muPdfViewFactory.muPdfView.muPDFReaderView.getDisplayedView();
                if (pageView != null) {
                    pageView.deselectText();
                    pageView.cancelDraw();
                }

                muPdfViewFactory.muPdfView.currentModel = MuPDFReaderView.Mode.Viewing;
                muPdfViewFactory.muPdfView.muPDFReaderView.setMode(muPdfViewFactory.muPdfView.currentModel);

                Map resArg2 = new HashMap();
                resArg2.put("StateCode",0);

                channel.invokeMethod("StateChange",resArg2);

                result.success(true);

                break;

            case "DelDraw": // 删除绘制
                MuPDFView pageViewDel = (MuPDFView) muPdfViewFactory.muPdfView.muPDFReaderView.getDisplayedView();
                if (pageViewDel != null) {
                    pageViewDel.deleteSelectedAnnotation();
                }
                result.success(true);
                break;

            case "SaveDraw":    // 保存绘制

                muPdfViewFactory.muPdfView.currentModel = MuPDFReaderView.Mode.Viewing;
                muPdfViewFactory.muPdfView.muPDFReaderView.setMode(muPdfViewFactory.muPdfView.currentModel);

                Map resArg3 = new HashMap();
                resArg3.put("StateCode",0);


                channel.invokeMethod("StateChange",resArg3);

                MuPDFView pageView2 = (MuPDFView) muPdfViewFactory.muPdfView.muPDFReaderView.getDisplayedView();

                if (pageView2 != null) {
                    pageView2.deselectText();
                    pageView2.saveDraw();
                    pageView2.update();
                }

                muPdfViewFactory.muPdfView.muPDFReaderView.resetupChildren();
                result.success(true);
                break;

            case "SetPenColor":     // 设置画笔颜色


//                if(muPdfViewFactory.muPdfView.currentModel == MuPDFReaderView.Mode.Drawing){
//
//                    muPdfViewFactory.muPdfView.currentModel = MuPDFReaderView.Mode.Viewing;
//                    muPdfViewFactory.muPdfView.muPDFReaderView.setMode(muPdfViewFactory.muPdfView.currentModel);
//
//                    MuPDFView pageViewSetPenColor = (MuPDFView) muPdfViewFactory.muPdfView.muPDFReaderView.getDisplayedView();
//
//                    if (pageViewSetPenColor != null) {
//                        pageViewSetPenColor.deselectText();
//                        pageViewSetPenColor.saveDraw();
//                        pageViewSetPenColor.update();
//                    }
//                    muPdfViewFactory.muPdfView.muPDFReaderView.resetupChildren();
//
//                    muPdfViewFactory.muPdfView.currentModel = MuPDFReaderView.Mode.Drawing;
//                    muPdfViewFactory.muPdfView.muPDFReaderView.setMode(muPdfViewFactory.muPdfView.currentModel);
//
//                }


                muPdfViewFactory.muPdfView.muPDFReaderView.setInkColor(Color.parseColor((String) arguments.get("Color")));

                result.success(true);

                break;

            case "SepPenWidth":     // 设置画笔粗细

//                if(muPdfViewFactory.muPdfView.currentModel == MuPDFReaderView.Mode.Drawing){
//
//                    muPdfViewFactory.muPdfView.currentModel = MuPDFReaderView.Mode.Viewing;
//                    muPdfViewFactory.muPdfView.muPDFReaderView.setMode(muPdfViewFactory.muPdfView.currentModel);
//
//                    MuPDFView pageViewSetPenColor = (MuPDFView) muPdfViewFactory.muPdfView.muPDFReaderView.getDisplayedView();
//                    if (pageViewSetPenColor != null) {
//                        pageViewSetPenColor.deselectText();
//                        pageViewSetPenColor.saveDraw();
//                        pageViewSetPenColor.update();
//                    }
//                    muPdfViewFactory.muPdfView.muPDFReaderView.resetupChildren();
//
//                    muPdfViewFactory.muPdfView.currentModel = MuPDFReaderView.Mode.Drawing;
//                    muPdfViewFactory.muPdfView.muPDFReaderView.setMode(muPdfViewFactory.muPdfView.currentModel);
//
//                }

                muPdfViewFactory.muPdfView.muPDFReaderView.setPaintStrockWidth(Float.parseFloat((String) arguments.get("Width")));

                result.success(true);
                break;

            case "SaveFile":    // 保存文件

                if(muPdfViewFactory.muPdfView.currentModel == MuPDFReaderView.Mode.Drawing){

                    muPdfViewFactory.muPdfView.currentModel = MuPDFReaderView.Mode.Viewing;
                    muPdfViewFactory.muPdfView.muPDFReaderView.setMode(muPdfViewFactory.muPdfView.currentModel);

                    MuPDFView pageViewSetPenColor = (MuPDFView) muPdfViewFactory.muPdfView.muPDFReaderView.getDisplayedView();
                    if (pageViewSetPenColor != null) {
                        pageViewSetPenColor.deselectText();
                        pageViewSetPenColor.saveDraw();
                        pageViewSetPenColor.update();
                    }
                    muPdfViewFactory.muPdfView.muPDFReaderView.resetupChildren();

                }

                muPdfViewFactory.muPdfView.muPDFCore.save();
                result.success(true);
                break;

            case "SwitchPageIndex": // 切换页面
                if(muPdfViewFactory.muPdfView.currentModel != MuPDFReaderView.Mode.Viewing){
                    result.success(false);
                    return;
                }
                muPdfViewFactory.muPdfView.muPDFReaderView.setDisplayedViewIndex((int)arguments.get("PageIndex"));
                result.success(true);
                break;

            case "TotalPageNum":    // 获取页面总数
                result.success(muPdfViewFactory.muPdfView.muPDFCore.countPages());
                break;

            case "CurrentPageNum":  // 获取当前在第几页
                result.success(muPdfViewFactory.muPdfView.currentPageIndex);
                break;


            default:
                result.success(null);
        }

    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }


}
