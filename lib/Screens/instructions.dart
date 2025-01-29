import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final List<String> gifs = [
    'assets/images/4-VEED (1).gif',
    'assets/images/4-VEED (2).gif',
    'assets/images/4-VEED.gif',
  ];

  final List<String> texts = [
    'Maintanance Service ',
    'Car Insurance',
    ' You are not alone ',
  ];

  final List<String> welcomeTexts = [
    'Not only insurance , you can find maintanance services !',
    'Explore Unique Options Tailored to Your Needs!',
    'Amanak ia always with you !',
  ];

  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final nextIndex = _pageController.page!.round();
      if (nextIndex != _currentIndex) {
        setState(() {
          _currentIndex = nextIndex;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: gifs.length,
                    itemBuilder: (context, index) => Center(
                      child: Image.asset(
                        gifs[index],
                        height: 300,
                        width: 300,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                // Text that changes based on the current GIF
                Text(
                  texts[_currentIndex],
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                // Dynamic welcome text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    welcomeTexts[_currentIndex],
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        gifs.length,
                        (index) => Container(
                          margin: const EdgeInsets.all(4),
                          width: index == _currentIndex ? 20 : 10,
                          height: 5,
                          decoration: BoxDecoration(
                            color: index == _currentIndex ? Colors.black : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_currentIndex < gifs.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(67, 75, 213, 1)
,                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 50,
              right: 20,
              child: TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Color.fromRGBO(67, 75, 213, 1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

