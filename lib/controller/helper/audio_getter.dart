import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class AudioGetter {
  Future<FilePickerResult?> getAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowCompression: true,
    );

    if (result != null)
      return result;
    else
      print('No audio selected.');
    return null;
  }

  Future<String> uploadAudioToFirebase({
    required BuildContext context,
    required FilePickerResult pickedFile,
    required String folderName,
  }) async {
    String fileName = basename(File(pickedFile.files.single.path!).path);
    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child(folderName)
        .child(fileName);
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'audio/mp3',
        customMetadata: {'picked-file-path': pickedFile.files.single.path!});
    String url = "";
    uploadTask = ref.putFile(File(pickedFile.files.single.path!), metadata);
    await uploadTask.whenComplete(() async {
      var dowurl = await ref.getDownloadURL();
      url = dowurl.toString();
    });

    return url;
  }
}
