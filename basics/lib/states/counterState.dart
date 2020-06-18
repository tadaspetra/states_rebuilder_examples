import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class CounterState {
  int counter;

  final stream = StreamController<int>();

  Stream<int> get counterStream => stream.stream;

  CounterState({this.counter});

  void incrementCounterLocally() {
    counter++;
  }

  Future<void> retrieveCounterFromDatabase() async {
    try {
      DocumentSnapshot doc =
          await Firestore.instance.collection("data").document("1234").get();

      counter = doc.data["counter"];
    } catch (e) {
      print(e);
    }
  }

  Stream<void> streamCounterFromDatabase() {
    try {
      Stream<DocumentSnapshot> doc =
          Firestore.instance.collection("data").document("1234").snapshots();

      doc.listen((event) {
        stream.sink.add(event.data["counter"]);
      });
    } catch (e) {
      print(e);
    }
    return null;
  }

  dispose() {
    stream.close();
  }
}
