import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Paymentpage extends StatefulWidget {
  final String apartment;
  final String name;
  final String username;
  final String room;
  final String floor;

  Paymentpage(
      {Key key,
      @required this.room,
      @required this.floor,
      @required this.apartment,
      @required this.name,
      @required this.username})
      : super(key: key);

  @override
  _PaymentpageState createState() => _PaymentpageState();
}

class _PaymentpageState extends State<Paymentpage> {
  var elec = '';
  var water = '';
  var getdata;
  String shroom = '';
  @override
  void initState() {
    super.initState();
    getwaterelec();
  }

  Future<void> getwaterelec() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseFirestore.instance
          .collection(widget.apartment)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room ${widget.room}'),
      ),
      body: Center(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection(widget.apartment)
                .doc('detail')
                .collection('meter')
                .doc(widget.floor)
                .collection('roominfloor')
                .doc(widget.room)
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
                                      child: Text(
                                          "ยอดชำระของวันที่ ${_list[index]["date"].toString()}"),
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
                                        ListTile(
                                          leading: Text(
                                            'ยอดค้างชำระ',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                color: Colors.black),
                                          ),
                                          trailing: Text('0'),
                                        ),
                                        ListTile(
                                          leading: Text('รวม'),
                                          trailing: Text(
                                              _list[index]["total"].toString()),
                                        ),
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
}
