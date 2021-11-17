import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  const MyButton({
    Key key,
    @required this.child,
    this.onTap,
    this.padding,
    this.activeColor,
    this.disabledColor,
    this.hoverColor,
    this.elevation,
    this.borderRadius,
    this.visible,
    this.disabled = false,
    this.shape,
    this.margin,
  }) : super(key: key);
  final Widget child;
  final Function onTap;
  final EdgeInsets padding, margin;
  final Color activeColor, disabledColor, hoverColor;
  final double elevation;
  final BorderRadius borderRadius;
  final bool visible, disabled;
  final RoundedRectangleBorder shape;

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible ?? true,
      child: GestureDetector(
        onTap: widget.onTap ?? () {},
        child: MouseRegion(
          onEnter: (val) {
            isHovered = true;
            setState(() {});
          },
          onExit: (val) {
            isHovered = false;
            setState(() {});
          },
          child: Card(
            margin: widget.margin ?? EdgeInsets.zero,
            shape: widget.shape ??
                RoundedRectangleBorder(
                  borderRadius:
                      widget.borderRadius ?? BorderRadius.circular(10),
                ),
            elevation: widget.elevation ?? 3,
            color: widget.disabled
                ? widget.disabledColor ?? Colors.grey
                : isHovered
                    ? widget.hoverColor ??
                        widget.activeColor ??
                        Colors.blue[800]
                    : widget.activeColor ?? Colors.blue[800],
            child: Padding(
              padding: widget.padding ??
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}
