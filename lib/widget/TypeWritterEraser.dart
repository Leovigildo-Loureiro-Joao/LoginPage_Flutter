// widgets/typewriter_with_cursor.dart
import 'package:flutter/material.dart';

class TypewriterWithCursor extends StatefulWidget {
  final String text;
  final Duration duration;
  final TextStyle? style;
  final TextAlign textAlign;
  final Color cursorColor;
  final Duration cursorBlinkDuration;

  const TypewriterWithCursor({
    super.key,
    required this.text,
    this.duration = const Duration(milliseconds: 40),
    this.style,
    this.textAlign = TextAlign.left,
    this.cursorColor = Colors.blue,
    this.cursorBlinkDuration = const Duration(milliseconds: 500),
  });

  @override
  State<TypewriterWithCursor> createState() => _TypewriterWithCursorState();
}

class _TypewriterWithCursorState extends State<TypewriterWithCursor>
    with TickerProviderStateMixin {
  late AnimationController _typeController;
  late AnimationController _cursorController;
  late Animation<int> _typeAnimation;
  late Animation<double> _cursorAnimation;
  
  String _displayText = '';
  bool _showCursor = true;

  @override
  void initState() {
    super.initState();
    
    // Controlador para a digitação
    _typeController = AnimationController(
      duration: widget.duration * widget.text.length,
      vsync: this,
    );

    // Controlador para o cursor piscando
    _cursorController = AnimationController(
      duration: widget.cursorBlinkDuration,
      vsync: this,
    )..repeat(reverse: true);

    _typeAnimation = IntTween(
      begin: 0,
      end: widget.text.length,
    ).animate(_typeController);

    _cursorAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_cursorController);

    _typeController.forward();

    _typeAnimation.addListener(() {
      setState(() {
        _displayText = widget.text.substring(0, _typeAnimation.value);
      });
    });

    _cursorAnimation.addListener(() {
      setState(() {
        _showCursor = _cursorAnimation.value > 0.5;
      });
    });
  }

  @override
  void dispose() {
    _typeController.dispose();
    _cursorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.textAlign == TextAlign.center 
          ? MainAxisAlignment.center 
          : widget.textAlign == TextAlign.right 
              ? MainAxisAlignment.end 
              : MainAxisAlignment.start,
      children: [
        Text(
          _displayText,
          style: widget.style,
          textAlign: widget.textAlign,
        ),
        if (_showCursor && _typeController.status != AnimationStatus.completed)
          Container(
            width: 2,
            height: widget.style?.fontSize ?? 16,
            margin: EdgeInsets.only(left: 2),
            color: widget.cursorColor,
          ),
      ],
    );
  }
}