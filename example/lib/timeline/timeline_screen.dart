import 'package:flutter/material.dart';

import 'package:mastodon/mastodon.dart' hide Card;
import 'package:provider/provider.dart';

import 'status_card.dart';

class TimelineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timeline"),
      ),
      body: _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mastodon = Provider.of<Mastodon>(context);

    return FutureBuilder<List<Status>>(
      future: mastodon.timeline(),
      initialData: null,
      builder: (_, snap) {
        final statuses = snap?.data;

        if (statuses == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return ListView(
          children: statuses.map((s) => StatusCard(status: s)).toList(),
        );
      },
    );
  }
}
