import 'package:flutter/material.dart';
import '/common/widgets/rounded_button.dart';
import '/features/meditation/models/meditation_category_model.dart';
import '/features/meditation/views/meditation/exercises.dart';
import '/utils/constants/color_extension.dart';

class SelectMeditationCategory extends StatelessWidget {
  final MeditationCategoryModel category;
  const SelectMeditationCategory({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        height: media.height * 0.2,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              FColor.primaryColor2.withAlpha(76),
              FColor.primaryColor1.withAlpha(76),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: TextStyle(
                      color: FColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${category.exercises.length} Exercise ",
                    style: TextStyle(color: FColor.gray, fontSize: 14),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 100,
                    height: 30,
                    child: RoundedBtn(
                      title: "View More",
                      fontSize: 12,
                      type: RoundedBtnType.textGradient,
                      elevation: 0.05,
                      fontWeight: FontWeight.w400,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => MeditationExercisesScreen(
                                  exercises: category.exercises,
                                  category: category,
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(138),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    category.image,
                    width: 110,
                    height: 110,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
