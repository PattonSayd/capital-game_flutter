import 'package:capitals_quiz/components.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12).copyWith(top: 12),
            child: const Headers(
              title: 'Is it Moscow?',
              subtitle: 'Russia',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(),
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
