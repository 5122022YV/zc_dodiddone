import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatelessWidget {
  final String title;
  final String description;
  final DateTime deadline;
  final Function? onEdit;
  final Function? onDelete;
  final Function? toLeft;
  final Function? toRight;  

  const TaskItem({
    Key? key,
    required this.title,
    required this.description,
    required this.deadline,
    this.onEdit,
    this.onDelete, 
    this.toLeft, 
    this.toRight,  
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Форматируем дату и время с помощью intl
    String formattedDeadline = DateFormat('dd.MM.yy HH:mm').format(deadline);

    // Определяем градиент в зависимости от срочности
    Duration timeUntilDeadline = deadline.difference(DateTime.now());
    Color gradientStart;
    if (timeUntilDeadline.inDays <= 1) {
      gradientStart = Colors.red;  // Срочная
    } else if (timeUntilDeadline.inDays <= 2) {
      gradientStart = Colors.yellow;  // Средняя срочность
    } else {
      gradientStart = Colors.green;  // Не срочная
    }
    
    return Dismissible(
      key: Key(title),  // Уникадльный ключ для Dismissible
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.arrow_forward_ios, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.blue,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(left: 20.0),
        child: const Icon(Icons.arrow_back_ios, color: Colors.white),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          // Вызываем функцию, если елемент был сдвинут влево
          toLeft?.call();
        } else if (direction == DismissDirection.startToEnd) {
          // Вызываем функцию, если елемент был сдвинут вправо
          toRight?.call();
        }
      },

      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // Добавляем Container для градиента
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [gradientStart, Colors.white],
                ),    
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: onEdit as void Function()?, 
                    icon: const Icon(Icons.edit),
                  ), 
                  IconButton(
                    onPressed: onDelete as void Function()?, 
                    icon: const Icon(Icons.delete),
                  ), 

                ],
              ),   
            ),  
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Дедлайн: $formattedDeadline',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            )
          ],
        ),   
      ),
    );
  }
}
