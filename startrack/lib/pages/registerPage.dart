// ignore_for_file: prefer_const_constructors, prefer_final_fields, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.fromARGB(255, 57, 52, 56), // Change the background color here
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 250.0, // Adjust the height of the image container
            child: Center(
              child: Image.asset(
                'assets/images/sr_logo.png',
                height: 400.0,
                width: 450.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(300, 20, 300, 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 20.0),
                  Center(
                    child: Text('StarTrack',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40.0,
                            color: Color.fromARGB(255, 229, 207, 163))),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      filled: true,
                      fillColor: Colors
                          .white, // Change the background color of the input box here
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      filled: true,
                      fillColor: Colors
                          .white, // Change the background color of the input box here
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }

                      if (!value!.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      filled: true,
                      fillColor: Colors
                          .white, // Change the background color of the input box here
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm-Password',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      filled: true,
                      fillColor: Colors
                          .white, // Change the background color of the input box here
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        String username = _usernameController.text;
                        String email = _emailController.text;
                        String password = _passwordController.text;
                        print(
                            'Registered with Username: $username, Email: $email, Password: $password');
                      }
                    },
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
