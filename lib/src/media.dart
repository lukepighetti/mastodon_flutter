import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mastodon_dart/mastodon_dart.dart';
import '../src/media_screen.dart';
import '../src/media_grid.dart';

/// This widget renders images found in a Status
/// todo: add support for other media
class Media extends StatefulWidget {
  final Status status;

  Media({@required this.status});

  @override
  _MediaState createState() => _MediaState();
}

class _MediaState extends State<Media> {
  List<Attachment> get images => widget.status.mediaAttachments.where((a) => a.type == AttachmentType.image).take(4).toList();

  bool get hasImages => images.isNotEmpty;
  bool _showSensitiveMedia = false;
  double _sigmaX;
  double _sigmaY;
  double _buttonOpacity;

  @override
  void initState() {
    super.initState();
    _updateBackdropProps();
  }

  /// Set the properties of the image backdrop based on whether the image is marked
  /// as sensitive and whether the user has tapped the button to show the sensitive content
  void _updateBackdropProps() {
    setState(() {
      // Normal image
      if (widget.status.sensitive == false) {
        // make image fully visible
        _sigmaX = 0;
        _sigmaY = 0;
        _buttonOpacity = 1.0;
      } else if (widget.status.sensitive == true && _showSensitiveMedia == false) {
        _sigmaX = 10;
        _sigmaY = 10;
        _buttonOpacity = 0.7;
      } else if (widget.status.sensitive == true && _showSensitiveMedia == true) {
        _sigmaX = 0;
        _sigmaY = 0;
        _buttonOpacity = 1.0;
      }
    });
  }

  /// Show the fullscreen image on tap
  void _handleNavigate(BuildContext context, Attachment attachment) {
    showMediaScreen(context, widget.status, attachment);
  }

  @override
  Widget build(BuildContext context) {
    if (!hasImages) {
      return Container();
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: MediaGrid(
            children: images
                .map(
                  (i) => GestureDetector(
                    onTap: () => _handleNavigate(context, i),

                    /// The box fit has to match the sibling Hero
                    child: Hero(
                      tag: i.id,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              i.previewUrl.toString(),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                          child: Container(
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0)),
                            child: Center(
                              child: Opacity(
                                opacity: _buttonOpacity,
                                child: widget.status.sensitive == true && _showSensitiveMedia == false
                                    ? FlatButton(
                                        color: Colors.grey[700],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        padding: EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 10),
                                        child: Text('Sensitive content', style: TextStyle(fontSize: 18)),
                                        onPressed: () {
                                          setState(() {
                                            _showSensitiveMedia = true;
                                            _updateBackdropProps();
                                          });
                                        },
                                      )
                                    : Container(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    }
  }
}
