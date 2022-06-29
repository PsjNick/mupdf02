package com.paj.mupdf02;

import android.content.Context;
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
import java.util.Map;

import io.flutter.plugin.platform.PlatformView;

public class MuPdfView implements PlatformView {

    final Context context;

    private  String filePath;

    private View rootView;

    // 当前页码
    int currentPageIndex = 1;

    public  MuPDFReaderView.Mode currentModel = MuPDFReaderView.Mode.Viewing;

    public com.artifex.mupdfdemo.MuPDFReaderView muPDFReaderView;
    public MuPDFCore muPDFCore;
    public MuPDFPageAdapter muPDFPageAdapter;

    public MuPdfView(Context context, Object args) {

        this.context = context;
        this.filePath = ((Map<String, Object>) args).get("FilePath").toString();

        boolean IsScrollHor = (boolean)((Map<String, Object>) args).get("IsScrollHor");

        log("FilePath: " + filePath);

        rootView = LayoutInflater.from(context).inflate(R.layout.mupdf_content, null);

        muPDFReaderView = rootView.findViewById(R.id.mupdfreaderview);

        try {
            muPDFCore = new MuPDFCore(context, filePath);
        } catch (Exception e) {
            muPDFCore = null;
            e.printStackTrace();
        }


        muPDFPageAdapter = new MuPDFPageAdapter(context, muPDFCore);

        muPDFReaderView.setAdapter(muPDFPageAdapter);

        muPDFReaderView.setHorizontalScrolling(IsScrollHor);

        muPDFReaderView.setDisplayedViewIndex(0);


        muPDFReaderView.setListener(new MuPDFReaderViewListener() {
            @Override
            public void onMoveToChild(int i) {
                currentPageIndex = i;

                Map resArg = new HashMap();
                resArg.put("PageIndex",currentPageIndex+1);


                Mupdf02Plugin.channel.invokeMethod("PageIndexChange",resArg);
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
                resArg.put("Name",item.name());

                Mupdf02Plugin.channel.invokeMethod("OnTapDraw",resArg);

            }
        });

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
