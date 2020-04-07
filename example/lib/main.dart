import 'package:example/timeline/timeline_screen.dart';
import 'package:flutter/material.dart';
import 'package:mastodon_dart/mastodon_dart.dart';
import 'package:mastodon_flutter/mastodon_flutter.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'auth/auth_screen.dart';

Future<void> main() async {
  // Ensure widgets are bound and initialized before doing anything!
  WidgetsFlutterBinding.ensureInitialized();
  // Create an instance of Mastodon. You will likely want this to be dynamic.
  Mastodon masto = Mastodon(
    Uri.parse("https://mastodon.technology"),
    websocketFactory: (uri) => IOWebSocketChannel.connect(uri),
  );
  // Create an AuthBloc (from mastodon_dart)
  final AuthBloc authBloc = AuthBloc(
    masto,
    Uri.parse("https://github.com/lukepighetti/mastodon-flutter"),
    storage: AuthStorage(),
  );
  // Ensure the AuthBloc is initialized before running the app!
  await authBloc.initalized;
  // Run the app
  runApp(MyApp(
    bloc: authBloc,
    mastodon: masto,
  ));
}

// We provide MyApp with the AuthBloc and Mastodon from above. These will be passed
// down through the app via MultiProvider.
class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
    @required this.bloc,
    this.mastodon,
  }) : super(key: key);

  final AuthBloc bloc;
  final Mastodon mastodon;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthBloc>.value(value: bloc),
        Provider<Mastodon>.value(value: mastodon),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          cardTheme: CardTheme(elevation: 0.3),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.blue,
          ),
        ),
        // Determine home widget based on authentication status. If there is a cached authentication token,
        // the AuthBloc will have already authenticated the user before the app is run, and we can get straight
        // to business. Otherwise go to the auth screen. NOTE: if you don't want to do it this way,
        // you don't have to, but you'll need to fiddle with your auth flow.
        home: bloc.account.value == null
            ? AuthScreen()
            : TimelineScreen(account: bloc.account.value),
      ),
    );
  }
}
