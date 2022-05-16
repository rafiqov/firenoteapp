import 'package:firenoteapp/models/note_models.dart';
import 'package:firenoteapp/services/hive_service.dart';
import 'package:firenoteapp/services/real_time_database_service.dart';
import 'package:firenoteapp/services/storage_service.dart';
import 'package:firenoteapp/views/functions_common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DetailController extends GetxController {
  static const String id = "/detail_page";

  // for edit
  Note? noteTransfer;

  bool isLoading = false;
  XFile? image;
  String? imgUrl;
  final imagePicker = ImagePicker();
  ImageSource imageSource = ImageSource.gallery;
  bool isGallery = true;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void onInit() {
    noteTransfer = Get.arguments;
    loadNote(noteTransfer);
    super.onInit();
  }

  void changeSource() {
    isGallery = !isGallery;
    if (isGallery) {
      imageSource = ImageSource.gallery;
    } else {
      imageSource = ImageSource.camera;
    }
    update();
    UtilsCommon.showSnackBar('source'.tr + ': $isGallery');
  }

  Future<void> storeNote() async {
    isLoading = true;
    update();
    if (noteTransfer == null) {
      String title = titleController.text.trim().toString();
      String content = contentController.text.trim().toString();
      if (content.isNotEmpty || title.isNotEmpty) {
        String userId = HiveDB.loadUser();

        if (imgUrl != null) {
          Note note = Note(
              title: title, content: content, userId: userId, imgUrl: imgUrl);
          await RealTimeDataBase.addPost(note);
        } else {
          UtilsCommon.showSnackBar("Choose image");
        }
      } else {
        UtilsCommon.showSnackBar("Wrong something");
      }
    } else {
      String title = titleController.text.trim().toString();
      String content = contentController.text.trim().toString();

      if (content.isNotEmpty || title.isNotEmpty) {
        Note note = Note(
            title: title,
            content: content,
            imgUrl: noteTransfer!.userId,
            key: noteTransfer!.key);

        await RealTimeDataBase.updatePost(note);
      }
    }
    isLoading = false;
    update();
    Get.back(result: true);
  }

  void loadNote(Note? note) {
    if (note != null) {
      titleController.text = note.title;
      contentController.text = note.content;
      imgUrl = note.imgUrl ?? 'https://lottiefiles.com/77099-placeholder';
      update();
    }
  }

  Future getImage() async {
    XFile? pickedImage = await imagePicker.pickImage(source: imageSource);

    pickedImage != null
        ? image = pickedImage
        : UtilsCommon.showSnackBar('No image picked');
    isLoading = false;
    update();
    _apiUploadImage();
  }

  void _apiUploadImage() async {
    isLoading = true;
    update();
    await StorageService.uploadImage(image!)
        .then((imageUrl) => {imgUrl = imageUrl});
  }
}
