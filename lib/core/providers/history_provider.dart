import 'package:flutter/foundation.dart';
import '../models/movie.dart';

class HistoryProvider extends ChangeNotifier {
  final List<Movie> _history = [];

  List<Movie> get history => List.unmodifiable(_history);

  void add(Movie movie) {
    _history.removeWhere((m) => m.id == movie.id);
    _history.insert(0, movie);
    if (_history.length > 20) _history.removeLast();
    notifyListeners();
  }

  void clear() {
    _history.clear();
    notifyListeners();
  }
}
