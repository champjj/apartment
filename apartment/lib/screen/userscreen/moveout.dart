import 'dart:io';

import 'package:apartment/dialog/dialogbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';

class Checkout extends StatefulWidget {
  final String apartment;
  final String name;
  final String username;
  final String room;
  final String floor;

  Checkout(
      {Key key,
      @required this.room,
      @required this.floor,
      @required this.apartment,
      @required this.name,
      @required this.username})
      : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  DateTime date = DateTime.now();
  DateTime datemonth = DateTime.now();
  String formatday;
  String formatmonth;
  String formatyear;
  String stringdate;
  String d;
  int setdate;
  bool check = true;
  List iteinroom = [
    "เตียง",
    "ฟุก",
    "โต๊ะ",
    "รีโมทแอร์",
    "แอร์",
    "ทีวี",
    "รีโมททีวี"
  ];
  List itemprice = ["5,000", "2,000", "500", "300", "3,000", "1,000", "500"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room ${widget.room}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text('วันที่ต้องการย้ายออก'),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      InkWell(
                        onTap: () {
                          datetimepicker();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(5)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("${date.day}/${date.month}/${date.year}"),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  child: Icon(Icons.calendar_today_outlined),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.grey),
                      child: ListTile(
                        leading: Text('ของภายในห้อง'),
                        trailing: Text('ราคา'),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: ListTile(
                      leading: Text(iteinroom[0]),
                      trailing: Text(itemprice[0]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: ListTile(
                      leading: Text(iteinroom[1]),
                      trailing: Text(itemprice[1]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: ListTile(
                      leading: Text(iteinroom[2]),
                      trailing: Text(itemprice[2]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: ListTile(
                      leading: Text(iteinroom[3]),
                      trailing: Text(itemprice[3]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: ListTile(
                      leading: Text(iteinroom[4]),
                      trailing: Text(itemprice[4]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: ListTile(
                      leading: Text(iteinroom[5]),
                      trailing: Text(itemprice[5]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: ListTile(
                      leading: Text(iteinroom[6]),
                      trailing: Text(itemprice[6]),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                AbsorbPointer(
                  absorbing: check,
                  child: InkWell(
                    onTap: () {
                      if (d == null) {
                        dialog(
                            context,
                            'แจ้งย้ายออก',
                            'ยืนยันจะย้ายออกวันที่ ${date.day}/${date.month}/${date.year}',
                            setdate);
                      } else {
                        dialog(context, 'แจ้งย้ายออก',
                            'ยืนยันจะย้ายออกวันที่ $d', setdate);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: check == true ? Colors.grey : Colors.green,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text('ยืนยันแจ้งย้ายออก'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void datetimepicker() async {
    await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year + 10))
        .then((value) {
      setState(() {
        if ((value.month > datemonth.month) && (value.year >= datemonth.year)) {
          date = value;
          formatday = DateFormat('dd').format(date);
          formatmonth = DateFormat('MM').format(date);
          formatyear = DateFormat('yyyy').format(date);
          d = "$formatday/$formatmonth/$formatyear";
          stringdate = "$formatyear$formatmonth$formatday";
          setdate = int.parse(stringdate);
          check = false;
        } else {
          dialogmsg(context, 'ตัวเลือกผิดพลาด',
              'กรุณาเลือกวันย้ายออกเดือนถัดไปเป็นอย่างต่ำ');
        }
      });
    });
  }

  /////////////////////////////  set status moveout   ///////////////////////////////

  void setstatusmoveout(int day, String showday) async {
    await Firebase.initializeApp().then((value) async {
      FirebaseFirestore.instance
          .collection(widget.apartment)
          .doc('detail')
          .collection('room')
          // .doc(widget.floor)
          // .collection('roominfloor')
          .doc(widget.room)
          .set({"outstatus": "1", "date": day, "showdate": showday},
              SetOptions(merge: true));
    });
  }

  Future<Null> dialog(
      BuildContext context, String head, String msg, int setdate) async {
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
                      setstatusmoveout(setdate, d);
                      Navigator.pop(context);
                    },
                    child: Text('ยืนยัน')),
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('ยกเลิก'))
              ],
            ));
  }
}
