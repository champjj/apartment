import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

// ignore: camel_case_types
class edithome {
  final firebaseuser = FirebaseAuth.instance.currentUser;

  Future<void> editannounce(String string) async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        FirebaseFirestore.instance
            .collection(event.displayName)
            .doc('detail')
            .collection("managehome")
            .doc('anc')
            .set({"announce": string}).then((value) => print('success1'));
      });
    });
  }

  Future<void> editrule(String string) async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        FirebaseFirestore.instance
            .collection(event.displayName)
            .doc('detail')
            .collection("managehome")
            .doc('rule')
            .set({"rule": string}).then((value) => print('success2'));
      });
    });
  }

  Future<void> editnumber(String string) async {
    await Firebase.initializeApp().then((value) async {
      FirebaseAuth.instance.authStateChanges().listen((event) {
        FirebaseFirestore.instance
            .collection(event.displayName)
            .doc('detail')
            .collection("managehome")
            .doc('number')
            .set({"number": string}).then((value) => print('success3'));
      });
    });
  }
}
