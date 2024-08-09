import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  // Инициализвция экземплярам Firebase Authentication 
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Метод для входа с помощью email и пароля
  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      //Вход в Firebase с помощью email и пароля 
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    }     
      catch (e) {
      // Обработка ошибок при входе с помощью email и пароля 
      // The try...catch blocks essential for handling potential errors during authentication. 
      // Блоки try...catch необходимы для обработки потенциальных ошибок при аутентификации.
      print('Ошибка входа по email и паролю: $e');
      return null;
    }
  }

  // Метод для регистрации по email и паролю
  Future<UserCredential?> createUserWithEmailAndPassword(
    String email, String password) async {
  //   try {
  //     // Регистрация в Firebase с помощью email и пароля
  //     return await _firebaseAuth.createUserWithEmailAndPassword(
  //       email: email, password: password);
  //   } catch (e) {
  //     // Обработка ошибок при регистрации с помощью email и пароля
  //     print('Ошибка при регистрации с помощью email и пароля: $e');
  //     return null;
  //   }
  // }

    try {
      // Регистрация в Firebase с помощью email и пароля
      UserCredential credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
      // Отправка запроса подтверждения почты
      await credential.user!.sendEmailVerification();
      return credential;
    } catch (e) {
      // Обработка ошибок при регистрации с помощью email и пароля
      print('Ошибка при регистрации с помощью email и пароля: $e');
      return null;
    }
  }

  // Метод для отправки запроса подтверждения почты
  Future<void> sendEmailVerification() async {
    try {
      // Получение текущего пользователя
      final user = _firebaseAuth.currentUser;

      // Отправка запроса подтвеждения почты
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } catch (e) {
      print('Обработка при отправке запроса подтверждения почты: $e');   
    }
  }
  
  // Метод для выхода из системы
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Ошибка выхода из системы: $e');
    }
  }

  // Метод для получения текущего пользователя
  User? get currentUser => _firebaseAuth.currentUser;
}
