import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:login_metro/helper/userModelClass.dart';
import 'package:login_metro/screens/admin_login.dart';
import 'package:login_metro/screens/taskScreen.dart';
import 'package:login_metro/register/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordHidden = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  addUser(String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  // Function to convert String UID to int
  int uidToInt(String uid) {
    var bytes = utf8.encode(uid); // Convert string to UTF-8 bytes
    var hash = bytes.fold(
        0,
        (sum, byte) =>
            sum + byte); // Sum all byte values to get a consistent int
    return hash;
  }

// Your sign-in method using Firebase Authentication
  Future<void> signInWithEmailPassword(
      BuildContext context, String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        print("User is successfully signed in");

        // Retrieve user information from Firebase Authentication
        String uid = user.uid;
        int userId = uidToInt(uid); // Convert UID to int
        print("======${userId}");
        String name = user.displayName ??
            ''; // If display name is not set, use empty string
        String userEmail =
            user.email ?? ''; // If email is not set, use empty string

        // Pass the user information to the TaskListScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskListScreen(
              user: Users(
                id: userId,
                name: name,
                email: userEmail,
                isAdmin: false, // You can set admin status based on your logic
              ),
            ),
          ),
        );
      }
    } catch (e) {
      print("Error signing in: $e");
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return const SizedBox(
            height: 50,
            child: Center(child: Text("Invalid Email or Password")),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 154, 198, 219),
        centerTitle: true,
        title: const Text("Sign In"),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Image.asset(
                "./assets/866.jpg",
                height: (MediaQuery.of(context).size.height / 4),
                width: (MediaQuery.of(context).size.width),
                alignment: Alignment.center,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.always,
                      key: _formKey,
                      child: Column(children: [
                        TextFormField(
                          validator: MultiValidator([
                            RequiredValidator(errorText: '*Required'),
                            EmailValidator(errorText: "**Not Valid Email**")
                          ]),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          controller: _emailController,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 93, 84, 7),
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Color.fromARGB(255, 37, 37, 37),
                            ),
                            hintText: "abc@xyz.com",
                            hintStyle: const TextStyle(fontSize: 18),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2),
                                borderRadius: BorderRadius.circular(20)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            label: const Text(
                              "email_Login",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          validator: MultiValidator(
                            [
                              RequiredValidator(errorText: "*Required"),
                              MinLengthValidator(6, errorText: "**Not Strong**")
                            ],
                          ),
                          obscureText: _passwordHidden,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 93, 84, 7),
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Color.fromARGB(255, 37, 37, 37),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: IconButton(
                                icon: _passwordHidden
                                    ? const Icon(Icons.visibility_off)
                                    : const Icon(Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _passwordHidden = !_passwordHidden;
                                  });
                                },
                                color: Colors.black87,
                              ),
                            ),
                            hintText: "Test123",
                            hintStyle: const TextStyle(fontSize: 18),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.red, width: 2),
                                borderRadius: BorderRadius.circular(20)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            label: const Text(
                              "Password",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text("Don't have Account?"),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpPage()));
                                  },
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminLoginPage()));
                                    },
                                    child: Text("Admin Login")),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              signInWithEmailPassword(
                                  context,
                                  _emailController.text,
                                  _passwordController.text);
                            }
                          },
                          child: Container(
                              height: 60,
                              width: 200,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 154, 198, 219),
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 160, 122, 8),
                                      style: BorderStyle.solid,
                                      width: 1)),
                              child: const Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )),
                        )
                      ]),
                    )
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
