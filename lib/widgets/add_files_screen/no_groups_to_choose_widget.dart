import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NoGroupsToChooseWidget extends StatelessWidget {
  const NoGroupsToChooseWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'You don\'t have any groups :(',
      textAlign: TextAlign.center,
      style: GoogleFonts.lato(
        fontSize: 15,
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
