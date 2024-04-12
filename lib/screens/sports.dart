import 'package:flutter/material.dart';
import 'package:playmingle/screens/hostgame.dart';
import 'package:playmingle/screens/joingame.dart';
import 'package:playmingle/screens/viewgames.dart';
import 'package:playmingle/screens/yourgames.dart';

class SportsScreen extends StatelessWidget {
  SportsScreen({Key? key, required this.mail}) : super(key: key);
  
  final String mail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mail),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Your Option:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton(
                  context,
                  const LinearGradient(
                    colors: [Colors.grey, Colors.grey],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  'Host Game',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HostGameScreen(mail: mail,),
                      ),
                    );
                  },
                ),
                _buildButton(
                  context,
                  const LinearGradient(
                    colors: [Colors.grey, Colors.grey],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  'Join Game',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JoinGameScreen(mail: mail,),
                      ),
                    );
                  },
                ),
                _buildButton(
                  context,
                  const LinearGradient(
                    colors: [Colors.grey, Colors.grey],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  'View Games',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewGames(),
                      ),
                    );
                  },
                ),
                _buildButton(
                  context,
                  const LinearGradient(
                    colors: [Colors.grey, Colors.grey],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  'Joined Games',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => YourGames(mail),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, LinearGradient gradient, String text, Function() onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          textStyle: const TextStyle(color: Color.fromARGB(255, 209, 160, 218)),
        ),
        child: Text(text,
        style: const TextStyle(color: Colors.white),),
      ),
    );
  }
}
