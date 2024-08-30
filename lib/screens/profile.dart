import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../pages/login_page.dart';
import '../services/firebase_auth.dart';
import '../utils/image_picker_util.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuthService _authenticaionService = FirebaseAuthService();

  File? _selectedImage;
  bool _showSaveButton = false;


  @override
  void initState() {
    super.initState();
// Get the initial path
  }

  @override
  Widget build(BuildContext context) {
    final user = _authenticaionService.currentUser;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Аватар
          Stack(
            children: [
              FutureBuilder<String?>(
                future: _getDownloadURL(), // Get the download URL
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Show a loading indicator
                  } else if (snapshot.hasError) {
                    return const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/boy.png'), // Show default image on error
                    );
                  } else {
                    return CircleAvatar(
                      radius: 50,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : snapshot.data != null
                              ? CachedNetworkImageProvider(snapshot.data!)
                              : const AssetImage('assets/boy.png'),
                    );
                  }
                },
              ),
              Positioned(
                bottom: -16,
                right: -14,
                child: IconButton(
                  onPressed: () {
                    _showImagePickerDialog(context);
                  },
                  icon: const Icon(Icons.photo_camera),
                ),
              ),
            ],
          ),

          // Кнопка "Сохранить"
          if (_showSaveButton)
            ElevatedButton(
              onPressed: () async {
                if (_selectedImage != null) {
                  try {
                    final storageRef = firebase_storage.FirebaseStorage.instance
                        .ref()
                        .child('user_avatars/${user!.uid}');
                    final uploadTask = storageRef.putFile(_selectedImage!);
                    await uploadTask.whenComplete(() async {
                      final downloadURL = await storageRef.getDownloadURL();
                      await user.updatePhotoURL(downloadURL);

                      setState(() {
                        _selectedImage = null;
                        _showSaveButton = false;
// Update _avatarPath with the full download URL
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Аватар успешно сохранен')),
                      );
                    });
                  } catch (e) {
                    print('Ошибка загрузки аватара: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ошибка загрузки аватара: $e')),
                    );
                  }
                }
              },
              child: const Text('Сохранить'),
            ),
          const SizedBox(height: 20),

          // Почта
          Text(
            user?.email ?? 'example@email.com',  // Отображаем почту пользователя, если она есть
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          // Кнопка подтверждения почты (отображается, если почта не подтверждена)
          if (user != null && !user.emailVerified)
            ElevatedButton(
              onPressed: () async {
                // Отправка запроса подтверждения почты
                await _authenticaionService.sendEmailVerification(); 
                // Показываем диалог с сообщением о том, письмо отправлено 
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Подтверждение почты'),
                    content: const Text(
                        'Письмо с подтверждением отправлено на ваш адрес.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage())),
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
              // Выход из системы
              await _authenticaionService.signOut();
              await CachedNetworkImage.evictFromCache(user?.photoURL ?? ''); // Clear cache here
              // Переход на страницу входа
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()), 
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,   // Красный цвет для кнопки выхода
            ),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }


  // Function to get the download URL 
  Future<String?> _getDownloadURL() async {
    final user = _authenticaionService.currentUser;
    if (user?.photoURL == null) {
      return null;
    }
    final storageRef = firebase_storage.FirebaseStorage.instance.ref().child('user_avatars/${user!.uid}');
    try {
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Error getting download URL: $e');
      return null;
    }
  } 


  // Диалог выбора изображения
  void _showImagePickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выберите изображение'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Из галереи'),
                onTap: () async {
                  File? imageFile =
                      await ImagePickerUtil.pickImageFromGallery();
                  if (imageFile != null) {
                    setState(() {
                      _selectedImage = imageFile;
                      _showSaveButton = true;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Сделать снимок'),
                onTap: () async {
                  File? imageFile =
                      await ImagePickerUtil.pickImageFromCamera();
                  if (imageFile != null) {
                    setState(() {
                      _selectedImage = imageFile;
                      _showSaveButton = true;
                    });
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}





// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// import '../pages/login_page.dart';
// import '../services/firebase_auth.dart';
// import '../utils/image_picker_util.dart';


// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//    final FirebaseAuthService _authenticaionService = FirebaseAuthService(); 

//   File? _selectedImage; // Переменная для сохранения выбранного изображения
//   bool _showSaveButton = false;  // Флаг для отображения кнопки "Сохранить"
//   String? _avatarCacheKey; // Add this variable 
  
//   @override
//   void initState() {
//     super.initState();
//     _avatarCacheKey = DateTime.now().millisecondsSinceEpoch.toString();
//   }


//   @override
//   Widget build(BuildContext context) {
//     final user = _authenticaionService.currentUser; // Получаем текущего пользователя

//     // Generate a new cache key if the user's photoURL changes
//     _avatarCacheKey = user!.photoURL ?? DateTime.now().millisecondsSinceEpoch.toString();

//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Аватар
//           Stack(
//             children: [
//               CachedNetworkImage(
//                 key: ValueKey(_avatarCacheKey), // Use the cache key here
//                 imageUrl: user.photoURL ?? '',
//                 imageBuilder: (context, imageProvider) => CircleAvatar(
//                   radius: 50,
//                   backgroundImage: imageProvider,
//                 ),
//                 placeholder: (context, url) => const CircularProgressIndicator(),
//                 errorWidget: (context, url, error) => const CircleAvatar(
//                   radius: 50,
//                   backgroundImage: AssetImage('assets/boy.png'),
//                 ),
//               ),

//               Positioned(
//                 bottom: -16,
//                 right: -14,
//                 child: IconButton(
//                   onPressed: () {
//                     // Показываем диалог выбора изображения
//                     _showImagePickerDialog(context);
//                   },
//                   icon: const Icon(Icons.photo_camera),
//                 ),
//               ),
//             ],
//           ),  
         


         
//           // Кнопка "Сохранить" (отображается, если выбрано новое изображение)
//           if (_showSaveButton)
//             ElevatedButton(
//               onPressed: () async {
//                 // Загрузка изображения в Firebase Storage
//                 if (_selectedImage != null) {
//                   try {
//                     final storageRef = firebase_storage.FirebaseStorage.instance
//                         .ref()
//                         .child('user_avatars/${user.uid}');
//                     final uploadTask = storageRef.putFile(_selectedImage!);
//                     await uploadTask.whenComplete(() async {
//                       // Получение URL-адреса загруженного изображения
//                       final downloadURL = await storageRef.getDownloadURL();
//                       // Обновление URL-адреса аватара пользователя в Firebase Authentication
//                       await user.updatePhotoURL(downloadURL);
//                       // Сброс состояния
//                       setState(() {
//                         _selectedImage = null;
//                         _showSaveButton = false;
//                         _avatarCacheKey = downloadURL; // Clear the cache key
//                       });
//                       // Вывод сообщения об успешном сохранении
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Аватар успешно сохранен')));
//                     });
//                   } catch (e) {
//                     print('Ошибка загрузки аватара: $e');
//                     // Вывод сообщения об ошибке пользователю
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Ошибка загрузки аватара: $e')));
//                   }
//                 }
//               },
//               child: const Text('Сохранить'),
//             ),
          
//           const SizedBox(height: 20),

//           // Почта
//           Text(
//             user.email ?? 'example@email.com',  // Отображаем почту пользователя, если она есть
//             style: const TextStyle(fontSize: 18),
//           ),
//           const SizedBox(height: 10),
//           // Кнопка подтверждения почты (отображается, если почта не подтверждена)
//           if (user != null && !user.emailVerified)
//             ElevatedButton(
//               onPressed: () async {
//                 // Отправка запроса подтверждения почты
//                 await _authenticaionService.sendEmailVerification(); 
//                 // Показываем диалог с сообщением о том, письмо отправлено 
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: const Text('Подтверждение почты'),
//                     content: const Text(
//                         'Письмо с подтверждением отправлено на ваш адрес.'),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const LoginPage())),
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
//             onPressed: () async {
//               // Выход из системы
//               await _authenticaionService.signOut();
//               await CachedNetworkImage.evictFromCache(user.photoURL ?? ''); // Clear cache here
//               // Переход на страницу входа
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const LoginPage()), 
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,   // Красный цвет для кнопки выхода
//             ),
//             child: const Text('Выйти'),
//           ),
//         ],
//       ),
//     );
//   }
  
//   // Диалог выбора изображения
//   void _showImagePickerDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Выберите изображение'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.photo_library),
//                 title: const Text('Из галереи'),
//                 onTap: () async {
//                   // Выбор изображения из галереи
//                   File? imageFile = 
//                       await ImagePickerUtil.pickImageFromGallery();
//                   if (imageFile != null) {
//                     setState(() {
//                       _selectedImage = imageFile;
//                       _showSaveButton = true;  // Показываем кнопку сохранить
//                     });
//                   }
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.camera_alt),
//                 title: const Text('Сделать снимок'),
//                 onTap: () async {
//                   // Съёмка изображения с камеры
//                   File? imageFile = await ImagePickerUtil.pickImageFromCamera();
//                   if (imageFile != null) {
//                     setState(() {
//                       _selectedImage = imageFile;
//                       _showSaveButton = true; // Показываем кнопку сохранить       
//                     });
//                   }
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
