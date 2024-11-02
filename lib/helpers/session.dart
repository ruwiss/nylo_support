import 'backpack.dart';

Session session(String name) => Session(name: name);

class Session {
  String name;

  Session({required this.name});

  /// Add a value to the session
  Session add(String key, dynamic value) {
    Backpack.instance.sessionUpdate(name, key, value);
    return this;
  }

  /// Get a value from the session
  T? get<T>(String key) {
    return Backpack.instance.sessionGet<T>(name, key);
  }

  /// Delete a value from the session
  Session delete(String key) {
    Backpack.instance.sessionRemove(name, key);
    return this;
  }

  /// Clear the session
  Session flush() {
    Backpack.instance.sessionFlush(name);
    return this;
  }

  /// Clear the session
  Session clear() {
    return flush();
  }

  /// Get all the session data
  Map<String, dynamic>? data() {
    return Backpack.instance.sessionData(name);
  }
}
