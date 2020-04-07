import 'dart:async';
import 'package:example/timeline/timeline_screen.dart';
import 'package:flutter/material.dart';
import 'package:mastodon_dart/mastodon_dart.dart';
import 'package:mastodon_flutter/mastodon_flutter.dart';
import 'package:provider/provider.dart';

// On this screen, we use the AuthBuilder widget to listen to the AuthBloc we made in main.dart
// and our _onLogin function. When the user returns to the application with a valid authentication token,
// the AuthBloc will handle the authentication process and the AuthBuilder will use _onLogin to
// take the user into the main part of the application. NOTE: If you do not want to have automatic login,
// you don't have to. Just don't use the `onLogin` parameter of the AuthBuilder, configure your UI the way you need,
// use the _authBuilderKey to use the `submitCode` function provided by AuthBuilder, and handle the navigation as you
// see fit.
class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthBloc bloc;
  final _authBuilderKey = GlobalKey<AuthBuilderState>();

  void _onLogin(Account account) {
    scheduleMicrotask(() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => TimelineScreen(account: account),
      ));
    });
  }

  @override
  void didChangeDependencies() {
    bloc = Provider.of<AuthBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: AuthBuilder(
        key: _authBuilderKey,
        bloc: bloc,
        onLogin: _onLogin,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                  bloc.token.value == null ? 'No token yet' : bloc.token.value),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text("Get login code"),
                  onPressed: () => _authBuilderKey.currentState.launchUrl(),
                  color: Colors.blue,
                  textColor: Colors.white,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
