import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firebase = FirebaseAuth.instance;

enum Gender { male, female, others }

class AuthScreen extends StatefulWidget {
  AuthScreen(this.mail, {super.key, this.ChangedEmail});
  final String mail;
  Function(String value)? ChangedEmail;

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  var _enteredFullName = '';
  var _enteredAge = 0;
  var _selectedGender = 'Male';
  var _cricket = 0;
  var _football = 0;
  var _enteredPhoneNumber = 0;
  var _isAuthenticating = false;

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      // show error message ...
      return;
    }

    _form.currentState!.save();

    try {
      setState(() {
        _isAuthenticating = true;
      });
      if (_isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _enteredEmail, password: _enteredPassword);
        widget.ChangedEmail!(_enteredEmail);
        
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_enteredEmail)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'name': _enteredFullName,
          'age': _enteredAge,
          'gender':_selectedGender,
          'cricket':_cricket,
          'football':_football,
          'phone':_enteredPhoneNumber,
          'games':[]
        });
      }
      
      widget.ChangedEmail!(_enteredEmail);

    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        // ...
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Email Address'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _enteredEmail = value!;
                            },
                          ),
                          if (!_isLogin)
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Username'),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return 'Please enter at least 4 characters.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredUsername = value!;
                              },
                            ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                prefixText:
                                    '+91', // Pre-filled non-editable "+91"
                              ),
                              keyboardType:
                                  TextInputType.phone, // Use phone keyboard
                              validator: (value) {
                                if (value == null || value.trim().length < 10) {
                                  return 'Invalid phone number. Enter a 10-digit number.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                // Parse the entered string to an integer before saving
                                _enteredPhoneNumber = int.parse(value!);
                              },
                            ),
                          if (!_isLogin)
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Full Name'),
                              keyboardType: TextInputType.text,
                              autocorrect:
                                  true, // Enable autocorrect for full names (optional)
                              textCapitalization: TextCapitalization
                                  .words, // Capitalize each word
                              onSaved: (value) {
                                _enteredFullName =
                                    value!; // Assuming you have a variable for full name
                              },
                            ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(labelText: 'Age'),
                              keyboardType: TextInputType
                                  .number, // Use number keyboard for age
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              onSaved: (value) {
                                _enteredAge = int.parse(
                                    value!); // Parse the entered value to an integer
                              },
                            ),
                          if (!_isLogin)
                            DropdownButtonFormField<String>(
                              value: _selectedGender.isNotEmpty
                                  ? _selectedGender
                                  : null, // Currently selected gender
                              hint: const Text('Select Gender'),
                              items: const [
                                DropdownMenuItem(
                                    value: 'Male', child: Text('Male')),
                                DropdownMenuItem(
                                    value: 'Female', child: Text('Female')),
                                DropdownMenuItem(
                                    value: 'Others',
                                    child: Text(
                                        'Others')), // Corrected typo (remove space)
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value!;
                                });
                              },
                            ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Cricket Proficiency Level'),
                              keyboardType: TextInputType
                                  .number, // Use number keyboard for age
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              onSaved: (value) {
                                _cricket = int.parse(
                                    value!); // Parse the entered value to an integer
                              },
                            ),
                          if (!_isLogin)
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Football Proficiency Level'),
                              keyboardType: TextInputType.number,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              onSaved: (value) {
                                _football = int.parse(value!);
                              },
                            ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _enteredPassword = value!;
                            },
                          ),
                          const SizedBox(height: 12),
                          if (_isAuthenticating)
                            const CircularProgressIndicator(),
                          if (!_isAuthenticating)
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Text(_isLogin ? 'Login' : 'Signup'),
                            ),
                          if (!_isAuthenticating)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'Create an account'
                                  : 'I already have an account'),
                            ),
                        ],
                      ),
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