import 'package:final_noteapp_new/providers/auth_provider.dart';
import 'package:final_noteapp_new/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  static const String routeName = 'signup-page';

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _fKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  final TextEditingController _passwordController = TextEditingController();
  late String _name, _email, _password;

  void _submit() async {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });

    if (!_fKey.currentState!.validate()) return;

    _fKey.currentState!.save();

    print('name: $_name, email: $_email, password: $_password');

    try {
      await context
          .read<AuthProvider>()
          .signUp(context, name: _name, email: _email, password: _password);
    } catch (e) {
      errorDialog(context, Exception(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthProvider>().state;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '註冊',
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Form(
                key: _fKey,
                autovalidateMode: autovalidateMode,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: '名字',
                          prefixIcon: Icon(Icons.account_circle),
                        ),
                        validator: (String? val) {
                          if (val!.trim().isEmpty) {
                            return '名字必須填入';
                          }
                          return null;
                        },
                        onSaved: (val) => _name = val!,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: '電郵',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (String ?val) {
                          if (!val!.trim().contains('@')) {
                            return '非有效電郵';
                          }
                          return null;
                        },
                        onSaved: (val) => _email = val!,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: '密碼',
                          prefixIcon: Icon(Icons.security),
                        ),
                        validator: (String? val) {
                          if (val!.trim().length < 6) {
                            return '密碼至少要有6個位元的長度';
                          }
                          return null;
                        },
                        onSaved: (val) => _password = val!,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          labelText: '確認密碼',
                          prefixIcon: Icon(Icons.security),
                        ),
                        validator: (String ?val) {
                          if (_passwordController.text != val) {
                            return '密碼不一致';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: authState.loading == true ? null : _submit,
                      child: Text(
                        '註冊',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextButton(
                      onPressed: authState.loading == true
                          ? null
                          : () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        '已有帳號，請登入',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}