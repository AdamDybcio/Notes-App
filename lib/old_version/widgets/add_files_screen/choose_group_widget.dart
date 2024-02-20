import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChooseGroupWidget extends StatelessWidget {
  const ChooseGroupWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Select a group',
      style: GoogleFonts.lato(
        fontSize: 20,
        color: Colors.white,
        shadows: const [
          Shadow(color: Colors.black, blurRadius: 1, offset: Offset(0.5, 0.5)),
          Shadow(color: Colors.black, blurRadius: 1, offset: Offset(-0.5, 0.5)),
          Shadow(color: Colors.black, blurRadius: 1, offset: Offset(0.5, -0.5)),
          Shadow(
              color: Colors.black, blurRadius: 1, offset: Offset(-0.5, -0.5)),
        ],
      ),
    );
  }
}
