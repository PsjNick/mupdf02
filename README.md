# mupdf02

基于mupdf的Android端pdf插件，支持简单的文件批注操作.

## Getting Started

注意：

1、暂时只支持 'armeabi-v7a' 的CPU架构，此架构只针对 32位 的ARM设备；
2、由于Flutter在Debug阶段打包架构为 64位 架构，所以在调试阶段请在app模块的 build.gradle 文件中 的 apply plugin: 'com.android.application'  的位置加入以下try catch代码：

```
try {
    project.setProperty('target-platform', 'android-arm')
} catch (e) {
    e.printStackTrace()
}
apply plugin: 'kotlin-android'
apply plugin: 'com.android.application'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
 ```

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

