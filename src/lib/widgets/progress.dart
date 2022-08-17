import 'dart:math';

import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Progress extends StatefulWidget {
  final int intakeAmount;
  final int todaysAmount;
  final int prevAmount;
  final int prevIntake;

  const Progress(
      {required this.prevIntake,
      required this.intakeAmount,
      required this.todaysAmount,
      required this.prevAmount,
      Key? key})
      : super(key: key);

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int _currentGoal = 2000;

  late Future<String> activeUnit;

  @override
  void initState() {
    activeUnit = _prefs.then((SharedPreferences prefs) {
      return prefs.getString('unit') ?? "";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int usePrevIntake =
        widget.prevIntake > 0 ? widget.prevIntake : widget.intakeAmount;
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Container(
        width: 100,
        height: 100,
        padding: const EdgeInsets.all(20.0),
        child: SfRadialGauge(
          enableLoadingAnimation: true,
          axes: <RadialAxis>[
            RadialAxis(
              axisLineStyle: const AxisLineStyle(
                  thickness: 0.05,
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  thicknessUnit: GaugeSizeUnit.factor,
                  cornerStyle: CornerStyle.bothCurve),
              showTicks: false,
              showLabels: false,
              onAxisTapped: (value) {},
              pointers: <GaugePointer>[
                RangePointer(
                    enableAnimation: true,
                    animationType: AnimationType.ease,
                    animationDuration: 1000,
                    color: Theme.of(context).primaryColor,
                    value: widget.todaysAmount / widget.intakeAmount * 100,
                    onValueChanged: (value) {},
                    cornerStyle: CornerStyle.bothCurve,
                    onValueChangeEnd: (value) {},
                    onValueChanging: (value) {},
                    enableDragging: true,
                    width: 0.05,
                    sizeUnit: GaugeSizeUnit.factor)
              ],
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  widget: Container(
                    height: 290,
                    width: 290,
                    padding: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(800),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.07),
                            blurRadius: 52,
                          )
                        ]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              color: Colors.transparent,
                              height: 85,
                              child: Countup(
                                begin: min(
                                    widget.prevAmount / usePrevIntake * 100,
                                    100),
                                end: min(
                                    widget.todaysAmount /
                                        widget.intakeAmount *
                                        100,
                                    100),
                                duration: const Duration(milliseconds: 800),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 64,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "%",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.todaysAmount.toString(),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17),
                            ),
                            FutureBuilder<String>(
                                future: activeUnit,
                                builder: (ctx, snapshot) {
                                  if (snapshot.connectionState !=
                                      ConnectionState.waiting) {
                                    return Text(
                                      ' / ${widget.intakeAmount.toString()}${snapshot.data}',
                                      style: const TextStyle(fontSize: 17),
                                    );
                                  } else {
                                    return Text(
                                      ' / ${widget.intakeAmount.toString()}ml',
                                      style: const TextStyle(fontSize: 17),
                                    );
                                  }
                                })
                          ],
                        )
                      ],
                    ),
                  ),
                  positionFactor: .03,
                  angle: 0.5,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
