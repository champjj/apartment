import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Userroom extends StatefulWidget {
  final String apartment;
  final String name;
  final String username;
  final String room;
  final String floor;
  Userroom(
      {Key key,
      @required this.room,
      @required this.floor,
      @required this.apartment,
      @required this.name,
      @required this.username})
      : super(key: key);

  @override
  _UserroomState createState() => _UserroomState();
}

class _UserroomState extends State<Userroom> {
  var address = '';
  String name = 'loading...';
  String phone = '';
  List iteinroom = [
    "เตียง",
    "ฟุก",
    "โต๊ะ",
    "รีโมทแอร์",
    "แอร์",
    "ทีวี",
    "รีโมททีวี"
  ];

  @override
  void initState() {
    super.initState();
    getaddress();
    getphone();
  }

  Future<void> getaddress() async {
    await Firebase.initializeApp().then((valuel) async {
      FirebaseFirestore.instance
          .collection(widget.apartment)
          .doc('detail')
          .collection('room')
          .doc(widget.floor)
          .collection('roominfloor')
          .doc(widget.room)
          .get()
          .then((value) {
        setState(() {
          address = value["adddress"];
        });
      });
    });
  }

  Future<void> getphone() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseFirestore.instance
          .collection(widget.apartment)
          .doc("detail")
          .collection("managehome")
          .doc('number')
          .get()
          .then((value) {
        setState(() {
          phone = value["number"];
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Room ${widget.room}"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(border: Border.all()),
                  child: Expanded(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Text('ชื่อ - นามสกุล : '),
                          title: Text(widget.name),
                        ),
                        ListTile(
                          leading: Text('ที่อยู่หอพัก     : '),
                          title: Text(address),
                        ),
                        ListTile(
                          leading: Text('ติดต่อหอพัก   : '),
                          title: Text(phone),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 270),
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: Colors.grey),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Text('ของภายในห้อง'),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(), color: Colors.white),
                            child: Column(
                              children: [
                                ListTile(
                                    title: Center(child: Text(iteinroom[0]))),
                                ListTile(
                                    title: Center(child: Text(iteinroom[1]))),
                                ListTile(
                                    title: Center(child: Text(iteinroom[2]))),
                                ListTile(
                                    title: Center(child: Text(iteinroom[3]))),
                                ListTile(
                                    title: Center(child: Text(iteinroom[4]))),
                                ListTile(
                                    title: Center(child: Text(iteinroom[5]))),
                                ListTile(
                                    title: Center(child: Text(iteinroom[6]))),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
