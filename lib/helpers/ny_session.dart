import 'backpack.dart';

NySession session(String name) => NySession(name: name);

class NySession {
  String name;

  NySession({required this.name});

  /// Add a value to the session
  NySession add(String key, dynamic value) {
    Backpack.instance.sessionUpdate(name, key, value);
    return this;
  }

  /// Get a value from the session
  T? get<T>(String key) {
    return Backpack.instance.sessionGet<T>(name, key);
  }

  /// Delete a value from the session
  NySession delete(String key) {
    Backpack.instance.sessionRemove(name, key);
    return this;
  }

  /// Clear the session
  NySession flush() {
    Backpack.instance.sessionFlush(name);
    return this;
  }

  /// Clear the session
  NySession clear() {
    return flush();
  }

  /// Get all the session data
  Map<String, dynamic>? data() {
    return Backpack.instance.sessionData(name);
  }
}
