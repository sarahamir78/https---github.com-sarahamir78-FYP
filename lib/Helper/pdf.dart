import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fyp_sports_v3/Models/pdfmodel.dart';
import 'package:velocity_x/velocity_x.dart';

class THelperFunction {
  THelperFunction._();

  static Future<PdfFile?> pickFilePdf(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['pdf'],
        type: FileType.custom,
      );
      if (result == null) {
        return null;
      }

      List<File> files = result.files.map((file) => File(file.path!)).toList();
      if (files.isEmpty) {
        return null;
      }

      File file = files.first;
      final pdfFile = PdfFile(file: file, filePath: file.path);
      VxToast.show(context, msg: 'PDF Selected.');
      return pdfFile;
    } catch (e) {
      VxToast.show(context, msg: "Error picking file: $e");
      return null;
    }
  }
}
