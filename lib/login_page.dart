import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _passwords;
  FormType _formType = FormType.login;
  final formkey = GlobalKey<FormState>();

  bool validateAndSave() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
      //print('form is valid. Email: $_email, password: $_passwords');
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if(_formType == FormType.login){
        FirebaseUser user = (await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: _email, password: _passwords))
            .user;
        print('Signined: ${user.uid}');
        }else{
          FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _passwords)).user;
          print('Registered user: ${user.uid}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    formkey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin(){
    formkey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter login demo'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButton(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        onSaved: (value) => _email = value,
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        decoration: InputDecoration(
          labelText: 'Email',
        ),
      ),
      TextFormField(
        onSaved: (value) => _passwords = value,
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
        ),
      ),
    ];
  }

  List<Widget> buildSubmitButton() {
    if(_formType == FormType.login){
      return [
      RaisedButton(
        onPressed: validateAndSubmit,
        child: Text('LOGIN'),
      ), 
      FlatButton(
        onPressed: moveToRegister,
        child: Text(
          'Create an account',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    ];
    } else{
      return [
      RaisedButton(
        onPressed: validateAndSubmit,
        child: Text('Create an account'),
      ), 
      FlatButton(
        onPressed: moveToLogin,
        child: Text(
          'Have an account? Login',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    ];
    }
    
  }
}
