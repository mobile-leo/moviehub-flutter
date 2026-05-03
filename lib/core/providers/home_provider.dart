import 'package:flutter/foundation.dart';
import '../models/genre.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

enum HomeTab { movies, series, myList }

class HomeProvider extends ChangeNotifier {
  final MovieService _service;

  HomeProvider({MovieService? service}) : _service = service ?? MovieService();

  HomeTab _tab = HomeTab.movies;
  HomeTab get tab => _tab;

  List<Movie> _trending = [];
  List<Movie> get trending => _trending;

  List<Movie> _upcoming = [];
  List<Movie> get upcoming => _upcoming;

  List<Movie> _popular = [];
  List<Movie> get popular => _popular;

  List<Movie> _topRated = [];
  List<Movie> get topRated => _topRated;

  List<Movie> _recommended = [];
  List<Movie> get recommended => _recommended;

  List<Genre> _genres = [];
  List<Genre> get genres => _genres;

  int? _selectedGenreId;
  int? get selectedGenreId => _selectedGenreId;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<Movie> get filteredTrending {
    if (_selectedGenreId == null) return _trending;
    return _trending.where((m) => m.genreIds.contains(_selectedGenreId)).toList();
  }

  void setTab(HomeTab tab) {
    if (_tab == tab) return;
    _tab = tab;
    notifyListeners();
    loadContent();
  }

  Future<void> selectGenre(int? genreId) async {
    _selectedGenreId = genreId;
    notifyListeners();

    if (genreId == null) {
      _recommended = [];
      notifyListeners();
      return;
    }

    try {
      _recommended = await _service.getByGenre(genreId, _tab == HomeTab.series ? 'tv' : 'movie');
      notifyListeners();
    } catch (_) {
      _recommended = [];
      notifyListeners();
    }
  }

  Future<void> loadContent() async {
    _isLoading = true;
    _error = null;
    _recommended = [];
    notifyListeners();

    try {
      if (_tab == HomeTab.series) {
        final results = await Future.wait([
          _service.getTrendingTv(),
          _service.getPopularTv(),
          _service.getTvGenres(),
        ]);
        _trending = results[0] as List<Movie>;
        _popular = results[1] as List<Movie>;
        _genres = results[2] as List<Genre>;
        _upcoming = [];
        _topRated = [];
      } else {
        final results = await Future.wait([
          _service.getTrending(),
          _service.getUpcoming(),
          _service.getPopularMovies(),
          _service.getTopRatedMovies(),
          _service.getMovieGenres(),
        ]);
        _trending = results[0] as List<Movie>;
        _upcoming = results[1] as List<Movie>;
        _popular = results[2] as List<Movie>;
        _topRated = results[3] as List<Movie>;
        _genres = results[4] as List<Genre>;
      }
      _selectedGenreId = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
