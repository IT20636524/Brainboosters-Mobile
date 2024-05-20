import 'package:flutter/material.dart';


class ChildrenGamesStartPage extends StatelessWidget {
  static String routeName = "/childrenGamesPage";

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
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  "assets/images/puzz.png", // Placeholder image path
                  width: size.width * 0.8, // Adjust width as needed
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Children Games", // Title
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Fun and educational games for children of all ages.", // Description
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => LevelsPage(difficultyFactor: 1, additionalTasks: sampleGames,), // Update with your actual parameters
                    //   ),
                    // );
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
                      "Get Started", // Button text
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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

// class LevelsPage extends StatelessWidget {
//   final int difficultyFactor;
//   final List<String> additionalTasks;
//
//   LevelsPage({required this.difficultyFactor, required this.additionalTasks});
//
//   @override
//   Widget build(BuildContext context) {
//     // Implementation of LevelsPage
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Levels"),
//       ),
//       body: Center(
//         child: Text("Levels Page"),
//       ),
//     );
//   }
// }
