import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleTextWidget extends StatelessWidget {
  const TitleTextWidget({
    Key? key,
    required this.mainText,
  }) : super(key: key);

  final String mainText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.2),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            mainText,
            style: GoogleFonts.lato(
              fontSize: 50,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
