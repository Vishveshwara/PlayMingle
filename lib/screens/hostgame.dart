import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();
final timeformatter = DateFormat.jm();

class HostGameScreen extends StatefulWidget {
  const HostGameScreen({super.key, required this.mail});
  final String mail;

  @override
  State<StatefulWidget> createState() {
    return _HostGameScreen();
  }
}

class _HostGameScreen extends State<HostGameScreen> {
  final _form = GlobalKey<FormState>();

  String _gameCode = '';
  String _selectSports = 'Cricket';
  int _totalPlayers = 0;
  String _location = '';
  DateTime _selectedDate = DateTime.now();

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    await FirebaseFirestore.instance.collection('game').doc(_gameCode).set({
      'code': _gameCode,
      'email': widget.mail,
      'sport': _selectSports,
      'numberofplayers': _totalPlayers,
      'location': _location,
      'date': formatter.format(_selectedDate),
      'time': timeformatter.format(_selectedDate),
      'players': [widget.mail],
    });

    DocumentReference docRef =
        FirebaseFirestore.instance.collection('users').doc(widget.mail);
    DocumentSnapshot doc = await docRef.get();
    docRef.update({
      'games': FieldValue.arrayUnion([_gameCode])
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Game Created'),
    ));
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final initialDate = DateTime(now.year, now.month, now.day);

    // Show date picker
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate:
          DateTime(now.year, now.month + 1, now.day), // One month in the future
    );

    if (pickedDate != null) {
      // Show time picker if a date is selected
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
      );

      if (pickedTime != null) {
        // Combine date and time into a DateTime object
        final selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          _selectedDate = selectedDateTime;
        });
      }
    }
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
                          DropdownButtonFormField<String>(
                            value:
                                _selectSports.isNotEmpty ? _selectSports : null,
                            hint: const Text('Select Game'),
                            items: const [
                              DropdownMenuItem(
                                  value: 'Cricket', child: Text('Cricket')),
                              DropdownMenuItem(
                                  value: 'Football', child: Text('Football')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectSports = value!;
                              });
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'No Of Players'),
                            keyboardType: TextInputType.number,
                            autocorrect: false,
                            textCapitalization: TextCapitalization.none,
                            onSaved: (value) {
                              _totalPlayers = int.parse(value!);
                            },
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Location'),
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
                              _location = value!;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                formatter.format(_selectedDate),
                              ),
                              IconButton(
                                onPressed: _presentDatePicker,
                                icon: const Icon(
                                  Icons.calendar_month,
                                ),
                              ),
                              Text(timeformatter.format(_selectedDate)),
                              const Icon(Icons.av_timer_rounded),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            child: const Text('Create Game'),
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
