import 'package:flutter/material.dart';
import 'package:mastodon/mastodon.dart';

class Media extends StatelessWidget {
  final Status status;

  Media({@required this.status});

  List<Attachment> get images => status.mediaAttachments
      .where((a) => a.type == AttachmentType.image)
      .take(4)
      .toList();

  int get imagesCount => images.length;

  bool get hasImages => images.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (!hasImages)
      return Container();
    else
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LayoutBuilder(
            builder: (_, box) {
              final width = box.maxWidth;

              return Container(
                constraints: BoxConstraints(maxHeight: width),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: images
                      .map((i) => Flexible(
                            child: Image.network(
                              i.previewUrl.toString(),
                              fit: BoxFit.cover,
                            ),
                          ))
                      .toList(),
                ),
              );
            },
          ),
        ),
      );
  }
}
