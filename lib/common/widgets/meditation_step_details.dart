import 'package:dotted_dashed_line/dotted_dashed_line.dart';
import 'package:flutter/material.dart';
import '/features/meditation/models/meditation_step_model.dart';
import '/utils/constants/color_extension.dart';

class MeditationStepDetails extends StatelessWidget {
  final List<MeditationStepModel> stepArr;
  final bool isLast;
  const MeditationStepDetails({
    super.key,
    required this.stepArr,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      // Changed from ListView.builder to Column
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(stepArr.length, (index) {
        final step = stepArr[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 25,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(color: FColor.secondaryColor1, fontSize: 14),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: FColor.secondaryColor1,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        border: Border.all(color: FColor.white, width: 3),
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                  ),
                  if (index != stepArr.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: DottedDashedLine(
                        height: 50,
                        width: 0,
                        dashColor: FColor.secondaryColor1,
                        axis: Axis.vertical,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: TextStyle(color: FColor.black, fontSize: 14),
                    ),
                    Text(
                      step.description,
                      style: TextStyle(color: FColor.gray, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
