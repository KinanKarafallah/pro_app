import 'package:flutter/material.dart';

class SignAuth extends StatefulWidget {
  SignAuth(this.submitFn, this.isLogging);
  final bool isLogging;
  final void Function(String email, String password, String username,
      bool isLogIn, BuildContext ctx) submitFn;

  @override
  State<SignAuth> createState() => _SignAuthState();
}

class _SignAuthState extends State<SignAuth> {
  final _formKey = GlobalKey<FormState>();
  var _isLogIn = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _isLogIn,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  key: ValueKey('email'),
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'please Enter a valid Email address';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Enter Your Email',
                      suffixIcon: Icon(Icons.email),
                      border: OutlineInputBorder()),
                  onSaved: (value) {
                    _userEmail = value;
                  },
                ),
                if (!_isLogIn)
                  TextFormField(
                    key: ValueKey('user name'),
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return 'please enter 4 charachter user name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        labelText: 'Enter User Name',
                        suffixIcon: Icon(Icons.person),
                        border: OutlineInputBorder()),
                    onSaved: (value) {
                      _userName = value;
                    },
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  validator: (value) {
                    if (value.isEmpty || value.length < 7) {
                      return 'please enter a valid password';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Enter Your Password',
                      suffixIcon: Icon(Icons.vpn_key_outlined),
                      border: OutlineInputBorder()),
                  onSaved: (value) {
                    _userPassword = value;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                if (widget.isLogging) CircularProgressIndicator(),
                if (!widget.isLogging)
                  TextButton(
                      onPressed: _trySubmit,
                      child: Text(_isLogIn ? 'Sign In' : 'Sign Up')),
                if (!widget.isLogging)
                  TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogIn = !_isLogIn;
                        });
                      },
                      child: Text(_isLogIn
                          ? 'Create New Account'
                          : 'I already have an account'))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
