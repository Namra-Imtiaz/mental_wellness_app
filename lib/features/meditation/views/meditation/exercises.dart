import 'package:flutter/material.dart';
import '/common/widgets/exercise_row.dart';
import '/features/meditation/models/meditation_category_model.dart';
import '/features/meditation/models/meditation_exercise_model.dart';
import '/features/meditation/views/meditation/exercise_steps._screen.dart';
import '/utils/constants/color_extension.dart';

class MeditationExercisesScreen extends StatefulWidget {
  final List<MeditationExerciseModel> exercises;
  final MeditationCategoryModel category;

  const MeditationExercisesScreen({
    super.key,
    required this.exercises,
    required this.category,
  });

  @override
  State<MeditationExercisesScreen> createState() =>
      _MeditationExercisesScreenState();
}

class _MeditationExercisesScreenState extends State<MeditationExercisesScreen> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,

        title: Text(
          widget.category.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// Suggestion title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recommended for you",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "${widget.category.items.length} items",
                    style: TextStyle(fontSize: 12, color: FColor.gray),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Text(
                "These might be used in the exercises below.",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),

              const SizedBox(height: 12),

              /// Suggestion cards
              SizedBox(
                height: media.width * 0.5,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.category.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.category.items[index];
                    return Container(
                      width: media.width * 0.35,
                      margin: const EdgeInsets.only(right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              height: media.width * 0.35,
                              color: FColor.lightGray,
                              alignment: Alignment.center,
                              child: Image.asset(
                                item["image"] ?? '',
                                width: media.width * 0.2,
                                height: media.width * 0.2,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item["title"] ?? 'Untitled',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              /// Exercises section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Available Exercises",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Total: ${widget.exercises.length}",
                    style: TextStyle(fontSize: 12, color: FColor.gray),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "Tap an exercise to begin your session",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),

              const SizedBox(height: 10),

              ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = widget.exercises[index];
                  return ExercisesRow(
                    exercises: [exercise],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => MeditationExerciseStepsScreen(
                                exercise: exercise,
                              ),
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
