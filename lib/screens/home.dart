import 'package:flutter/material.dart';
import 'package:medimg_app/services/auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  Future<String> scanBarcodeNormal() async {
    String barcodeScanRes = 'Unknown';
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666", "Άκυρο", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    return barcodeScanRes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: Text('Καταχώρηση Barcode'),
          centerTitle: true,
          backgroundColor: Colors.green[600],
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.launch),
              onPressed: () async {
                // await _auth.signOut();
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context),
                );
              },
            ),
          ],
        ),
        body: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget> [
                Text(
                  'Σκανάρετε ή πληκτρολογήστε τον κωδικό ΕΟΦ (Τμήμα Β στην εικόνα)',
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 2.0,
                    fontSize: 17.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                Divider(
                  height: 20.0,
                  color: Colors.grey,
                ),
                Expanded(
                  child: Image.asset('assets/barcode2.jpg'),
                ),
                ButtonTheme(
                  minWidth: 200.0,
                  height: 40.0,
                  child: RaisedButton.icon(
                      onPressed: () async {
                        String scanBarcode = await scanBarcodeNormal();
                        if (scanBarcode != '-1') {
                          Navigator.pushNamed(context, '/medinfo', arguments: {
                            'barcode': scanBarcode,
                          });
                        }
                        //Navigator.pushNamed(context, '/scan');
                      },
                      icon: Icon(Icons.center_focus_weak),
                      label: Text('Σκανάρετε'),
                      color: Colors.green[600]
                  ),
                ),
                SizedBox(height: 10.0),
                ButtonTheme(
                    minWidth: 200.0,
                    height: 40.0,
                    child: RaisedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/type');
                        },
                        icon: Icon(Icons.keyboard),
                        label: Text('Πληκτρολογήστε'),
                        color: Colors.green[600]
                    )
                ),
                SizedBox(height: 150.0)
              ],
            )

        )
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Αποσύνδεση:'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Θέλετε σίγουρα να αποσυνδεθείτε;"),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () async {
            await _auth.signOut();
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: Text('Ναι',
            style: TextStyle(
              color: Colors.green[600],
              fontSize: 15.0,
            ),
          ),
        ),
      ],
    );
  }

}

