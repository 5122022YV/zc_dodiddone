import 'package:flutter/material.dart';
import '../theme/theme.dart';
import 'main_page.dart';
import '../services/firebase_auth.dart'; // Импортируем AuthenticationService

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true; // Флаг для определения режима (вход/регистрация)
  final _formKey = GlobalKey<FormState>(); // Ключ для формы
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); // Для регистрации

  final _authService = FirebaseAuthService(); // Создаем экземпляр AuthenticationService

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height, 
          width: MediaQuery.of(context).size.width,
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
              stops: const [0.1, 0.9],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Добавление логотипа университета
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/zerocoder.png', // Замените на правильный путь к файлу
                        height: 60, // Устанавливаем высоту изображения
                      ),
                      const SizedBox(width: 8),
                      // Добавляем текст "zerocoder"
                      Text(
                        'zerocoder',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Белый цвет текста
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
        
                  // Вставка надписи DoDidDone
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'Do',
                          style: TextStyle(
                            color: DoDidDoneTheme.lightTheme.colorScheme.primary,
                          ),
                        ),
                        const TextSpan(
                          text: 'Did',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'Done',
                          style: TextStyle(
                            color: DoDidDoneTheme.lightTheme.colorScheme.secondary,
                          ),
                        ),
                        ],
                    ),
                  ),
                  const SizedBox(height: 30),
        
                  // Заголовок
                  Text(
                    isLogin ? 'Вход' : 'Регистрация',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
        
                  // Поле логина
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Почта',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите email';
                      }
                      if (!value.contains('@')) {
                        return 'Неверный формат email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
        
                  // Поле пароля
                  TextFormField(
                    controller: _passwordController,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите пароль';
                      }
                      if (value.length < 6) {
                        return 'Пароль должен быть не менее 6 символов';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
        
                  // Поле "Повторить пароль" (только для регистрации)
                  if (!isLogin)
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Повторить пароль',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, повторите пароль';
                        }
                        if (value != _passwordController.text) {
                          return 'Пароли не совпадают';
                        }
                        return null;
                      },
                    ),
                  const SizedBox(height: 30),
        
                  // Кнопка "Войти"
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (isLogin) {
                          // Вход
                          try {
                            final userCredential = await _authService.signInWithEmailAndPassword(
                                _emailController.text, _passwordController.text);   
                            if (userCredential != null) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MainPage()));
                            }
                          } catch (e) {
                            print('Ошибка входа: $e');
                            // Вывод сообщения об ошибке пользователя
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Ошибка входа: $e')));
                          }
                        } else {
                          // Регистрация
                          try {
                            final userCredential = await _authService.createUserWithEmailAndPassword(
                                _emailController.text, 
                                _passwordController.text);
                            if (userCredential != null) {
                              // Переход на Mainpage
                              Navigator.pushReplacement(
                                  context, 
                                  MaterialPageRoute(
                                      builder: (context) => const MainPage()));
                            }
                          } catch (e) {
                            print('Ошибка регистрации: $e');
                            // Вывод сообщения об ошибке пользователя
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Ошибка регистрации: $e')));
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isLogin
                          ? DoDidDoneTheme.lightTheme.colorScheme.primary
                          : DoDidDoneTheme.lightTheme.colorScheme.secondary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(isLogin ? 'Войти' : 'Зарегистрироваться'),
                  ),
                  const SizedBox(height: 20),
        
                  // Кнопка "У меня еще нет аккаунта"
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                      });
                    },
                    child: Text(
                      isLogin
                          ? 'У меня еще нет аккаунта...'
                          : 'Уже есть аккаунт...',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
