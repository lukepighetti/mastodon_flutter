import 'package:flutter/material.dart';
import 'package:mastodon/mastodon.dart';
import 'package:provider/provider.dart';

import 'auth/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final instance = Uri.parse("https://mastodon.technology");

  @override
  Widget build(BuildContext context) {
    return StatefulProvider<Mastodon>(
      valueBuilder: (_) => Mastodon(instance),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          cardTheme: CardTheme(elevation: 0.3),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.blue,
          ),
        ),
        home: AuthScreen(),
      ),
    );
  }
}
