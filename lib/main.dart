import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutterrific_opentelemetry/flutterrific_opentelemetry.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'pages/home_page.dart';
import 'pages/opal_page.dart';
import 'pages/videos_page.dart';
import 'pages/links_page.dart';

late final String appVersion;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final packageInfo = await PackageInfo.fromPlatform();
  appVersion = packageInfo.version;

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterOTel.reportError(
        'FlutterError.onError', details.exception, details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FlutterOTel.reportError('PlatformError', error, stack);
    return true;
  };

  await FlutterOTel.initialize(
    serviceName: const String.fromEnvironment('OTEL_SERVICE_NAME',
        defaultValue: 'observe-cx'),
    serviceVersion: appVersion,
    endpoint: const String.fromEnvironment('OTEL_EXPORTER_OTLP_ENDPOINT',
        defaultValue: 'http://10.0.2.2:4317'),
    secure: const bool.fromEnvironment('OTEL_EXPORTER_OTLP_SECURE',
        defaultValue: false),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Observe CX',
      navigatorObservers: [FlutterOTel.routeObserver],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C5CE7),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C5CE7),
          brightness: Brightness.dark,
        ),
      ),
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const HomePage();
      case 1:
        page = const OpalPage();
      case 2:
        page = const VideosPage();
      case 3:
        page = const LinksPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return Scaffold(
            body: page,
            bottomNavigationBar: NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.code_outlined),
                  selectedIcon: Icon(Icons.code),
                  label: 'OPAL',
                ),
                NavigationDestination(
                  icon: Icon(Icons.play_circle_outline),
                  selectedIcon: Icon(Icons.play_circle),
                  label: 'Videos',
                ),
                NavigationDestination(
                  icon: Icon(Icons.link_outlined),
                  selectedIcon: Icon(Icons.link),
                  label: 'Links',
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  extended: constraints.maxWidth >= 800,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.code_outlined),
                      selectedIcon: Icon(Icons.code),
                      label: Text('OPAL'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.play_circle_outline),
                      selectedIcon: Icon(Icons.play_circle),
                      label: Text('Videos'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.link_outlined),
                      selectedIcon: Icon(Icons.link),
                      label: Text('Links'),
                    ),
                  ],
                ),
                Expanded(child: page),
              ],
            ),
          );
        }
      },
    );
  }
}
