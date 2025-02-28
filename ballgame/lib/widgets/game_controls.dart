import 'package:flutter/material.dart';

class GameControls extends StatelessWidget {
  final Function jumpLeft;
  final Function jumpRight;
  final Function returnToMenu;

  const GameControls({
    Key? key,
    required this.jumpLeft,
    required this.jumpRight,
    required this.returnToMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: Colors.blue[800],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () => jumpLeft(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[300],
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 30,
            ),
          ),
          ElevatedButton(
            onPressed: () => returnToMenu(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text(
              "В меню",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => jumpRight(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[300],
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Icon(
              Icons.arrow_forward,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
