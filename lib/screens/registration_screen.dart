import 'package:firebase_auth/firebase_auth.dart';

import 'package:flashchat/constants.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
 

class RegistrationScreen extends StatefulWidget {
  
  static const String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner =false;
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        
        child: Padding(
          
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 200.0,
                child: Hero(tag: 'logo', child: Image.asset('images/logo.png')),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: kMessageTextFieldDecorationRegister.copyWith(
                  hintText: 'Enter your email',
                  
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
        
                obscureText: true,
                onChanged: (value) {
        
                  password = value;
                },
                decoration: kMessageTextFieldDecorationRegister.copyWith(
                  hintText: 'Enter your password',
                ),
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: ()  async{

                      setState(() {
                        showSpinner=true;
                      });
                      try {
                        final newUser = await _auth.createUserWithEmailAndPassword(
                            email: email, password: password);
                        if(newUser != null){
                          Navigator.popAndPushNamed(context, ChatScreen.id);
        
        
                        }
                        setState(() {
                        showSpinner=false;
                      });
                      }
                      catch (e){
                        print(e);
        
                      }
     
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



