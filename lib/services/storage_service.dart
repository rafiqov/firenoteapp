import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  static final storage = FirebaseStorage.instance.ref();
  static const folder = 'notes_images';

  static Future<String?> uploadImage(XFile _image) async {
    print(_image.path);
    String img_name = "image_" + DateTime.now().toString();
    print(img_name);
    var firebaseStorageRef = storage.child(folder).child(img_name);
    print('errrtt' + firebaseStorageRef.toString());
    var uploadTask = firebaseStorageRef.putFile(File(_image.path));
    print(uploadTask);
    try {
      TaskSnapshot snapshot = await uploadTask;
      print('Uploaded ${snapshot.bytesTransferred} bytes.');
    } on FirebaseException catch (e) {

      print(uploadTask.snapshot);

      if (e.code == 'permission-denied') {
        print('User does not have permission to upload to this reference.');
      }

    }
    var taskSnapshot = await uploadTask.snapshot;
    if (taskSnapshot != null) {
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print(downloadUrl);
      return downloadUrl;
    }
    return null;
  }
}