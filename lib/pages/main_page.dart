import 'package:flutter/material.dart';
import 'package:zc_dodiddone/pages/profile_page.dart';
import 'package:zc_dodiddone/screens/completed.dart';
import 'package:zc_dodiddone/screens/for_today.dart';
import '../screens/all_tasks.dart'; // Импортируем файл с страницами задач
import '../screens/profile.dart';
import '../theme/theme.dart';
import '../widgets/dialog_widget.dart'; // Импортируем файл с темой

class MainPage extends StatefulWidget {
  // ignore: use_super_parameters
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  } 

  int _selectedIndex = 0;
  
  static const List<Widget> _widgetOptions = <Widget>[
    TasksPage(),
    ForTodayPage(),
    CompletedPage(),
    // ProfilePage(), 
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

        return DialogWidget(
          title: _title,
          description: _description,
          deadline: _deadline,  
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
            icon: const Icon(Icons.person, 
            color: Colors.white,
            )
          )
        ]
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'Профиль',
          // ),
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








// //import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// //import 'package:intl/intl.dart';
// import 'package:zc_dodiddone/screens/completed.dart';
// import 'package:zc_dodiddone/screens/for_today.dart';
// import '../screens/all_tasks.dart'; // Импортируем файл с страницами задач
// import '../screens/profile.dart';
// import '../theme/theme.dart';
// import '../widgets/dialog_widget.dart'; // Импортируем файл с темой

// class MainPage extends StatefulWidget {
//   // ignore: use_super_parameters
//   const MainPage({Key? key}) : super(key: key);

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   int _selectedIndex = 0;
//   static const List<Widget> _widgetOptions = <Widget>[
//     TasksPage(),
//     ForTodayPage(),
//     CompletedPage(),
//     ProfilePage(), 
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   // Функция для показа диалогового окна 'Добавить задачу'
//   void _showAddTaskDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         String _title = '';
//         String _description = '';
//         DateTime _deadline = DateTime.now();

//         return DialogWidget(
//           title: _title,
//           description: _description,
//           deadline: _deadline,  
//         ); 
//       },
//     );  
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent, // Прозрачный AppBar
//         elevation: 0, // Убираем тень
//       ),
//       body: Container( // Добавляем Container для фона
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight, // Изменяем направление градиента
//             colors: [
//               DoDidDoneTheme.lightTheme.colorScheme.secondary,
//               DoDidDoneTheme.lightTheme.colorScheme.primary,
//             ],
//             stops: const [0.1, 0.9], // Основной цвет занимает 90% пространства
//           ),
//         ),
//         child: Center(
//           child: _widgetOptions.elementAt(_selectedIndex),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list),
//             label: 'Задачи',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today),
//             label: 'Сегодня',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.check_circle),
//             label: 'Выполнено',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Профиль',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _showAddTaskDialog, // Вызываем функцию при нажатии
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

