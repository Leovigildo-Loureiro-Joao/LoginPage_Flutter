import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:loginpage/pages/login_screen.dart';
import 'package:loginpage/pages/sing_screen.dart';
import 'package:loginpage/ui/themes.dart';

import '../widget/slideCard.dart';

class WelcomeScreen extends StatefulWidget {
  final bool? cadastrado;
  const WelcomeScreen({
    super.key,
    required this.theme,
    required this.switchTheme,
    this.cadastrado
  });

  final ThemeData theme;
  final VoidCallback switchTheme;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
    late AnimationController _animationController;
    late Animation<double> _scaleAnimation;
    late PageController _pageController;
    late Timer? _autoPlayTimer;

  
  int _currentPage = 0;
  final List<Map<String, String>> _slides = [
    {
      'texto': 'Gerencie todas suas senhas\nem um único lugar',
      'svg': 'security.svg',
    },
    {
      'texto': 'Acesso rápido e seguro\nàs suas credenciais',
      'svg': 'lock.svg',
    },
    {
      'texto': 'Sincronize entre\ntodos seus dispositivos',
      'svg': 'sync.svg',
    },
  ];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pageController = PageController(viewportFraction: 0.8);

    _animationController.repeat(reverse: true);
    
    //Auto-rotate carousel (opcional)
    _startAutoPlay();
  }

   void _startAutoPlay() {
    
    _autoPlayTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        
        if (_currentPage < _slides.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else {
          _pageController.animateToPage(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
   }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void fakeSession() async{
     Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen(theme: widget.theme,updateTheme: widget.switchTheme,cadastrado: widget.cadastrado,)),
      );
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: widget.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Container(
          width: 500,
          padding: EdgeInsets.all(width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Gestor de senhas",
                style: Themes.titleText,
              ),
              const SizedBox(height: 30),
              
              // **CAROUSEL**
              
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        double value = 1.0;
                        if (_pageController.position.haveDimensions) {
                          value = _pageController.page! - index;
                          value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                        }
                        
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Slidecard(
                        texto: _slides[index]['texto']!,
                        svg: _slides[index]['svg']!,
                        scaleAnimation: _scaleAnimation,
                      ),
                    );
                  },
                ),
              ),
                SizedBox(height: height * 0.05),
                Wrap(
                  runSpacing: 20,
                  spacing: 20,
                  children:[
                  ElevatedButton( 
                    style: ButtonStyle(
                        minimumSize: WidgetStatePropertyAll<Size>(Size(150, 50)),

                    ),
                    onPressed: fakeSession,
                    child: const Text("Login"),
                    ),
                  ElevatedButton( 
                    style: ButtonStyle(
                      minimumSize: WidgetStatePropertyAll<Size>(Size(150, 50)),
                      backgroundColor: WidgetStatePropertyAll<Color>(ColorsApp.secondaryColor),
                    ),
                    onPressed: fakeCreateSession,
                    child: const Text("Sing up"),
                  ),
                ]
              ),
              SizedBox(height: height * 0.02),
            ],
          ),
        ),
        )
        
      ),
    );
  }

  void fakeCreateSession() {
    Navigator.pushReplacement(context, 
    MaterialPageRoute(builder: (context) => SingScreen(theme: widget.theme, updateTheme: widget.switchTheme,isFisrtTime: widget.cadastrado,)));
  }
}