import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/genre_model.dart';
import '../../model/popular_movies_model.dart';
import '../../services/api_constant.dart';
import '../../services/rest_api_services.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  Movies? data;
  Movies? genreBasedMoviesData;
  List<bool> genreBoolean = [];
  void setSelectedGenre(int index) {
    genreBoolean.clear();
    for (var i = 0; i < Genres().genres.length; i++) {
      genreBoolean.add(false);
    }
    genreBoolean[index] = true;
  }

  int selectedGenreId() {
    if (genreBoolean.isNotEmpty) {
      int index = genreBoolean.indexOf(true);
      int genreID = Genres().genres[index].id;
      return genreID;
    } else {
      return 16;
    }
  }

  getGenres(List<int> genresID) {
    List<String> genre = [];
    for (var i = 0; i < genresID.length; i++) {
      genre.add(Genres().findGenre(genresID[i]));
    }
    return genre.join(', ');
  }

  HomeScreenBloc() : super(HomeScreenInitial()) {
    on<InitEvent>((event, emit) => _init(emit));
    on<GenreSelectionEvent>(
        ((event, emit) => _genreSelectionEvent(event, emit)));
    on<FavouriteEvent>((((event, emit) => _isFavourite(event, emit))));
  }

  Future<void> _init(Emitter<HomeScreenState> emit) async {
    emit(LoadingState());
    setSelectedGenre(0);
    final _response = await RestApiServices()
        .fetchApiData(path: APIconstant.popularMoviePath);
    data = Movies.fromJson(_response.data);
    if (data != null || data?.results != null || data!.results!.isNotEmpty) {
      for (int index = 0; index < data!.results!.length; index++) {
        data!.results![index].genre =
            getGenres(data!.results![index].genreIds!);
      }
    }
    final Movies genreBasedMovies = Movies.fromJson(_response.data);
    genreBasedMoviesData = genreBasedMovies;
    if (data != null ||
        genreBasedMoviesData?.results != null ||
        genreBasedMoviesData!.results!.isNotEmpty) {
      for (int index = 0;
          index < genreBasedMoviesData!.results!.length;
          index++) {
        genreBasedMoviesData!.results![index].genre =
            getGenres(genreBasedMoviesData!.results![index].genreIds!);
      }
    }
    emit(InitState());
  }

  _genreSelectionEvent(
      GenreSelectionEvent event, Emitter<HomeScreenState> emit) async {
    emit(LoadingState());
    setSelectedGenre(event.index);
    final _response = await RestApiServices().fetchApiData(
        id: selectedGenreId(), path: APIconstant.discoverMoviePath);
    final Movies genreBasedMovies = Movies.fromJson(_response.data);
    genreBasedMoviesData = genreBasedMovies;
    if (data != null ||
        genreBasedMoviesData?.results != null ||
        genreBasedMoviesData!.results!.isNotEmpty) {
      for (int index = 0;
          index < genreBasedMoviesData!.results!.length;
          index++) {
        genreBasedMoviesData!.results![index].genre =
            getGenres(genreBasedMoviesData!.results![index].genreIds!);
      }
    }
    emit(InitState());
  }

  _isFavourite(FavouriteEvent event, Emitter<HomeScreenState> emit) {
    event.movie.favourite = !event.movie.favourite;
    emit(InitState());
  }
}
