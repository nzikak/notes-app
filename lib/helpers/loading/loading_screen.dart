import 'dart:async';
import 'package:flutter/material.dart';
import 'package:notes_app/helpers/loading/loading_screen_controller.dart';

class LoadingScreen {
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();

  LoadingScreen._sharedInstance();

  factory LoadingScreen() => _shared;

  LoadingScreenController? _controller;

  void hide() {
    _controller?.close();
    _controller = null;

  }

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final textStream = StreamController<String>();
    textStream.add(text);

    final overlayState = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
                maxHeight: size.height * 0.8,
                maxWidth: size.width * 0.8,
                minWidth: size.width * 0.5),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10.0),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 20.0),
                    StreamBuilder(
                      stream: textStream.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data as String,
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return Container();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });

    overlayState?.insert(overlay);

    return LoadingScreenController(
      close: () {
        textStream.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        textStream.add(text);
        return true;
      },
    );
  }
}
