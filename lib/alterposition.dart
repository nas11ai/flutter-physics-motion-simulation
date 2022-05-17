import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class AlterPosition extends SingleChildRenderObjectWidget {
  final Matrix4 alterPosition;
  final AlignmentGeometry? alignment;
  final bool transformHitTests;
  const AlterPosition({
    Key? key,
    required this.alterPosition,
    this.alignment,
    this.transformHitTests = true,
    Widget? child,
  })  : assert(alterPosition != null),
        super(key: key, child: child);

  AlterPosition.rotate({
    Key? key,
    required double angle,
    this.alignment = Alignment.center,
    this.transformHitTests = true,
    Widget? child,
  })  : alterPosition = Matrix4.rotationZ(angle),
        super(key: key, child: child);

  @override
  RenderTransform createRenderObject(BuildContext context) {
    return RenderTransform(
      transform: alterPosition,
      alignment: alignment,
      textDirection: Directionality.maybeOf(context),
      transformHitTests: transformHitTests,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderTransform renderObject) {
    renderObject
      ..transform = alterPosition
      ..alignment = alignment
      ..textDirection = Directionality.maybeOf(context)
      ..transformHitTests = transformHitTests;
  }
}
