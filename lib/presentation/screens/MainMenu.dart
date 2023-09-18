import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:super_battleground/presentation/screens/SuperBattlegroundGame/SuperBattlegroundGame.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'MyGame/MyGame.dart';
import 'RPG/MainGame.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});
  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/menu_background.gif"),
            fit: BoxFit.cover,
          ),
        ),
        child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('Main Menu', style: TextStyle(
              color: Colors.white,
              fontSize: 38,
            ),),
               Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: OutlinedButton(onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => GameWidget(game: MainGame()),
                    ),
                  ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.transparent),
                      ),
                      child: const Text('START', style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                  ),)
                  ),
              ),
          ],
        ),
      ),
      ),
    );
  }
}