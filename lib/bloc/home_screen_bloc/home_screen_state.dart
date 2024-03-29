part of 'home_screen_bloc.dart';

@immutable
abstract class HomeScreenState {}

class HomeScreenInitial extends HomeScreenState {}

class InitState extends HomeScreenState {}

class LoadingState extends HomeScreenState {}

class SuccessfulState extends HomeScreenState {}

class FailureState extends HomeScreenState {}
