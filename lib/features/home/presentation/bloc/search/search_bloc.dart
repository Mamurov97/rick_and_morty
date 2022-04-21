// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled/core/error/failure.dart';
import 'package:untitled/features/home/domain/entities/person_entity.dart';
import 'package:untitled/features/home/domain/use_cases/search_person.dart';

part 'search_event.dart';

part 'search_state.dart';

const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHED_FAILURE_MESSAGE = 'Cache Failure';

class SearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPerson;

  SearchBloc({required this.searchPerson}) : super(PersonSearchEmpty()) {
    on<SearchPersons>(_onEvent);
  }

  FutureOr<void> _onEvent(
      SearchPersons event, Emitter<PersonSearchState> emit) async {
    emit(PersonSearchLoading());
    final failureOrPerson =
        await searchPerson(SearchPersonParams(query: event.personQuery));
    emit(failureOrPerson.fold(
        (l) => PersonSearchError(message: _mapFailureToMessage(l)),
        (r) => PersonSearchLoaded(persons: r)));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHED_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
