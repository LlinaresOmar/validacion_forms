import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {

  final Widget child;

  const AuthBackground({super.key, required this.child});
  

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          PurpleBox(),
          _HeaderIcon(),
          this.child,
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: 
      Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: 30),
        child: Icon(
          Icons.person_pin,
           color: Colors.white,
           size: 250.0,
          ),
      )
    );
  }
}

class PurpleBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: _purpleBackground(),
      child: Stack(
        children: [
          Positioned(top: 80, left: 30, child: _Bubble()),
          Positioned(top: -20, left: 300, child: _Bubble()),
          Positioned(top: 250, left: -10, child: _Bubble()),
          Positioned(top: 160, left: 280, child: _Bubble()),
          Positioned(top: 290, left: 300, child: _Bubble()),
        ],
      ),
    );
  }

  BoxDecoration _purpleBackground() {
    return BoxDecoration(
        gradient: LinearGradient(colors: [
      Color.fromRGBO(63, 63, 165, 1.0),
      Color.fromRGBO(90, 70, 178, 1.0)
    ]));
  }
}

class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 0.05),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}