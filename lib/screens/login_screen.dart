
import 'package:flashchat/constants.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  bool showSpinner =false;
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
                style: TextStyle(color: Colors.black),
                
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email=value;
                },
                decoration: kMessageTextFieldDecorationLogin.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password=value;
                  },
                  decoration: kMessageTextFieldDecorationLogin.copyWith(
                    hintText: 'Enter your password',
        
        
                  )),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async{

                      setState(() {
                        showSpinner=true;
                      });

                      try{
                      final regUser = await _auth.signInWithEmailAndPassword(email:email, password: password);

                        Navigator.pushNamed(context, ChatScreen.id);
                      
                      setState(() {
                        showSpinner=false;
                      });
                      }
                      catch(e){
                        print(e);
                      }
                      
                            // .createUserWithEmailAndPassword(
                            // email: email, password: password);
                      // Navigator.pop(context);
                      //Implement login functionality.
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Log In',
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



