import 'package:example/timeline/timeline_screen.dart';
import 'package:flutter/material.dart';

import 'package:mastodon/mastodon.dart';
import 'package:mastodon_flutter/mastodon_flutter.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _controller = TextEditingController();
  AuthBloc bloc;

  @override
  void didChangeDependencies() {
    bloc = AuthBloc(
      Provider.of<Mastodon>(context),
      Uri.parse("https://github.com/lukepighetti/mastodon-flutter"),
      storage: AuthStorage(),
    );

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
        bloc: bloc,
        builder: (_, launchUrl, submitCode, token, account) {
          final isAuthenticated = account != null;

          print(account);

          if (isAuthenticated) {
            print("we're authenticated!");

            Future.delayed(Duration(seconds: 1)).then((_) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => TimelineScreen()));
            });
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  enabled: submitCode != null,
                  controller: _controller,
                  onChanged: submitCode,
                  style: Theme.of(context).textTheme.headline,
                  decoration: InputDecoration(
                    hintText: token ?? "Paste code here",
                  ),
                ),
              ),
              RaisedButton(
                child: Text("Authenticate"),
                onPressed: launchUrl,
              ),
            ],
          );
        },
      ),
    );
  }
}
