package com.paj.mupdf02;

import android.content.Context;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class MuPdfViewFactory extends PlatformViewFactory {


    public  MuPdfView muPdfView;

    public MuPdfViewFactory() {
        super(StandardMessageCodec.INSTANCE);
    }

    @NonNull
    @Override
    public PlatformView create(@Nullable Context context, int viewId, @Nullable Object args) {
        muPdfView =new MuPdfView(context, args);
        return muPdfView;
    }



}
