import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spinningwheel/settingsscreen.dart';

class SpinScreen extends StatefulWidget {
  const SpinScreen({Key? key}) : super(key: key);

  @override
  State<SpinScreen> createState() => _SpinScreenState();
}

class _SpinScreenState extends State<SpinScreen> {
  final selected = BehaviorSubject<int>();
  String rewards = ""; // Değişen değer tipini String olarak güncelledik
  Timer? _timer;
  bool showSettings = false;

  List<String> items = [
    "100", "200", "500", "1000", "2000"
  ];

  List<double> chances = [
    0.20, 0.20, 0.20, 0.20, 0.20
  ];

  @override
  void dispose() {
    selected.close();
    _timer?.cancel();
    super.dispose();
  }

  int selectItem() {
    double randomNumber = Random().nextDouble();
    double cumulative = 0.0;
    for (int i = 0; i < chances.length; i++) {
      cumulative += chances[i];
      if (randomNumber <= cumulative) {
        return i;
      }
    }
    return chances.length - 1;
  }

  void _startTimer(BuildContext context) {
    _timer = Timer(Duration(seconds: 12), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen(items, chances, (newItems, newChances) {
          setState(() {
            items = newItems;
            chances = newChances;
          });
        })),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: GestureDetector(
        onTapDown: (_) {
          _startTimer(context);
        },
        onTapUp: (_) {
          _timer?.cancel();
        },
        child: Center(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ÇEVİR KAZAN!",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7B3AA8)
                    ),
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    height: 300,
                    child: FortuneWheel(
                      selected: selected.stream,
                      animateFirst: false,
                      items: [
                        for (int i = 0; i < items.length; i++)
                          ...<FortuneItem>[
                            FortuneItem(child: Text(items[i])),
                          ],
                      ],
                      onAnimationEnd: () {
                        setState(() {
                          rewards = items[selected.value]; // Kazanılan ödülü string olarak güncelledik
                        });
                        print(rewards);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("$rewards Kazandınız!"), // rewards değerini doğrudan metin içinde kullandık
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selected.add(selectItem());
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.purple, // Butonun rengini mor yapmak için primary parametresini kullanın
                    ),
                    child: Text("DÖNDÜR",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),),
                  ),

                  SizedBox(height: 20),
                  Text(
                    "Kazanılan: $rewards", // Kazanılan ödülü gösteren metin
                    style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF4F236C),
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              if (showSettings)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showSettings = false;
                      });
                    },
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
