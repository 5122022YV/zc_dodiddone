import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zc_dodiddone/pages/main_page.dart';
import 'package:zc_dodiddone/services/firebase_auth.dart';
import '../pages/login_page.dart';
import 'package:zc_dodiddone/theme/theme.dart';


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  late User? user;

  @override
  void initState() {
    super.initState();
    user = _authService.currentUser; // Initialize user here
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: DoDidDoneTheme.lightTheme,
      home: user == null ? const LoginPage() : const MainPage(),
    ); 
  }
}

// Используемый код до изменений для автовхода 
// import 'package:flutter/material.dart';
// import '../pages/login_page.dart';
// import 'package:zc_dodiddone/theme/theme.dart';


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'zc_dodiddone',
//       theme: DoDidDoneTheme.lightTheme,
//       home: const LoginPage(),
//     );
//   }
// }