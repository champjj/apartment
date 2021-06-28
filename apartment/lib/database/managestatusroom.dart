import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

// ignore: camel_case_types
class editroom {
  final firebaseuser = FirebaseAuth.instance.currentUser;

////////////////////////////   Edit Floor   /////////////////////////////////////////////
  Future<void> addfloor(String floor) async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        FirebaseFirestore.instance
            .collection(event.displayName)
            .doc('detail')
            .collection('floor')
            .doc(floor)
            .set({"floor": "$floor"}).then((value) => Text('AddFloor Success'));
      });
    });
  }

  Future<void> deletefloor(String floor) async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        FirebaseFirestore.instance
            .collection(event.displayName)
            .doc('detail')
            .collection('floor')
            .doc(floor)
            .delete()
            .then((value) {
          Text('DeleteFloor Success');
        });
      });
    });
  }
  //////////////////////////////////////////////////////////////////////////////////////////

  Future<void> addroom(String floor, String room) async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        FirebaseFirestore.instance
            .collection(event.displayName)
            .doc('detail')
            .collection('room')
            // .doc("$floor")
            // .collection("roominfloor")
            .doc("$floor$room")
            .set({
          "room": "$floor$room",
          "floor": "$floor",
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
          "date": "",
          "urlimg": "",
          "detailroom": "",
          "showdate": "",
        }, SetOptions(merge: true)).then(
                (value) => print('Success create floor'));
      });
    });
  }

  Future<void> deleteroom(String deroom, String defloor) async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        FirebaseFirestore.instance
            .collection(event.displayName)
            .doc('detail')
            .collection('room')
            // .doc('$defloor')
            // .collection('roominfloor')
            .doc(deroom)
            .delete()
            .then((value) => print('Delete Success'));
      });
    });
  }
  ////////////////////////////////////  เปลี่ยนค่าน้ำค่าไฟ  //////////////////////////////////////////////

  Future<void> waterElecBill(String water, String elec) async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) async {
        await FirebaseFirestore.instance
            .collection(event.displayName)
            .doc('detail')
            .collection('waterelecbill')
            .doc('waterelecbill')
            .set({"water": water, "elec": elec}).then(
                (value) => print('EditWater&Elec Success'));
      });
    });
  }

////////////////////////////////  add User  /////////////////////////////

  Future<void> createuser(String username, String password, String name,
      String apartment, String floor, String room, String img) async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance.collection('user').doc(username).set({
        "username": "$username",
        "password": "$password",
        "name": "$name",
        "apartment": "$apartment",
        "floor": "$floor",
        "room": "$room",
        // "urlimg": "$img"
      }, SetOptions(merge: true)).then((value) => print("Create Success"));
    });
  }

  Future<void> adduser(
      String floor,
      String room,
      String status,
      String name,
      String username,
      String password,
      String number,
      String idcard,
      String adddress,
      String note,
      String img) async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        FirebaseFirestore.instance
            .collection(event.displayName)
            .doc('detail')
            .collection('room')
            .doc("$room")
            .set({
          "room": "$room",
          "name": "$name",
          "floor": "$floor",
          "status": "$status",
          "username": "$username",
          "password": "$password",
          "number": "$number",
          "idcard": "$idcard",
          "adddress": "$adddress",
          "note": "$note",
          "urlimg": "$img"
        }, SetOptions(merge: true)).then((value) => print('Success AddUser'));
      });
    });
  }

  //////////////////////////////   delete payment   ////////////////////////////
  Future<void> deletepayment(
      String apartmentname, String floor, String room, String date) async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        FirebaseFirestore.instance
            .collection(apartmentname)
            .doc('detail')
            .collection('meter')
            .doc(room)
            .collection('bill')
            .doc(date)
            .delete()
            .then((value) => print(date));
      });
    });
  }
  //////////////////////////////////////////////////////////////////////////////

////////////////////////////   available room   ////////////////////////////////
  Future<void> plusroomavailable(String apartmentname, String idroom) async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        FirebaseFirestore.instance
            .collection(apartmentname)
            .doc('detail')
            .collection('roomavailable')
            .doc(idroom)
            .set({"available": '1'});
      });
    });
  }

  Future<void> deleteroomavailable(String apartmentname, String idroom) async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        FirebaseFirestore.instance
            .collection(apartmentname)
            .doc('detail')
            .collection('roomavailable')
            .doc(idroom)
            .delete();
      });
    });
  }
  //////////////////////////////////////////////////////////////////////////////
}
