import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {

  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  Map data = {};

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Λήψη Φωτογραφίας'),
        centerTitle: true,
        backgroundColor: Colors.green[600],
        elevation: 0.0,
      ),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.green[600],
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${data['barcode']}.png',
            );
            final file = File(path);
            if (await file.exists()) {
              await file.delete();
            }
            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => DisplayPictureScreen(imagePath: path),
            //   ),
            // );
            Navigator.pushNamed(context, '/editpicture', arguments: {
              'imagePath': path,
            });
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;
//
//   const DisplayPictureScreen({Key key, @required this.imagePath}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:  AppBar(
//         title: Text('Καταχώρηση Φωτογραφίας'),
//         centerTitle: true,
//         backgroundColor: Colors.green[600],
//         elevation: 0.0,
//       ),
//       // The image is stored as a file on the device. Use the `Image.file`
//       // constructor with the given path to display the image.
//       body: Padding(
//           padding: EdgeInsets.all(50.0),
//           child: Column (
//               children: <Widget>[
//                 Image.file(File(imagePath)),
//                 SizedBox(height: 30.0),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     RawMaterialButton(
//                       onPressed: () async {
//                         final file = File(imagePath);
//                         await file.delete();
//                         imageCache.clear();
//                         Navigator.pop(context);
//                       },
//                       elevation: 2.0,
//                       fillColor: Colors.red,
//                       child: Icon(
//                         Icons.delete,
//                         size: 35.0,
//                         color: Colors.white,
//                       ),
//                       padding: EdgeInsets.all(15.0),
//                       shape: CircleBorder(),
//                     ),
//                     SizedBox(width: 10),
//                     RawMaterialButton(
//                       onPressed: () {
//                         Navigator.pushNamed(context, '/uploadimg', arguments: {
//                           'imagePath': imagePath
//                         });
//                       },
//                       elevation: 2.0,
//                       fillColor: Colors.green[600],
//                       child: Icon(
//                         Icons.check,
//                         size: 35.0,
//                         color: Colors.white,
//                       ),
//                       padding: EdgeInsets.all(15.0),
//                       shape: CircleBorder(),
//                     ),
//                   ],
//                 )
//               ]
//           )
//       )
//     );
//   }
// }
