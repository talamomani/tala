import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
void main(){
  runApp(myapp());

}
class myapp extends StatelessWidget{
  const myapp({super.key});


@override 
Widget build(BuildContext context){
  return MaterialApp(
    home: Scaffold(
      body: progressapp(),

    ),
  );
}
}
class progressapp extends StatelessWidget{
  const progressapp({super.key});
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: Colors.red,
      strokeWidth: 15,
    );

  }
}

