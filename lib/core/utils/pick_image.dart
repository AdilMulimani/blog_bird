import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImage() async {
  try {
    final XFile? xFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      debugPrint('Picked file path: ${xFile.path}');
      return File(xFile.path);
    }
  } catch (e) {
    debugPrint('Error picking image: $e');
    return null;
  }
  return null;
}
