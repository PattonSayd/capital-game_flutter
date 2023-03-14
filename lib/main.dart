import 'package:capitals_quiz/components.dart';
import 'package:capitals_quiz/game.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with GameMixin<HomePage> {
  final TCardController _cardController = TCardController();

  @override
  void initState() {
    onInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (gameItems.isEmpty) {
      return const SizedBox.shrink();
    }
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12).copyWith(top: 12),
            child: Headers(
              title: 'Is it ${gameItems[current].capital}?',
              subtitle: gameItems[current].country,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TCard(
              slideSpeed: 25,
              delaySlideFor: 60,
              controller: _cardController,
              cards: gameItems
                  .map((e) => CapitalCard(key: ValueKey(e), item: e))
                  .toList(),
              onForward: (index, info) => onGuess(
                index,
                info.direction == SwipDirection.Right,
                gameItems[current].fake != null,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Controls(
              onAnswer: (isTrue) => _cardController.forward(
                direction: isTrue ? SwipDirection.Right : SwipDirection.Left,
              ),
            ),
          )
        ],
      ),
    );
  }
}
