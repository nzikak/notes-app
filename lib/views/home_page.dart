import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/services/auth/auth_service.dart';
import 'package:notes_app/views/login_view.dart';
import 'package:notes_app/views/notes/note_view.dart';
import 'package:notes_app/views/verify_email_view.dart';

//
// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return getCurrentScreen();
//   }
//
//   Widget getCurrentScreen() {
//     final user = AuthService.firebase().currentUser;
//     if(user != null) {
//       if(user.isEmailVerified) {
//         return const NotesView();
//       } else {
//         return const VerifyEmail();
//       }
//     } else {
//       return const LoginView();
//     }
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CounterBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Counter App"),
          centerTitle: true,
        ),
        body: BlocConsumer<CounterBloc, CounterState>(
          listener: (context, counterState) {
            _controller.clear();
          },
          builder: (context, counterState) {
            final value =
                counterState is CounterStateInvalid ? counterState.value : "";

            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Current value is ${counterState.value}"),
                  const SizedBox(height: 10),
                  Visibility(
                    child: Text("Invalid input: $value"),
                    visible: counterState is CounterStateInvalid,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(hintText: "Enter a number here"),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          final counterBloc = context.read<CounterBloc>();
                          counterBloc.add(DecrementEvent(_controller.text));
                        },
                        child: const Text("Minus"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final counterBloc = context.read<CounterBloc>();
                          counterBloc.add(IncrementEvent(_controller.text));
                        },
                        child: const Text("Add"),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

@immutable
abstract class CounterState {
  final int value;

  const CounterState(this.value);
}

class CounterStateValid extends CounterState {
  const CounterStateValid(int value) : super(value);
}

class CounterStateInvalid extends CounterState {
  final String invalidValue;

  const CounterStateInvalid({
    required this.invalidValue,
    required int previousValue,
  }) : super(previousValue);
}

@immutable
abstract class CounterEvent {
  final String value;

  const CounterEvent(this.value);
}

class IncrementEvent extends CounterEvent {
  const IncrementEvent(String value) : super(value);
}

class DecrementEvent extends CounterEvent {
  const DecrementEvent(String value) : super(value);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(const CounterStateValid(0)) {
    on<IncrementEvent>((event, emit) {
      final number = int.tryParse(event.value);
      if (number == null) {
        emit(CounterStateInvalid(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(CounterStateValid(state.value + number));
      }
    });

    on<DecrementEvent>((event, emit) {
      final number = int.tryParse(event.value);
      if (number == null) {
        emit(CounterStateInvalid(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(CounterStateValid(state.value - number));
      }
    });
  }
}
