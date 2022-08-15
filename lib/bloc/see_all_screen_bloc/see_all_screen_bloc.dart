import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/popular_movies_model.dart';
import '../../services/api_constant.dart';
import '../../services/rest_api_services.dart';

part 'see_all_screen_event.dart';
part 'see_all_screen_state.dart';

class SeeAllScreenBloc extends Bloc<SeeAllScreenEvent, SeeAllScreenState> {
  Movies? data;
  SeeAllScreenBloc() : super(SeeAllScreenInitial()) {
    on<InitEvent>((event, emit) => _init(emit));
  }

  Future<void> _init(Emitter<SeeAllScreenState> emit) async {
    emit(LoadingState());
    final _response = await RestApiServices()
        .fetchApiData(path: APIconstant.popularMoviePath);
    data = Movies.fromJson(_response.data);

    emit(InitState());
  }
}
