import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class AnimatedBallAlign extends ImplicitlyAnimatedWidget {
  final AlignmentGeometry alignment;
  final Widget? child;

  const AnimatedBallAlign({
    Key? key,
    required this.alignment,
    this.child,
    Curve curve = Curves.linear,
    required Duration duration,
    VoidCallback? onEnd,
  })  : assert(alignment != null),
        super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  @override
  AnimatedWidgetBaseState<AnimatedBallAlign> createState() =>
      _AnimatedBallAlignState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment));
  }
}

class _AnimatedBallAlignState
    extends AnimatedWidgetBaseState<AnimatedBallAlign> {
  AlignmentGeometryTween? _alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _alignment!.evaluate(animation)!,
      child: widget.child,
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _alignment = visitor(
      _alignment,
      widget.alignment,
      (dynamic value) =>
          AlignmentGeometryTween(begin: value as AlignmentGeometry),
    ) as AlignmentGeometryTween?;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder description) {
    super.debugFillProperties(description);
    description.add(DiagnosticsProperty<AlignmentGeometryTween>(
        'alignment', _alignment,
        defaultValue: null));
  }
}
