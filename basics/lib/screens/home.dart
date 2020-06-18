import 'package:flutter/material.dart';
import 'package:reference/states/counterState.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Injector(
          inject: <Injectable>[
            Inject(() => CounterState(counter: 1)),
            Inject.stream(() => Injector.get<CounterState>().counterStream,
                name: "counterStream")
          ],
          builder: (BuildContext context) {
            final ReactiveModel<CounterState> counterState =
                Injector.getAsReactive<CounterState>();
            final counterStream =
                Injector.getAsReactive<int>(name: "counterStream");

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "States_Rebuilder\nBasics",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 100),
                StateBuilder(
                  observeMany: [
                    () => counterState,
                    () => counterStream,
                  ],
                  builder: (context, _) {
                    return Column(
                      children: <Widget>[
                        Text("Local State: " +
                            counterState.state.counter.toString()),
                        Text(
                            "Streamed Value: " + counterStream.state.toString())
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  child: Text("Increment"),
                  onPressed: () =>
                      counterState.setState((s) => s.incrementCounterLocally()),
                ),
                RaisedButton(
                  child: Text("Retrieve Future"),
                  onPressed: () => counterState
                      .setState((s) => s.retrieveCounterFromDatabase()),
                ),
                RaisedButton(
                  child: Text("Start Stream"),
                  onPressed: () => counterState
                      .setState((s) => s.streamCounterFromDatabase()),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
