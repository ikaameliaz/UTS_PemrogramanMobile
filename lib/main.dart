import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
    );
  }
}

// Splash Page
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Timer untuk pindah otomatis ke HomePage
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/loggo.png', // Pastikan file gambar ini ada di folder assets
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}

// Home Page
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController classController = TextEditingController();

  @override
  void dispose() {
    // Jangan lupa dispose controller biar gak bocor memori
    nameController.dispose();
    classController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/loggo.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: classController,
                decoration: const InputDecoration(
                  labelText: 'Kelas',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty || classController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Isi nama dan kelas dulu ya!')),
                    );
                    return;
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TopicPage(
                        name: nameController.text,
                        className: classController.text,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Lanjut', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Topic Page
class TopicPage extends StatelessWidget {
  final String name;
  final String className;

  const TopicPage({super.key, required this.name, required this.className});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Topik'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Halo, $name dari kelas $className!',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              const Text(
                'Silahkan pilih topik kuis',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizPythonPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Pemrograman Dasar Python', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QuizCppPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Pemrograman dasar C++', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//python page
class QuizPythonPage extends StatefulWidget {
  const QuizPythonPage({super.key});

  @override
  _QuizPythonPageState createState() => _QuizPythonPageState();
}

class _QuizPythonPageState extends State<QuizPythonPage> {
  int currentQuestionIndex = 0;
  bool answered = false;
  int selectedAnswerIndex = -1;
  int remainingTime = 30; // Waktu 30 detik per soal
  late Timer _timer;

  List<Question> questions = [
    Question(
      text: 'Apa ekstensi file Python?',
      options: ['.java', '.py', '.cpp'],
      correctAnswerIndex: 1,
      explanation: 'File Python disimpan dengan ekstensi .py.',
    ),
    Question(
      text: 'Bagaimana cara mencetak teks di Python?',
      options: ['console.log()', 'printf()', 'print()'],
      correctAnswerIndex: 2,
      explanation: 'Fungsi print() digunakan untuk mencetak di Python.',
    ),
    Question(
      text: 'Tipe data untuk angka desimal di Python adalah?',
      options: ['int', 'float', 'str'],
      correctAnswerIndex: 1,
      explanation: 'float digunakan untuk bilangan desimal.',
    ),
    Question(
      text: 'Fungsi input() di Python digunakan untuk?',
      options: ['Menampilkan output', 'Mengambil input', 'Menghitung angka'],
      correctAnswerIndex: 1,
      explanation: 'input() digunakan untuk mengambil input dari user.',
    ),
    Question(
      text: 'Bagaimana komentar ditulis dalam Python?',
      options: ['//komentar', '#komentar', '/*komentar*/'],
      correctAnswerIndex: 1,
      explanation: 'Komentar di Python menggunakan tanda #.',
    ),
    Question(
      text: 'Operator logika "dan" di Python adalah?',
      options: ['and', '&&', '||'],
      correctAnswerIndex: 0,
      explanation: 'Python menggunakan "and" untuk logika DAN.',
    ),
    Question(
      text: 'Apa output dari print(2**3) di Python?',
      options: ['6', '8', '9'],
      correctAnswerIndex: 1,
      explanation: '2 pangkat 3 adalah 8.',
    ),
    Question(
      text: 'Tipe data untuk True atau False di Python adalah?',
      options: ['bool', 'int', 'float'],
      correctAnswerIndex: 0,
      explanation: 'Tipe data boolean adalah bool.',
    ),
    Question(
      text: 'Bagaimana membuat list kosong di Python?',
      options: ['list()', '[]', 'keduanya benar'],
      correctAnswerIndex: 2,
      explanation: 'list() atau [] keduanya bisa membuat list kosong.',
    ),
    Question(
      text: 'Metode append() digunakan untuk?',
      options: ['Menghapus item', 'Menambahkan item', 'Mengubah item'],
      correctAnswerIndex: 1,
      explanation: 'append() digunakan untuk menambahkan item ke list.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Mulai timer ketika halaman dibuka
    startTimer();
  }

  @override
  void dispose() {
    // Batalkan timer saat keluar halaman
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    // Reset timer
    setState(() {
      remainingTime = 30;
    });

    // Mulai timer baru
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          // Waktu habis, anggap seperti menjawab salah
          if (!answered) {
            answered = true;
            selectedAnswerIndex = -1; // Tidak ada jawaban dipilih
            _timer.cancel(); // Hentikan timer
          }
        }
      });
    });
  }

  void checkAnswer(int index) {
    if (answered) return;

    setState(() {
      selectedAnswerIndex = index;
      answered = true;
    });

    // Menyimpan jawaban user
    questions[currentQuestionIndex].userSelectedAnswer = index;

    // Hentikan timer ketika menjawab
    _timer.cancel();
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        answered = false;
        selectedAnswerIndex = -1;
      });

      // Mulai timer baru untuk pertanyaan berikutnya
      startTimer();
    } else {
      // Menghitung jawaban yang benar
      int correctAnswers = 0;
      for (var i = 0; i < questions.length; i++) {
        if (questions[i].userSelectedAnswer == questions[i].correctAnswerIndex) {
          correctAnswers++;
        }
      }

      // Navigasi ke halaman hasil
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResultPage(
            correctAnswers: correctAnswers,
            totalQuestions: questions.length,
            quizType: 'Python',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Kuis Python (${currentQuestionIndex + 1}/${questions.length})'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Timer display with animation
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: remainingTime > 10 ? Colors.blue : Colors.red,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Waktu: $remainingTime detik',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Question
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                question.text,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            // Options
            ...List.generate(question.options.length, (index) {
              // Determine colors based on whether the question has been answered
              MaterialStateProperty<Color?> backgroundColor;
              MaterialStateProperty<Color?> foregroundColor;

              if (answered) {
                // For answered state
                if (index == question.correctAnswerIndex) {
                  // Correct answer - always green
                  backgroundColor = MaterialStateProperty.resolveWith((states) => Colors.green);
                  foregroundColor = MaterialStateProperty.resolveWith((states) => Colors.white);
                } else if (index == selectedAnswerIndex) {
                  // Selected but incorrect - red
                  backgroundColor = MaterialStateProperty.resolveWith((states) => Colors.red);
                  foregroundColor = MaterialStateProperty.resolveWith((states) => Colors.white);
                } else {
                  // Other options - light gray
                  backgroundColor = MaterialStateProperty.resolveWith((states) => Colors.grey[200]);
                  foregroundColor = MaterialStateProperty.resolveWith((states) => Colors.black87);
                }
              } else {
                // For unanswered state - default blue
                backgroundColor = MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.blueAccent.shade700;
                  }
                  return Colors.blueAccent;
                });
                foregroundColor = MaterialStateProperty.resolveWith((states) => Colors.white);
              }

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    // Override disabled colors to maintain our custom colors
                    overlayColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.transparent;
                      }
                      return null;
                    }),
                  ),
                  onPressed: answered ? () {} : () => checkAnswer(index),
                  child: Text(
                    question.options[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            if (answered || remainingTime == 0)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Penjelasan:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      question.explanation,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: (answered || remainingTime == 0) ? nextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBackgroundColor: Colors.grey.shade400,
                disabledForegroundColor: Colors.white70,
              ),
              child: Text(
                currentQuestionIndex == questions.length - 1
                    ? 'Selesai'
                    : 'Soal Berikutnya',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Class Question jika belum dibuat
class Question {
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;
  int? userSelectedAnswer; // Menyimpan jawaban yang dipilih

  Question({
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
    this.userSelectedAnswer,
  });
}

// ResultPage yang sudah digabungkan untuk kedua quiz
class ResultPage extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;
  final String quizType; // Menambahkan parameter quizType untuk membedakan dari quiz mana

  const ResultPage({
    super.key,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.quizType,
  });

  @override
  Widget build(BuildContext context) {
    // Hitung persentase keberhasilan
    final double percentage = (correctAnswers / totalQuestions) * 100;
    String message;
    Color messageColor;

    // Tentukan pesan berdasarkan persentase
    if (percentage >= 80) {
      message = 'Hebat! Kamu menguasai $quizType dengan baik!';
      messageColor = Colors.green;
    } else if (percentage >= 60) {
      message = 'Bagus! Terus belajar $quizType!';
      messageColor = Colors.blue;
    } else {
      message = 'Jangan menyerah! Coba lagi ya!';
      messageColor = Colors.orange;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Kuis'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Score display
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Skor Kamu',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '$correctAnswers/$totalQuestions',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: messageColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Feedback message
              Text(
                message,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: messageColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Kembali ke TopicPage
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Kembali ke Menu'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Kembali ke halaman kuis untuk mencoba lagi
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => quizType == 'Python'
                                ? const QuizPythonPage()
                                : const QuizCppPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Ulangi Kuis'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//cpp page
class QuizCppPage extends StatefulWidget {
  const QuizCppPage({super.key});

  @override
  _QuizCppPageState createState() => _QuizCppPageState();
}

class _QuizCppPageState extends State<QuizCppPage> {
  int currentQuestionIndex = 0;
  bool answered = false;
  int selectedAnswerIndex = -1;
  int remainingTime = 30; // Waktu 30 detik per soal
  late Timer _timer;

  List<Question> questions = [
    Question(
      text: 'Ekstensi file untuk program C++ adalah?',
      options: ['.py', '.cpp', '.html'],
      correctAnswerIndex: 1,
      explanation: 'File C++ disimpan dengan ekstensi .cpp.',
    ),
    // Other questions remain the same...
    Question(
      text: 'Apa arti dari operator == di C++?',
      options: ['Assign nilai', 'Bandingkan kesamaan', 'Bandingkan lebih besar'],
      correctAnswerIndex: 1,
      explanation: 'Operator == digunakan untuk membandingkan kesamaan.',
    ),
    Question(
      text: 'Perintah untuk menampilkan output di C++?',
      options: ['cout', 'print', 'echo'],
      correctAnswerIndex: 0,
      explanation: 'cout digunakan untuk output di C++.',
    ),
    Question(
      text: 'Header file yang diperlukan untuk cout?',
      options: ['<stdio.h>', '<iostream>', '<string>'],
      correctAnswerIndex: 1,
      explanation: 'cout ada di header <iostream>.',
    ),
    Question(
      text: 'Simbol untuk akhir baris pada cout?',
      options: ['\\n', 'endl', 'end'],
      correctAnswerIndex: 1,
      explanation: 'endl digunakan untuk pindah ke baris baru di cout.',
    ),
    Question(
      text: 'Tipe data untuk angka desimal di C++ adalah?',
      options: ['int', 'float', 'char'],
      correctAnswerIndex: 1,
      explanation: 'float digunakan untuk bilangan desimal di C++.',
    ),
    Question(
      text: 'Bagaimana cara membuat komentar satu baris di C++?',
      options: ['//komentar', '#komentar', '/*komentar*/'],
      correctAnswerIndex: 0,
      explanation: 'Komentar satu baris di C++ menggunakan //. ',
    ),
    Question(
      text: 'Tipe data untuk karakter tunggal di C++?',
      options: ['char', 'string', 'bool'],
      correctAnswerIndex: 0,
      explanation: 'char digunakan untuk menyimpan karakter tunggal.',
    ),
    Question(
      text: 'Bagaimana mendeklarasikan array int berisi 5 elemen di C++?',
      options: ['int arr(5);', 'int arr[5];', 'int arr{5};'],
      correctAnswerIndex: 1,
      explanation: 'Array di C++ dideklarasikan dengan tanda [].',
    ),
    Question(
      text: 'Apa arti dari operator == di C++?',
      options: ['Assign nilai', 'Bandingkan kesamaan', 'Bandingkan lebih besar'],
      correctAnswerIndex: 1,
      explanation: 'Operator == digunakan untuk membandingkan kesamaan.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Mulai timer ketika halaman dibuka
    startTimer();
  }

  @override
  void dispose() {
    // Batalkan timer saat keluar halaman
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    // Reset timer
    setState(() {
      remainingTime = 30;
    });

    // Mulai timer baru
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          // Waktu habis, anggap seperti menjawab salah
          if (!answered) {
            answered = true;
            selectedAnswerIndex = -1; // Tidak ada jawaban dipilih
            _timer.cancel(); // Hentikan timer
          }
        }
      });
    });
  }

  void checkAnswer(int index) {
    if (answered) return;

    setState(() {
      selectedAnswerIndex = index;
      answered = true;
    });

    // Menyimpan jawaban user
    questions[currentQuestionIndex].userSelectedAnswer = index;

    // Hentikan timer ketika menjawab
    _timer.cancel();
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        answered = false;
        selectedAnswerIndex = -1;
      });

      // Mulai timer baru untuk pertanyaan berikutnya
      startTimer();
    } else {
      // Menghitung jawaban yang benar
      int correctAnswers = 0;
      for (var i = 0; i < questions.length; i++) {
        if (questions[i].userSelectedAnswer == questions[i].correctAnswerIndex) {
          correctAnswers++;
        }
      }

      // Navigasi ke halaman hasil
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ResultPage(
            correctAnswers: correctAnswers,
            totalQuestions: questions.length,
            quizType: 'C++',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Kuis C++ (${currentQuestionIndex + 1}/${questions.length})'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Timer display with animation
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: remainingTime > 10 ? Colors.blue : Colors.red,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.timer, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    'Waktu: $remainingTime detik',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Question
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                question.text,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            // Options
            ...List.generate(question.options.length, (index) {
              // Determine colors based on whether the question has been answered
              MaterialStateProperty<Color?> backgroundColor;
              MaterialStateProperty<Color?> foregroundColor;

              if (answered) {
                // For answered state
                if (index == question.correctAnswerIndex) {
                  // Correct answer - always green
                  backgroundColor = MaterialStateProperty.resolveWith((states) => Colors.green);
                  foregroundColor = MaterialStateProperty.resolveWith((states) => Colors.white);
                } else if (index == selectedAnswerIndex) {
                  // Selected but incorrect - red
                  backgroundColor = MaterialStateProperty.resolveWith((states) => Colors.red);
                  foregroundColor = MaterialStateProperty.resolveWith((states) => Colors.white);
                } else {
                  // Other options - light gray
                  backgroundColor = MaterialStateProperty.resolveWith((states) => Colors.grey[200]);
                  foregroundColor = MaterialStateProperty.resolveWith((states) => Colors.black87);
                }
              } else {
                // For unanswered state - default blue
                backgroundColor = MaterialStateProperty.resolveWith((states) {
                  if (states.contains(MaterialState.pressed)) {
                    return Colors.blueAccent.shade700;
                  }
                  return Colors.blueAccent;
                });

              }

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: backgroundColor,
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    // Override disabled colors to maintain our custom colors
                    overlayColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.transparent;
                      }
                      return null;
                    }),
                  ),
                  onPressed: answered ? () {} : () => checkAnswer(index),
                  child: Text(
                    question.options[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            if (answered || remainingTime == 0)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Penjelasan:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      question.explanation,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: (answered || remainingTime == 0) ? nextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBackgroundColor: Colors.grey.shade400,
                disabledForegroundColor: Colors.white70,
              ),
              child: Text(
                currentQuestionIndex == questions.length - 1
                    ? 'Selesai'
                    : 'Soal Berikutnya',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}