import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class JoinGameScreen extends StatefulWidget {
  const JoinGameScreen({super.key, required this.mail});
  final String mail;

  @override
  State<StatefulWidget> createState() {
    return _JoinGameScreen();
  }
}

class _JoinGameScreen extends State<JoinGameScreen> {
  final _form = GlobalKey<FormState>();

  String _gameCode = '';

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(widget.mail);
    DocumentSnapshot doc = await docRef.get();
    docRef.update({
      'games': FieldValue.arrayUnion([_gameCode])
    });

    DocumentReference docRef2 =
        FirebaseFirestore.instance.collection('game').doc(_gameCode);
    DocumentSnapshot doc2 = await docRef2.get();
    docRef2.update({
      'players': FieldValue.arrayUnion([widget.mail])
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Game Joined'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' '),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
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
                          Text(
                            widget.mail,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Game Code'),
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
                              _gameCode = value!;
                            },
                          ),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: const Text('Join Game'),
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
