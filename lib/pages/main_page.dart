import 'package:flutter/material.dart';
import '../screens/profile.dart';
import '../theme/theme.dart'; // Импортируем файл с темой
import '../screens/all_tasks.dart'; // Импортируем файл с страницами задач

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TasksPage(),
    Text('Сегодня'),
    Text('Выполнено'),
    ProfilePage(), // Заменяем Text на ProfilePage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Функция для показа диалогового окна
  void _showAddTaskDialog() {
    // Переменная для хранения выбранной даты и времени
    DateTime? _selectedDateTime;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Добавить задачу'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(hintText: 'Введите название задачи'),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(hintText: 'Описание задачи'),
              ),
              SizedBox(height: 16),
              // Кнопка для выбора даты и времени
              ElevatedButton(
                onPressed: () {
                  // Открываем виджет выбора даты и времени
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  ).then((pickedDate) {
                    if (pickedDate == null) return;
                    // Открываем виджет выбора времени
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((pickedTime) {
                      if (pickedTime == null) return;
                      // Сохраняем выбранную дату и время
                      _selectedDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  });
                },
                child: Text('Выбрать дедлайн'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Закрываем диалоговое окно
              },
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                // Здесь вы можете добавить логику для сохранения задачи
                // Используйте _selectedDateTime для получения выбранной даты и времени
                Navigator.of(context).pop(); // Закрываем диалоговое окно
              },
              child: Text('Добавить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Прозрачный AppBar
        elevation: 0, // Убираем тень
      ),
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
        child: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog, // Вызываем функцию при нажатии
        child: Icon(Icons.add),
      ),
    );
  }
}
