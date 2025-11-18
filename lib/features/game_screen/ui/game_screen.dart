

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mercypharma/core/constant/app_colors.dart';

import '../data/images_map.dart';

class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({super.key});

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> with TickerProviderStateMixin {
  late List<_CardModel> cards;
  _CardModel? firstPick;
  _CardModel? secondPick;
  bool wait = false;
  int timeLeft = 90;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    initGame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showFirstTimeDialog();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void initGame(){
    timeLeft = 90;
    timer?.cancel();


    List<String> images = [
      'assets/images/1.png',
      'assets/images/2.png',
      'assets/images/3.png',
      'assets/images/4.png',
      'assets/images/5.png',
      'assets/images/6.png',
      'assets/images/7.png',
      'assets/images/8.png',
      'assets/images/9.png',
    ];

    cards = [];
    for (var img in images) {
      cards.add(_CardModel(image: img));
      cards.add(_CardModel(image: img));
    }

    cards.shuffle(Random());
    firstPick = null;
    secondPick = null;
    wait = false;
    setState(() {});
  }

  void _startGame({bool isRestart = false}) {
    if(isRestart){
      initGame();
    }
    _startTimer();
    setState(() {});
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft == 1) {
        t.cancel();
        _showLoseDialog();
      }
      setState(() => timeLeft--);
    });
  }

  void _onCardTap(_CardModel card) async {
    if (wait || card.isSolved || card.isFlipped) return;

    setState(() => card.isFlipped = true);

    if (firstPick == null) {
      firstPick = card;
    } else {
      secondPick = card;
      wait = true;

      await Future.delayed(const Duration(milliseconds: 800));

      if (firstPick!.image == secondPick!.image) {
        firstPick!.isSolved = true;
        secondPick!.isSolved = true;
      } else {
        firstPick!.isFlipped = false;
        secondPick!.isFlipped = false;
      }

      firstPick = null;
      secondPick = null;
      wait = false;

      if (cards.every((c) => c.isSolved)) {
        timer?.cancel();
        _showWinDialog();
      }
      setState(() {});
    }
  }

  void _showFirstTimeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.gradient, // same app gradient
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🎮 مرحباً بك!',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'هيا بنا نلعب! 🕹️\nابحث عن الصور المتشابهة بأسرع وقت ممكن لتفوز!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 25),

                // Start Game Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryColor,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _startGame();
                  },
                  child: const Text(
                    'ابدأ اللعب 🚀',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.gradient, // SAME APP GRADIENT
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🎉 مبروووك!',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'لقد وجدت جميع الصور المتشابهة!👏',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 25),

                // Re-Play Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryColor,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _startGame(isRestart: true);
                  },
                  child: const Text(
                    'إعادة اللعب 🔁',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLoseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.gradient, // same smooth blue gradient
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '⏳ لقد خسرت!',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'انتهى الوقت قبل إيجاد كل الصور 😢',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 25),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryColor,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _startGame(isRestart: true);
                  },
                  child: const Text(
                    'إعادة اللعب 🔁',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "Mercypharma",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 5,
        backgroundColor: AppColors.primaryColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.gradient,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                'الوقت المتبقي: $timeLeft ثانية',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: cards.length,
                  itemBuilder: (context, i) {
                    return _MemoryCard(
                      card: cards[i],
                      onTap: () => _onCardTap(cards[i]),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardModel {
  final String image;
  bool isFlipped;
  bool isSolved;

  _CardModel({required this.image, this.isFlipped = false, this.isSolved = false});
}

class _MemoryCard extends StatefulWidget {
  final _CardModel card;
  final VoidCallback onTap;

  const _MemoryCard({required this.card, required this.onTap});

  @override
  State<_MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<_MemoryCard> {
  double tiltX = 0;
  double tiltY = 0;

  void _resetTilt() {
    setState(() {
      tiltX = 0;
      tiltY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (event) {
        setState(() {
          tiltX = (event.localPosition.dy - 50) / 200;
          tiltY = (event.localPosition.dx - 50) / -200;
        });
      },
      onPointerUp: (_) => _resetTilt(),
      onPointerCancel: (_) => _resetTilt(),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(tiltX)
            ..rotateY(tiltY)
            ..scale(1 + (tiltX.abs() + tiltY.abs()) / 4),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, anim) {
              final rotate = Tween(begin: pi, end: 0.0).animate(
                CurvedAnimation(parent: anim, curve: Curves.easeInOut),
              );

              return AnimatedBuilder(
                animation: rotate,
                builder: (_, __) {
                  final isUnder = (child.key != ValueKey(widget.card.isFlipped));
                  final value = isUnder ? min(rotate.value, pi / 2) : rotate.value;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(value),
                    child: child,
                  );
                },
                child: child,
              );
            },
            child: widget.card.isFlipped || widget.card.isSolved
                ? _front()
                : _back(),
          ),
        ),
      ),
    );
  }

  Widget _back() {
    return Container(
      key: const ValueKey('back'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyColor, width: 2),
        image: const DecorationImage(
          image: AssetImage('assets/icons/logo2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }


  Widget _front() {
    return Container(
      key: const ValueKey('front'),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.redColor, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Image.asset(
                widget.card.image,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Text(
            getImageName(widget.card.image) ?? '',
            style: const TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }


  String? getImageName(String imagePath) {
    final number = extractImageNumber(imagePath);
    return imagesNames[number.toString()];
  }

  int extractImageNumber(String path) {
    final fileName = path.split('/').last;
    final nameOnly = fileName.split('.').first;
    return int.tryParse(nameOnly) ?? 0;
  }

}

class RotationYTransition extends AnimatedWidget {
  final Widget child;

  const RotationYTransition({super.key, required Animation<double> turns, required this.child})
      : super(listenable: turns);

  @override
  Widget build(BuildContext context) {
    final anim = listenable as Animation<double>;
    final angle = anim.value * 3.1416;

    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(angle),
      alignment: Alignment.center,
      child: child,
    );
  }
}
