import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({super.key, this.title, this.description, this.deadline, this.taskId});
  final String? title;
  final String? description;
  final DateTime? deadline;
  final String? taskId;  // ID задачи для редактирования

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  String? _title;
  String? _description;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _description = widget.description;
    _deadline = widget.deadline;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Используем Dialog вместо AlertDialog для настройки ширины
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Скругление углы
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
                },
                controller: TextEditingController(text: _title), // Устанавливаем начальное значение
              ),
              TextField(
                decoration: const InputDecoration(labelText: ('Описание')),
                onChanged: (value) {
                  _description = value;
                },
                controller: TextEditingController(text: _description), // Устанавливаем начальное значение
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0), // Отступ сверху
                child: Row(
                  children: [
                    Text(
                      'Дедлайн: ${DateFormat('dd.MM.yy HH:mm').format(_deadline ?? DateTime.now())}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 16), // Отступ между текстом и кнопкой
                    IconButton(
                      onPressed: () {
                        // Открываем календарь для выбора даты и времени
                        showDatePicker(
                          context: context,
                          initialDate: _deadline ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        ).then((pickedDate) {
                          if (pickedDate != null) {
                            // После выбора даты, открыть TimePicker
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(_deadline ?? DateTime.now()),
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
                      icon: const Icon(Icons.calendar_today),
                    ),
                  ],
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
                      final tasksCollection = FirebaseFirestore.instance.collection('tasks');
                      
                      if (widget.taskId != null) {
                        // Редактирование существующей здачи
                        await tasksCollection.doc(widget.taskId).update({
                          'title': _title,
                          'description': _description,
                          'deadline': _deadline,
                        });
                      } else {
                        // Добавление новой задачи
                        await tasksCollection.add({
                          'title': _title,
                          'description': _description,
                          'deadline': _deadline,
                          'completed': false,
                          'is_for_today': false,
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Сохранить'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}




