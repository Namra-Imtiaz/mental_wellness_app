import 'meditation_exercise_model.dart';

class MeditationCategoryModel {
  final String title;
  final String image;
  final List<MeditationExerciseModel> exercises;
  final List<Map<String,String>> items;

  MeditationCategoryModel({
    required this.title,
    required this.image,
    required this.items,
    required this.exercises,
  });
}
