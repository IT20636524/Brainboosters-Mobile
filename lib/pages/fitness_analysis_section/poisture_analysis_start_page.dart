import 'package:flutter/material.dart';

class PoistureAnalysisStartPage extends StatefulWidget {
  static String routeName = "/poistureAnalysisStartPage";

  @override
  State<PoistureAnalysisStartPage> createState() => _PoistureAnalysisStartPageState();
}

class _PoistureAnalysisStartPageState extends State<PoistureAnalysisStartPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.deepPurpleAccent, Colors.purple],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              Image.asset(
                "assets/images/poisture.png",
              ),
              const SizedBox(height: 20),
              Text(
                "Welcome to the",
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 18,
                ),
              ),
              Text(
                "Poisture Analysis",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Do you want to analyze your posture?",
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/fitnessAnalysisStart");
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    alignment: Alignment.center,
                    width: size.width - 100,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
