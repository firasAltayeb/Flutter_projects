import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_constants.dart';
import '../models/question_model.dart';

final questionListProvider = StateProvider<List<QuestionModel>>((ref) {
  final shuffledList = [...AppConstants.questions]..shuffle();
  return shuffledList;
});

final questionIndexProvider = StateProvider<int>((ref) => 0);

final selectedAnsAccuracyProvider = StateProvider<int>((ref) => 0);

final resultScreenMsgProvider = StateProvider<String>((ref) => '');

final selectedAnsTextProvider = StateProvider<String>((ref) => '');

final mistakeAttemptsProvider = StateProvider<int>((ref) => 4);

final incorrectPlayerProvider = StateProvider<AudioPlayer?>((ref) => null);

final correctPlayerProvider = StateProvider<AudioPlayer?>((ref) => null);
