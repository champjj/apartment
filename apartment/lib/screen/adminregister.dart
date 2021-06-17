import 'dart:ui';

import 'package:apartment/screen/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:apartment/dialog/dialogbox.dart';

class AdminRegister extends StatefulWidget {
  @override
  _AdminRegisterState createState() => _AdminRegisterState();
}

class _AdminRegisterState extends State<AdminRegister> {
  // Sign in
  FirebaseAuth _auth = FirebaseAuth.instance;

  // textcontrol
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController apartmentname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 30, right: 30),
            child: ListTile(
              leading: Text('       E-mail :'),
              title: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: email,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Username'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: ListTile(
              leading: Text('Password :'),
              title: TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: ListTile(
              leading: Text(
                '   Confirm :',
              ),
              title: TextField(
                controller: confirmpassword,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 23, right: 30),
            child: ListTile(
              leading: Text('Apartment :'),
              title: TextField(
                controller: apartmentname,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name of apartment'),
              ),
            ),
          ),
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(top: 30, right: 70, left: 70),
              child: ListTile(
                title: TextButton(
                  onPressed: () {
                    _register();
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.teal[100],
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

////////////  Signin   ///////////////////////////////////////
  Future<Null> _register() async {
    String semail = email.text.trim();
    String spassword = password.text.trim();

    await _auth
        .createUserWithEmailAndPassword(email: semail, password: spassword)
        .then((user) => {
              _apantmentname(),
            })
        .catchError((error) => dialogmsg(context, 'Alert!', error));
  }

  Future<void> _apantmentname() async {
    await FirebaseAuth.instance.currentUser
        .updateProfile(displayName: apartmentname.text.trim())
        .then((value) => registermsg(context, 'สำเร็จ', 'สมัครสมาชิกสำเร็จ'));
  }

  void registermsg(BuildContext context, String head, String msg) async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: ListTile(
                title: Text(head),
                subtitle: Text(msg),
              ),
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text('OK'))
              ],
            ));
  }
}
