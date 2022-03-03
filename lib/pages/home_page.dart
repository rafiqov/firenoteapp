import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firenoteapp/commons/drawer_widget.dart';

import 'package:firenoteapp/commons/loading_widget.dart';
import 'package:firenoteapp/services/hive_service.dart';
import 'package:firenoteapp/services/real_time_database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../commons/lottie_common.dart';
import '../models/note_models.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<Note> notes = [];

  void getData() async {
    setState(() => isLoading = true);
    String userId = HiveDB.loadUser();
    notes = await RealTimeDataBase.getPosts(userId);
    setState(() => isLoading = false);
  }

  void _openDetailPage() async {
    var res = await Navigator.pushNamed(context, DetailPage.id);
    if (res as bool) {
      setState(() => isLoading = true);
      String userId = HiveDB.loadUser();
      notes = await RealTimeDataBase.getPosts(userId);
      setState(() => isLoading = false);
    }
  }

  void removeNote(Note note) async {
    setState(() => isLoading = true);
    await RealTimeDataBase.deletePost(note);
    String userId = HiveDB.loadUser();
    notes = await RealTimeDataBase.getPosts(userId);
    setState(() => isLoading = false);
  }

  void _openDetailForEdit(Note note) async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  note: note,
                )));
    if (result != null && result == true) {
      String userId = HiveDB.loadUser();
      notes = await RealTimeDataBase.getPosts(userId);
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      drawer: const DrawerWidget(),
      body: Stack(
        children: [
          ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return itemWidget(notes[index]);
              }),
          LoadingWidget(isLoading: isLoading)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openDetailPage,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar appbar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      title: Text("home".tr()),
    );
  }

  Widget itemWidget(Note note) {
    return Column(
      children: [
        Slidable(
          startActionPane: ActionPane(
            extentRatio: 0.3,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => removeNote(note),
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'delete'.tr(),
              ),
            ],
          ),
          endActionPane: ActionPane(
            extentRatio: 0.3,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => _openDetailForEdit(note),
                backgroundColor: const Color(0xFF7BC043),
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'edit'.tr(),
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
