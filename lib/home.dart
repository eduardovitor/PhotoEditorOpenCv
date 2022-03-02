import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv/core/core.dart';
import 'package:opencv/opencv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'opencvfilters.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final imgpicker = ImagePicker();
  late File? imgfile_original;
  late File? imgfile;
  late Image? image = null;
  late Widget swapwidget = buildOptions();
  int swap = 0;
  var cropper = ImageCropper();
  getImagefromGallery() async {
    var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
    var tmpImgFile = File(pickedFile!.path);
    setState(() {
      imgfile = tmpImgFile;
      imgfile_original = tmpImgFile;
      image = Image.file(imgfile!);
    });
  }

  checkImgNull() {
    if (image == null) {
      return null;
    } else {
      return image;
    }
  }

  restoreOriginalImage() {
    setState(() {
      image = Image.file(imgfile_original!);
    });
  }

  buildOpenCvOptions() {
    return ListView(
        padding: const EdgeInsets.all(50),
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            child: Container(
              width: 100,
              height: 100,
              color: Colors.deepPurple,
              child: const Center(
                  child: Text('Blur', style: TextStyle(color: Colors.white))),
            ),
            onTap: () async {
              var imgbytesret = await ApplyOpenCvBlur(imgfile!);
              setState(() {
                image = Image.memory(imgbytesret);
              });
              imgfile = await imgfile!
                  .writeAsBytes(imgbytesret, mode: FileMode.writeOnly);
            },
          ),
          const SizedBox(width: 15),
          GestureDetector(
              child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.deepPurple,
                  child: const Center(
                      child: Text('Filter 2D',
                          style: TextStyle(color: Colors.white)))),
              onTap: () async {
                var imgbytesret = await ApplyOpenCv2DFilter(imgfile!);
                setState(() {
                  image = Image.memory(imgbytesret);
                });
                imgfile = await imgfile!
                    .writeAsBytes(imgbytesret, mode: FileMode.writeOnly);
              }),
          const SizedBox(width: 15),
          GestureDetector(
              child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.deepPurple,
                  child: const Center(
                      child: Text('Median blur',
                          style: TextStyle(color: Colors.white)))),
              onTap: () async {
                var imgbytesret = await ApplyMedianBlur(imgfile!);
                setState(() {
                  image = Image.memory(imgbytesret);
                });
                imgfile = await imgfile!
                    .writeAsBytes(imgbytesret, mode: FileMode.writeOnly);
              }),
          const SizedBox(width: 15),
          GestureDetector(
              child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.deepPurple,
                  child: const Center(
                      child: Text('Gaussian blur',
                          style: TextStyle(color: Colors.white)))),
              onTap: () async {
                var imgbytesret = await ApplyGaussianBlur(imgfile!);
                setState(() {
                  image = Image.memory(imgbytesret);
                });
                imgfile = await imgfile!
                    .writeAsBytes(imgbytesret, mode: FileMode.writeOnly);
              }),
          const SizedBox(width: 15),
          GestureDetector(
              child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.deepPurple,
                  child: const Center(
                      child: Text('Sobel',
                          style: TextStyle(color: Colors.white)))),
              onTap: () async {
                var imgbytesret = await ApplySobel(imgfile!);
                setState(() {
                  image = Image.memory(imgbytesret);
                });
                imgfile = await imgfile!
                    .writeAsBytes(imgbytesret, mode: FileMode.writeOnly);
              }),
          const SizedBox(width: 15),
          GestureDetector(
              child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.deepPurple,
                  child: const Center(
                      child: Text('Laplacian',
                          style: TextStyle(color: Colors.white)))),
              onTap: () async {
                var imgbytesret = await ApplyLaplacian(imgfile!);
                setState(() {
                  image = Image.memory(imgbytesret);
                });
                imgfile = await imgfile!
                    .writeAsBytes(imgbytesret, mode: FileMode.writeOnly);
              }),
          const SizedBox(width: 15),
          GestureDetector(
              child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.deepPurple,
                  child: const Center(
                      child: Text('Dilate',
                          style: TextStyle(color: Colors.white)))),
              onTap: () async {
                var imgbytesret = await ApplyDilate(imgfile!);
                setState(() {
                  image = Image.memory(imgbytesret);
                });
                imgfile = await imgfile!
                    .writeAsBytes(imgbytesret, mode: FileMode.writeOnly);
              }),
          const SizedBox(width: 15),
          GestureDetector(
              child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.deepPurple,
                  child: const Center(
                      child: Text('Erode',
                          style: TextStyle(color: Colors.white)))),
              onTap: () async {
                var imgbytesret = await ApplyErode(imgfile!);
                setState(() {
                  image = Image.memory(imgbytesret);
                });
                imgfile = await imgfile!
                    .writeAsBytes(imgbytesret, mode: FileMode.writeOnly);
              }),
        ]);
  }

  buildOptions() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
      scrollDirection: Axis.horizontal,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              swapwidget = buildOpenCvOptions();
            });
          },
          icon: const Icon(Icons.portrait),
          label: const Text('Filters'),
          style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
        ),
        const SizedBox(width: 25),
        ElevatedButton.icon(
          onPressed: () {
            cropSquareImage(imgfile!);
          },
          icon: const Icon(Icons.cut),
          label: const Text('Crop'),
          style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
        ),
      ],
    );
  }

  Future<Null> cropSquareImage(File imagefile) async {
    File? croppedFile = await cropper.cropImage(
        sourcePath: imagefile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square]);
    if (croppedFile != null) {
      setState(() {
        imgfile = croppedFile;
        image = Image.file(croppedFile);
      });
    }
  }

  saveImage(String filename) async {
    if (await _requestPermission(Permission.storage)) {
      Directory? directory = await getExternalStorageDirectory();
      String newPath = "";
      print(directory);
      List<String> paths = directory!.path.split("/");
      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }
      newPath = newPath + "/PhotoEditor";
      directory = Directory(newPath);
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        var fullname = directory.path + filename;
        File newfile = File(fullname);
        var bytes = await imgfile!.readAsBytes();
        newfile = await newfile.writeAsBytes(bytes, mode: FileMode.append);
        print(fullname);
        print(newfile.path);
        print("Saved copy of image");
      }
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey _globalKey = GlobalKey();
    return Scaffold(
        appBar: AppBar(
            title: const Text('Photo editor', style: TextStyle(fontSize: 14)),
            backgroundColor: Colors.deepPurple,
            actions: [
              IconButton(
                icon: const Icon(Icons.camera),
                onPressed: getImagefromGallery,
              ),
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  DateTime now = DateTime.now();
                  String formattedDate =
                      DateFormat('yyyy-MM-dd – kk:mm').format(now);
                  var filename = '/Copy' + formattedDate + '.jpg';
                  saveImage(filename);
                },
              ),
              IconButton(
                  icon: const Icon(Icons.restore),
                  onPressed: restoreOriginalImage),
              IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      swapwidget = buildOptions();
                    });
                  })
            ]),
        body: Column(
          children: [
            Expanded(
                child: Container(
                    child: checkImgNull(), alignment: Alignment.center)),
            Expanded(child: swapwidget)
          ],
        ));
  }
}
