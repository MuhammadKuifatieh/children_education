import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImageGetter {
  Future<FilePickerResult> getImage() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    );

    if (result != null)
      return result;
    else
      print('No image selected.');
    return null;
  }

  Future<String> uploadImageToFirebase(
      {BuildContext context,
      FilePickerResult pickedFile,
      String folderName}) async {
    String fileName = basename(File(pickedFile.files.single.path).path);
    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(folderName)
        .child(fileName);
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': pickedFile.files.single.path});
    String url;
    uploadTask = ref.putFile(File(pickedFile.files.single.path), metadata);
    await uploadTask.whenComplete(() async {
      var dowurl = await ref.getDownloadURL();
      url = dowurl.toString();
    });

    return url;
  }
}
