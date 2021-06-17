import 'package:apartment/screen/userscreen/aboutdorm.dart';
import 'package:apartment/screen/userscreen/usermainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import '../loginpage.dart';

class Navigationuser extends StatefulWidget {
  final String apartment;
  final String name;
  final String username;
  final String room;
  final String floor;
  Navigationuser(
      {Key key,
      @required this.room,
      @required this.floor,
      @required this.apartment,
      @required this.name,
      @required this.username})
      : super(key: key);
  @override
  _NavigationuserState createState() => _NavigationuserState();
}

class _NavigationuserState extends State<Navigationuser> {
  dynamic abourdorm;
  dynamic usermainpage;
  String iname, iusername, iapartment, ifloor, iroom;
  String uname, uusername, uapartment, ufloor, uroom;
  int _currentIndex = 0;
  var setdata = '';
  // final tabs = [Aboutdorm(), UserMainpage(), LoginPage()];
  List tabs = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp();

    iusername = widget.username;
    iname = widget.name;
    iapartment = widget.apartment;
    ifloor = widget.floor;
    iroom = widget.room;

    abourdorm = Aboutdorm(
      apartment: iapartment,
      username: iusername,
      name: iname,
      floor: ifloor,
      room: iroom,
    );

    usermainpage = UserMainpage(
      apartment: iapartment,
      username: iusername,
      name: iname,
      floor: ifloor,
      room: iroom,
    );
    tabs = [abourdorm, usermainpage, LoginPage()];
  }

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
              label: 'หอพัก',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.room_preferences),
              label: 'หน้าหลัก',
              backgroundColor: Colors.red),
          BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'ออกจากระบบ',
              backgroundColor: Colors.teal[100]),
        ],
        onTap: (index) {
          if (index == 2) {
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
