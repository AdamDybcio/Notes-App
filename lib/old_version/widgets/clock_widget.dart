import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';

class ClockWidget extends StatelessWidget {
  const ClockWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.redAccent.shade400.withOpacity(0.9),
        ),
        height: MediaQuery.of(context).size.width * 0.35,
        width: MediaQuery.of(context).size.width * 0.35,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: AnalogClock(
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.white),
                color: Colors.transparent,
                shape: BoxShape.circle),
            width: MediaQuery.of(context).size.width * 0.25,
            height: MediaQuery.of(context).size.width * 0.25,
            isLive: true,
            hourHandColor: Colors.white,
            minuteHandColor: Colors.white,
            showSecondHand: false,
            numberColor: Colors.white,
            showNumbers: true,
            showAllNumbers: true,
            textScaleFactor: 1.4,
            showTicks: true,
            tickColor: Colors.white,
            showDigitalClock: true,
            digitalClockColor: Colors.white,
            datetime: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              DateTime.now().hour,
              DateTime.now().minute,
              DateTime.now().second,
            ),
          ),
        ),
      ),
    );
  }
}
