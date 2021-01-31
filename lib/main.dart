import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medimg_app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:medimg_app/models/user.dart';
import 'package:camera/camera.dart';
import 'package:medimg_app/screens/wrapper.dart';
import 'package:medimg_app/screens/type_barcode.dart';
import 'package:medimg_app/screens/loading.dart';
import 'package:medimg_app/screens/medinfo.dart';
import 'package:medimg_app/screens/take_picture.dart';
import 'package:medimg_app/screens/image_editor/img_editor.dart';
import 'package:medimg_app/screens/uploadimg.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(StreamProvider<AppUser>.value(
    value: AuthService().user,
    child: MaterialApp(
      routes: {
        '/': (context) => Wrapper(),
        '/type': (context) => TypeBarcode(),
        '/loading': (context) => Loading(),
        '/medinfo': (context) => MedInfo(),
        '/takepicture': (context) =>
            TakePictureScreen(
              // Pass the appropriate camera to the TakePictureScreen widget.
              camera: firstCamera,
            ),
        '/editpicture': (context) => ImageEditorDemo(),
        '/uploadimg': (context) => UploadImg(),
      },
    ),
  ));
}

