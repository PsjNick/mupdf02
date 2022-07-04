package com.paj.mupdf02;

import android.content.Context;
import android.graphics.Color;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;

import androidx.annotation.Nullable;

import com.artifex.mupdfdemo.Hit;
import com.artifex.mupdfdemo.MuPDFCore;
import com.artifex.mupdfdemo.MuPDFPageAdapter;
import com.artifex.mupdfdemo.MuPDFReaderView;
import com.artifex.mupdfdemo.MuPDFReaderViewListener;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

public class MuPdfView implements PlatformView {

    final Context context;

    private  String filePath;

    public View rootView,frameEye;

    // 当前页码
    int currentPageIndex = 0;

    public  MuPDFReaderView.Mode currentModel = MuPDFReaderView.Mode.Viewing;

    public com.artifex.mupdfdemo.MuPDFReaderView muPDFReaderView;
    public MuPDFCore muPDFCore;
    public MuPDFPageAdapter muPDFPageAdapter;

    public MuPdfView(Context context, Object args) {

        this.context = context;
        this.filePath = ((Map<String, Object>) args).get("FilePath").toString();

        boolean IsScrollHor = (boolean)((Map<String, Object>) args).get("IsScrollHor");

        currentPageIndex = (int)((Map<String, Object>) args).get("InitPageIndex");

        log("FilePath: " + filePath);

        rootView = LayoutInflater.from(context).inflate(R.layout.mupdf_content, null);

        muPDFReaderView = rootView.findViewById(R.id.mupdfreaderview);
        frameEye = rootView.findViewById(R.id.frame_eye);

        try {
            muPDFCore = new MuPDFCore(context, filePath);
        } catch (Exception e) {
            muPDFCore = null;
            e.printStackTrace();
        }


        muPDFPageAdapter = new MuPDFPageAdapter(context, muPDFCore);

        muPDFReaderView.setAdapter(muPDFPageAdapter);

        muPDFReaderView.setHorizontalScrolling(IsScrollHor);



        muPDFReaderView.setListener(new MuPDFReaderViewListener() {
            @Override
            public void onMoveToChild(int i) {

                currentPageIndex = i;

                Map resArg = new HashMap();
                resArg.put("Method","PageIndexChange");
                Map resArgData = new HashMap();
                resArgData.put("PageIndex",currentPageIndex);
                resArgData.put("AllIndex",muPDFCore.countPages() - 1);
                resArg.put("Data",resArgData);

                Mupdf02Plugin.events.success(resArg);

            }

            @Override
            public void onTapMainDocArea() {
                // todo
            }

            @Override
            public void onDocMotion() {
                // todo
            }

            @Override
            public void onHit(Hit item) {

                if(Mupdf02Plugin.channel == null){
                    return;
                }

                Map resArg = new HashMap();
                resArg.put("Method","OnTapDraw");

                Map resArgData = new HashMap();
                resArgData.put("Name",item.name());

                resArg.put("Data",resArgData);

                Mupdf02Plugin.events.success(resArg);

//                Mupdf02Plugin.channel.invokeMethod("OnTapDraw",resArg);

            }
        });


        muPDFReaderView.setDisplayedViewIndex(currentPageIndex);


        // 护眼模式

        String colorStr = ((Map<String, Object>) args).get("InitFrameEyeColor").toString();

        if(!colorStr.toLowerCase(Locale.ROOT).equals("null") && !colorStr.isEmpty()) {
            frameEye.setBackgroundColor(Color.parseColor(colorStr));
        }


    }

    @Nullable
    @Override
    public View getView() {
        log("getView");
        return rootView;
    }

    @Override
    public void dispose() {

    }


    private void log(String info) {

        Log.i(this.getClass().getSimpleName(), info);

    }

}
