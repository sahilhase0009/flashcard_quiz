import 'package:flutter/material.dart';

void main() => runApp(const FlashcardQuizApp());

class FlashcardQuizApp extends StatelessWidget {
  const FlashcardQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flashcard Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FlashcardHomePage(),
    );
  }
}

class FlashcardHomePage extends StatefulWidget {
  const FlashcardHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FlashcardHomePageState createState() => _FlashcardHomePageState();
}

class _FlashcardHomePageState extends State<FlashcardHomePage> {
  List<Map<String, String>> flashcards = [];
  int currentIndex = 0;
  int score = 0;
  bool isQuizMode = false;

  TextEditingController questionController = TextEditingController();
  TextEditingController answerController = TextEditingController();
  TextEditingController userAnswerController = TextEditingController();

  void addFlashcard(String question, String answer) {
    setState(() {
      flashcards.add({'question': question, 'answer': answer});
    });
    questionController.clear();
    answerController.clear();
    Navigator.pop(context);
  }

  void startQuiz() {
    setState(() {
      isQuizMode = true;
      currentIndex = 0;
      score = 0;
    });
  }

  void submitAnswer() {
    String userAnswer = userAnswerController.text.trim();
    String correctAnswer = flashcards[currentIndex]['answer'] ?? '';

    if (userAnswer.toLowerCase() == correctAnswer.toLowerCase()) {
      setState(() {
        score++;
      });
    }

    userAnswerController.clear();

    if (currentIndex + 1 < flashcards.length) {
      setState(() {
        currentIndex++;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Quiz Completed'),
          content: Text('Your Score: $score/${flashcards.length}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  isQuizMode = false;
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Quiz App'),
      ),
      body: isQuizMode
          ? Container(
              child: Center(
                child: flashcards.isNotEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            flashcards[currentIndex]['question'] ?? '',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextField(
                              controller: userAnswerController,
                              decoration: const InputDecoration(
                                labelText: 'Your Answer',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: submitAnswer,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 32),
                            ),
                            child: const Text('Submit Answer',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )
                    : const Text(
                        'No flashcards available. Add some first!',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
              ),
            )
          : ListView(
              children: [
                ...flashcards.map((flashcard) {
                  return Card(
                    child: ListTile(
                      title: Text(flashcard['question'] ?? ''),
                      subtitle: Text('Answer: ${flashcard['answer']}'),
                    ),
                  );
                }),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: isQuizMode
            ? null
            : () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        left: 16.0,
                        right: 16.0,
                        top: 16.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: questionController,
                            decoration:
                                const InputDecoration(labelText: 'Question'),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: answerController,
                            decoration:
                                const InputDecoration(labelText: 'Answer'),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => addFlashcard(
                              questionController.text,
                              answerController.text,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 32),
                            ),
                            child: const Text('Add Flashcard',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent, // Button background color
              padding: const EdgeInsets.symmetric(
                  vertical: 24), // Increase vertical padding
              textStyle: const TextStyle(
                fontSize: 22, // Larger font size for better readability
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // More rounded corners
              ),
            ),
            onPressed: flashcards.isNotEmpty ? startQuiz : null,
            child: const Text(
              'Start Quiz',
              style: TextStyle(color: Colors.white), // Ensure text is white
            ),
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
