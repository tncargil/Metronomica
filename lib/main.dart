import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:metronome/metronome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          sizeConstraints: BoxConstraints.tightFor(
            width: 70,
            height: 70,
          ),
        ),
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        scaffoldBackgroundColor: Colors.black,
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0x670101)),
        //useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Metronomica'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final metronome = Metronome();
  final player = AudioPlayer();
  int bpm = 120;
  int incrementAmount = 5;
  bool isPlaying = false;
  double tuningValue = 0.0;

  void playMetronome() {
    metronome.play(120);
  }

  void playSoundThingy() async {
    await player.play(AssetSource("click.mp3"));
    //await SystemSound.play(SystemSoundType.click);
  }

  void checkTuning() {

  } 

  void updateBpm(int tempoChangeAmount) {
    bpm += tempoChangeAmount;
    metronome.setBPM(bpm);
    setState(() {
    });
  }

  @override
  void dispose() {
    metronome.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    metronome.init(
      'assets/snare44_wav.wav',
      bpm: 120,
      volume: 50,
      enableTickCallback: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Colors.black,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 250),
                Text(
                  bpm.round().toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 40),
                ),
                const SizedBox(height: 20),
                Slider(
                  value: bpm.toDouble(),
                  max: 300,
                  divisions: 300,
                  onChangeEnd: (value) {
                    metronome.setBPM(bpm);
                  },
                  onChanged: (value) {
                    bpm = value.toInt();
                    setState(() {});
                  },
                ),
                const SizedBox(height: 40),
                FloatingActionButton(
                  onPressed: () async {
                    if (isPlaying) {
                      metronome.pause();
                    } else {
                      metronome.play(bpm);
                    }
                    setState(() {
                      isPlaying = !isPlaying;
                    });
                  },
                  enableFeedback: false,
                  tooltip: 'Play',
                  child: const Icon(Icons.play_arrow),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () {
                        updateBpm(incrementAmount);
                      },
                      enableFeedback: false,
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () {
                        updateBpm(-incrementAmount);
                      },
                      enableFeedback: false,
                      child: const Icon(Icons.remove),
                    ),
                  ],
                ),
                const SizedBox(height: 90),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          if (incrementAmount == 5) {
                            incrementAmount = 10;
                          } else if (incrementAmount == 10) {
                            incrementAmount = 1;
                          } else if (incrementAmount == 1) {
                            incrementAmount = 5;
                          }
                        });
                      },
                      enableFeedback: false,
                      child: Text(incrementAmount.toString()),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: ElevatedButton(
              onPressed: () {
                checkTuning();
              },
              child: const Icon(Icons.music_note),
            ),
          ),
        ],
      ),
    );
  }
}
