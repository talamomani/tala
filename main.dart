import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DownloadExamplePage(),
  ));
}

class DownloadExamplePage extends StatefulWidget {
  const DownloadExamplePage({super.key});

  @override
  State<DownloadExamplePage> createState() => _DownloadExamplePageState();
}

class _DownloadExamplePageState extends State<DownloadExamplePage> {
  double progress = 0.0;
  bool isDownloading = false;
  bool isDone = false;

  void startDownload() {
    setState(() {
      isDownloading = true;
      isDone = false;
      progress = 0.0;
    });
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      if (progress >= 1.0) {
        setState(() {
          isDownloading = false;
          isDone = true;
        });
        return false;
      }
      setState(() {
        progress += 0.1;
      });
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Download')),
      body: Center(
        child: isDone
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.download_done, size: 60, color: Colors.green),
                  SizedBox(height: 20),
                  Text('Download Completed', style: TextStyle(fontSize: 20)),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LinearProgressIndicator(value: isDownloading ? progress : 0.0),
                  const SizedBox(height: 20),
                  Text('${(progress * 100).toStringAsFixed(0)}%'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isDownloading ? null : startDownload,
                    child: const Text('Start Download'),
                  ),
                ],
              ),
      ),
    );
  }
}