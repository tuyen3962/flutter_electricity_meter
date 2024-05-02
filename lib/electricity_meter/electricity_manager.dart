import 'dart:async';

import 'package:flutter/material.dart';

class ElectricityMeterManager {
  final int maxValue;
  final currentValue = ValueNotifier(0);
  var _destination = 0;
  late Timer? timer = null;

  ElectricityMeterManager({required this.maxValue});

  void startRotate(int targetValue) {
    timer?.cancel();
    timer = null;
    _destination = targetValue;
    currentValue.value = 0;
    timer = Timer.periodic(const Duration(), (_) {
      var newVal = currentValue.value + 2;
      if (newVal >= _destination) {
        currentValue.value = _destination;
        timer?.cancel();
        timer = null;
      } else {
        currentValue.value = newVal;
      }
    });
  }

  void onChange(int targetValue) {
    timer?.cancel();
    timer = null;
    _destination = targetValue;
    timer = Timer.periodic(const Duration(), (_) {
      if (currentValue.value > targetValue) {
        var newVal = currentValue.value - 2;
        if (newVal <= _destination) {
          currentValue.value = _destination;
          timer?.cancel();
          timer = null;
        } else {
          currentValue.value = newVal;
        }
      } else {
        var newVal = currentValue.value + 2;
        if (newVal >= _destination) {
          currentValue.value = _destination;
          timer?.cancel();
          timer = null;
        } else {
          currentValue.value = newVal;
        }
      }
    });
  }

  void dispose() {
    timer?.cancel();
    currentValue.dispose();
  }
}
