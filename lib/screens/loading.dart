import 'package:flutter/material.dart';
import 'package:medimg_app/services/eof_info.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  Map data = {};

  void setupMedInfo (barcode) async {
    EofInfo instance = EofInfo(barcode: barcode);
    await instance.getData();
    Navigator.pushNamed(context, '/medinfo', arguments: {
      'barcode': barcode,
      'name': instance.name,
      'img': instance.img
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    setupMedInfo (data['barcode']);

    return Scaffold(
        backgroundColor: Colors.green[600],
        body: Center(
            child: SpinKitFadingCube(
              color: Colors.white,
              size: 50.0,
            )
        )
    );
  }
}