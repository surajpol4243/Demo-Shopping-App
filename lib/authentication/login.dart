import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/authentication/register.dart';
import 'package:untitled/products/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? emailcontroller;
  TextEditingController? passwordcontroller;
  bool hide = true;
  var key = GlobalKey<FormState>();

  bool isValidEmail(String? email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email!);
  }

  @override
  void initState() {
    super.initState();
    emailcontroller = TextEditingController();
    passwordcontroller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailcontroller,
                  validator: (input) {
                    if (!isValidEmail(input)) {
                      return 'Invalid email';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Email ID',
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: passwordcontroller,
                  obscureText: hide,
                  validator: (input) {
                    if (input!.length < 8) {
                      return "Password length should be more than 8 digits!";
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    contentPadding: new EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                    suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            hide = !hide;
                          });
                        },
                        child: Icon(Icons.hide_image)),
                  ),
                ),
              ),
              MaterialButton(
                color: Colors.blue,
                onPressed: () async {
                  if (key.currentState!.validate()) {
                    print('validated');
                    // Firebase.initializeApp();
                    showDialog(
                        context: context,
                        builder: (bc) {
                          return AlertDialog(
                            title: Text('Signing in...'),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                              ],
                            ),
                          );
                        });
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .signInWithEmailAndPassword(
                              email: emailcontroller!.text,
                              password: passwordcontroller!.text)
                          .then((value) {
                        Navigator.pop(context);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => ProductsPage(
                                      user: value.user!.uid,
                                    )),
                            (route) => false);
                        return value;
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    }
                  }
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              MaterialButton(
                color: Colors.blue,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Registerpage()));
                },
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              MaterialButton(
                color: Colors.blue,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (bc) {
                        return AlertDialog(
                          title: Text('Signing in...'),
                          content: Container(
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        );
                      });
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => ProductsPage(
                                user: "null",
                              )),
                      (route) => false);
                },
                child: Text(
                  'Continue without login',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
