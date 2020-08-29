import 'package:driving_data_collector/utils/styles.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  ActionButton(this.text, this.onTap);
  final String text;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size.width * 0.7,
        height: 50,
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Styles.kAccentColor,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
