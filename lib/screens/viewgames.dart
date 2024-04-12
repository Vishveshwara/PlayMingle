import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewGames extends StatefulWidget {
  const ViewGames({super.key});

  @override
  State<ViewGames> createState() => _ViewGamesState();
}

class _ViewGamesState extends State<ViewGames> {
  final Stream<QuerySnapshot<Map<String, dynamic>>> _gamesStream =
      FirebaseFirestore.instance.collection('game').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Games'), // Set a meaningful title
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context), // Concise arrow function
            icon: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _gamesStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Handle errors gracefully
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator()); // Show loading indicator
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final gameData = documents[index].data();
              return GameCard(
                // Extract game data from Firestore document
                code: gameData['code'],
                date: gameData['date'],
                email: gameData['email'],
                location: gameData['location'],
                numberOfPlayers: gameData['numberofplayers'],
                players: gameData['players'],
                sport: gameData['sport'],
                time: gameData['time'],
              );
            },
          );
        },
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final String code;
  final String date;
  final String email;
  final String location;
  final int numberOfPlayers;
  final List<dynamic> players; // Assuming players is a list of strings (emails)
  final String sport;
  final String time;

  const GameCard({
    Key? key,
    required this.code,
    required this.date,
    required this.email,
    required this.location,
    required this.numberOfPlayers,
    required this.players,
    required this.sport,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var noofplayersjoined = players.length;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display game details using Text widgets or other UI elements
            const SizedBox(height: 8.0),
            Text(
              'Game Code: $code',
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Sport: $sport',
              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Text('Time: $time'),
            const SizedBox(height: 4.0),
            Text('Location: $location'),
            const SizedBox(height: 4.0),
            Text('Host Email: $email'),
            const SizedBox(height: 4.0),
            Text('Players Joined: $noofplayersjoined / $numberOfPlayers'),
            const SizedBox(height: 4.0),
            const Text(
              'Players:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4.0),
            // Display list of players (assuming players is a list of strings)
            Wrap(
              children: players.map((player) => Text('$player ')).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
