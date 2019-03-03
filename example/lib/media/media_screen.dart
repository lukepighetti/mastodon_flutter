import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:mastodon/mastodon.dart';

/// Shows a [_MediaScreen] containing the given Attachment.
///
/// Note: [Hero] is tagged by [Attachment.id] and must have a [BoxFit] that
/// matches it's sibling [Hero].
showMediaScreen(BuildContext context, Attachment attachment) {
  Navigator.push(
    context,
    _HeroDialogRoute(
      builder: (BuildContext context) => _MediaScreen(attachment: attachment),
    ),
  );
}

/// The media screen itself!
class _MediaScreen extends StatefulWidget {
  final Attachment attachment;

  _MediaScreen({@required this.attachment});

  @override
  _MediaScreenState createState() => _MediaScreenState();
}

class _MediaScreenState extends State<_MediaScreen> {
  Attachment get attachment => widget.attachment;

  _handleExit() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade900,
      child: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Dismissible(
              key: Key(attachment.id),
              direction: DismissDirection.vertical,

              /// Cannot be null because the hero tries to animate
              resizeDuration: Duration(microseconds: 1),
              onDismissed: (_) => _handleExit(),
              child: FittedBox(
                fit: BoxFit.contain,

                /// The box fit has to match the sibling Hero
                child: Hero(
                  tag: attachment.id,
                  child: Image.network(
                    attachment.previewUrl.toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: _handleExit,
                icon: Icon(
                  FeatherIcons.x,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A dialog style route that uses a [PageRoute] to enable
/// the use of [Hero] dialogues.
///
/// Particularly useful for creating a [Hero] animation that
/// goes from a social-media style feed to a full-screen media view.
class _HeroDialogRoute<T> extends PageRoute<T> {
  _HeroDialogRoute({this.builder}) : super();

  final WidgetBuilder builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.grey.shade900;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  String get barrierLabel => "Dialog";
}
