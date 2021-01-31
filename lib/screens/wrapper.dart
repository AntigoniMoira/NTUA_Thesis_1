import 'package:medimg_app/screens/authenticate/authenticate.dart';
import 'package:medimg_app/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medimg_app/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser>(context);
    //print(user.uid);
    // return either the Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    }
    else {
      return Home();
    }

  }
}