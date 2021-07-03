import 'package:apartment/dialog/dialogbox.dart';
import 'package:apartment/screen/adminregister.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'adminscreen/navigationbarpage.dart';
import 'userscreen/navigationuser.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  dynamic apartment, floor, room, name, iusername;
  dynamic chuser = 0;
  String username;
  dynamic inpassword = 0;
  String ipass;
  dynamic statuscha;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> chechusermember(String user) async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('user')
          .where("username", isEqualTo: '$user')
          .get()
          .then((value) {
        setState(() {
          chuser = value.size;
          print("usernamestatus $chuser");
        });
      });
    });
  }

  Future<void> statusch() async {
    await FirebaseFirestore.instance
        .collection('user')
        .where("statusout", isEqualTo: "1")
        .get()
        .then((value) {
      setState(() {
        statuscha = value.size;
      });
    });
  }

  Future<void> chechusermemberpass(String pass) async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('user')
          .where("password", isEqualTo: '$pass')
          .get()
          .then((value) {
        setState(() {
          inpassword = value.size;
          print("password status $inpassword");
        });
      });
    });
  }

  Future<void> loginuser(String username) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc('$username')
        .get()
        .then((value) {
      setState(() {
        apartment = value['apartment'];
        floor = value['floor'];
        name = value['name'];
        room = value['room'];
        iusername = value['username'];
        ipass = value['password'];
      });
      print('login success');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: const EdgeInsets.only(right: 20, left: 40, top: 100),
      child: ListView(
        children: [
          ListTile(
            title: Center(child: Text('Welcome to Myapartment')),
          ),
          ListTile(
            leading: Text('Username :'),
            title: TextFormField(
              onChanged: (value) {
                setState(() {
                  username = value;
                  chechusermember('$username');
                  loginuser(username);
                });
              },
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Username'),
            ),
          ),
          ListTile(
            leading: Text('Password :'),
            title: TextFormField(
              onChanged: (value) {
                setState(() {
                  inpassword = value;
                  loginuser(username);
                  chechusermemberpass('$inpassword');
                });
              },
              controller: password,
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Password'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, right: 70, left: 70),
            child: ListTile(
              title: TextButton(
                onPressed: () {
                  if ((chuser == 1) && (inpassword > 0) && (statuscha == 1)) {
                    setState(() {
                      loginuser(username);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Navigationuser(
                                    apartment: apartment,
                                    name: name,
                                    room: room,
                                    floor: floor,
                                    username: iusername,
                                  )));
                    });
                  } else {
                    checkuser();
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.black),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.teal[100],
                  side: BorderSide(color: Colors.black),
                ),
              ),
            ),
          ),
          ListTile(
            title: Container(
              child: Row(
                children: <Widget>[
                  Expanded(child: Divider(color: Colors.black)),
                  Text("Don’t have an account?",
                      style: TextStyle(color: Colors.black)),
                  Expanded(child: Divider(color: Colors.black)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 70, left: 70),
            child: ListTile(
              title: TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AdminRegister()));
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
        ],
      ),
    )));
  }

  Future<void> checkuser() async {
    String semail = email.text.trim();
    String spassword = password.text.trim();
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: semail, password: spassword)
          .then((value) => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => NavigatorPage())))
          .catchError((error) {
        switch (error.code) {
          case "ERROR_WRONG_PASSWORD":
            dialogmsg(context, 'Error Sign in', 'Wrong pasword');
            break;
          case "ERROR_INVALID_EMAIL":
            dialogmsg(
                context, 'Error Sign in', "Email is not correct! Try again");
            break;
          case "ERROR_USER_NOT_FOUND":
            dialogmsg(
                context, 'Error Sign in', "User not found! Register first!");
            break;
          case "ERROR_USER_DISABLED":
            dialogmsg(
                context, 'Error Sign in', "User has been disabled! Try again");
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            dialogmsg(context, 'Error Sign in',
                "Sign in disabled due to too many requests from this user! Try again");
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
            dialogmsg(context, 'Error Sign in',
                "Operation not allowed! Please enable it in the firebase console");
            break;
          default:
            dialogmsg(context, 'Fail', 'Sign in fail. try again');
        }
      });
    });
  }
}
