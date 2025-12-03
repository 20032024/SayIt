import 'package:flutter/material.dart';

IconData getIconForSign(String sign) {
  switch (sign.toLowerCase()) {
    case 'stop':
      return Icons.do_not_disturb_alt;

    case 'right of way':
    case 'right of way at intersection':
      return Icons.turn_right;

    case 'speed limit':
    case 'speed':
      return Icons.speed;

    case 'no uturn':
    case 'no u-turn':
      return Icons.u_turn_left;

    case 'parking':
      return Icons.local_parking;

    default:
      return Icons.info_outline;
  }
}
