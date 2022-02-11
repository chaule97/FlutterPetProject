import 'package:app/redux/app_state.dart';
import 'package:app/redux/models/user/user_action.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LoginScreen extends StatefulWidget {
  final String next;
  const LoginScreen({Key? key, required this.next}) : super(key: key);

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  void submitCallBack () {
    if (_formKey.currentState!.validate()) {
      final loginAction = LoginAction(
          _userTextEditingController.text,
          _passwordTextEditingController.text
      );

      StoreProvider.of<AppState>(context).dispatch(loginAction);
    }
  }

  @override
  void dispose() {
    _userTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, bool>(
      converter: (store) => store.state.user.refreshToken.isNotEmpty,
      onWillChange: (prev, isLogin) {
        if (isLogin) {
          Navigator.pushReplacementNamed(context, widget.next);
        }
      },
      builder: (context, isLogin) {

        return Scaffold(
            body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: Column(
                  children: [
                    const Text(
                      "Shop Login",
                      style: TextStyle(
                          fontSize: 30
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: _userTextEditingController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.username,
                            ),
                          ),
                          TextFormField(
                            controller: _passwordTextEditingController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.password,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: ElevatedButton(
                                onPressed: submitCallBack,
                                child: Text(AppLocalizations.of(context)!.login)
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
            )
        );
      },
    );
  }
}
