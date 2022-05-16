import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  static String snackBar = '';
  static final storage = FirebaseStorage.instance.ref();
  static const folder = 'notes_images';

  static Future<String?> uploadImage(XFile _image) async {
    String imgName = "image_" + DateTime.now().toString();
    var firebaseStorageRef = storage.child(folder).child(imgName);
    var uploadTask = firebaseStorageRef.putFile(File(_image.path));
    try {
      TaskSnapshot snapshot = await uploadTask;
      snackBar = 'Uploaded ${snapshot.bytesTransferred} bytes.';
    } on FirebaseException catch (e) {
      snackBar = uploadTask.snapshot.toString();

      if (e.code == 'permission-denied') {
        snackBar = 'User does not have permission to upload to this reference.';
      }
    }
    var taskSnapshot = uploadTask.snapshot;
    final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    snackBar = downloadUrl;
    return downloadUrl;
  }
}