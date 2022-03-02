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

ApplyOpenCvBlur(File imgfile) async {
  var img_bytes = await imgfile.readAsBytes();
  var edited_img =
      await ImgProc.blur(img_bytes, [45, 45], [20, 30], Core.borderReflect);
  return edited_img;
}

ApplyOpenCv2DFilter(File imgfile) async {
  var img_bytes = await imgfile.readAsBytes();
  var edited_img = await ImgProc.filter2D(img_bytes, -1, [2, 2]);
  return edited_img;
}

ApplyMedianBlur(File imgfile) async {
  var img_bytes = await imgfile.readAsBytes();
  var edited_img = await ImgProc.medianBlur(img_bytes, 45);
  return edited_img;
}

ApplyGaussianBlur(File imgfile) async {
  var img_bytes = await imgfile.readAsBytes();
  var edited_img = await ImgProc.gaussianBlur(img_bytes, [45, 45], 0);
  return edited_img;
}

ApplySobel(File imgfile) async {
  var img_bytes = await imgfile.readAsBytes();
  var edited_img = await ImgProc.sobel(img_bytes, -1, 1, 1);
  return edited_img;
}

ApplyLaplacian(File imgfile) async {
  var img_bytes = await imgfile.readAsBytes();
  var edited_img = await ImgProc.laplacian(img_bytes, 10);
  ;
  return edited_img;
}

ApplyDilate(File imgfile) async {
  var img_bytes = await imgfile.readAsBytes();
  var edited_img = await ImgProc.dilate(img_bytes, [2, 2]);
  return edited_img;
}

ApplyErode(File imgfile) async {
  var img_bytes = await imgfile.readAsBytes();
  var edited_img = await ImgProc.erode(img_bytes, [2, 2]);
  return edited_img;
}
