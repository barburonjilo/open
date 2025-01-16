adb -s emulator-5554 emu kill; adb -s localhost:5555 emu kill; adb devices | grep -q 'emulator' || echo "Emulator sudah dihentikan"; ps aux | grep -i 'qemu-system-x86_64' | grep -v grep | awk '{print $2}' | xargs kill -9; ps aux | grep -i 'emulator' | grep -v grep | awk '{print $2}' | xargs kill -9; flutter emulators --kill; adb shell am force-stop com.android.launcher; clear

cat > lib/main.dart << "END"
import 'package:flutter/material.dart';
import 'dart:html' as html; // Untuk fungsi refresh halaman di web
import 'dart:async'; // Untuk timer

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tinggal Ngopi , Mantap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white, // Latar belakang putih solid
      ),
      home: const AutoRefreshPage(),
    );
  }
}

class AutoRefreshPage extends StatefulWidget {
  const AutoRefreshPage({super.key});

  @override
  _AutoRefreshPageState createState() => _AutoRefreshPageState();
}

class _AutoRefreshPageState extends State<AutoRefreshPage> {
  // Waktu countdown dalam jam (misalnya 1 jam)
  int _counterInHours = 1; 
  late double _counter; // Variabel untuk menghitung waktu dalam jam
  late Timer _timer;

  // Variabel untuk menghitung waktu yang sudah berjalan
  int _elapsedHours = 0; // Jam yang sudah berlalu

  @override
  void initState() {
    super.initState();
    _counter = _counterInHours.toDouble(); // Mengonversi jam ke tipe double untuk perhitungan
    // Timer untuk countdown setiap jam
    _timer = Timer.periodic(const Duration(hours: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter -= 1; // Mengurangi waktu per jam
          _elapsedHours += 1; // Menambahkan jam yang sudah berlalu
        });
      } else {
        _timer.cancel();
        _refreshPage(); // Panggil refresh ketika countdown selesai
      }
    });
  }

  // Fungsi untuk refresh halaman
  void _refreshPage() {
    setState(() {
      // Pesan sebelum halaman di-refresh
    });
    html.window.location.reload(); // Refresh halaman
  }

  // Fungsi untuk menampilkan countdown dalam format jam
  String _getTimeString() {
    int hours = _counter.floor(); // Jam
    return '$hours jam'; // Menampilkan jam saja
  }

  // Fungsi untuk menampilkan jam yang sudah berlalu
  String _getElapsedTime() {
    return 'Sudah berjalan $_elapsedHours jam'; // Menampilkan jam yang sudah berlalu
  }

  @override
  void dispose() {
    _timer.cancel(); // Membatalkan timer ketika widget dihancurkan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wolu, Mantap !!!! (${_getElapsedTime()} | Refresh: ${_getTimeString()})'), // Menampilkan waktu yang sudah berlalu dan countdown di title
        backgroundColor: Colors.blue, // Menggunakan warna solid biru untuk AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Mengubah alignment ke atas
          children: <Widget>[
            // Menampilkan countdown waktu yang tersisa
            Text(
              _getTimeString(),
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.red), // Warna teks merah solid
            ),
            const SizedBox(height: 20), // Memberikan jarak antar elemen

            const Text(
              'Ngopi.Dulu..',
              style: TextStyle(fontSize: 20, color: Colors.black), // Teks hitam
            ),
          ],
        ),
      ),
    );
  }
}

END

clear

cat > .idx/dev.nix << "END"
# wolu
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "stable-24.05"; # or "unstable"
  packages = [
    pkgs.jdk17
    pkgs.unzip
  ];
  # Sets environment variables in the workspace
  env = {};
  idx = {
    extensions = [
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
    ];
    workspace = {
      # Runs when a workspace is first created with this `dev.nix` file
      onCreate = {
        build-flutter = ''
          cd /home/user/myapp/android

          ./gradlew \
            --parallel \
            -Pverbose=true \
            -Pdart-defines=RkxVVFRFUl9XRUJfQ0FOVkFTS0lUX1VSTD1odHRwczovL3d3dy5nc3RhdGljLmNvbS9mbHV0dGVyLWNhbnZhc2tpdC85NzU1MDkwN2I3MGY0ZjNiMzI4YjZjMTYwMGRmMjFmYWMxYTE4ODlhLw== \
            -Pdart-obfuscation=false \
            -Ptrack-widget-creation=true \
            -Ptree-shake-icons=false \
            -Pfilesystem-scheme=org-dartlang-root \
            assembleDebug
        '';
      };
      
      # To run something each time the workspace is (re)started, use the `onStart` hook
    };
    # Enable previews and customize configuration
    previews = {
      enable = true;
      previews = {
        web = {
          command = ["flutter" "run" "--machine" "-d" "web-server" "--web-hostname" "0.0.0.0" "--web-port" "$PORT"];
          manager = "flutter";
        };
      };
    };
  };
}

END


clear
