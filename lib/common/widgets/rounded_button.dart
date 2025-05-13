import 'package:flutter/material.dart';
import '/utils/constants/color_extension.dart';

enum RoundedBtnType { bgGradient, bgSGradient, textGradient }

class RoundedBtn extends StatelessWidget {
  final String title;
  final RoundedBtnType type;
  final VoidCallback onPressed;
  final double fontSize;
  final double elevation;
  final FontWeight fontWeight;

  const RoundedBtn({
    super.key,
    required this.title,
    this.type = RoundedBtnType.bgGradient,
    this.fontSize = 16,
    this.elevation = 1,
    this.fontWeight = FontWeight.w700,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              type == RoundedBtnType.bgSGradient
                  ? FColor.secondaryG
                  : FColor.primaryG,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow:
            type == RoundedBtnType.bgGradient ||
                    type == RoundedBtnType.bgSGradient
                ? const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 0.5,
                    offset: Offset(0, 0.5),
                  ),
                ]
                : null,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        height: 50,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        textColor: FColor.primaryColor1,
        minWidth: double.maxFinite,
        elevation:
            type == RoundedBtnType.bgGradient ||
                    type == RoundedBtnType.bgSGradient
                ? 0
                : elevation,
        color:
            type == RoundedBtnType.bgGradient ||
                    type == RoundedBtnType.bgSGradient
                ? Colors.transparent
                : FColor.white,
        child:
            type == RoundedBtnType.bgGradient ||
                    type == RoundedBtnType.bgSGradient
                ? Text(
                  title,
                  style: TextStyle(
                    color: FColor.white,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  ),
                )
                : ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      colors: FColor.primaryG,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(
                      Rect.fromLTRB(0, 0, bounds.width, bounds.height),
                    );
                  },
                  child: Text(
                    title,
                    style: TextStyle(
                      color: FColor.primaryColor1,
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                    ),
                  ),
                ),
      ),
    );
  }
}
