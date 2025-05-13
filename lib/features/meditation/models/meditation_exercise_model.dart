import 'meditation_step_model.dart';

class MeditationExerciseModel {
  final String title;
  final String description;
  final String videoUrl;
  final String videothumbnail;
  final List<MeditationStepModel> steps;
  String duration;

  MeditationExerciseModel({
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.videothumbnail,
    required this.steps,
    required this.duration,
  });
}
