import 'package:flutter/material.dart';

typedef CloseDialog = void Function();

CloseDialog showLoadingDialog({
  required BuildContext context,
  required String content,
}) {
  final dialog = AlertDialog(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 10.0),
        Text(content)
      ],
    ),
  );

  showDialog(
    context: context,
    builder: (context) => dialog,
    barrierDismissible: false
  );

  return () => Navigator.of(context).pop();
}
