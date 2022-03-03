import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  bool isLoading;

  LoadingWidget( {Key? key, this.isLoading = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator(backgroundColor: Colors.redAccent))
        : const SizedBox.shrink();
  }
}
