import 'package:flutter/material.dart';
import 'package:medimg_app/shared/constants.dart';

class TypeBarcode extends StatefulWidget {
  @override
  _TypeBarcodeState createState() => _TypeBarcodeState();
}

class _TypeBarcodeState extends State<TypeBarcode> {

  //var _barcode;

  //final barcodeCon = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String barcode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[50],
        appBar: AppBar(
          title: Text('Πληκτρολόγηση Barcode'),
          centerTitle: true,
          backgroundColor: Colors.green[600],
          elevation: 0.0,
        ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Barcode'),
                keyboardType: TextInputType.number,
                validator: (val) => val.length != 13 ? 'Το barcode πρέπει να περιλαμβάνει ακριβώς 13 ψηφία' : null,
                onChanged: (val) {
                  setState(() => barcode = val);
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton.icon(
                  icon: Icon(Icons.send),
                  label: Text('Αναζήτηση'),
                  color: Colors.green[600],
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      Navigator.pushNamed(context, '/medinfo', arguments: {
                        'barcode': barcode,
                      });
                    }
                  }
              ),
              SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }
}
