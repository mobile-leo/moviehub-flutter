import 'package:flutter/foundation.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class SearchProvider extends ChangeNotifier {
  final MovieService _service;

  SearchProvider({MovieService? service}) : _service = service ?? MovieService();

  List<Movie> _results = [];
  List<Movie> get results => _results;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _query = '';
  String get query => _query;

  Future<void> search(String query) async {
    _query = query;
    if (query.trim().isEmpty) {
      _results = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _results = await _service.search(query);
    } catch (_) {
      _results = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _query = '';
    _results = [];
    notifyListeners();
  }
}
