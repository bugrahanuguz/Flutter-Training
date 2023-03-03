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
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightBlue),
                    borderRadius: BorderRadius.circular(15)),
                child: ListView.builder(
                  itemCount: laps.length,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.all(2),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.lightBlue)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${index + 1}"),
                        SizedBox(
                          width: 10,
                        ),
                        Text("${laps[index]}"),
                        Icon(Icons.arrow_forward)
                      ],
                    ),
                  ),
                  // children: laps.map((e) => Text(e.toString())).toList(),
                ),
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
