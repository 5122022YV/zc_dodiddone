import 'package:flutter/material.dart';
import '../services/firebase_auth.dart'; // Импортируем AuthenticationService
import '../pages/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuthService _authService = FirebaseAuthService(); // Создаем экземпляр AuthenticationService

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser; // Получаем текущего пользователя

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Аватар
          CircleAvatar(
            radius: 50,
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL!) // Если есть аватар, отображаем его
                : const AssetImage('assets/boy.png'), // Иначе используем дефолтный аватар
          ),
          const SizedBox(height: 20),
          // Почта
          Text(
            user?.email ?? 'example@email.com', // Отображаем почту пользователя, если она есть
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          // Кнопка подтверждения почты (отображается, если почта не подтверждена)
          if (!user!.emailVerified)
            ElevatedButton(
              onPressed: () {
                _authService.sendEmailVerification(); // Отправляем запрос подтверждения почты
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Подтверждение почты'),
                    content: const Text(
                        'Письмо с подтверждением отправлено на ваш адрес.'),
                    actions: [
                      TextButton(
                        //onPressed: () => Navigator.pop(context),
                        onPressed: () => Navigator.pushReplacement(
                           context,
                           MaterialPageRoute(builder: (context) => const LoginPage())),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Подтвердить почту'),
            ),
          const SizedBox(height: 20),
          // Кнопка выхода из профиля
          ElevatedButton(
            onPressed: () async {
              await _authService.signOut(); // Выход из системы
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return const LoginPage();
              }));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Красный цвет для кнопки выхода
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../pages/login_page.dart';
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({Key? key}) : super(key: key);
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
// class _ProfilePageState extends State<ProfilePage> {
//   bool isEmailVerified = false; // Флаг для проверки подтверждения почты
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Аватар
//           CircleAvatar(
//             radius: 50,
//             backgroundImage: const AssetImage(
//                 'assets/boy.png'), // Замените на реальный путь к аватару
//           ),
//           const SizedBox(height: 20),
//           // Почта
//           Text(
//             'example@email.com', // Замените на реальную почту пользователя
//             style: const TextStyle(fontSize: 18),
//           ),
//           const SizedBox(height: 10),
//           // Кнопка подтверждения почты (отображается, если почта не подтверждена)
//           if (!isEmailVerified)
//             ElevatedButton(
//               onPressed: () {
//                 // Обработка отправки запроса подтверждения почты
//                 // Например, можно показать диалог с сообщением о том, что письмо отправлено
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: const Text('Подтверждение почты'),
//                     content: const Text(
//                         'Письмо с подтверждением отправлено на ваш адрес.'),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text('OK'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               child: const Text('Подтвердить почту'),
//             ),
//           const SizedBox(height: 20),
//           // Кнопка выхода из профиля
//           ElevatedButton(
//             onPressed: () {
//               // Обработка выхода из профиля
//               // Например, можно перейти на страницу входа
//               Navigator.pushReplacement(context,
//                   MaterialPageRoute(builder: (context) {
//                 return const LoginPage();
//               }));
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red, // Красный цвет для кнопки выхода
//             ),
//             child: const Text('Выйти'),
//           ),
//         ],
//       ),
//     );
//   }
// }