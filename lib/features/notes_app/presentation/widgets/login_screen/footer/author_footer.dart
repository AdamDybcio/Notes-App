import 'package:flutter/material.dart';

class AuthorFooter extends StatelessWidget {
  const AuthorFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.025,
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.5),
      ),
      child: Center(
        child: Opacity(
          opacity: 0.5,
          child: RichText(
            text: const TextSpan(
              text: 'Made by ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
              children: [
                TextSpan(
                  text: 'Adam Dybcio',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                TextSpan(
                  text: ' | ',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
                TextSpan(
                  text: '2024',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
