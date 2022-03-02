import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv/core/core.dart';
import 'package:opencv/opencv.dart';
import 'opencvfilters.dart';

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
              var img = await ApplyOpenCvBlur(imgfile!);
              setState(() {
                image = img;
              });
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
                var img = await ApplyOpenCv2DFilter(imgfile!);
                setState(() {
                  image = img;
                });
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
                var img = await ApplyMedianBlur(imgfile!);
                setState(() {
                  image = img;
                });
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
                var img = await ApplyGaussianBlur(imgfile!);
                setState(() {
                  image = img;
                });
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
                var img = await ApplySobel(imgfile!);
                setState(() {
                  image = img;
                });
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
                var img = await ApplyLaplacian(imgfile!);
                setState(() {
                  image = img;
                });
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
                var img = await ApplyDilate(imgfile!);
                setState(() {
                  image = img;
                });
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
                var img = await ApplyErode(imgfile!);
                setState(() {
                  image = img;
                });
              }),
        ]);
  }

  buildOptions() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
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
        const SizedBox(width: 5),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.circle),
          label: const Text('Shapes'),
          style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
        ),
        const SizedBox(width: 5),
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

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {},
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
