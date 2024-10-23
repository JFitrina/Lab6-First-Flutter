import 'package:flutter/material.dart';
import 'package:flutterloginpage/page/addProductPage.dart';
import 'package:flutterloginpage/page/editProductPage.dart';
import 'package:flutterloginpage/page/editProductPage.dart';
import 'package:flutterloginpage/page/home_screen.dart';
import 'package:flutterloginpage/page/login.dart';
import 'package:flutterloginpage/page/register.dart';
import 'package:provider/provider.dart';
import 'package:flutterloginpage/providers/user_provider.dart';
import 'package:flutterloginpage/providers/user_provider.dart';
import 'package:flutterloginpage/page/home_admin.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
          title: 'Login Example',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: '/login',
          routes: {
            '/home': (context) => HomeScreen(),
            '/login': (context) => Login(),
            '/register': (context) => RegisterPage(),
            '/admin': (context) => HomeAdmin(),
            '/add_product': (context) => AddProductPage(),
          }),
    );
  }
}