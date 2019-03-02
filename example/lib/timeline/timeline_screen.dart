import 'package:flutter/material.dart';

import 'package:mastodon/mastodon.dart' hide Card;
import 'package:provider/provider.dart';

import 'status_card.dart';

class TimelineScreen extends StatelessWidget {
  final Account account;

  TimelineScreen({@required this.account});

  @override
  Widget build(BuildContext context) {
    return Provider<Account>(
      value: account,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Timeline"),
        ),
        body: _TimelineTabBar(),
      ),
    );
  }
}

class _TimelineTabBar extends StatefulWidget {
  @override
  __TimelineTabBarState createState() => __TimelineTabBarState();
}

class __TimelineTabBarState extends State<_TimelineTabBar>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    _controller = TabController(vsync: this, length: 4);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mastodon = Provider.of<Mastodon>(context);
    final account = Provider.of<Account>(context);

    return Column(
      children: <Widget>[
        TabBar(
          controller: _controller,
          labelPadding: EdgeInsets.symmetric(vertical: 12.0),
          tabs: <Widget>[
            Text("Feed"),
            Text("Local"),
            Text("Public"),
            Text("Wall"),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _controller,
            children: <Widget>[
              _Timeline(
                future: mastodon.timeline(),
              ),
              _Timeline(
                future: mastodon.publicTimeline(local: true),
              ),
              _Timeline(
                future: mastodon.publicTimeline(local: false),
              ),
              _Timeline(
                future: mastodon.statuses(account?.id),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  final Future<List<Status>> future;

  _Timeline({@required this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Status>>(
      future: future,
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
