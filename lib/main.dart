import 'package:capitals_quiz/domain/assemble.dart';
import 'package:flutter/material.dart';

import 'iu/app.dart';
import 'logger.dart';

void main() {
  initLogger();
  configureDependencies();
  runApp(const App());
}
