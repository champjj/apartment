import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Aboutdorm extends StatefulWidget {
  final String apartment;
  final String name;
  final String username;
  final String room;
  final String floor;
  Aboutdorm(
      {Key key,
      @required this.room,
      @required this.floor,
      @required this.apartment,
      @required this.name,
      @required this.username})
      : super(key: key);
  @override
  _AboutdormState createState() => _AboutdormState();
}

class _AboutdormState extends State<Aboutdorm> {
  String img =
      'https://firebasestorage.googleapis.com/v0/b/apartmentapp-e5c6f.appspot.com/o/apartmenticon.png?alt=media&token=0714ba20-a747-4f91-a6e5-13e956d9d77a';
  String announce = 'กรอกข้อความ';
  String rule = 'กรอกข้อความ';
  String number = 'กรอกเบอร์โทรศัพท์';
  String apartmentname = 'Loading...';
  String urlimg;
  var firebaseuser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    displayname();
    apartmentname = widget.apartment;
  }

  Future<void> anc() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection(widget.apartment)
          .doc('detail')
          .collection('managehome')
          .doc('anc')
          .get()
          .then((str) {
        setState(() {
          announce = str['announce'];
        });
      });
    });
  }

  Future<void> rul() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection(widget.apartment)
          .doc('detail')
          .collection('managehome')
          .doc('rule')
          .get()
          .then((str) {
        setState(() {
          rule = str['rule'];
        });
      });
    });
  }

  Future<void> getimg() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection(widget.apartment)
          .doc('detail')
          .collection('managehome')
          .doc('rule')
          .get()
          .then((str) {
        setState(() {
          urlimg = str['urlimg'];
        });
      });
    });
  }

  Future<void> numb() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection(widget.apartment)
          .doc('detail')
          .collection('managehome')
          .doc('number')
          .get()
          .then((str) {
        setState(() {
          number = str['number'];
        });
      });
    });
  }

  Future<void> displayname() async {
    await Firebase.initializeApp().then((value) async {
      setState(() {
        anc();
        rul();
        numb();
        getimg();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Padding(
      padding: const EdgeInsets.only(top: 50),
      child: ListView(
        children: [
          ListTile(
            title: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(),
                child: Image.network(
                  urlimg == null ? img : urlimg,
                  loadingBuilder: (context, child, progress) {
                    return progress == null ? child : LinearProgressIndicator();
                  },
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: ListTile(
              leading: Text('ประกาศ'),
            ),
          ),
          ListTile(
            title: Center(
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                width: 280,
                height: 120,
                child: SingleChildScrollView(
                    child: Text(
                  '$announce',
                  style: TextStyle(color: Colors.teal[300]),
                )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: ListTile(
              leading: Text('กฏระเบียบ'),
            ),
          ),
          ListTile(
            title: Center(
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                width: 280,
                height: 120,
                child: SingleChildScrollView(
                    child: Text(
                  rule,
                  style: TextStyle(color: Colors.teal[300]),
                )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: ListTile(
              leading: Text('เบอร์โทรศัพท์'),
            ),
          ),
          ListTile(
            title: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  width: 280,
                  height: 100,
                  child: SingleChildScrollView(
                      child: Text(
                    number,
                    style: TextStyle(color: Colors.teal[300]),
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
    )));
  }
}
