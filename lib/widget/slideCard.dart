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
     final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
                  width: height >600?230:height*0.2,
                ),
              ),
            );
          },
        ),
        
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