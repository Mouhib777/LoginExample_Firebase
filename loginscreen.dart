import 'package:bil/Service/snackbar.dart';
import 'package:bil/constant/constants.dart';
import 'package:bil/screens/home/homescreen.dart';
import 'package:bil/screens/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bil/screens/registrescreen.dart';
import 'package:bil/Background/background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bil/Service/auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  VoidCallback? ontap;

  bool isloading = false;

  String? email;

  String? password;

  Function(String)? onchanged;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        body: Background(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Image.asset(
                    'assets/images/sign.png',
                    width: 140,
                  )
                  // Text(
                  // "LOGIN",
                  // style: TextStyle(
                  //  fontWeight: FontWeight.w800,
                  //  color: Colors.blue[800],
                  //    fontSize: 36),
                  // textAlign: TextAlign.left,
                  //),
                  ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  onChanged: (data) {
                    email = data;
                  },
                  decoration: InputDecoration(labelText: "E-mail address"),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  onChanged: (data) {
                    password = data;
                  },
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: Text(
                  "Forgot your password?",
                  style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              GestureDetector(
                onTap: ontap,
                child: Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: RaisedButton(
                    onPressed: () async {
                      isloading = true;
                      setState(() {});

                      // ScaffoldMessenger.of(context).showSnackBar(
                      // SnackBar(content: Text('stanna shway ... ')));
                      try {
                        await loginuser();

                        showSnackBar(context, 'Mar7bé  💙 ');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => homescreen(
                                      currentUserId: '',
                                      visitedUserId: '',
                                    )));
                      } on FirebaseAuthException catch (ex) {
                        if (ex.code == 'user-not-found') {
                          showSnackBar(context, 'Met2aked li nty maana 🤔 ?');
                        } else if (ex.code == 'wrong-password')
                          showSnackBar(context, "wrong password 😰  ");
                      }
                      isloading = false;
                      setState(() {});
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: size.width * 0.5,
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(80.0),
                          gradient: new LinearGradient(colors: [
                            Color.fromRGBO(32, 136, 177, 41),
                            BIL_Color,
                          ])),
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "LOGIN",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()))
                  },
                  child: Text(
                    "",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800]),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  static final _auth = FirebaseAuth.instance;
  static final _fireStore = FirebaseFirestore.instance;

  static Future<bool> signin(String name, String email, String password) async {
    try {
      UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? signedInUser = authResult.user;

      if (signedInUser != null) {
        _fireStore.collection('users').doc(signedInUser.uid).set({
          'uid': signedInUser.uid,
          'name': name,
          'email': email,
          'profilePicture': '',
          'coverImage': '',
          'bio': ''
        });
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> loginuser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: email!.trim(), password: password!.trim());
  }
}
