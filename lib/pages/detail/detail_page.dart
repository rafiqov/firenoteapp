import 'package:cached_network_image/cached_network_image.dart';
import 'package:firenoteapp/pages/detail/detail_controller.dart';
import 'package:firenoteapp/views/lottie_common.dart';
import 'package:firenoteapp/views/main_button.dart';
import 'package:firenoteapp/views/text_field_common_widget.dart';
import 'package:firenoteapp/views/text_with_link.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailPage extends GetView<DetailController> {
  static const String id = '/detail';

  const DetailPage({Key? key}) : super(key: key);

  @override
  DetailController get controller => super.controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DetailController>(
        init: controller,
        builder: (_controller) {
          return WillPopScope(
            onWillPop: () async {
              _controller.storeNote();
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text("detail_note".tr),
                centerTitle: true,
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      imageViewWidget(
                        imageUrl: _controller.imgUrl,
                        controller: _controller,
                        size: 200,
                      ),
                      changeSourceImage(_controller)
                    ],
                  ),
                  TextFieldWidget(
                      name: "title".tr,
                      controller: _controller.titleController),
                  TextFieldWidget(
                      name: "content".tr,
                      controller: _controller.contentController),
                  MainButton(
                      name: _controller.noteTransfer == null
                          ? 'add'.tr
                          : 'edit'.tr,
                      function: _controller.storeNote)
                ],
              ),
            ),
          );
        });
  }

  Positioned changeSourceImage(DetailController controller) {
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
              text: "source".tr + ':  ${controller.isGallery}',
              function: () => controller.changeSource())),
    );
  }

  Widget imageViewWidget(
      {String? imageUrl,
      double size = 200,
      required DetailController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: GestureDetector(
        onTap: controller.getImage,
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
          imageUrl: imageUrl ??
              'https://avatars.mds.yandex.net/i?id=984180c9735fa1a9f95a5fa62f4717bd-5885656-images-thumbs&n=13',
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              CircularProgressIndicator(value: downloadProgress.progress),
          errorWidget: (context, url, error) =>
              LottieCommon(lottieEnum: LottieEnum.error, size: size),
        ),
      ),
    );
  }
}
