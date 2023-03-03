import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class IHome extends StatefulWidget {
  const IHome({super.key});

  @override
  State<IHome> createState() => _IHomeState();
}

class _IHomeState extends State<IHome> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  Timer? timer;
  Duration duration = Duration.zero;
  List<Duration> laps = [];
  int total = 0;

  bool get isStop => timer == null;
  bool get isActive => (timer != null && timer!.isActive);

  add() {
    Duration dur = Duration(milliseconds: (isActive ? total : 0) + timer!.tick);
    laps.add(dur);
    setState(() {});
  }

  start() {
    if (isStop || !isActive) {
      controller.forward();
      laps.clear();
      timer = Timer.periodic(const Duration(milliseconds: 1), (_timer) {
        duration = Duration(milliseconds: total + _timer.tick);
        print(duration);
        setState(() {});
      });
    } else {
      controller.reverse();
      pause();
    }
  }

  pause() {
    if (!isStop) {
      total += timer!.tick;
      timer!.cancel();
    }
  }

  stop() {
    if (!isStop) {
      timer!.cancel();
      timer = null;
      total = 0;
      duration = Duration.zero;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              (duration).toString(),
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView(
                children: [
                  for (var item in laps) Text(item.toString()),
                ],
                // children: laps.map((e) => Text(e.toString())).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (!isStop)
                  IconButton(
                      onPressed: () {
                        stop();
                      },
                      icon: Icon(Icons.stop)),
                IconButton(
                    onPressed: () {
                      start();
                    },
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.play_pause,
                      progress: animation,
                    )),
                if (!isStop)
                  IconButton(
                      onPressed: () {
                        add();
                      },
                      icon: Icon(Icons.flag)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
