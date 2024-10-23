import 'package:flutter/material.dart';
import 'package:flutterloginpage/page/login.dart';
import 'package:flutterloginpage/widget/costomCliper.dart';
import 'package:flutterloginpage/controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      print('Username : ${usernameController.text}');
      print('Password : ${passwordController.text}');
      print('name : ${nameController.text}');
      print('role : ${roleController.text}');
      print('email : ${emailController.text}');

      try {
        final user = await AuthController().register(
            context,
            usernameController.text,
            passwordController.text,
            nameController.text,
            roleController.text,
            emailController.text);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 100),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'REGISTER',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Color.fromARGB(255, 208, 208, 208),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "USERNAME",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: usernameController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor:
                                          Color.fromARGB(255, 207, 206, 206),
                                      filled: true),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your username';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "PASSWORD",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor:
                                          Color.fromARGB(255, 209, 209, 209),
                                      filled: true),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "NAME",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: nameController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor:
                                          Color.fromARGB(255, 208, 208, 208),
                                      filled: true),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "ROLE",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: roleController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor:
                                          Color.fromARGB(255, 207, 207, 207),
                                      filled: true),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your role';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "EMAIL ADDRESS",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextFormField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      fillColor:
                                          Color.fromARGB(255, 209, 209, 209),
                                      filled: true),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: _register,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.fromARGB(255, 234, 238, 113),
                                Color.fromARGB(255, 242, 219, 90),
                              ],
                            ),
                          ),
                          child: Text(
                            'REGISTER',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ),
                      ),
                      SizedBox(height: height * .02),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.all(1),
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Have an account? ',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 39, 67, 252),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 0,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
                        child: Icon(Icons.keyboard_arrow_left,
                            color: Colors.black),
                      ),
                      Text('BACK',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
