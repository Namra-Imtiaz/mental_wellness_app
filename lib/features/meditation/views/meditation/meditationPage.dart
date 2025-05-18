import 'package:flutter/material.dart';
import '/common/widgets/select_meditation_category.dart';
import '/features/meditation/data/focus_meditation_data.dart';
import '/features/meditation/data/relax_meditation_data.dart';
import '/features/meditation/data/mind_meditation_data.dart';
import '/utils/constants/color_extension.dart';

class MeditationPage extends StatelessWidget {
  const MeditationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final allCategories = [
      focusMeditationCategory,
      mindMeditationCategory,
      relaxMeditationCategory,
    ];
    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF8F6FF),
        centerTitle: true,
        title: Text(
          'Meditation',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: FColor.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: media.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              "How are you feeling today?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Select a meditation category that suits your current state of mind. Whether you need to relax, regain focus, or calm racing thoughts — there's something for you.",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 10),
            ListView.builder(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                var categoryModel = allCategories[index];
                return SelectMeditationCategory(category: categoryModel);
              },
            ),
          ],
        ),
      ),
    );
  }
}
