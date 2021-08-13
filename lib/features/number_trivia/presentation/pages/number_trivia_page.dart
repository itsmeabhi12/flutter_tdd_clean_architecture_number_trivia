import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/bloc/number_trivia_event.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/bloc/number_trivia_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Trivia'),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: BlocBuilder<NumberTriviaBLoc, NumberTriviaState>(
              builder: (context, state) {
                if (state is Empty) {
                  return DisplayWidget(
                    message: 'Start Searching',
                  );
                }
                if (state is Loading) {
                  return LoadingWIdget();
                }
                if (state is Error) {
                  return DisplayWidget(message: state.message);
                }
                if (state is Loaded) {
                  return DisplayTrivia(
                    state: state,
                  );
                }

                return null;
              },
            ),
          ),
          TriviaController()
        ],
      ),
    );
  }
}

class TriviaController extends StatefulWidget {
  const TriviaController({
    Key key,
  }) : super(key: key);

  @override
  _TriviaControllerState createState() => _TriviaControllerState();
}

class _TriviaControllerState extends State<TriviaController> {
  String numberStr;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (v) {
                numberStr = v;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 25,
              ),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<NumberTriviaBLoc>(context)
                            .add(GetConcreteNumberTriviaEvent(numberStr));
                      },
                      child: Text('Get Trivia'))),
              SizedBox(
                width: 50,
              ),
              Expanded(
                child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<NumberTriviaBLoc>(context)
                          .add(GetRandomNumberTriviaEvent());
                    },
                    child: Text('Radnom Trivia')),
              ),
              SizedBox(
                width: 25,
              )
            ],
          )
        ],
      ),
    );
  }
}

class DisplayTrivia extends StatelessWidget {
  final Loaded state;
  const DisplayTrivia({
    this.state,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          state.numberTrivia.number.toString(),
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Expanded(
            child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                state.numberTrivia.text,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ))
      ],
    );
  }
}

class LoadingWIdget extends StatelessWidget {
  const LoadingWIdget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class DisplayWidget extends StatelessWidget {
  final String message;
  const DisplayWidget({
    @required this.message,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
