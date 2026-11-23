import 'package:flutter/widgets.dart';

/// Gives the widget tree access to a [ChangeNotifier] without any package.
///
/// Widgets that call [Scope.of] rebuild when the store notifies. Use
/// [Scope.read] inside callbacks (onTap, onPressed) when you only need to call
/// a method and do not want to rebuild.
class Scope<T extends ChangeNotifier> extends InheritedNotifier<T> {
  const Scope({super.key, required T store, required Widget child})
      : super(notifier: store, child: child);

  static T of<T extends ChangeNotifier>(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<Scope<T>>();
    assert(scope != null, 'No Scope<$T> found above this widget.');
    return scope!.notifier!;
  }

  static T read<T extends ChangeNotifier>(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<Scope<T>>();
    assert(scope != null, 'No Scope<$T> found above this widget.');
    return scope!.notifier!;
  }
}
