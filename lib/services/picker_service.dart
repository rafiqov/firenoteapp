import 'package:image_picker/image_picker.dart';

class PickerService {
  static final ImagePicker picker = ImagePicker();
  static XFile? videoPicker;

  static getVideo() async {
    XFile? pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      videoPicker = pickedVideo;
    }
  }
}
