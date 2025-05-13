import 'package:flutter/material.dart';
import '/features/meditation/models/meditation_exercise_model.dart';
import '/utils/constants/color_extension.dart';

class ExercisesRow extends StatelessWidget {
  final List<MeditationExerciseModel> exercises;
  final VoidCallback onPressed;

  const ExercisesRow({
    super.key,
    required this.exercises,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          exercises.map((exercise) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              leading: ClipOval(
                child: Image.asset(
                  exercise.videothumbnail,
                  fit: BoxFit.cover,
                  width: 56,
                  height: 56,
                ),
              ),
              title: Text(
                exercise.title,
                style: TextStyle(
                  color: FColor.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                exercise.duration,
                style: TextStyle(color: FColor.gray, fontSize: 12),
              ),
              trailing: IconButton(
                onPressed: onPressed,
                icon: Image.asset(
                  "assets/images/next_go.png",
                  width: 20,
                  height: 20,
                  fit: BoxFit.contain,
                ),
              ),
            );
          }).toList(),
    );
  }
}
