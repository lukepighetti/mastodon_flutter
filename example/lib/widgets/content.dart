import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:mastodon/mastodon.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:html/dom.dart' hide Text;
import 'package:html/parser.dart';

class Content extends StatelessWidget {
  final Document html;

  Content({@required Status status}) : html = parse(status.content);

  String get content => html.body.innerHtml;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: content,
      onLinkTap: (url) => launch(url),
      blockSpacing: 8,
      defaultTextStyle: TextStyle(fontSize: 16),
      renderNewlines: true,
      customRender: (node, __) {
        if (node is Element) {
          switch (node.className) {
            case "invisible":
              return Container();
            case "ellipsis":
              return null;
            case "mention":
              return null;
            case "hashtag":
              return null;
          }
        }
      },
      linkStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
