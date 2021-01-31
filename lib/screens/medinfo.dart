import 'package:flutter/material.dart';
import 'package:medimg_app/services/database.dart';
//import 'package:medimg_app/services/eof_info.dart';
import 'package:medimg_app/shared/loading.dart';
import 'package:medimg_app/models/med.dart';

class MedInfo extends StatefulWidget {

  @override
  _MedInfoState createState() => _MedInfoState();
}

class _MedInfoState extends State<MedInfo> {

  Map data = {};
  Med med;
  bool loading = true;

  void setupMedInfo (medBarcode) async {
    DatabaseService instance = DatabaseService(barcode: medBarcode);
    Med medinfo = await instance.readData();

    setState(() {
      med = medinfo;
      loading = false;
    });

  }


  @override
  void initState () {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    setupMedInfo(data['barcode']);

    return loading ?  Loading() : Scaffold(
      resizeToAvoidBottomPadding: false,
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
            Text(
                'ΟΝΟΜΑ',
                style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 2.0
                )
            ),
            SizedBox(height: 10.0),
            Text(
                med.name,
                style: TextStyle(
                    color: Colors.green[600],
                    letterSpacing: 2.0,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                )
            ),
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
                med.barcode,
                style: TextStyle(
                    color: Colors.green[600],
                    letterSpacing: 2.0,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold
                )
            ),
            SizedBox(height: 20.0),
            Builder(
                builder: (context) {
                  if (med.img == 'not') {
                    return Column (
                        children: <Widget> [
                          Text (
                            'Επιστρέψτε στην αρχική για να αναζητήσετε κάποιο άλλο barcode.',
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
                                  color: Colors.green[600]
                              )
                          ),
                        ]
                    );
                  }
                  else if (med.img != '') {
                    return Column (
                      children: <Widget> [
                        Image.network(
                            med.img,
                          height: 200
                        ),
                        SizedBox(height: 20.0),
                        Text (
                          'Αυτό το φάρμακο έχει ήδη εικόνα. Επιστρέψτε στην αρχική για να αναζητήσετε κάποιο άλλο barcode.',
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
                    );
                  } else {
                    return Column (
                      children: <Widget> [
                        Text(
                          'Καταχωρήσετε μια εικόνα για αυτό το φάρμακο:',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15.0
                          )
                        ),
                        SizedBox(height: 30.0),
                        ButtonTheme(
                            minWidth: 200.0,
                            height: 40.0,
                            child: RaisedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/takepicture', arguments: {
                                    'barcode': data['barcode'],
                                  });
                                },
                                icon: Icon(Icons.camera_enhance),
                                label: Text('Λήψη φωτογραφίας'),
                                color: Colors.green[600],
                              textColor: Colors.white,
                            )
                        ),
                      ]
                    );
                  }
                }
            )
          ]
        )
      )
    )
    );
  }
}
