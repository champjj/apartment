import 'package:apartment/screen/adminscreen/dashboard.dart';
import 'package:apartment/screen/adminscreen/roomstatus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../loginpage.dart';
import 'aboutapartment.dart';

class NavigatorPage extends StatefulWidget {
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _currentIndex = 0;
  final tabs = [AdminHomepage(), RoomStatuspage(), DashboardPage(), LoginPage];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'หน้าหลัก',
              backgroundColor: Colors.green),
          BottomNavigationBarItem(
              icon: Icon(Icons.room_preferences),
              label: 'สถานะห้อง',
              backgroundColor: Colors.yellow[600]),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'ออกจากระบบ',
              backgroundColor: Colors.teal[100]),
        ],
        onTap: (index) {
          if (index == 3) {
            dialogbox(context);
          } else
            setState(() {
              _currentIndex = index;
            });
        },
      ),
    );
  }

  Future<Null> dialogbox(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: ListTile(
                title: Text('ออกจากระบบ'),
                subtitle: Text('คุณต้องการออกจากระบบใช่ไหม'),
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('ยกเลิก')),
                    TextButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut().then((value) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                            print('Logout');
                          });
                        },
                        child: Text('ตกลง')),
                  ],
                )
              ],
            ));
  }
}
