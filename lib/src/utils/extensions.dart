import 'package:flutter/material.dart';

extension ListExtension on List<Widget> {
  /// Adds SizeBox between widgets of List of Widget and returns new list with added SizeBoxes.
  List<Widget> space(double space, Axis direction) => List.generate(
        length * 2,
        (index) {
          if (index % 2 != 0) {
            return SizedBox(
              height: direction == Axis.horizontal ? 0 : space,
              width: direction == Axis.horizontal ? space : 0,
            );
          } else {
            return this[(index / 2).floor()];
          }
        },
      );
}
