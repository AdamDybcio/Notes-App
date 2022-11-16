import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class AddFilesButtonWidget extends StatelessWidget {
  const AddFilesButtonWidget({
    Key? key,
    required this.imageFileList,
  }) : super(key: key);

  final List<XFile>? imageFileList;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Add',
      textAlign: TextAlign.center,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 20,
          color: imageFileList!.isEmpty ? Colors.black : Colors.black,
          shadows: const [
            Shadow(
                color: Colors.white, blurRadius: 1, offset: Offset(0.5, 0.5)),
            Shadow(
                color: Colors.white, blurRadius: 1, offset: Offset(-0.5, 0.5)),
            Shadow(
                color: Colors.white, blurRadius: 1, offset: Offset(0.5, -0.5)),
            Shadow(
                color: Colors.white, blurRadius: 1, offset: Offset(-0.5, -0.5)),
          ],
        ),
      ),
    );
  }
}
