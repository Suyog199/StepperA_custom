/// /*** Uttam kumar mitra ***/
/// create date 04/03/2023; 10:41 PM
///
///

import 'package:flutter/material.dart';

import '../../stepper_a.dart';

class StepperNotifier extends ChangeNotifier {
  ///IF you need different Step border style
  ///default border style is [straight]
  final BorderType borderType;

  ///If need different Stepper line style
  ///default stepper line style is [straight]
  final LineType lineType;

  ///If you need different BorderShape
  ///default borderShape is [circle]
  final BorderShape borderShape;

  /// A circular array of dash offsets and lengths.
  ///
  /// For example, the array `[5, 10]` would result in dashes 5 pixels long
  /// default the array [3,5]
  final List<double> dashPattern;

  /// An object that can be used to control the position to which this page
  /// view is scrolled.
  PageController controller;

  /// An object that can be used to control the position to which this Stepper
  /// view is scrolled.
  final ScrollController _stepController = ScrollController();

  ///Active page index
  ///default index is 0
  int _currentIndex = 0;

  ///Step animation direction
  AnimationDirection _direction = AnimationDirection.clockwise;

  ///next Page index
  ///default set next page index is 0
  int nextPageIndex = 0;

  ///Total page length
  ///default page index set is 1
  int totalIndex = 0;

  final GlobalKey<FormState>? formKey;

  ///Ticker Provider from [StepperA], cause need to use it in [AnimationSlide]
  late TickerProviderStateMixin singleTickerProviderStateMixin;

  late AnimationController stepperController;
  late Animation<double> animation;

  StepperNotifier({
    required this.borderType,
    required this.lineType,
    required this.borderShape,
    required this.dashPattern,
    required this.controller,
    required int initialPage,
    required int length,
    required TickerProviderStateMixin vsync,
    this.formKey,
  }) {
    _currentIndex = initialPage;
    nextPageIndex = initialPage;
    totalIndex = length;
    singleTickerProviderStateMixin = vsync;
    stepperController = AnimationController(
        vsync: vsync, duration: const Duration(milliseconds: 1000));
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(stepperController);
  }

  int checkFormKeyValidation(int index) {
    if (_currentIndex > index) return index;

    if (formKey == null) return index;

    formKey!.currentState?.save();

    if (formKey!.currentState != null && formKey!.currentState!.validate())
      return index;

    return _currentIndex;
  }

  Animation<double> getAnimation() {
    stepperController.reset();
    stepperController.forward();
    return animation;
  }

  ///Getter for [_currentIndex]
  int get currentIndex => _currentIndex;

  ///Getter for [_direction]
  AnimationDirection get direction => _direction;

  ///Setter for [_currentIndex]
  set currentIndex(int index) {
    if (_currentIndex > index) {
      _direction = AnimationDirection.anticlockwise;
    } else {
      _direction = AnimationDirection.clockwise;
    }

    _currentIndex = checkFormKeyValidation(index);
    controller.animateToPage(_currentIndex,
        duration: const Duration(milliseconds: durationTime),
        curve: Curves.easeOut);
    notifyListeners();
  }

  ScrollController getStepScrollController(
      {required double itemWidth,
      required double lineWidth,
      required double screenWidth}) {
    final double scrollAmount =
        ((_currentIndex + 1) * (lineWidth + itemWidth)) - screenWidth;
    if (scrollAmount > 0) {
      _stepController.animateTo(scrollAmount,
          duration: const Duration(milliseconds: durationTime),
          curve: Curves.easeIn);
    }
    return _stepController;
  }

  @override
  void dispose() {
    controller.dispose();
    stepperController.dispose();
    super.dispose();
  }
}
