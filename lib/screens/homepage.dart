import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen(this.mail, {super.key});

  final String mail;

  @override
  Widget build(BuildContext context) {
    if (mail.isEmpty) {
      FirebaseAuth.instance.signOut();
    return const Text('Error: Mail not provided'); // Or handle the error appropriately
  }
    return Scaffold(
      appBar: AppBar(
        title: const Text(' '),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(mail)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            // Handle the case where the document doesn't exist
            if (!snapshot.hasData) {
              return const Text('User not found');
            }

            final userData = snapshot.data!.data()!;
            final username = userData['username'];
            final gender = userData['gender'];
            final fn = userData['name'];
            final mailId = userData['email'];
            final age = userData['age'];
            final cricket = userData['cricket'];
            final football = userData['football'];
            final phone = userData['phone'];

            return Scaffold(
  body: Center(
    child: SingleChildScrollView( // Allow scrolling if content overflows
      child: Padding(
        padding: const EdgeInsets.all(20.0), // Add padding for aesthetics
        child: Column(
          mainAxisSize: MainAxisSize.min, // Content shrinks to minimum size
          crossAxisAlignment: CrossAxisAlignment.start, // Left-align content
          children: [
            const Text(
              'Logged in!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0), // Add some space between sections
            const Text(
              'Username:',
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
            Text(username),
            const SizedBox(height: 10.0),
            const Text(
              'Full Name:',
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
            Text(fn),
            const SizedBox(height: 10.0),
            const Text(
              'Email:',
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
            Text(mailId),
            const SizedBox(height: 10.0),
            const Text(
              'Phone Number:',
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
            Text(phone.toString()),
            const Text(
              'Age:',
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
            Text(age.toString()), // Convert age to string for display
            const SizedBox(height: 10.0),
            const Text(
              'Gender:',
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
            Text(gender),
            const SizedBox(height: 10.0),
            const Text(
              'Cricket Proficiency Level:',
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
            Text(cricket.toString()),
            const Text(
              'Football Proficiency Level:',
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
            Text(football.toString()),
          ],
        ),
      ),
    ),
  ),
);

          },
        ),
      ),
    );
  }
}