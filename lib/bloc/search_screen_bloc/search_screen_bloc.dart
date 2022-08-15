import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/popular_movies_model.dart';
import '../../services/api_constant.dart';
import '../../services/rest_api_services.dart';

part 'search_screen_event.dart';
part 'search_screen_state.dart';

class SearchScreenBloc extends Bloc<SearchScreenEvent, SearchScreenState> {
  Movies? searchMovies;
  String seachText = "";
  SearchScreenBloc() : super(SearchScreenInitial()) {
    on<InitEvent>((event, emit) => _init(emit));
  }

  Future<void> _init(Emitter<SearchScreenState> emit) async {
    emit(LoadingState());
    final _response = await RestApiServices().fetchApiData(
        path: APIconstant.searchMoviePath,
        text: seachText == '' ? seachText = 'a' : seachText);
    searchMovies = Movies.fromJson(_response.data);

    emit(InitState());
  }
}
