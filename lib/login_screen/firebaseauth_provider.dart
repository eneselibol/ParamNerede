import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paramnerede_app/home_page.dart';
import 'package:paramnerede_app/sqflite_islemleri.dart';
import 'login_page.dart';
import 'package:provider/provider.dart';
import 'user_repository.dart';

class ProviderWithFirebaseAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, UserRepository userRepo, child) {
      switch (userRepo.durum) {
        case UserDurumu.Idle:
          return SplashEkran();
        case UserDurumu.OturumAciliyor:
        case UserDurumu.OturumAcilmamis:
          return LoginPage();
        case UserDurumu.OturumAcik:
          return SqfliteIslemleri();
          
      }
    });
  }
}

class SplashEkran extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Splash Ekran"),
      ),
      body: Center(child: Text("Splash Ekranı")),
    );
  }
}
