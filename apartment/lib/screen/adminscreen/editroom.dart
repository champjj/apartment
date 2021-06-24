import 'dart:io';
import 'dart:ui';

import 'package:apartment/database/managestatusroom.dart';
import 'package:apartment/dialog/dialogbox.dart';

import 'package:apartment/screen/adminscreen/notavailable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';

class Editroom extends StatefulWidget {
  final String idroom;
  final String idfloor;
  Editroom({Key key, @required this.idroom, @required this.idfloor})
      : super(key: key);
  @override
  _EditroomState createState() => _EditroomState();
}

class _EditroomState extends State<Editroom> {
  String name = '',
      username = '',
      password = '',
      conpassword = '',
      phone = '',
      adddress = '',
      idcard = '',
      note = '',
      apartmentname = '',
      urlimg = 'null';
  dynamic chuser = '';
  File file;

  var firebaseuser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    displayname();
  }

////////////////////////////   image   ///////////////////////////////////
  Future<void> uploadImage() async {
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child("userimage/$apartmentname$username");
    StorageUploadTask storageUploadTask = storageReference.putFile(file);
    urlimg = await (await storageUploadTask.onComplete).ref.getDownloadURL();
    getimgsave(urlimg);
  }

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
          .collection('room')
          .doc('${widget.idroom}')
          .set({
        "urlimg": pic,
      }, SetOptions(merge: true)).then((value) {
        print(pic);
      });
    });
  }
  //////////////////////////////////////////////////////////////////////////

  Future<void> displayname() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {
          apartmentname = event.displayName;
        });
      });
    });
  }

  Future<void> chechusermember() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('user')
          .where("username", isEqualTo: username)
          .get()
          .then((value) {
        setState(() {
          chuser = value.size;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Room ${widget.idroom}"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, right: 5, left: 5, bottom: 15),
                child: Container(
                  height: 820,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(border: Border.all(width: 1)),
                        child: ListTile(
                          leading: Text('ข้อมูลผู้เช่า'),
                        ),
                      ),
                      ListTile(
                        leading: Text('รูปผู้เช่า'),
                        title: Container(
                            height: 100,
                            width: 100,
                            child: InkWell(
                              onTap: () {
                                chooseImage(ImageSource.gallery);
                              },
                              child: Container(
                                  child: file == null
                                      ? Icon(Icons.supervised_user_circle)
                                      : Image.file(file)),
                            )),
                      ),
                      ListTile(
                        title: TextFormField(
                          onChanged: (value) => name = value.trim(),
                          initialValue: '$name',
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'ชื่อผู้ใช้*'),
                        ),
                      ),
                      ListTile(
                        title: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              username = value.trim();
                              chechusermember();
                            });
                          },
                          initialValue: username,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'username*'),
                        ),
                      ),
                      ListTile(
                        title: TextFormField(
                          onChanged: (value) => password = value.trim(),
                          initialValue: password,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password*'),
                        ),
                      ),
                      ListTile(
                        title: TextFormField(
                          onChanged: (value) => conpassword = value.trim(),
                          initialValue: conpassword,
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Confirm - Password*'),
                        ),
                      ),
                      ListTile(
                        title: TextFormField(
                          onChanged: (value) => phone = value.trim(),
                          initialValue: phone,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'เบอร์โทร*'),
                        ),
                      ),
                      ListTile(
                        title: TextFormField(
                          onChanged: (value) => adddress = value.trim(),
                          initialValue: adddress,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'ที่อยู่ผู้เช่า*'),
                        ),
                      ),
                      ListTile(
                        title: TextFormField(
                          onChanged: (value) => idcard = value.trim(),
                          initialValue: idcard,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'หมายเลขบัตรประชาชน*'),
                        ),
                      ),
                      ListTile(
                        title: TextFormField(
                          onChanged: (value) => note = value.trim(),
                          initialValue: note,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'หมายเหตุ'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: ListTile(
                          title: TextButton(
                            onPressed: () {
                              if ((name == '') ||
                                  (username == '') ||
                                  (password.trim() == '') ||
                                  (phone == '') ||
                                  (adddress == '') ||
                                  (idcard == '')) {
                                dialogmsg(context, 'ช่องว่าง',
                                    'กรุณากรอกข้อมูลในช่องที่มีเครื่องหมาย * ให้ครบ');
                              } else if (password.length < 5) {
                                dialogmsg(context, 'รหัสผ่านน้อย',
                                    'กรุณากรอกรหัสผ่านให้มากกว่า 5 ตัวอักษร');
                              } else if (password.trim() !=
                                  conpassword.trim()) {
                                dialogmsg(context, 'รหัสผ่านไม่ตรงกัน',
                                    'กรุณากรอกรหัสผ่านให้ตรงกันทั้ง 2 ช่อง');
                              } else {
                                if (chuser != 0) {
                                  dialogmsg(context, 'Username ซ้ำ',
                                      'username ซ้ำ กรุณาเปลี่ยนเพื่อให่ไม่ซ้ำกับผู้อื่น');
                                } else {
                                  uploadImage();
                                  editroom().deleteroomavailable(
                                      apartmentname, widget.idroom);
                                  editroom().createuser(
                                      username,
                                      password,
                                      name,
                                      apartmentname,
                                      widget.idfloor,
                                      widget.idroom,
                                      urlimg);
                                  editroom()
                                      .adduser(
                                          widget.idfloor,
                                          widget.idroom,
                                          '1',
                                          name,
                                          username,
                                          password,
                                          phone,
                                          idcard,
                                          adddress,
                                          note,
                                          urlimg)
                                      .then((value) =>
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      NotavailableRoom(
                                                        idfloor:
                                                            "${widget.idfloor}",
                                                        idroom:
                                                            "${widget.idroom}",
                                                      ))));
                                }
                              }
                            },
                            child: Text(
                              'บันทึก',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.green,
                              side: BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
