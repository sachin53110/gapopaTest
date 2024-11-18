// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Dock(
//             items: const [
//               Icons.person,
//               Icons.message,
//               Icons.call,
//               Icons.camera,
//               Icons.photo,
//             ],
//             builder: (e) {
//               return Container(
//                 constraints: const BoxConstraints(minWidth: 48),
//                 height: 48,
//                 margin: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.primaries[e.hashCode % Colors.primaries.length],
//                 ),
//                 child: Center(child: Icon(e, color: Colors.white)),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// class Dock<T> extends StatefulWidget {
//   const Dock({
//     super.key,
//     required this.items,
//     required this.builder,
//   });
//
//   final List<T> items;
//
//   final Widget Function(T) builder;
//
//   @override
//   State<Dock<T>> createState() => _DockState<T>();
// }
//
// class _DockState<T> extends State<Dock<T>> {
//   late List<T> _items = widget.items.toList();
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height:80,
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         color: Colors.black12,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: ReorderableListView(
//         scrollDirection: Axis.horizontal,
//         onReorder: _onReorder,
//         children: _items
//             .asMap()
//             .entries
//             .map(
//               (entry) => AnimatedContainer(
//
//             key: ValueKey(entry.key),
//             duration: const Duration(milliseconds: 200),
//             curve: Curves.easeInOut,
//             margin: const EdgeInsets.symmetric(horizontal: 8),
//             child: widget.builder(entry.value),
//           ),
//         )
//             .toList(),
//       ),
//     );
//   }
//
//   void _onReorder(int oldIndex, int newIndex) {
//     setState(() {
//       if (newIndex > oldIndex) {
//         newIndex -= 1;
//       }
//       final item = _items.removeAt(oldIndex);
//       _items.insert(newIndex, item);
//     });
//   }
// }
//

import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (e) {
              return Container(
                constraints: const BoxConstraints(minWidth: 48),
                height: 48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.primaries[e.hashCode % Colors.primaries.length],
                ),
                child: Center(child: Icon(e, color: Colors.white)),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();

  /// Index of the currently dragged item.
  int? _draggingIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_items.length, (index) {
          // Add a placeholder when dragging
          if (_draggingIndex == index) {
            return SizedBox(
              width: 48,
              height: 48,
              child: const Opacity(opacity: 0),
            );
          }

          return DragTarget<int>(
            onWillAccept: (fromIndex) => fromIndex != index,
            onAccept: (fromIndex) {
              setState(() {
                final item = _items.removeAt(fromIndex);
                _items.insert(index, item);
              });
            },
            builder: (context, candidateData, rejectedData) {
              return LongPressDraggable<int>(
                data: index,
                dragAnchorStrategy: pointerDragAnchorStrategy,
                onDragStarted: () {
                  setState(() {
                    _draggingIndex = index;
                  });
                },
                onDragEnd: (details) {
                  setState(() {
                    _draggingIndex = null;
                  });
                },
                onDraggableCanceled: (velocity, offset) {
                  // Reset the dragging index if not dropped on a target
                  setState(() {
                    _draggingIndex = null;
                  });
                },
                feedback: Opacity(
                  opacity: 0.8,
                  child: widget.builder(_items[index]),
                ),
                childWhenDragging: const SizedBox.shrink(),
                child: widget.builder(_items[index]),
              );
            },
          );
        }),
      ),
    );
  }
}
