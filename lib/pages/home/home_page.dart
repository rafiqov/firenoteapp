import 'package:cached_network_image/cached_network_image.dart';
import 'package:firenoteapp/pages/home/home_controller.dart';
import 'package:firenoteapp/services/hive_service.dart';
import 'package:firenoteapp/views/drawer_widget.dart';
import 'package:firenoteapp/views/loading_widget.dart';
import 'package:firenoteapp/views/lottie_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

import '../../models/note_models.dart';

class HomePage extends StatelessWidget {
  static const String id = 'home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return Scaffold(
            appBar: appbar(),
            drawer: const DrawerWidget(),
            body: RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              color: Colors.white,
              backgroundColor:
                  HiveDB.loadMode() ? Colors.black : Colors.blue.shade600,
              onRefresh: () async => controller.getData(),
              child: Stack(
                children: [
                  ListView.builder(
                      itemCount: controller.notes.length,
                      itemBuilder: (context, index) {
                        return itemWidget(controller.notes[index], controller);
                      }),
                  LoadingWidget(isLoading: controller.isLoading)
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: controller.openDetailPage,
              child: const Icon(Icons.add),
            ),
          );
        });
  }

  AppBar appbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Get.theme.primaryColor,
      title: Text("home".tr),
      centerTitle: true,
    );
  }

  Widget itemWidget(Note note, HomeController controller) {
    return Column(
      children: [
        Slidable(
          startActionPane: ActionPane(
            extentRatio: 0.3,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => controller.removeNote(note),
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'delete'.tr,
              ),
            ],
          ),
          endActionPane: ActionPane(
            extentRatio: 0.3,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => controller.openDetailForEdit(note),
                backgroundColor: const Color(0xFF7BC043),
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'edit'.tr,
              ),
            ],
          ),
          child: ListTile(
            tileColor:
                HiveDB.loadMode() ? Colors.grey.shade700 : Colors.grey.shade200,
            minLeadingWidth: 60,
            leading: imageViewWidget(imageUrl: note.imgUrl),
            title: Text(note.title),
            subtitle: Text(note.content),
          ),
        ),
        Divider(
            height: 1,
            color: HiveDB.loadMode() ? Colors.white : Colors.black,
            thickness: 1)
      ],
    );
  }

  Widget imageViewWidget({String? imageUrl}) {
    double size = 50;
    String url =
        'https://avatars.mds.yandex.net/i?id=984180c9735fa1a9f95a5fa62f4717bd-5885656-images-thumbs&n=13';
    return CircleAvatar(
      radius: size / 2,
      child: CachedNetworkImage(
        height: size,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
            image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                colorFilter:
                    const ColorFilter.mode(Colors.grey, BlendMode.colorBurn)),
          ),
        ),
        imageUrl: imageUrl ?? url,
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) =>
            LottieCommon(lottieEnum: LottieEnum.error, size: size),
      ),
    );
  }
}
