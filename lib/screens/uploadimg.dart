import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medimg_app/shared/loading.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:medimg_app/services/database.dart';
import 'package:medimg_app/services/storage.dart';

class UploadImg extends StatefulWidget {
  @override
  _UploadImgState createState() => _UploadImgState();
}

class _UploadImgState extends State<UploadImg> {

  Map data = {};
  String imgUrl = '';
  String barcode = '';
  bool loading = true;

  void uploadAndUpdateDB (imgPath) async {
    String imgurl = await StorageService(imgPath: imgPath).uploadImg();

    File _imageFile =  File(imgPath);
    String fileName = basename(_imageFile.path);
    String medBarcode = fileName.split(".")[0];
    DatabaseService instance = DatabaseService(barcode: medBarcode);
    await instance.updateData(imgurl);
    setState(() {
      imgUrl = imgurl;
      barcode = medBarcode;
      loading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    uploadAndUpdateDB(data['imagePath']);

    return loading ?  Loading() : Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
            title: Text('Πληροφορίες Φαρμάκου'),
            centerTitle: true,
            backgroundColor: Colors.green[600],
            elevation: 0.0,
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
            child: SingleChildScrollView(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Text(
                      'BARCODE',
                      style: TextStyle(
                          color: Colors.grey,
                          letterSpacing: 2.0
                      )
                  ),
                  SizedBox(height: 10.0),
                  Text(
                      barcode,
                      style: TextStyle(
                          color: Colors.green[600],
                          letterSpacing: 2.0,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold
                      )
                  ),
                  SizedBox(height: 20.0),
                  Column (
                      children: <Widget> [
                        // Image.network(
                        //     imgUrl,
                        //     height: 200
                        // ),
                        Image.file(File(data['imagePath'])),
                        SizedBox(height: 20.0),
                        Text (
                          'Η εικόνα καταχωρήθηκε επιτυχώς! Επιστρέψτε στην αρχική για να αναζητήσετε κάποιο άλλο barcode.',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 30.0),
                        ButtonTheme(
                            minWidth: 200.0,
                            height: 40.0,
                            child: RaisedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/');
                                },
                                icon: Icon(Icons.home),
                                label: Text('Αρχική'),
                                color: Colors.green[600],
                              textColor: Colors.white,
                            )
                        ),
                      ]
                  )
                ]
            )
            )
        )
    );
  }
}
