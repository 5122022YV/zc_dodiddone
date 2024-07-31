import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true; // Флаг для определения режима (вход/регистрация)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: isLogin
                ? [
                    DoDidDoneTheme.lightTheme.colorScheme.secondary,
                    DoDidDoneTheme.lightTheme.colorScheme.primary,
                  ]
                : [
                    DoDidDoneTheme.lightTheme.colorScheme.primary,
                    DoDidDoneTheme.lightTheme.colorScheme.secondary,
                  ],
            stops: const [0.1, 0.9], // Основной цвет занимает 90% пространства
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Заголовок
              Text(
                isLogin ? 'Вход' : 'Регистрация', // Заголовок "Вход" или "Регистрация"
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Белый цвет текста
                ),
              ),
              const SizedBox(height: 30),

              // Поле логина
              TextField(
                decoration: InputDecoration(
                  hintText: 'Почта',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Поле пароля
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Пароль',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Поле "Повторить пароль" (только для регистрации)
              if (!isLogin)
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Повторить пароль',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              const SizedBox(height: 30),

              // Кнопка "Войти"
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainPage()));
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: !isLogin
                      ? DoDidDoneTheme.lightTheme.colorScheme.primary
                      : DoDidDoneTheme.lightTheme.colorScheme.secondary, // Цвет фона кнопки? DoDidDoneTheme.lightTheme.colorScheme.primary
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(isLogin ? 'Войти' : 'Зарегистрироваться'), // "Войти" или "Зарегистрироваться"
              ),
              const SizedBox(height: 20),

              // Кнопка "У меня еще нет аккаунта"
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin; // Переключение состояния
                  });
                },
                child: Text(
                  isLogin
                      ? 'У меня еще нет аккаунта...'
                      : 'Уже есть аккаунт...', // Текст меняется в зависимости от состояния
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
