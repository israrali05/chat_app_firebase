import 'package:chat_app_firebase/firebase_options.dart';
import 'package:chat_app_firebase/models/firebase_helper.dart';
import 'package:chat_app_firebase/models/user_model.dart';
import 'package:chat_app_firebase/screens/home_screen.dart';
import 'package:chat_app_firebase/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  User? currentUser = FirebaseAuth.instance.currentUser;
  UserModel? thisuserModel = await FirebaseHelper.getUserById(currentUser!.uid);
  if (currentUser != null) {
    runApp(HomeScreenLogin(userModel: thisuserModel!, user: currentUser));
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class HomeScreenLogin extends StatelessWidget {
  final UserModel userModel;
  final User user;

  const HomeScreenLogin(
      {super.key, required this.userModel, required this.user});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeScreen(firebaseUser: user, userModel: userModel));
  }
}
