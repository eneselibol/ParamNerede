import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_screen/firebaseauth_provider.dart';
import 'login_screen/user_repository.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserRepository>(
      create: (context) => UserRepository(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: new ThemeData(
            scaffoldBackgroundColor: Color.fromRGBO(70, 70, 70, 1)),
        
        home: ProviderWithFirebaseAuth(),
      ),
    );
  }
}

