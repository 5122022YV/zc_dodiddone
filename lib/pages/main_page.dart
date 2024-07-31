import 'package:flutter/material.dart';
import '../theme/theme.dart'; // Импортируем файл с темой

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    TasksScreen(), // Задачи
    TodayScreen(), // Сегодня
    CompletedScreen(), // Выполнено
    ProfileScreen(), // Профиль
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Прозрачный AppBar
        elevation: 0, // Убираем тень
//        title: Text( 
//          _screens[_selectedIndex].runtimeType.toString(), // Заголовок по экрану
//          style: TextStyle(color: Colors.black), // Черный текст
      ),
//    ),
      body: Container( // Добавляем Container для фона
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight, // Изменяем направление градиента
            colors: [
              DoDidDoneTheme.lightTheme.colorScheme.secondary,
              DoDidDoneTheme.lightTheme.colorScheme.primary,
            ],
            stops: const [0.1, 0.9], // Основной цвет занимает 90% пространства
          ),
        ),
        child: _screens[_selectedIndex], // Оборачиваем body в Container
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent, // Прозрачный BottomNavigationBar
        elevation: 0, // Убираем тень
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: DoDidDoneTheme.lightTheme.colorScheme.primary, // Основной цвет для выбранной иконки
        unselectedItemColor: Colors.grey, // Серый цвет для невыбранных иконок
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Задачи',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Сегодня',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Выполнено',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}

// Заглушки для экранов
class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Задачи'));
  }
}

class TodayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Сегодня'));
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Профиль'));
  }
}

class CompletedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Выполнено'));
  }
}
