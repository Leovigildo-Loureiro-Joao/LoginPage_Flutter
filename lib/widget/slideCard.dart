import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loginpage/ui/themes.dart';

class Slidecard extends StatelessWidget {
  final String texto;
  final String svg;
  final Animation<double> scaleAnimation;

  const Slidecard({
    super.key,
    required this.texto,
    required this.svg,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: scaleAnimation.value,
              child: Container(
                child: SvgPicture.asset(
                  'assets/$svg',
                  fit: BoxFit.cover,
                  height: 230,
                  width: 230,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            texto,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}