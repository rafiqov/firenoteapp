import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firenoteapp/commons/functions_common.dart';
import 'package:firenoteapp/commons/main_button.dart';
import 'package:firenoteapp/commons/text_field_common_widget.dart';
import 'package:firenoteapp/commons/text_with_link.dart';
import 'package:firenoteapp/services/real_time_database_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../commons/drawer_widget.dart';

import '../commons/lottie_common.dart';
import '../models/note_models.dart';
import '../services/hive_service.dart';
import '../services/storage_service.dart';

class DetailPage extends StatefulWidget {
  static const String id = "/detail_page";

  // for edit
  final Note? note;

  const DetailPage({Key? key, this.note}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isLoading = false;
  XFile? image;
  String? imgUrl;
  final imagePicker = ImagePicker();
  ImageSource imageSource = ImageSource.gallery;
  bool isGallery = true;

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();


  void changeSource() {
    setState(() {
      isGallery = !isGallery;
      if (isGallery) {
        imageSource = ImageSource.gallery;
      } else {
        imageSource = ImageSource.camera;
      }
    });
    FunctionCommon.showSnackBar(
        text: 'source'.tr() + ': $isGallery', context: context);
  }

  Future<void> _storeNote() async {
    setState(() => isLoading = true);
    if (widget.note == null) {
      String title = titleController.text.trim().toString();
      String content = contentController.text.trim().toString();
      if (content.isNotEmpty || title.isNotEmpty) {
        String userId = HiveDB.loadUser();
        _apiUploadImage();
        Note note = Note(
            title: title, content: content, userId: userId, imgUrl: imgUrl);
        await RealTimeDataBase.addPost(note);
        // if (imgUrl != null) {
        //   Note note = Note(
        //       title: title, content: content, userId: userId, imgUrl: imgUrl);
        //   RealTimeDataBase.addPost(note);
        // } else {
        //   FunctionCommon.showSnackBar(text: "Choose image", context: context);
        // }
      } else {
        FunctionCommon.showSnackBar(text: "Wrong something", context: context);
      }
    } else {
      String title = titleController.text.trim().toString();
      String content = contentController.text.trim().toString();

      if (content.isNotEmpty) {


        Note note = Note(
            title: title,
            content: content,
            imgUrl: imgUrl ?? 'https://lottiefiles.com/77099-placeholder',
            userId: widget.note?.userId,
            key: widget.note?.key);

        await RealTimeDataBase.updatePost(note);
      }
    }
    setState(() => isLoading = false);
    Navigator.pop(context, true);
  }

  void loadNote(Note? note) {
    if (note != null) {
      setState(() {
        titleController.text = note.title;
        contentController.text = note.content;
        imgUrl = note.imgUrl ?? 'https://lottiefiles.com/77099-placeholder';
      });
    }
  }

  Future getImage() async {
    XFile? pickedImage = await imagePicker.pickImage(source: imageSource);
    setState(() {
      pickedImage != null
          ? image = pickedImage
          : FunctionCommon.showSnackBar(
              text: 'No image picked', context: context);
      isLoading = false;
    });
    _apiUploadImage();
  }

  void _apiUploadImage() async {
    setState(() => isLoading = true);
    await StorageService.uploadImage(image!).then((imageUrl) => {imgUrl = imageUrl});
  }

  @override
  void initState() {
    super.initState();
    loadNote(widget.note);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _storeNote();
        return false;
      },
      child: Scaffold(
        endDrawer: const DrawerWidget(),
        appBar: AppBar(
          title: Text("detail_note".tr()),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                imageViewWidget(
                  imageUrl: imgUrl,
                  size: 200,
                ),
                changeSourceImage()
              ],
            ),
            TextFieldWidget(name: "title".tr(), controller: titleController),
            TextFieldWidget(
                name: "content".tr(), controller: contentController),
            MainButton(
                name: widget.note == null ? 'add'.tr() : 'edit'.tr(),
                function: _storeNote)
          ],
        ),
      ),
    );
  }

  Positioned changeSourceImage() {
    return Positioned(
      top: 10,
      left: 50,
      child: Container(
          height: 40,
          width: 200,
          decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.only(topLeft: Radius.circular(40)),
              color: Colors.grey.shade600),
          alignment: Alignment.center,
          child: TextWithLinkWidget(
              text: "source".tr() + ':  $isGallery', function: changeSource)),
    );
  }

  Widget imageViewWidget(
      {String? imageUrl, double size = 200}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: GestureDetector(
        onTap: getImage,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          height: size,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size / 5),
              image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                  colorFilter:
                      const ColorFilter.mode(Colors.grey, BlendMode.colorBurn)),
            ),
          ),
          imageUrl: imageUrl ?? 'https://avatars.mds.yandex.net/i?id=984180c9735fa1a9f95a5fa62f4717bd-5885656-images-thumbs&n=13',
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) =>
              LottieCommon(lottieEnum: LottieEnum.error, size: size),
        ),
      ),
    );
  }
}
