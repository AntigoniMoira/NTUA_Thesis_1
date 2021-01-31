import 'package:firebase_database/firebase_database.dart';
import 'package:medimg_app/models/med.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {

  final databaseReference = FirebaseDatabase.instance.reference();
  String barcode; //main barcode

  DatabaseService({this.barcode});

  Future<Med> readData() async {
    try {
      return await databaseReference.child("meds/$barcode").once().then((DataSnapshot snapshot) {
        return Med(
            barcode: snapshot.value['barcode'] ?? '',
            name: snapshot.value['name'] ?? '',
            img: snapshot.value['ntua_img'] ?? ''
        );
      });
    }
    catch (e){
      print('caught error: $e');
      return Med(
          barcode: barcode,
          name: 'Αυτό το barcode δεν υπάρχει στην βάση δεδομένων μας.' ?? '',
          img: 'not'
      );
    }
  }

  Future<void> updateData(imgUrl) async{
    try {
      await databaseReference.child("meds/$barcode").update({
        'ntua_img': imgUrl
      });
    }
    catch (e){
      print('caught error: $e');
    }
  }

}
