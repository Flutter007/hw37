import 'package:flutter/material.dart';

class ListTilePhoto extends StatelessWidget {
  final String title;
  final String subtitle;
  const ListTilePhoto({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final titleLarge = Theme.of(context).textTheme.titleLarge!;

    return ListTile(
      title: Text(title, style: titleLarge),
      subtitle: Image.network(subtitle, width: 80, height: 100),
    );
  }
}
