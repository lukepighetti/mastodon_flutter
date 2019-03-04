import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mastodon/mastodon.dart';

import '../media/media_screen.dart';

class Media extends StatelessWidget {
  final Status status;

  Media({@required this.status});

  List<Attachment> get images => status.mediaAttachments
      .where((a) => a.type == AttachmentType.image)
      .take(4)
      .toList();

  bool get hasImages => images.isNotEmpty;

  _handleNavigate(BuildContext context, Attachment attachment) {
    showMediaScreen(context, status, attachment);
  }

  @override
  Widget build(BuildContext context) {
    if (!hasImages)
      return Container();
    else
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _MediaGrid(
            children: images
                .map((i) => GestureDetector(
                      onTap: () => _handleNavigate(context, i),

                      /// The box fit has to match the sibling Hero
                      child: Hero(
                        tag: i.id,
                        child: Image.network(
                          i.previewUrl.toString(),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      );
  }
}

/// Takes 1-4 widgets and lays them out in a social-media style grid.
/// [aspectRatio] and [gap] can both be overriden.
///
/// A social-media style grid is common in the industry. It has a [gap],
/// maintains an [aspectRatio], and lays out up to four images in the following
/// order:
///
/// ```
/// One   Two   Three  Four
/// 1 1   1 2   1 2    1 2
/// 1 1   1 2   1 3    3 4
///```
///
/// Note: Every widget is wrapped in an Expanded widget.
class _MediaGrid extends StatelessWidget {
  final List<Widget> children;
  final double aspectRatio;
  final double gap;

  _MediaGrid({
    @required List<Widget> children,
    this.aspectRatio = 1.6,
    this.gap = 4.0,
  })  : this.children = children.map((c) => Expanded(child: c)).toList(),
        assert(children.length >= 1),
        assert(children.length <= 4);

  int get count => children.length;

  List<List<Widget>> get layout {
    switch (count) {
      case 1:
        return [
          [children.first],
          [],
        ];
      case 2:
        return [
          [children.first],
          [children[1]],
        ];
      case 3:
        return [
          [children.first],
          [children[1], SizedBox(height: gap), children[2]],
        ];
      case 4:
        return [
          [children.first, SizedBox(height: gap), children[2]],
          [children[1], SizedBox(height: gap), children[3]],
        ];

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          /// Left column
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: layout.first,
            ),
          ),

          /// Gap
          count >= 2
              ? SizedBox(
                  width: gap,
                )
              : Container(),

          /// Right column
          layout.last.isEmpty
              ? Container()
              : Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: layout.last,
                  ),
                ),
        ],
      ),
    );
  }
}
