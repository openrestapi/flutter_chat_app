import 'package:bloc/bloc.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    // TODO: implement onTransition
    //print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    // TODO: implement onEvent
    //print(bloc.toString());
    //print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    // TODO: implement onError
    print(error);
    super.onError(bloc, error, stacktrace);
  }
}
