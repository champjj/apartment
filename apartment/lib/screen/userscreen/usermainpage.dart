import 'package:apartment/screen/userscreen/moveout.dart';
import 'package:apartment/screen/userscreen/payment.dart';
import 'package:apartment/screen/userscreen/userroom.dart';
import 'package:flutter/material.dart';

class UserMainpage extends StatefulWidget {
  final String apartment;
  final String name;
  final String username;
  final String room;
  final String floor;
  UserMainpage(
      {Key key,
      @required this.room,
      @required this.floor,
      @required this.apartment,
      @required this.name,
      @required this.username})
      : super(key: key);
  @override
  _UserMainpageState createState() => _UserMainpageState();
}

class _UserMainpageState extends State<UserMainpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 200, left: 100, right: 100),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.green, border: Border.all()),
                  child: ListTile(
                    title: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Paymentpage(
                                        apartment: widget.apartment,
                                        name: widget.name,
                                        room: widget.room,
                                        floor: widget.floor,
                                        username: widget.username,
                                      )));
                        },
                        child: Text(
                          'แจ้งค่าชำระ',
                          style: TextStyle(color: Colors.black),
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.blue, border: Border.all()),
                  child: ListTile(
                    title: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Userroom(
                                        apartment: widget.apartment,
                                        name: widget.name,
                                        room: widget.room,
                                        floor: widget.floor,
                                        username: widget.username,
                                      )));
                        },
                        child: Text('ห้องของฉัน',
                            style: TextStyle(color: Colors.black))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.yellow, border: Border.all()),
                  child: ListTile(
                    title: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Checkout(
                                        apartment: widget.apartment,
                                        name: widget.name,
                                        room: widget.room,
                                        floor: widget.floor,
                                        username: widget.username,
                                      )));
                        },
                        child: Text('แจ้งย้ายออก',
                            style: TextStyle(color: Colors.black))),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
