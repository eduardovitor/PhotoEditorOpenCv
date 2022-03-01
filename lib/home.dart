import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv/core/core.dart';
import 'package:opencv/opencv.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final imgpicker = ImagePicker();
  late File? imgfile;
  late Image? image = null;
  getImagefromGallery() async {
    var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
    var tmpImgFile = File(pickedFile!.path);
    setState(() {
      imgfile = tmpImgFile;
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
      image = Image.file(imgfile!);
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
              color: Colors.black,
              child: const Center(
                  child: Text('Blur', style: TextStyle(color: Colors.white))),
            ),
            onTap: ApplyOpenCvBlur,
          ),
          const SizedBox(width: 15),
          GestureDetector(
              child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.black,
                  child: const Center(
                      child: Text('Filter 2D',
                          style: TextStyle(color: Colors.white)))),
              onTap: ApplyOpenCv2DFilter)
        ]);
  }

  buildOptions() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
      scrollDirection: Axis.horizontal,
      children: [
        ElevatedButton.icon(
          onPressed: buildOpenCvOptions,
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
          onPressed: () {},
          icon: const Icon(Icons.cut),
          label: const Text('Crop'),
          style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
        ),
      ],
    );
  }

  ApplyOpenCvBlur() async {
    var img_bytes = await imgfile!.readAsBytes();
    var edited_img =
        await ImgProc.blur(img_bytes, [45, 45], [20, 30], Core.borderReflect);
    setState(() {
      image = Image.memory(edited_img);
    });
  }

  ApplyOpenCv2DFilter() async {
    var img_bytes = await imgfile!.readAsBytes();
    var edited_img = await ImgProc.filter2D(img_bytes, -1, [2, 2]);
    setState(() {
      image = Image.memory(edited_img);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Photo editor'),
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
            ]),
        body: Column(
          children: [
            Expanded(
                child: Container(
                    child: checkImgNull(), alignment: Alignment.center)),
            Expanded(child: buildOptions())
          ],
        ));
  }
}
