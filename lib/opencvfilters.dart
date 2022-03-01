import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:opencv/core/core.dart';
import 'package:opencv/opencv.dart';

class OpenCvFilters extends StatefulWidget {
  const OpenCvFilters({Key? key}) : super(key: key);

  @override
  _OpenCvFiltersState createState() => _OpenCvFiltersState();
}

class _OpenCvFiltersState extends State<OpenCvFilters> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

ApplyOpenCvBlur(Image image, File imgfile) async {
  var img_bytes = await imgfile.readAsBytes();
  var edited_img =
      await ImgProc.blur(img_bytes, [45, 45], [20, 30], Core.borderReflect);
  var img_memory = Image.memory(edited_img);
  return img_memory;
}

ApplyOpenCv2DFilter(Image image, File imgfile) async {
  var img_bytes = await imgfile.readAsBytes();
  var edited_img = await ImgProc.filter2D(img_bytes, -1, [2, 2]);
  var img_memory = Image.memory(edited_img);
  return img_memory;
}

ApplyMedianBlur(Image image, File imgfile) async {
  var img_bytes = await imgfile.readAsBytes();
  var edited_img = await ImgProc.medianBlur(img_bytes, 45);
  var img_memory = Image.memory(edited_img);
  return img_memory;
}

ApplyGaussianBlur(Image image, File imgfile) async {
  var img_bytes = await imgfile.readAsBytes();
  var edited_img = await ImgProc.gaussianBlur(img_bytes, [45, 45], 0);
  var img_memory = Image.memory(edited_img);
  return img_memory;
}

ApplySobel(Image image, File imgfile) async {
  var img_bytes = await imgfile.readAsBytes();
  var edited_img = await ImgProc.sobel(img_bytes, -1, 1, 1);
  var img_memory = Image.memory(edited_img);
  return img_memory;
}

ApplyLaplacian(Image image, File imgfile) async {
  var img_bytes = await imgfile.readAsBytes();
  var edited_img = await ImgProc.laplacian(img_bytes, 10);
  var img_memory = Image.memory(edited_img);
  return img_memory;
}

ApplyDilate(Image image, File imgfile) async {
  var img_bytes = await imgfile.readAsBytes();
  var edited_img = await ImgProc.dilate(img_bytes, [2, 2]);
  var img_memory = Image.memory(edited_img);
  return img_memory;
}

ApplyErode(Image image, File imgfile) async {
  var img_bytes = await imgfile.readAsBytes();
  var edited_img = await ImgProc.erode(img_bytes, [2, 2]);
  var img_memory = Image.memory(edited_img);
  return img_memory;
}
