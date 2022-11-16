import 'dart:io';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:image_painter/image_painter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class WriteNoteScreen extends StatefulWidget {
  final userData;
  const WriteNoteScreen({Key? key, this.userData}) : super(key: key);

  @override
  State<WriteNoteScreen> createState() => _WriteNoteScreenState();
}

class _WriteNoteScreenState extends State<WriteNoteScreen> {
  final _imageKey = GlobalKey<ImagePainterState>();
  File file = File('');
  bool isLoading = false;

  void saveImage() async {
    final fileName =
        '${widget.userData['login'].toString().toLowerCase().trim()}'
        '${DateTime.now().month}'
        '${DateTime.now().day}'
        '${DateTime.now().hour}'
        '${DateTime.now().minute}'
        '${DateTime.now().second}'
        '.png';

    final image = await _imageKey.currentState!.exportImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/notes').create(recursive: true);
    final fullPath = '$directory/notes/$fileName';
    file = await File(fullPath).create();
    file.writeAsBytesSync(image as List<int>);

    file = File(fullPath);

    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.35,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.width * 0.2,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: OutlinedButton(
                      onPressed: null,
                      child: Text(
                        "Choose an action:",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            shadows: [
                              Shadow(
                                  color: Colors.white,
                                  blurRadius: 1,
                                  offset: Offset(0.5, 0.5)),
                              Shadow(
                                  color: Colors.white,
                                  blurRadius: 1,
                                  offset: Offset(-0.5, 0.5)),
                              Shadow(
                                  color: Colors.white,
                                  blurRadius: 1,
                                  offset: Offset(0.5, -0.5)),
                              Shadow(
                                color: Colors.white,
                                blurRadius: 1,
                                offset: Offset(-0.5, -0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    OpenFile.open(fullPath);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: OutlinedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                          Colors.orangeAccent,
                        )),
                        onPressed: null,
                        child: Text(
                          "Open and save to your gallery",
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              shadows: [
                                Shadow(
                                    color: Colors.black,
                                    blurRadius: 1,
                                    offset: Offset(0.5, 0.5)),
                                Shadow(
                                    color: Colors.black,
                                    blurRadius: 1,
                                    offset: Offset(-0.5, 0.5)),
                                Shadow(
                                    color: Colors.black,
                                    blurRadius: 1,
                                    offset: Offset(0.5, -0.5)),
                                Shadow(
                                  blurRadius: 1,
                                  offset: Offset(-0.5, -0.5),
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Color? color;

  @override
  void initState() {
    color = Colors.black;
    super.initState();
  }

  @override
  void dispose() {
    ValueNotifier(_imageKey).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ImagePainter.asset(
            'assets/nic.png',
            placeholderWidget: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(color: Colors.white),
            ),
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.86,
            brushIcon: const Icon(
              Icons.brush,
              color: Colors.black,
              shadows: [
                Shadow(
                    color: Colors.white,
                    blurRadius: 1,
                    offset: Offset(0.5, 0.5)),
                Shadow(
                    color: Colors.white,
                    blurRadius: 1,
                    offset: Offset(-0.5, 0.5)),
                Shadow(
                    color: Colors.white,
                    blurRadius: 1,
                    offset: Offset(0.5, -0.5)),
                Shadow(
                    color: Colors.white,
                    blurRadius: 1,
                    offset: Offset(-0.5, -0.5)),
              ],
            ),
            undoIcon: const Icon(
              Icons.undo,
              color: Colors.black,
              shadows: [
                Shadow(
                    color: Colors.white,
                    blurRadius: 1,
                    offset: Offset(0.5, 0.5)),
                Shadow(
                    color: Colors.white,
                    blurRadius: 1,
                    offset: Offset(-0.5, 0.5)),
                Shadow(
                    color: Colors.white,
                    blurRadius: 1,
                    offset: Offset(0.5, -0.5)),
                Shadow(
                    color: Colors.white,
                    blurRadius: 1,
                    offset: Offset(-0.5, -0.5)),
              ],
            ),
            clearAllIcon: Icon(
              Icons.delete,
              color: Colors.redAccent.shade400,
              shadows: const [
                Shadow(
                    color: Colors.black,
                    blurRadius: 1,
                    offset: Offset(0.5, 0.5)),
                Shadow(
                    color: Colors.black,
                    blurRadius: 1,
                    offset: Offset(-0.5, 0.5)),
                Shadow(
                    color: Colors.black,
                    blurRadius: 1,
                    offset: Offset(0.5, -0.5)),
                Shadow(
                    color: Colors.black,
                    blurRadius: 1,
                    offset: Offset(-0.5, -0.5)),
              ],
            ),
            colorIcon: Icon(
              Icons.color_lens,
              color: color,
              shadows: [
                Shadow(
                  color: color == Colors.black ? Colors.white : Colors.black,
                  offset: const Offset(0.5, 0.5),
                ),
                Shadow(
                  color: color == Colors.black ? Colors.white : Colors.black,
                  offset: const Offset(-0.5, -0.5),
                ),
                Shadow(
                  color: color == Colors.black ? Colors.white : Colors.black,
                  offset: const Offset(-0.5, 0.5),
                ),
                Shadow(
                  color: color == Colors.black ? Colors.white : Colors.black,
                  offset: const Offset(0.5, -0.5),
                ),
              ],
            ),
            onColorChanged: (newColor) {
              setState(() {
                color = newColor;
              });
            },
            colors: const [
              Colors.black,
              Colors.white,
              Colors.red,
              Colors.yellow,
              Colors.pink,
              Colors.green,
              Colors.grey,
              Colors.orange,
              Colors.blue,
              Colors.purple,
              Colors.brown,
              Colors.cyan,
            ],
            key: _imageKey,
            scalable: true,
            initialStrokeWidth: 3,
            initialColor: Colors.black,
            initialPaintMode: PaintMode.freeStyle,
          ),
          Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
            child: IconButton(
              splashColor: Colors.blue,
              splashRadius: 30,
              onPressed: isLoading ? null : saveImage,
              icon: Icon(
                Icons.save,
                size: 40,
                color: isLoading ? Colors.grey : Colors.blue,
                shadows: const [
                  Shadow(
                      color: Colors.black,
                      blurRadius: 1,
                      offset: Offset(0.5, 0.5)),
                  Shadow(
                      color: Colors.black,
                      blurRadius: 1,
                      offset: Offset(-0.5, 0.5)),
                  Shadow(
                      color: Colors.black,
                      blurRadius: 1,
                      offset: Offset(0.5, -0.5)),
                  Shadow(
                      color: Colors.black,
                      blurRadius: 1,
                      offset: Offset(-0.5, -0.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
