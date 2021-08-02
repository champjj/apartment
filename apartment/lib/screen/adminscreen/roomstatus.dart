import 'package:apartment/database/managestatusroom.dart';
import 'package:apartment/dialog/dialogbox.dart';

import 'package:apartment/screen/adminscreen/editroom.dart';
import 'package:apartment/screen/adminscreen/notavailable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class RoomStatuspage extends StatefulWidget {
  @override
  _RoomStatuspageState createState() => _RoomStatuspageState();
}

class _RoomStatuspageState extends State<RoomStatuspage> {
  String searchtext;
  dynamic idroom = 101;
  dynamic ifloor = 1;
  dynamic addfloor = 0;
  dynamic defloor = 0;
  dynamic iroom = 1;
  dynamic deroom;
  dynamic available = 0;
  dynamic overdue = 0;
  dynamic outstatus = 0;
  dynamic allavailable = 0;
  String water;
  String elec;
  String apartmentname = 'Loading...';
  String showdate;
  String day, month, year;
  String sumdate;
  dynamic firebasedatabase;

  var dataselect;
  final firebaseuser = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    displayname();
    checkStatusroom();
    ifloor = "1";
  }

  Future<void> displayname() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {
          apartmentname = event.displayName;
          getwaterelec();
          firstdata();
          checkStatusroom();
        });
      });
    });
  }

  Future<void> getwaterelec() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection(apartmentname)
          .doc('detail')
          .collection('waterelecbill')
          .doc('waterelecbill')
          .get()
          .then((value) {
        setState(() {
          water = value['water'];
          elec = value['elec'];
        });
      });
    });
  }

//////////////////////////////////  checkStatus   //////////////////////////////////////////////

  Future<void> checkStatusroom() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) async {
        await FirebaseFirestore.instance
            .collection(event.displayName)
            .doc('detail')
            .collection('room')
            .where('status', isEqualTo: '0')
            .where('floor', isEqualTo: ifloor)
            .get()
            .then((snap) async {
          await FirebaseFirestore.instance
              .collection(event.displayName)
              .doc('detail')
              .collection('room')
              .where('outstatus', isEqualTo: '1')
              .get()
              .then((out) async {
            await FirebaseFirestore.instance
                .collection(event.displayName)
                .doc('detail')
                .collection('room')
                .where('overdue', isEqualTo: '1')
                .get()
                .then((over) async {
              await FirebaseFirestore.instance
                  .collection(apartmentname)
                  .doc('detail')
                  .collection('room')
                  .where('status', isEqualTo: '0')
                  .get()
                  .then((allavb) {
                setState(() {
                  allavailable = allavb.size;
                  overdue = over.size;
                  outstatus = out.size;
                  available = snap.size;
                });
              });
            });
          });
        });
      });
    });
  }

  //////////////////////////////////////////////////////////////////////////////////

  void _search() async {
    if (searchtext.length > 0) {
      setState(() {
        firebasedatabase = FirebaseFirestore.instance
            .collection(apartmentname)
            .doc('detail')
            .collection('room')
            .where('name', isGreaterThanOrEqualTo: searchtext)
            .snapshots();
      });
    } else {
      setState(() {
        firebasedatabase = FirebaseFirestore.instance
            .collection(apartmentname)
            .doc('detail')
            .collection('room')
            .where('floor', isEqualTo: "$ifloor")
            .snapshots();
      });
    }
  }

  void firstdata() {
    setState(() async {
      firebasedatabase = FirebaseFirestore.instance
          .collection(apartmentname)
          .doc('detail')
          .collection('room')
          .where('floor', isEqualTo: "$ifloor")
          .snapshots();
    });
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.red),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '    ห้องว่าง($available)\nห้องว่างทั้งหมด($allavailable)',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'ค้างชำระ($overdue)',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'สถานะย้ายออก($outstatus)',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
            ///////////////////////////////////////  ปุ่มแก้ค่าน้ำค่าไฟ  //////////////////////////////////////////
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: ListTile(
                leading: TextButton(
                  onPressed: () {
                    dialogeditwaterelelcbill(
                        context, 'แก้ไขค่าน้ำค่าไฟ', water, elec);
                  },
                  child: Text(
                    'แก้ไขค่าน้ำค่าไฟ',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    side: BorderSide(color: Colors.black),
                  ),
                ),
                title: TextFormField(
                  onChanged: (value) {
                    setState(() {
                      searchtext = value;
                      _search();
                    });
                  },
                  initialValue: searchtext,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100)),
                    hintText: 'Search',
                    isDense: true,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),

            /////////////////////////////////////   แสดงชั้น   ////////////////////////////////////////
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                      ),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: firebasefirestore
                            .collection(apartmentname)
                            .doc('detail')
                            .collection('floor')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> querySnapshot) {
                          if (querySnapshot.hasError) {
                            return Text('เกิดข้อผิดพลาด ลองใหม่อีกครั้ง');
                          } else if (!querySnapshot.hasData) {
                            return LinearProgressIndicator();
                          } else {
                            final listfloor = querySnapshot.data.docs;
                            defloor = listfloor.length;
                            addfloor = listfloor.length + 1;

                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: listfloor.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border:
                                        Border.all(style: BorderStyle.solid),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        ifloor = listfloor[index]['floor'];
                                        checkStatusroom();
                                        firstdata();
                                        print(ifloor);
                                      });
                                    },
                                    child: ListTile(
                                      title: Center(
                                          child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 13),
                                        child: Text(listfloor[index]['floor'],
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Colors.black)),
                                      )),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  /////////////////////////////////  ปุ่มเพิ่ม ลบ ชั้น  ////////////////////////////////////////
                  Container(
                    child: TextButton(
                      onPressed: () {
                        dialogmsgdeletefloor(
                            context, 'ยืนยันการยกเลิกชั้นบนสุด', 'ยืนยันการยกเลิกชั้นบนสุด');
                      },
                      child: Text(
                        'ยกเลิกชั้นบนสุด',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        editroom().addfloor("$addfloor");
                      },
                      child: Text(
                        'เพิ่มชั้น',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /////////////////////  แสดงห้อง  ///////////////////////////////////////

            StreamBuilder<QuerySnapshot>(
              stream: firebasedatabase,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> querySnapshot) {
                if (querySnapshot.hasError) {
                  return Text('เกิดข้อผิดพลาด ลองใหม่อีกครั้ง');
                } else if (!querySnapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  final _list = querySnapshot.data.docs;
                  iroom = _list.length + 1;
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 14, right: 14, bottom: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InkWell(
                              onTap: () {
                                if (_list[index]["status"] == 0.toString()) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Editroom(
                                                idroom: _list[index]["room"]
                                                    .toString(),
                                                idfloor: ifloor,
                                              )));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              NotavailableRoom(
                                                idroom: _list[index]["room"]
                                                    .toString(),
                                                idfloor: ifloor,
                                              )));
                                }
                              },
                              child: ListTile(
                                leading: Text(
                                  _list[index]["overdue"] == "0"
                                      ? "Room ${_list[index]["room"]}"
                                      : "Room ${_list[index]["room"]}\nค้างชำระ",
                                ),
                                title: Text(_list[index]["outstatus"] ==
                                        0.toString()
                                    ? ''
                                    : "ต้องการย้ายออก ${_list[index]["showdate"]}"),
                                trailing: Text(
                                  _list[index]["status"] == 0.toString()
                                      ? 'ว่าง'
                                      : 'ไม่ว่าง',
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),

            ///////////////////////    button  add delete room   ///////////////////////////////

            Padding(
              padding: const EdgeInsets.only(top: 10, right: 14),
              child: Container(
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                    onPressed: () {
                      iroom--;
                      if (iroom == 0) {
                        dialogmsg(context, 'ลบห้องพัก', 'ไม่มีห้องพัก');
                        iroom++;
                      } else if (iroom < 10) {
                        dialogdelete(context, "ยกเลิกห้องล่าสุด",
                            "คุณต้องการการลบห้อง $ifloor" "0$iroom ใช่หรือไม่");
                      } else {
                        dialogdelete(context, "ยกเลิกห้องล่าสุด",
                            "คุณต้องการการลบห้อง $ifloor$iroom ใช่หรือไม่");
                      }
                    },
                    child: Text(
                      'ยกเลิกห้องล่าสุด',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red,
                      side: BorderSide(color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: TextButton(
                      onPressed: () {
                        if (iroom < 10) {
                          editroom().addroom("$ifloor", "0$iroom");
                          editroom().plusroomavailable(
                              apartmentname, "${ifloor}0$iroom");
                        } else {
                          editroom().addroom("$ifloor", iroom);
                          editroom().plusroomavailable(apartmentname, iroom);
                        }

                        checkStatusroom();
                      },
                      child: Text(
                        'เพิ่มห้อง',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                  )
                ]),
              ),
            ),

            ///////////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }

  Future<Null> dialogdelete(
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          iroom++;
                          Navigator.pop(context);
                        },
                        child: Text('ยกเลิก')),
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: TextButton(
                          onPressed: () {
                            if (iroom < 10) {
                              deroom = "$ifloor" "0${iroom.toString()}";
                              editroom().deleteroom(deroom, '$ifloor');
                              editroom()
                                  .deleteroomavailable(apartmentname, deroom);
                            } else {
                              deroom = "$ifloor$iroom";
                              editroom().deleteroom(deroom, '$ifloor');
                              editroom()
                                  .deleteroomavailable(apartmentname, deroom);
                            }

                            checkStatusroom();
                            Navigator.pop(context);
                          },
                          child: Text('ยืนยัน')),
                    )
                  ],
                )
              ],
            ));
  }

////////////////////////////   delete floor  //////////////////////////////////
  Future<Null> dialogmsgdeletefloor(
      BuildContext context, String head, String msg) async {
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
                      Navigator.pop(context);
                      editroom().deletefloor("$defloor");
                    },
                    child: Text('ยืนยัน')),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('ยกเลิก')),
              ],
            ));
  }

  Future<Null> dialogeditwaterelelcbill(
      BuildContext context, String head, dynamic water, dynamic elec) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Container(
          width: double.maxFinite,
          height: 180,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Center(child: Text(head)),
              ),
              ListTile(
                leading: Text('ค่าน้ำ'),
                title: TextFormField(
                  initialValue: water,
                  keyboardType: TextInputType.number,
                  onChanged: (wat) {
                    water = wat;
                  },
                ),
              ),
              ListTile(
                leading: Text('ค่าไฟ'),
                title: TextFormField(
                  initialValue: elec,
                  keyboardType: TextInputType.number,
                  onChanged: (ele) {
                    elec = ele;
                  },
                ),
              ),
            ],
          ),
        ),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('ยกเลิก')),
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: TextButton(
                  onPressed: () {
                    editroom().waterElecBill(water, elec);
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(backgroundColor: Colors.green),
                  child: Text(
                    'บันทึก',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
