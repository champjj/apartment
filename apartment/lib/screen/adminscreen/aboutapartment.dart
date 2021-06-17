import 'dart:async';
import 'dart:io';

import 'package:apartment/database/managehome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';

class AdminHomepage extends StatefulWidget {
  @override
  _AdminHomepageState createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  String img =
      'https://firebasestorage.googleapis.com/v0/b/apartmentapp-e5c6f.appspot.com/o/apartmenticon.png?alt=media&token=0714ba20-a747-4f91-a6e5-13e956d9d77a';
  String announce = 'กรอกข้อความ';
  String rule = 'กรอกข้อความ';
  String number = 'กรอกเบอร์โทรศัพท์';
  String apartmentname = 'Loading...';
  String urlimg;
  var firebaseuser = FirebaseAuth.instance.currentUser;
  File file;

  @override
  void initState() {
    super.initState();
    displayname();
  }

  Future<void> anc() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection(apartmentname)
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
          .collection(apartmentname)
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

  Future<void> numb() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection(apartmentname)
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
      FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {
          apartmentname = event.displayName;
          anc();
          rul();
          numb();
          getimg();
        });
      });
    });
  }

  ////////////////////////////    img   ////////////////////////////////////////////
  Future<void> chooseImage(ImageSource imageSource) async {
    try {
      var object = await ImagePicker()
          .getImage(source: imageSource, maxHeight: 800, maxWidth: 800);
      setState(() {
        file = File(object.path);
      });
    } catch (e) {}
  }

  Future<void> getimgsave(String pic) async {
    await Firebase.initializeApp().then((value) async {
      FirebaseFirestore.instance
          .collection(apartmentname)
          .doc('detail')
          .collection('managehome')
          .doc('img')
          .set({
        "urlimg": pic,
      }).then((value) {
        print(pic);
      });
    });
  }

  Future<void> getimg() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseFirestore.instance
          .collection(apartmentname)
          .doc('detail')
          .collection('managehome')
          .doc('img')
          .get()
          .then((value) {
        setState(() {
          urlimg = value["urlimg"];
        });
      });
    });
  }

  Future<void> uploadImage() async {
    String imgname = apartmentname;
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child("apartment/$imgname");
    StorageUploadTask storageUploadTask = storageReference.putFile(file);
    urlimg = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    getimgsave(urlimg);
  }
  /////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 60, right: 60),
          child: ListTile(
            trailing: InkWell(
              onTap: () {
                chooseImage(ImageSource.gallery);
              },
              child: Text(
                'แก้ไข',
                style: TextStyle(
                    decoration: TextDecoration.underline, color: Colors.blue),
              ),
            ),
          ),
        ),
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
          padding: const EdgeInsets.only(left: 80, right: 80),
          child: ListTile(
            title: InkWell(
              onTap: () {
                setState(() {
                  uploadImage();
                  getimg();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('บันทึกรูปภาพ'),
                )),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 60, right: 60),
          child: ListTile(
            leading: Text('ประกาศ'),
            trailing: InkWell(
              onTap: () {
                dialogeditannounce(
                    context, 'แก้ไขประกาศ', 'กรอกข้อความที่ต้องการแก้ไข');
              },
              child: Text(
                'แก้ไข',
                style: TextStyle(
                    decoration: TextDecoration.underline, color: Colors.blue),
              ),
            ),
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
          padding: const EdgeInsets.only(left: 60, right: 60),
          child: ListTile(
            leading: Text('กฏระเบียบ'),
            trailing: InkWell(
              onTap: () {
                dialogeditrule(
                    context, 'แก้ไขกฏระเบียบ', 'กรอกข้อความที่ต้องการแก้ไข');
              },
              child: Text(
                'แก้ไข',
                style: TextStyle(
                    decoration: TextDecoration.underline, color: Colors.blue),
              ),
            ),
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
          padding: const EdgeInsets.only(left: 60, right: 60),
          child: ListTile(
            leading: Text('เบอร์โทรศัพท์'),
            trailing: InkWell(
              onTap: () {
                dialogeditnumber(context, 'แก้ไขเบอร์โทรศัพท์',
                    'กรอกข้อความที่ต้องการแก้ไข');
              },
              child: Text(
                'แก้ไข',
                style: TextStyle(
                    decoration: TextDecoration.underline, color: Colors.blue),
              ),
            ),
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
    )));
  }

////////////////////////////////    setup dialog   /////////////////////////////////////
  Future<void> dialogeditannounce(
      BuildContext context, String head, String msg) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          title: Text(head),
          subtitle: Text(msg),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                child: TextFormField(
                  onChanged: (aedit) => announce = aedit,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  edithome().editannounce(announce);
                  setState(() {});
                  Navigator.pop(context);
                },
                child: Text('บันทึก'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> dialogeditrule(
      BuildContext context, String head, String msg) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          title: Text(head),
          subtitle: Text(msg),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                child: TextFormField(
                  onChanged: (redit) => rule = redit,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  edithome().editrule(rule);
                  setState(() {});
                  Navigator.pop(context);
                },
                child: Text('บันทึก'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> dialogeditnumber(
      BuildContext context, String head, String msg) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          title: Text(head),
          subtitle: Text(msg),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  onChanged: (nedit) => number = nedit,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  edithome().editnumber(number);
                  setState(() {});
                  Navigator.pop(context);
                },
                child: Text('บันทึก'),
              ),
            ],
          )
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////////////////
}
