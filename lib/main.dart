import 'package:capitals_quiz/components.dart';
import 'package:capitals_quiz/models.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';

TCardController _cardController = TCardController();

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

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const items = [
      GameItem(
        original: Country(
          'Ajerbaijan',
          'Baku',
          imageUrls: [
            'https://images.unsplash.com/photo-1602485487042-e5e9b528c389'
          ],
        ),
      ),
      GameItem(
        original: Country(
          'Ajerbaijan',
          'Baku',
          imageUrls: [
            'https://images.unsplash.com/photo-1586672089683-0075010e0011'
          ],
        ),
      ),
      GameItem(
        original: Country(
          'Ajerbaijan',
          'Baku',
          imageUrls: [
            'https://images.unsplash.com/photo-1597164121150-0a58f73d0812'
          ],
        ),
      ),
      GameItem(
        original: Country(
          'Ajerbaijan',
          'Baku',
          imageUrls: [
            'https://images.unsplash.com/photo-1561578131-ff1cbbe2747e'
          ],
        ),
      ),
    ];
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12).copyWith(top: 12),
            child: const Headers(
              title: 'Is it Baku?',
              subtitle: 'Azerbaijan',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TCard(
              slideSpeed: 15,
              delaySlideFor: 60,
              controller: _cardController,
              cards: items
                  .map((e) => CapitalCard(
                        // key: ValueKey(e),📍📍📍📍📍📍📍📍📍
                        item: e,
                      ))
                  .toList(),
              onForward: (index, info) => print('Swipe: ${info.direction}'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Controls(
              onAnswer: (isTrue) {
                print('Answer: $isTrue');
              },
            ),
          )
        ],
      ),
    );
  }
}
