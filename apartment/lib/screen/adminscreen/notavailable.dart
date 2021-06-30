import 'package:apartment/database/managestatusroom.dart';
import 'package:apartment/dialog/dialogbox.dart';
import 'package:apartment/model/overdue_model.dart';
import 'package:apartment/screen/adminscreen/checkpayment.dart';
import 'package:apartment/screen/adminscreen/navigationbarpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

class NotavailableRoom extends StatefulWidget {
  final String idroom;
  final String idfloor;
  NotavailableRoom({Key key, @required this.idroom, @required this.idfloor})
      : super(key: key);

  @override
  _NotavailableRoomState createState() => _NotavailableRoomState();
}

class _NotavailableRoomState extends State<NotavailableRoom> {
  String name = '...',
      phone = '...',
      adddress = '...',
      idcard = '...',
      note = '...',
      roomnote = '',
      apartmentname = '...',
      overdue = '',
      outstatus = '';
  double overdueprice = 0;
  int savedate;
  bool check = true;

  double waterprice = 0;
  double elecprice = 0;
  double beforewatermeter = 0;
  double afterwatermeter = 0;
  double unitwatermeter = 0;
  double beforeelecmeter = 0;
  double afterelecmeter = 0;
  double unitelecmeter = 0;
  double water = 0;
  double elec = 0;
  double accruedamount = 0;
  double total = 0;
  double roomprice = 0;
  String dateday = DateFormat('dd').format(DateTime.now());
  String datemonth = DateFormat('MM').format(DateTime.now());
  String dateyear = DateFormat('yyyy').format(DateTime.now());
  String dday = DateTime.now().toString();
  String datenow;
  String edate;
  String urlimg;
  var firebaseuser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    displayname();
    getbill();

    datenow = '$dateday' + '/' + '$datemonth' + '/' + '$dateyear';
    edate = "$dateyear$datemonth$dateday";
    savedate = int.parse(edate);
  }

  Future<void> displayname() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {
          apartmentname = event.displayName;
          getwaterelec();
          getdataroom();
          getbill();
        });
      });
    });
  }

  Future<void> getbill() async {
    await Firebase.initializeApp().then((value) async {
      FirebaseFirestore.instance
          .collection(apartmentname)
          .doc('detail')
          .collection('meter')
          .doc(widget.idroom)
          .collection('bill')
          .where("room", isEqualTo: "${widget.idroom}")
          .where("overdue", isEqualTo: '1')
          .snapshots()
          .listen((event) {
        setState(() {
          overdueprice = 0;
          event.size == 0 ? setoverduestatus('0') : setoverduestatus('1');
          for (var snapshots in event.docs) {
            Map<String, dynamic> map = snapshots.data();
            OverdueModel model = OverdueModel.fromMap(map);
            setState(() {
              overdueprice += model.total;
            });
          }
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

  Future<void> ern(String roomed) async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection(apartmentname)
          .doc('detail')
          .collection('room')
          .doc('${widget.idroom}')
          .set({"detailroom": "$roomed"}, SetOptions(merge: true));
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
          water = double.parse(value['water']);
          elec = double.parse(value['elec']);
        });
      });
    });
  }

  Future<void> getdataroom() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection(apartmentname)
          .doc('detail')
          .collection('room')
          .doc('${widget.idroom}')
          .get()
          .then((gdata) {
        setState(() {
          urlimg = gdata["urlimg"];
          name = gdata["name"];
          adddress = gdata["adddress"];
          phone = gdata["number"];
          idcard = gdata["idcard"];
          note = gdata["note"];
          overdue = gdata["overdue"];
          roomnote = gdata["detailroom"];
          outstatus = gdata["outstatus"];
          if (outstatus == '1') {
            check = false;
          } else {
            check = true;
          }
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
                  height: 560,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                  ),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          decoration:
                              BoxDecoration(border: Border.all(width: 1)),
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  '   ผู้เช่า',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all()),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'ยอดค้างชำระ\n $overdueprice บาท',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  editdialog(roomnote);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1)),
                                  child: Container(
                                    width: 150,
                                    height: 40,
                                    child: Center(
                                        child: Container(
                                            child: SingleChildScrollView(
                                                child: Text('$roomnote')))),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Text('รูปผู้เช่า'),
                        title: Container(
                            height: 70,
                            width: 70,
                            child: urlimg == null || urlimg == 'null'
                                ? Icon(Icons.supervised_user_circle)
                                : Image.network(urlimg)),
                      ),
                      ListTile(
                        leading: Text('ชื่อ'),
                        title: Text('                        $name'),
                      ),
                      ListTile(
                        leading: Text('เบอร์โทร'),
                        title: Text('                     $phone'),
                      ),
                      ListTile(
                          leading: Text('ที่อยู่ผู้เช่า'),
                          title: Text("                    $adddress")),
                      ListTile(
                          leading: Text('หมายเลขบัตรประชาชน'),
                          title: Text('$idcard')),
                      ListTile(
                        leading: Text('หมายเหตุ'),
                        title: Text('                     $note'),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 30, right: 30, top: 30),
                        child: ListTile(
                          title: TextButton(
                            onPressed: () {
                              edit(name, phone, adddress, idcard, note);
                            },
                            child: Text(
                              '          แก้ไข          ',
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
                ),
              ),
              AbsorbPointer(
                absorbing: check,
                child: TextButton(
                  onPressed: () {
                    moveout();
                    editroom().plusroomavailable(apartmentname, widget.idroom);
                  },
                  child: Text(
                    'ยกเลิกสัญญา / ย้ายออก',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: check == true ? Colors.grey : Colors.red,
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Checkpayment(
                                idfloor: widget.idfloor,
                                idroom: widget.idroom,
                              )));
                },
                child: Text(
                  'ตรวจสอบการชำระเงิน\n           เรียบร้อย',
                  style: TextStyle(color: Colors.white),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                  side: BorderSide(color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, right: 5, left: 5, bottom: 10),
                child: Container(
                  width: 700,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10, right: 90, bottom: 15),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  child: Text('ยอดชำระของวันที่ $datenow')),
                            ),
                          ),
                        ),
                        Container(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                roomprice = double.parse(value);
                                unitwatermeter =
                                    afterwatermeter - beforewatermeter;
                                waterprice = unitwatermeter * water;
                                total = accruedamount +
                                    waterprice +
                                    elecprice +
                                    roomprice;
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'ค่าห้อง'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Table(
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              children: [
                                //////////////  1  //////////////////
                                TableRow(children: [
                                  Text(
                                    'มิเตอร์น้ำ',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  TextFormField(
                                    onChanged: (value) {
                                      beforewatermeter = double.parse(value);
                                      setState(() {
                                        unitwatermeter =
                                            afterwatermeter - beforewatermeter;
                                        waterprice = unitwatermeter * water;
                                        total = accruedamount +
                                            waterprice +
                                            elecprice +
                                            roomprice;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  Text(
                                    '   -',
                                    style: TextStyle(fontSize: 40),
                                  ),
                                  TextFormField(
                                    onChanged: (value) {
                                      afterwatermeter = double.parse(value);
                                      setState(() {
                                        unitwatermeter =
                                            afterwatermeter - beforewatermeter;
                                        waterprice = unitwatermeter * water;
                                        total = accruedamount +
                                            waterprice +
                                            elecprice +
                                            roomprice;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  Container(),
                                ]),
                                //////////////  2  //////////////////
                                TableRow(children: [
                                  Text(
                                    '  ค่าน้ำ        $water บาท',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  AbsorbPointer(
                                    absorbing: true,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: '$unitwatermeter'),
                                    ),
                                  ),
                                  Text('    หน่วย',
                                      style: TextStyle(fontSize: 18)),
                                  AbsorbPointer(
                                    absorbing: true,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: '$waterprice'),
                                    ),
                                  ),
                                  Text(
                                    '   บาท',
                                    style: TextStyle(fontSize: 18),
                                  )
                                ]),
                                //////////////  3  //////////////////
                                TableRow(children: [
                                  Text(
                                    'มิเตอร์ไฟ',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  TextFormField(
                                    onChanged: (value) {
                                      beforeelecmeter = double.parse(value);
                                      setState(() {
                                        unitelecmeter =
                                            afterelecmeter - beforeelecmeter;
                                        elecprice = unitelecmeter * elec;
                                        total = accruedamount +
                                            waterprice +
                                            elecprice +
                                            roomprice;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  Text(
                                    '   -',
                                    style: TextStyle(fontSize: 40),
                                  ),
                                  TextFormField(
                                    onChanged: (value) {
                                      afterelecmeter = double.parse(value);

                                      setState(() {
                                        unitelecmeter =
                                            afterelecmeter - beforeelecmeter;
                                        elecprice = unitelecmeter * elec;
                                        total = accruedamount +
                                            waterprice +
                                            elecprice +
                                            roomprice;
                                      });
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  Container(),
                                ]),
                                //////////////  4  //////////////////
                                TableRow(children: [
                                  Text(
                                    '  ค่าไฟ        $elec บาท',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  AbsorbPointer(
                                    absorbing: true,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: '$unitelecmeter'),
                                    ),
                                  ),
                                  Text('    หน่วย',
                                      style: TextStyle(fontSize: 18)),
                                  AbsorbPointer(
                                    absorbing: true,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "$elecprice"),
                                    ),
                                  ),
                                  Text('   บาท', style: TextStyle(fontSize: 18))
                                ]),
                                /////////////////   5   /////////////////
                              ]),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Table(
                          children: [
                            TableRow(children: [
                              Text('รวม', style: TextStyle(fontSize: 18)),
                              Text('$total', style: TextStyle(fontSize: 18))
                            ]),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            waterelecbill(
                                beforewatermeter.toString(),
                                afterwatermeter.toString(),
                                beforeelecmeter.toString(),
                                afterelecmeter.toString(),
                                unitwatermeter.toString(),
                                unitelecmeter.toString(),
                                waterprice.toString(),
                                elecprice.toString(),
                                roomprice.toString(),
                                total,
                                edate.toString(),
                                widget.idroom);
                            anotherbill(
                                beforewatermeter,
                                afterwatermeter,
                                beforeelecmeter,
                                afterelecmeter,
                                unitwatermeter,
                                unitelecmeter,
                                waterprice,
                                elecprice,
                                roomprice,
                                total,
                                savedate,
                                widget.idroom);
                          },
                          child: Text(
                            '        บันทึก         ',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            side: BorderSide(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //////////////////////////   Edit Room Detail  //////////////////////////////
  void editdialog(String editroomnote) {
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
                title: Center(child: Text('แก้ไขรายละเอียดห้อง')),
              ),
              ListTile(
                title: TextFormField(
                  initialValue: editroomnote,
                  onChanged: (ern) {
                    editroomnote = ern;
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
                    ern(editroomnote);
                    Navigator.pop(context);
                    getdataroom();
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

  /////////////////////////////////  edit room data ///////////////////////////////////////////

  void edit(String ename, String ephone, String eaddress, String eidcard,
      String enote) {
    showDialog(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: SimpleDialog(
          title: Container(
            width: double.maxFinite,
            height: 370,
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: Center(child: Text('แก้ไขรายละเอียดห้อง')),
                ),
                ListTile(
                  leading: Text('ชื่อ          '),
                  title: TextFormField(
                    initialValue: name,
                    onChanged: (ern) {
                      name = ern;
                    },
                  ),
                ),
                ListTile(
                  leading: Text('เบอร์โทร'),
                  title: TextFormField(
                    initialValue: phone,
                    onChanged: (ph) {
                      phone = ph;
                    },
                  ),
                ),
                ListTile(
                  leading: Text('ที่อยู่ผู้เช่า'),
                  title: TextFormField(
                    initialValue: adddress,
                    onChanged: (add) {
                      adddress = add;
                    },
                  ),
                ),
                ListTile(
                  leading: Text('บัตรปชช.'),
                  title: TextFormField(
                    initialValue: idcard,
                    onChanged: (ern) {
                      idcard = ern;
                    },
                  ),
                ),
                ListTile(
                  leading: Text('หมายเหตุ'),
                  title: TextFormField(
                    initialValue: note,
                    onChanged: (ern) {
                      note = ern;
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
                      dataroom(name, phone, adddress, idcard, note);
                      Navigator.pop(context);
                      getdataroom();
                      getbill();
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
      ),
    );
  }

  void dataroom(String name, String phone, String address, String idcard,
      String note) async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection(apartmentname)
          .doc('detail')
          .collection('room')
          .doc('${widget.idroom}')
          .set({
        "name": "$name",
        "number": "$phone",
        "idcard": "$idcard",
        "adddress": "$adddress",
        "note": "$note",
      }, SetOptions(merge: true)).then((value) => getdataroom());
    });
  }

  /////////////////////////////////////////////////////////////////

  ////////////////////   moveout Room Data  ///////////////////////////
  void moveout() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: ListTile(
                title: Text('ต้องการลบข้อมูลห้อง ' + widget.idroom + ' ?'),
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        usermoveout(
                            name, phone, adddress, widget.idroom, idcard, dday);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NavigatorPage()));
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

  void usermoveout(String name, String phone, String adddress, String room,
      String idcard, String dayout) async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection(apartmentname)
          .doc('history')
          .collection('room')
          .doc()
          .set({
        "name": "$name",
        "phone": "$phone",
        "address": "$adddress",
        "room": "$room",
        "idcard": "$idcard",
        "dayout": "$dayout"
      }, SetOptions(merge: true)).then((value) => cleardata());
    });
  }

  void cleardata() async {
    await FirebaseFirestore.instance
        .collection(apartmentname)
        .doc('detail')
        .collection('room')
        .doc(widget.idroom)
        .set({
      "status": "0",
      "username": "",
      "password": "",
      "name": "",
      "number": "",
      "idcard": "",
      "address": "",
      "note": "",
      "overdue": "0",
      "outstatus": "0",
      "accruedamount": "0",
    }, SetOptions(merge: true));
  }

  ///////////////////////   Room total price   /////////////////////////////////////////
  void waterelecbill(
      String beforewatermeter,
      String afterwatermeter,
      String beforeelecmeter,
      String afterelecmeter,
      String unitwater,
      String unitelec,
      String waterprice,
      String elecprice,
      String roomprice,
      double total,
      String eday,
      String room) async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection(apartmentname)
          .doc('detail')
          .collection('meter')
          .doc('${widget.idroom}')
          .collection('bill')
          .doc(eday)
          .set({
        "beforewatermeter": beforewatermeter,
        "afterwatermeter": afterwatermeter,
        "beforeelecmeter": beforeelecmeter,
        "afterelecmeter": afterelecmeter,
        "unitwater": unitwatermeter,
        "unitelec": unitelecmeter,
        "waterprice": waterprice,
        "elecprice": elecprice,
        "roomprice": roomprice,
        "total": total,
        "date": savedate,
        "room": room,
        "overdue": "1",
      }).then((value) {
        // getdataroom();
      });
    });
  }

  void anotherbill(
      double beforewatermeter,
      double afterwatermeter,
      double beforeelecmeter,
      double afterelecmeter,
      double unitwater,
      double unitelec,
      double waterprice,
      double elecprice,
      double roomprice,
      double total,
      int date,
      String room) async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection(apartmentname)
          .doc('result')
          .collection('bill')
          .doc("${widget.idroom}$edate")
          .set({
        "beforewatermeter": beforewatermeter,
        "afterwatermeter": afterwatermeter,
        "beforeelecmeter": beforeelecmeter,
        "afterelecmeter": afterelecmeter,
        "unitwater": unitwatermeter,
        "unitelec": unitelecmeter,
        "waterprice": waterprice,
        "elecprice": elecprice,
        "roomprice": roomprice,
        "total": total,
        "date": savedate,
        "room": room,
        "overdue": "1",
      }, SetOptions(merge: true)).then((value) {
        dialogmsg(context, 'สำเร็จ', 'บันทึกข้อมูลสำเร็จ');
      });
    });
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////
}
