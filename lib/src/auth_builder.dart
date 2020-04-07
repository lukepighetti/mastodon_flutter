import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mastodon_dart/mastodon_dart.dart';
import 'package:url_launcher/url_launcher.dart';

typedef AuthWidgetLogin = void Function(Account account);

/// This builder widget provides a way to handle authentication events at the Flutter level.
/// As with all widgets in this library, AuthBuilder is meant to be used in conjunction with mastodon_dart.
class AuthBuilder extends StatefulWidget {
  const AuthBuilder({
    Key key,
    @required this.bloc,
    @required this.child,
    this.onLogin,
    this.onLogout,
  })  : assert(bloc != null),
        super(key: key);

  /// An AuthBloc from mastodon_dart
  final AuthBloc bloc;

  /// The widget to return
  final Widget child;

  /// An optional [AuthWidgetLogin] function to provide functionality on login
  final AuthWidgetLogin onLogin;

  /// An optional function to provide functionality on logout
  final VoidCallback onLogout;

  @override
  AuthBuilderState createState() => AuthBuilderState();
}

class AuthBuilderState extends State<AuthBuilder> with WidgetsBindingObserver {
  /// StreamSubscription to an Account
  StreamSubscription<Account> _subAccount;

  /// Here we listen for the Account from the provided AuthBloc and call [_onAccountChanged]
  @override
  void initState() {
    super.initState();
    _subAccount = widget.bloc.account.listen(_onAccountChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  /// Here we check if the widget has been updated with a new AuthBloc. If so, we stop listening for
  /// an Account from that AuthBloc, start listening for an Account from the new AuthBloc created by the updated widget,
  /// and call [_onAccountChanged].
  @override
  void didUpdateWidget(AuthBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.bloc != oldWidget.bloc) {
      _subAccount.cancel();
      _subAccount = widget.bloc.account.listen(_onAccountChanged);
    }
  }

  /// If we have an Account call onLogin. If not, call onLogout.
  void _onAccountChanged(Account account) {
    if (account != null) {
      widget.onLogin?.call(account);
    } else {
      widget.onLogout?.call();
    }
  }

  /// Here we check to see if the user has returned to the application from getting an authentication code
  /// from the browser. We check for an authentication code and submit it to the AuthBloc.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 500)).then(
          (value) => Clipboard.getData("text/plain")
              .then((clipboard) => submitCode(clipboard?.text)),
        );
      });
    }
  }

  /// Open the browser via the [AuthBloc] uri so the user can get an auth token
  void launchUrl() {
    final uri = widget.bloc.uri.value.toString();
    assert(uri != null);
    launch(uri);
  }

  /// Add an authentication code to [AuthBloc]
  void submitCode(String code) {
    assert(code != null);
    widget.bloc.codeSink.add(code);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subAccount.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
