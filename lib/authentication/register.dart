import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:untitled/authentication/login.dart';
import 'package:untitled/products/homepage.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({Key? key}) : super(key: key);

  @override
  _RegisterpageState createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  TextEditingController? nameController;
  TextEditingController? emailController;
  TextEditingController? numberController;
  TextEditingController? passwordController;
  TextEditingController? conformpasswordController;
  bool hide = true;
  bool hide1 = true;
  var key = GlobalKey<FormState>();

  bool isValidEmail(String? email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email!);
  }

  bool isValidPassword(String? password) {
    return RegExp(r'^[0-9]+$').hasMatch(password!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    numberController = TextEditingController();
    passwordController = TextEditingController();
    conformpasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
        ),
        body: SingleChildScrollView(
          child: Container(
              child: Center(
                  child: Form(
            key: key,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: ' Name',
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
                    controller: emailController,
                    validator: (input) {
                      if (!isValidEmail(input)) {
                        return 'Invalid email';
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Email-id',
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
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    validator: (input) {
                      if (input!.length < 10) {
                        return "enter correct phone number.";
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Mobile number',
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
                    controller: passwordController,
                    obscureText: hide1,
                    keyboardType: TextInputType.number,
                    validator: (input) {
                      if (input!.length < 8) {
                        return "Password length should be more than 8 digits!";
                      }
                      if (!isValidPassword(input)) {
                        return "Password must only contain digits";
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Password',
                        contentPadding: new EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              hide1 = !hide1;
                            });
                          },
                          child: Icon(Icons.hide_image),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: conformpasswordController,
                    obscureText: hide,
                    keyboardType: TextInputType.number,
                    validator: (input) {
                      if (input!.length < 8) {
                        return "Password length should be more than 8 digits!";
                      }
                      if (!isValidPassword(input)) {
                        return "Password must only contain digits";
                      }
                    },
                    decoration: InputDecoration(
                        hintText: 'Conform Password',
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
                          child: Icon(Icons.hide_image),
                        )),
                  ),
                ),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () async {
                    if (key.currentState!.validate()) {
                      print('Validated');
                      Firebase.initializeApp();
                      showDialog(
                          context: context,
                          builder: (bc) {
                            return AlertDialog(
                              title: Text('Registering...'),
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                ],
                              ),
                            );
                          });
                      Firebase.initializeApp();

                      try {
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                                email: "${emailController!.text}",
                                password: "${passwordController!.text}")
                            .then((value) async {
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(value.user!.uid)
                              .set({
                            'name': nameController!.text,
                            'email': emailController!.text,
                            'phone': numberController!.text,
                          }).then((d) {
                            Navigator.pop(context);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => ProductsPage(
                                          user: value.user!.uid,
                                        )),
                                (route) => false);
                          });
                          return value;
                        });
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                        } else if (e.code == 'email-already-in-use') {
                          print('The account already exists for that email.');
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    'login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ))),
        ),
      ),
    );
  }
}
