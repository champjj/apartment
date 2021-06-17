import 'package:apartment/model/dashboard_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int checkdate;
  double toltalsum = 0;
  double watersum = 0;
  double elecsum = 0;
  double result = 0;
  dynamic countuser = 0;
  String change = 'เลือกวันที่';
  ////////////////////   show DateTime   /////////////////////////
  DateTime dateTime;
  DateTime dateTimeuntil;
  DateTime selectdate = DateTime.now();
  DateTime selectdateuntil = DateTime.now();
  /////////////////////  changeFormatDateTime  ///////////////////
  String stringdate;
  String stringdateuntil;
  ////////////////////   chang datetime for calculate   //////////
  int caldate;
  int caldateuntil;
  //////////////////////   format date   /////////////////////////
  String formatday;
  String formatmonth;
  String formatyear;
  String formatdayuntil;
  String formatmonthuntil;
  String formatyearuntil;

  String apartmentname = 'Loading...';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    displayname();
    dateTime = DateTime.now();
    dateTimeuntil = DateTime.now();
  }

  Future<void> displayname() async {
    await Firebase.initializeApp().then((value) {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {
          apartmentname = event.displayName;
        });
      });
    });
  }

  void getbill() async {
    await Firebase.initializeApp().then((value) {
      firestore
          .collection(apartmentname)
          .doc('result')
          .collection('bill')
          .where("overdue", isEqualTo: '0')
          .snapshots()
          .listen((event) {
        setState(() {
          toltalsum = 0;
          watersum = 0;
          elecsum = 0;
          result = 0;
          countuser = 0;
          for (var snapshots in event.docs) {
            Map<String, dynamic> map = snapshots.data();
            billmeter model = billmeter.fromMap(map);

            if (model.date >= caldate) {
              if (model.date <= caldateuntil) {
                setState(() {
                  toltalsum += model.total;
                  watersum += model.waterprice;
                  elecsum += model.elecprice;
                  countuser++;
                });
              }
            }
          }
          result = toltalsum - (watersum + elecsum);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Container(
                width: 190,
                height: 190,
                child: PieChart(PieChartData(
                    borderData: FlBorderData(show: false),
                    sections: [
                      PieChartSectionData(
                        value: watersum == 0 ? 1 : watersum,
                        titleStyle: TextStyle(color: Colors.black),
                        color: Colors.blue,
                      ),
                      PieChartSectionData(
                          value: elecsum == 0 ? 1 : elecsum,
                          titleStyle: TextStyle(color: Colors.black),
                          color: Colors.pink),
                      PieChartSectionData(
                          value: toltalsum == 0 ? 1 : toltalsum,
                          titleStyle: TextStyle(color: Colors.black),
                          color: Colors.green[700]),
                      PieChartSectionData(
                        value: result,
                        color: Colors.amber,
                        titleStyle: TextStyle(color: Colors.black),
                      )
                    ])),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          datepicker();
                        },
                        child: Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all()),
                          child: Expanded(
                            child: Row(
                              children: [
                                Container(
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${dateTime.day}/${dateTime.month}/${dateTime.year}",
                                    ),
                                  )),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.arrow_drop_down_outlined),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        child: Text('ถึง'),
                        width: 30,
                      ),
                      InkWell(
                        onTap: () {
                          datepickeruntil();
                        },
                        child: Container(
                          height: 40,
                          width: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all()),
                          child: Row(
                            children: [
                              Container(
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      "${dateTimeuntil.day}/${dateTimeuntil.month}/${dateTimeuntil.year}"),
                                )),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.arrow_drop_down_outlined),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(100)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: () {
                                  getbill();
                                },
                                child: Icon(Icons.search_sharp)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: Container(
                decoration: BoxDecoration(border: Border.all()),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    child: Expanded(
                      child: Column(
                        children: [
                          Container(
                            child: Text(
                              'รวมรายรับ : $toltalsum บาท',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.green[700]),
                            ),
                          ),
                          Container(
                            child: Text(
                              'ค่าน้ำที่จ่าย : $watersum บาท',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.blue),
                            ),
                          ),
                          Container(
                            child: Text(
                              'ค่าไฟที่จ่าย : $elecsum บาท',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.pink),
                            ),
                          ),
                          Container(
                            child: Text(
                              'รายได้สุทธิ : $result บาท',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Colors.amber),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Text('จำนวนผู้เช่าในช่วงเดือน  : $countuser',
                                style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

///////////////////////   get date   ///////////////////////////////////////////

  void datepicker() async {
    await showDatePicker(
            context: context,
            initialDate: selectdate,
            firstDate: DateTime(DateTime.now().year - 5),
            lastDate: DateTime(DateTime.now().year + 5))
        .then((value) {
      setState(() {
        dateTime = value;
        formatday = DateFormat('dd').format(dateTime);
        formatmonth = DateFormat('MM').format(dateTime);
        formatyear = DateFormat('yyyy').format(dateTime);

        stringdate = "$formatyear$formatmonth$formatday";
        caldate = int.parse(stringdate);
        selectdate = value;
        print(caldate);
      });
    });
  }

  void datepickeruntil() async {
    await showDatePicker(
            context: context,
            initialDate: selectdateuntil,
            firstDate: DateTime(DateTime.now().year - 5),
            lastDate: DateTime(DateTime.now().year + 5))
        .then((value) {
      setState(() {
        dateTimeuntil = value;
        formatdayuntil = DateFormat('dd').format(dateTimeuntil);
        formatmonthuntil = DateFormat('MM').format(dateTimeuntil);
        formatyearuntil = DateFormat('yyyy').format(dateTimeuntil);
        stringdateuntil = "$formatyearuntil$formatmonthuntil$formatdayuntil";
        caldateuntil = int.parse(stringdateuntil);
        selectdateuntil = value;
        print(caldateuntil);
      });
    });
  }
  ///////////////////////////////////////////////////////////////////////////////////
}
