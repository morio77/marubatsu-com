import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marubatsu_com/utils/cell_type_utils.dart';

// 1マス分を描画する
class CellPainter extends CustomPainter {
  final CellType cellType;
  CellPainter(this.cellType);

  @override
  void paint(Canvas canvas, Size size) {
    switch (cellType) {
      case CellType.maru: // マルの場合
        final paint = Paint()
          ..color = Colors.red
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 5;
        final center = Offset(size.width / 2, size.height / 2);
        final radius = min(size.width, size.height) * 0.8;
        canvas.drawCircle(center, radius, paint);
        break;

      case CellType.batsu: // バツの場合
        final margin = 0.1;
        final paint = Paint()
          ..color = Colors.blue
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5;

        // 左上から右下への線
        final path1 = Path()
          ..moveTo(size.width * margin, size.height * margin)
          ..lineTo(size.width * (1 - margin), size.height * (1 - margin));
        canvas.drawPath(path1, paint);

        // 左下から右上への線
        final path2 = Path()
          ..moveTo(size.width * margin, size.height * (1 - margin))
          ..lineTo(size.width * (1 - margin), size.height * margin);
        canvas.drawPath(path2, paint);
        break;

      case CellType.none: // まだ埋まっていないセルの場合
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}