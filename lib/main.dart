import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_language_translator/screens/home.dart';
import 'package:sign_language_translator/screens/initial_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
    await Window.initialize();

    Window.setEffect(
      effect: WindowEffect.acrylic,
      color: Colors.transparent,
    );
  }

  final storage = await SharedPreferences.getInstance();
  final bool isConfigured = storage.getBool("isConfigured") ?? false;
  runApp(App(isConfigured));
}

class App extends StatelessWidget {
  final bool isConfigured;
  const App(this.isConfigured, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sign Language Translator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: isConfigured ? Home() : InitialConfig(),
    );
  }
}
