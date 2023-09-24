import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login_metro/sign_up_page.dart';
import 'firebase_auth_implementation/firebase_auth_services.dart';
import 'firebase_auth_implementation/firebase_options.dart';

import 'newPage.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  bool _passwordHidden = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  addUser(String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  void _signIn() async {
    final FirebaseAuthService _auth = FirebaseAuthService();

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);
    if (user != null) {
      print("User is successfully signedIn");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => newPage()));
    } else {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              height: 50,
              child: Center(child: Text("Invalid EmailId or Password")),
            );
          });
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
      drawer: customWidget(),
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
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "My App",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
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
                          autofillHints: [AutofillHints.email],
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
                            hintStyle: TextStyle(fontSize: 18),
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
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Don't have Account?"),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignUpPage()));
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              _signIn();
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

class customWidget extends StatelessWidget {
  const customWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey),
              child: Column(
                children: [
                  CircleAvatar(
                    // child: Text("ksdkjf"),
                    backgroundColor: Colors.grey.withOpacity(0.1),

                    backgroundImage: const NetworkImage(
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                    maxRadius: 50,
                  ),
                  Spacer(),
                  Text(
                    "User",
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              )),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profile"),
            trailing: Icon(Icons.arrow_right),
            autofocus: true,
            onTap: (() {
              Navigator.pop(context);
            }),
            focusColor: Colors.amber,
          ),
          Divider(
            thickness: 1,
            endIndent: 10,
            indent: 10,
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Setting"),
            trailing: Icon(Icons.arrow_right),
            //autofocus: true,
            onTap: (() {
              Navigator.pop(context);
            }),
          ),
          Divider(
            thickness: 1,
            endIndent: 10,
            indent: 10,
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("Favorite"),
            trailing: Icon(Icons.arrow_right),
            //autofocus: true,
            onTap: (() {
              Navigator.pop(context);
            }),
          ),
          Divider(
            thickness: 1,
            endIndent: 10,
            indent: 10,
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Sign Out"),
            trailing: Icon(Icons.arrow_right),
            //autofocus: true,
            onTap: (() {
              Navigator.pop(context);
            }),
            dense: true,
          ),
          Divider(
            thickness: 1,
            endIndent: 10,
            indent: 10,
          ),
        ],
      ),
    );
  }
}
//-------------------------**************************--------------------------