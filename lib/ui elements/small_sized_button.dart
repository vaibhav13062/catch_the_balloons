import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SmallSizedButton extends StatelessWidget {
  final String? text;
  final VoidCallback? function;
  final Color? color;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  const SmallSizedButton(
      {super.key, required this.text,
      this.textColor,
      this.fontWeight,
      this.fontSize,
      this.color,
      required this.function,
      this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: function,
            child: Container(
              padding: padding ?? const EdgeInsets.all(10),
              child: Text(
                text!,
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: textColor,
                        fontWeight: fontWeight,
                        fontSize: fontSize)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
