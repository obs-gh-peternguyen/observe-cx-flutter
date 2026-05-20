# Observe CX App

## Android
A new Flutter project. 

To build `APK` with OpenTelemetry settings:

```
flutter clean; flutter build apk --release `
  --dart-define=OTEL_SERVICE_NAME="observe-cx" `
  --dart-define=OTEL_EXPORTER_OTLP_ENDPOINT="<endpoint>>:4317" `
  --dart-define=OTEL_EXPORTER_OTLP_SECURE="false" `
  --dart-define=OTEL_RESOURCE_ATTRIBUTES="service.instance.id=android,service.version=0.0.5,deployment.environment.name=dev"

```
Once built, the `APK` file can be found here:
```
./build/app/outputs/flutter-apk/app-release.apk
```

## Android Testing
1. Download and install Android Studio
2. Follow instructions here: https://docs.flutter.dev/platform-integration/android/setup
3. Open Android Studio and open this project.
4. On the menu bar, go to: Tools > Device Manager > Create Device: Resizable_Experimental
5. Run the emulator to make sure it works, but don't close it yet
6. Run `flutter devices` to make sure you see the Android emulator. 
7. Proceed to run `flutter run` to make sure you see the app.
8. Add this to your `PATH`: `~\AppData\Local\Android\Sdk\emulator` (Windows) or `~/Libarary/Android/sdk/emulator` (Mac)
9. Run this: `emulator -list_avds` it should return the name of your emulator.
10. Run the emulator without Android Studio with `emulator -avd Resizable_Experimental` (or whatever you named it)
11. Finally, do `flutter run` to see the app load in the emulator.

## Windows
Requires Visual Studio and the "Desktop Development with C++" option. To build `EXE` with OpenTelemetry settings:

```
flutter clean; flutter build windows --release `
  --dart-define=OTEL_SERVICE_NAME="observe-cx.windows" `
  --dart-define=OTEL_EXPORTER_OTLP_ENDPOINT="<endpoint>:4317" `
  --dart-define=OTEL_EXPORTER_OTLP_SECURE="true" `
  --dart-define=OTEL_RESOURCE_ATTRIBUTES="service.instance.id=windows,service.version=0.0.5,deployment.environment.name=desktop"
```

Note: Requires `DLL` files and `data` folder to launch `EXE`.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
