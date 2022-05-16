import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firenoteapp/views/functions_common.dart';
import 'package:flutter/cupertino.dart';

class CheckConnectionService {
  static Future<bool> checkConnection(BuildContext context) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile) {
      UtilsCommon.showSnackBar("Internet Mobile connection");
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      UtilsCommon.showSnackBar("Internet Wifi connection");
      return true;
    } else {
      UtilsCommon.showSnackBar("No Internet connection");
      return false;
    }
  }
}
