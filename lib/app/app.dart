import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import 'package:zc_dodiddone/theme/theme.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zc_dodiddone',
      theme: DoDidDoneTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}


