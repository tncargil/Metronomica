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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        scaffoldBackgroundColor: Colors.grey,
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
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
  bool isPlaying = false;
  void playMetronome() {
    metronome.play(120);
  }

  void playSoundThingy() async {
    await player.play(AssetSource("click.mp3"));
    //await SystemSound.play(SystemSoundType.click);
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Colors.black,

        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        //TextButton(style: TextButton(onPressed: (){bpm += 5}, child: Text('+')));
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "ebug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          SizedBox(height: 280),
            Text(
              bpm.round().toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          SizedBox(height: 10),
            Slider(
              value: bpm.toDouble(),
              max: 300,
              divisions: 300,
              onChangeEnd: (value) {
                metronome.setBPM(bpm);
              },
              onChanged: (value) {
                bpm = value.toInt();
                setState(() {
                });
              },
            ),
            SizedBox(height: 30),
            FloatingActionButton(
              
              onPressed: () async {
                if(isPlaying) {
                metronome.pause();
              } else {
                metronome.play(bpm);
              }
                isPlaying = !isPlaying; 
              },
              enableFeedback: false,
              tooltip: 'Play',
              child: const Icon(Icons.play_arrow),
            ), // 
            const Spacer(),
            Row(        
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[ 
                FloatingActionButton(onPressed: ()
                {
                    updateBpm(5);
                  },
                  enableFeedback: false,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(        
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[ 
                FloatingActionButton(onPressed: ()
                {
                    updateBpm(-5);
                  },
                  enableFeedback: false,
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          SizedBox(height: 200),
         ],
        ),
      ),
//This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
