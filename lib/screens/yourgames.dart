import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:playmingle/screens/viewgames.dart';

class YourGames extends StatelessWidget {
  const YourGames(this.mail, {super.key});

  final String mail;

  @override
  Widget build(BuildContext context) {
    if (mail.isEmpty) {
      FirebaseAuth.instance.signOut();
      return const Text(
          'Error: Mail not provided'); // Or handle the error appropriately
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Joined Games'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future:
              FirebaseFirestore.instance.collection('users').doc(mail).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (!snapshot.hasData) {
              return const Text('User not found');
            }

            final userData = snapshot.data!.data()!;
            final gameIds =
                userData['games'] as List<dynamic>; // Assuming games is a list

            return ListView.builder(
              itemCount: gameIds.length,
              itemBuilder: (context, index) {
                final gameId = gameIds[index];

                // **Type checking and handling for robustness:**
                if (gameId is String) { // Check if gameId is a string
                return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance.collection('game').doc(gameId).get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    // Handle cases where the document might not exist:
                    if (!snapshot.hasData) {
                      return const Text('Game not found'); // Or display a different message
                    }

                    final gameData = snapshot.data!.data()!;
                    return GameCard(
                      // Extract game data from game document
                      code: gameData['code'],
                      date: gameData['date'],
                      email: gameData['email'],
                      location: gameData['location'],
                      numberOfPlayers: gameData['numberofplayers'],
                      players: gameData['players'],
                      sport: gameData['sport'],
                      time: gameData['time'],
                      // Add any additional fields you want to display
                    );
                  },
                );
              } else {
                // Handle non-string gameIds gracefully (e.g., log a warning or display an error message)
                print('Warning: Invalid game ID type: ${gameId.runtimeType}');
                return const Text('Error: Invalid game ID format'); // Or customize the error message
              }
            },
          );
        },
      ),
    ),
  );
}
}
