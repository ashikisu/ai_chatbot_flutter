import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:ai_chatbot_flutter/constant/constant.dart';
import 'package:ai_chatbot_flutter/pages/home_page.dart';

void main() {

  /// Add this line
  Gemini.init(apiKey:GEMINI_API_KEY,);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JARVIS',
      theme: ThemeData(


        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,

      ),
      home: const AHomePage(),

    );
  }
}
