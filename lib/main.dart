import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'splash.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'arvirmdnid',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(useMaterial3: true).copyWith(
          scaffoldBackgroundColor: const Color(0xFF0A1929),
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF29B6F6), brightness: Brightness.dark),
        ),
        home: const SplashPage(),
      );
}
