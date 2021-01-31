import 'package:http/http.dart';
import 'dart:convert';

class EofInfo {

  String barcode; //main barcode
  String  name;
  bool img; //false or true in img exists

  EofInfo({this.barcode});

  Future<void> getData() async {

    try {
      //Response response = await get('https://meds_db/$barcode');
      Map response = await Future.delayed(Duration(seconds: 3), () {
        return ({'name': 'Eliquis', 'img': false});
      });

      //Map data = jsonDecode(response.body);
      name = response['name'];
      img = response['img'];
    }
    catch (e){
      print('caught error: $e');
      name = 'could not get name data';
      img = true;
    }

  }

}