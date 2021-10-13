import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_pixels/image_pixels.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImagePixels Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ImagePixels Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final AssetImage darkImage = const AssetImage("lib/images/darkImage.jpg");
  final AssetImage lightImage = const AssetImage("lib/images/lightImage.jpg");

  ///Map of image providers to keys
  Map<String, ImageProvider> providers = {};

  ///The list of file names
  List<String> filenames = [];

  ///Index
  int index = 0;

  ///File at the index
  String? get file => filenames.isEmpty ? null : filenames[index];

  @override
  void initState(){
    _initImages();
  }

  Future _initImages() async {

    // Get images
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent) as Map<String, dynamic>;

    //Retreives a list of keys for the file names
    filenames = manifestMap.keys.toList();

    ///Create a provider for each image
    for (var file in filenames) {
      providers[file] = AssetImage(file);
    }

    //Set state
    if(mounted)
      setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          index = 0;
          if(mounted)
            setState(() {});
        },
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if(filenames.isNotEmpty){
            index = (index + 1) % filenames.length;
            if(mounted)
              setState(() {});
          }
        },
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                Center(child: Text("${index + 1}/${filenames.length}")),

                if(file != null)
                  Expanded(
                    child: ImagePixels.container(
                      imageProvider: providers[file!],
                      child: Container(
                        alignment: Alignment.center,
                        child: SizedBox(width: 100, child: Image(image: providers[file]!)),
                      ),
                    ),
                  ),

                //
                //
                // Expanded(
                //   //
                //   // 2) This uses the plain `ImagePixels` constructor.
                //   // It gives you a lot more control, and complete access
                //   // to the image's width/height and pixels.
                //   child: ImagePixels(
                //     imageProvider: lightImage,
                //     builder: (BuildContext context, ImgDetails img) {
                //       return Container(
                //         color: img.pixelColorAtAlignment!(Alignment.topLeft),
                //         alignment: Alignment.center,
                //         child: Stack(
                //           clipBehavior: Clip.none,
                //           children: [
                //             SizedBox(
                //               width: 100,
                //               child: Image(image: lightImage),
                //             ),
                //             Positioned(
                //               bottom: -30,
                //               right: 0,
                //               left: 0,
                //               child: Text(
                //                 "Size: ${img.width} × ${img.height}",
                //                 textAlign: TextAlign.center,
                //               ),
                //             ),
                //           ],
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
