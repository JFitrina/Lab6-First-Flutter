import 'dart:math';
import 'package:flutterloginpage/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutterloginpage/page/home_screen.dart';
import 'package:flutterloginpage/controllers/auth_controller.dart';
import 'package:flutterloginpage/models/user_models.dart';
import 'package:flutterloginpage/page/register.dart';
import 'package:flutterloginpage/widget/costomCliper.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    print(_usernameController.text);
    print(_passwordController.text);
    if (_formKey.currentState!.validate()) {
      try {
        UserModel userModel = await AuthController()
            .login(context, _usernameController.text, _passwordController.text);

        if (!mounted) return;

        // ตรวจสอบ role ของผู้ใช้
        String role = userModel.user.role;
        print("role :$role");

        // อัปเดตสถานะการเข้าสู่ระบบของผู้ใช้
        Provider.of<UserProvider>(context, listen: false).onLogin(userModel);

        // นำทางไปยังหน้าตาม role ของผู้ใช้
        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin');
        } else if (role == 'user') {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // กรณีที่ role ไม่ตรงกับที่คาดไว้
          print('Error: Unknown role');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      // ต้อง return widget ที่สร้าง
      appBar: AppBar(
        title: Text('LOGIN'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              width: 370, // กำหนดความกว้างของกล่องสี่เหลี่ยม
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                    255, 247, 243, 113), // สีพื้นหลังของกล่องสี่เหลี่ยม
                borderRadius: BorderRadius.circular(16.0), // มุมโค้งของกล่อง
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 0, 0, 0)
                        .withOpacity(0.5), //แสงเงาของกล่อง
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // การเลื่อนของเงา
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontSize: 46,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    SizedBox(height: 32.0),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'USERNAME',
                          prefixIcon: Icon(Icons.person,
                              color: const Color.fromARGB(255, 12, 12, 12)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          prefixIcon: Icon(Icons.lock,
                              color: const Color.fromARGB(255, 0, 0, 0)),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 220, 223, 220), // เปลี่ยนสีพื้นหลังของปุ่ม
                        padding: EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10), // ขนาดปุ่ม
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // มุมโค้งของปุ่ม
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 20,
                            color: const Color.fromARGB(
                                255, 15, 15, 15)), // เปลี่ยนสีข้อความและขนาด
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      child: Text(
                        'REGISTER',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
