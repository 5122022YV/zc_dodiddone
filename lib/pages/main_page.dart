import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zc_dodiddone/screens/completed.dart';
import 'package:zc_dodiddone/screens/for_today.dart';
import '../screens/all_tasks.dart'; // Импортируем файл с страницами задач
import '../screens/profile.dart';
import '../theme/theme.dart'; // Импортируем файл с темой

class MainPage extends StatefulWidget {
  // ignore: use_super_parameters
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    TasksPage(),
    ForTodayPage(),
    CompletedPage(),
    ProfilePage(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Функция для показа диалогового окна 'Добавить задачу'
  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String _title = '';
        String _description = '';
        DateTime _deadline = DateTime.now();

        return Dialog(  
          // Используем Dialog вместо AlertDialog для настройки ширины
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),  // Скругление углы
          ), 
          child: SizedBox(  
            width: 400, // Ширина диалогового окна
            child: Padding(  
              padding: const EdgeInsets.all(20.0), // Отступ для содержимого
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: ('Назване')),
                    onChanged: (value) {
                      _title = value;
                    }  
                  ),
                   TextField(
                    decoration: const InputDecoration(labelText: ('Описание')),
                    onChanged: (value) {
                      _description = value;
                    }  
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0), // Отступ сверху
                    child: ElevatedButton(
                      onPressed: () {
                        // Открываем календарь для выбора даты и времени
                        showDatePicker(
                          context: context,
                          initialDate: _deadline,
                          firstDate: DateTime.now(),
                          lastDate: 
                              DateTime.now().add(const Duration(days: 365)),                          
                        ).then((pickedDate) {
                          if (pickedDate != null) {
                            // После выбора даты, открыть TimePicker
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(_deadline),
                            ).then((pickedTime) {
                              if (pickedTime != null) {
                                setState(() {
                                  _deadline = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    pickedTime.hour,
                                    pickedTime.minute,
                                  ); 
                                });
                              }
                            });
                          }
                        });
                      },  
                      child: Text(
                          'Выбрать дедлайн: ${DateFormat('dd.MM.yy HH:mm').format(_deadline)}'),
                    ),
                  ),
                  const SizedBox(height: 20), // Отступ снизу
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Отмена'),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Добавить задачи в FirebaseFirestore
                          final tasksCollection = 
                              FirebaseFirestore.instance.collection('tasks');
                          await tasksCollection.add({
                            'title': _title,
                            'description': _description,
                            'deadline': _deadline,
                            'completed': false,
                            'is_for_today': false,  
                          });

                          Navigator.pop(context);
                        },
                        child: const Text('Добавить'),  
                      ),
                    ],
                  ),  
                ],  
              ),
            ),
          ),
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
