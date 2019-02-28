import 'package:flutter/material.dart';
import 'package:mastodon/mastodon.dart';
import 'package:mastodon_flutter/mastodon_flutter.dart';
import 'package:provider/provider.dart';

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
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = TextEditingController();
  AuthBloc bloc;

  @override
  void didChangeDependencies() {
    bloc = AuthBloc(
      Provider.of<Mastodon>(context),
      Uri.parse("https://fluttermvp.com"),
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: AuthBuilder(
        bloc: bloc,
        builder: (_, launchUrl, submitCode, account) {
          final isAuthenticated = account != null;

          if (isAuthenticated != null) {
            print("We're authenticated!");
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("We are ${isAuthenticated ? "" : "not "}authenticated"),
              Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  enabled: submitCode != null,
                  controller: _controller,
                  onChanged: submitCode,
                  decoration: InputDecoration(
                    hintText: "Paste code here",
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
