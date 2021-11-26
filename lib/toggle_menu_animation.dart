import 'dart:math';

import 'package:flutter/material.dart';

class ToggleMenuAnimation extends StatefulWidget {
  final double height;
  final VoidCallback onPress;
  final bool isSelected;
  final Color activeColor;
  final Color deactiveColor;

  const ToggleMenuAnimation({
    Key? key,
    this.height = 100.0,
    required this.onPress,
    required this.isSelected,
    this.activeColor = Colors.redAccent,
    this.deactiveColor = Colors.blue,
  }) : super(key: key);

  @override
  State<ToggleMenuAnimation> createState() => _ToggleMenuAnimationState();
}

class _ToggleMenuAnimationState extends State<ToggleMenuAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // function helper convert degrees to radians
  double degrees2Radians = pi / 180.0;
  double radians(double degrees) => degrees * degrees2Radians;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPress,
      child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            if (widget.isSelected) {
              _animationController.forward();
            } else {
              _animationController.reverse();
            }

            return Container(
              height: widget.height,
              width: widget.height,
              color:
                  widget.isSelected ? widget.activeColor : widget.deactiveColor,
              padding: widget.isSelected
                  ? null
                  : EdgeInsets.only(left: widget.height * 0.2),
              child: Stack(
                alignment:
                    widget.isSelected ? Alignment.center : Alignment.centerLeft,
                children: [
                  // 1. translate to center Offset(0,0)
                  // 2. rotate to 45 degrees
                  // 3. set with to widget.height * 0.6
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateZ(
                        radians(45 * _animationController.value),
                      ),
                    child: Transform.translate(
                      offset: Offset(
                          0,
                          -(widget.height / 4) +
                              (widget.height / 4) * _animationController.value),
                      child: Container(
                        color: Colors.white,
                        width: widget.isSelected
                            ? widget.height * 0.6
                            : widget.height * 0.35,
                        height: widget.height * 0.05,
                      ),
                    ),
                  ),
                  // translate to right
                  // Add opacity
                  Opacity(
                    opacity: 1 -
                        1 * _animationController.value, // opacity from 1 to 0
                    child: Transform.translate(
                      offset:
                          Offset(widget.height * _animationController.value, 0),
                      child: Container(
                        color: Colors.white,
                        width: widget.height * 0.6,
                        height: widget.height * 0.05,
                      ),
                    ),
                  ),
                  // 1. translate to center Offset(0,0)
                  // 2. rotate to 315 degrees
                  // 3. set width to height * 0.6
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateZ(
                        radians(
                          315 * _animationController.value,
                        ), // change -45 to 315 degrees
                      ),
                    child: Transform.translate(
                      offset: Offset(
                          0,
                          widget.height / 4 -
                              (widget.height / 4) * _animationController.value),
                      child: Container(
                        color: Colors.white,
                        width: widget.isSelected
                            ? widget.height * 0.6
                            : widget.height * 0.2,
                        height: widget.height * 0.05,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
