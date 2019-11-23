import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(home: PhysicsCardDragDemo()),
    );

class PhysicsCardDragDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PhysicsCardDragDemo")),
      body: DraggableCard(
        child: FlutterLogo(
          size: 128,
        ),
      ),
    );
  }
}

class DraggableCard extends StatefulWidget {
  final Widget child;
  DraggableCard({this.child});

  @override
  State<StatefulWidget> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Alignment _dragAlignment = Alignment.center;
  Animation<Alignment> _animation;

  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runAnimation() {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    print("build: _dragAlignment: $_dragAlignment");
    final align = Align(
      alignment: _dragAlignment,
      child: Card(
        child: widget.child,
      ),
    );

    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanDown: (details) {
        _controller.stop();
      },
      onPanUpdate: (details) {
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2),
            details.delta.dy / (size.width / 2),
          );
        });
      },
      onPanEnd: (details) {
        _runAnimation();
      },
      child: align,
    );
  }
}
