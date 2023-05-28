import 'dart:async';

import 'package:flutter_app/features/tv_remote/remote_event.dart';
import 'package:flutter_app/features/tv_remote/remote_state.dart';

class RemoteBloc {
  var state = RemoteState(70);

  final eventController = StreamController<RemoteEvent>();

  final stateController = StreamController<RemoteState>();

  RemoteBloc() {
    eventController.stream.listen((event) {
      if (event is IncrementEvent) {
        state = RemoteState(state.volume + event.increment);
      } else if (event is DecrementEvent) {
        state = RemoteState(state.volume - event.decrement);
      } else if (event is MutedEvent) {
        state = RemoteState(0);
      } else if (event is UnmutedEvent) {

      }

      stateController.sink.add(state);
    });
  }
}