import 'package:apartment/database/managestatusroom.dart';
import 'package:apartment/dialog/dialogbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Checkpayment extends StatefulWidget {
  final String idroom;
  final String idfloor;
  Checkpayment({Key key, @required this.idroom, @required this.idfloor})
      : super(key: key);
  @override
  _CheckpaymentState createState() => _CheckpaymentState();
}

class _CheckpaymentState extends State<Checkpayment> {
  var elec = '';
  var water = '';
  var getdata;
  var getdateindex;
  String shroom = '';
  String apartmentname = '';
  String showdate;
  String day, month, year;
  String sumdate;
  @override
  void initState() {
    super.initState();
    getwaterelec();
    displayname();
  }

  Future<void> displayname() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {
          apartmentname = event.displayName;
          getwaterelec();
        });
      });
    });
  }

  Future<void> getwaterelec() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseFirestore.instance
          .collection(apartmentname)
          .doc('detail')
          .collection('waterelecbill')
          .doc('waterelecbill')
          .get()
          .then((value) {
        setState(() {
          elec = value["elec"];
          water = value["water"];
        });
      });
    });
  }

  Future<void> setoverduestatus(String status) async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection(apartmentname)
          .doc('detail')
          .collection('room')
          .doc(widget.idroom)
          .set({"overdue": "$status"}, SetOptions(merge: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room ${widget.idroom}'),
      ),
      body: Center(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(apartmentname)
                .doc('detail')
                .collection('meter')
                .doc(widget.idroom)
                .collection('bill')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> querySnapshot) {
              if (querySnapshot.hasError) {
                return Center(
                  child: Text('เชื่อมต่อฐานข้อมูลไม่สำเร็จ'),
                );
              } else if (querySnapshot.connectionState ==
                  ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (!querySnapshot.hasData) {
                return Center(child: Text('ไม่มียอดค้างชำระ'));
              } else {
                final _list = querySnapshot.data.docs;
                return Expanded(
                    child: Center(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _list.length,
                      itemBuilder: (BuildContext context, int index) {
                        showdate = _list[index]["date"].toString();
                        year = showdate.substring(0, 4);
                        month = showdate.substring(4, 6);
                        day = showdate.substring(6);
                        sumdate = "$day/$month/$year";
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            decoration: BoxDecoration(border: Border.all()),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("ยอดชำระของวันที่ $sumdate"),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 40, right: 40),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: Text('ค่าห้อง'),
                                          trailing: Text(_list[index]
                                                  ["roomprice"]
                                              .toString()),
                                        ),
                                        ListTile(
                                          leading: Text('ค่าห้อง'),
                                          trailing: Text(_list[index]
                                                  ["roomprice"]
                                              .toString()),
                                        ),
                                        ListTile(
                                          leading: Text('ค่าน้ำ'),
                                          title: Text(
                                              '$water บาท ${_list[index]["unitwater"]} หน่วย'),
                                          trailing: Text(_list[index]
                                                  ["waterprice"]
                                              .toString()),
                                        ),
                                        ListTile(
                                          leading: Text('ค่าไฟ'),
                                          title: Text(
                                              '$elec บาท ${_list[index]["unitelec"]} หน่วย'),
                                          trailing: Text(_list[index]
                                                  ["elecprice"]
                                              .toString()),
                                        ),
                                        // ListTile(
                                        //   leading: Text(
                                        //     'ยอดค้างชำระ',
                                        //     style: TextStyle(
                                        //         decoration:
                                        //             TextDecoration.underline,
                                        //         color: Colors.black),
                                        //   ),
                                        //   trailing: Text('0'),
                                        // ),
                                        ListTile(
                                          leading: Text('รวม'),
                                          trailing: Text(
                                              _list[index]["total"].toString()),
                                        ),
                                        ListTile(
                                          title: TextButton(
                                              onPressed: () {
                                                deletepayment(
                                                    _list[index]["date"]);
                                              },
                                              child: Text(
                                                'ชำระบิลเรียบร้อยแล้ว',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              style: TextButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                side: BorderSide(
                                                    color: Colors.black),
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                ));
              }
            },
          ),
        ),
      ),
    );
  }

  void deletepayment(int list) {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: ListTile(
                title: Text('ต้องการลบบิลนี้ใช่หรือไม่'),
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        editroom().deletepayment(apartmentname, widget.idfloor,
                            widget.idroom, list.toString());
                        resultbill(list);
                        Navigator.pop(context);
                      },
                      child: Text(
                        '       ยืนยัน       ',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        side: BorderSide(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('       ยกเลิก       ',
                          style: TextStyle(color: Colors.white)),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        side: BorderSide(color: Colors.black),
                      ),
                    )
                  ],
                )
              ],
            ));
  }

  void resultbill(var date) async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection(apartmentname)
          .doc('result')
          .collection('bill')
          .doc("${widget.idroom}$date")
          .set({
        "overdue": "0",
      }, SetOptions(merge: true)).then((value) {
        dialogmsg(context, 'สำเร็จ', 'บันทึกข้อมูลสำเร็จ');
      });
    });
  }
}
