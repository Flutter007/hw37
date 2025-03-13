import 'package:flutter/material.dart';

class ListTileCustom extends StatelessWidget {
  final String title;
  final String subtitle;
  const ListTileCustom({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final titleLarge = Theme.of(context).textTheme.titleLarge!;
    final titleMedium = Theme.of(context).textTheme.titleMedium!;
    return ListTile(
      title: Text(title, style: titleLarge),
      subtitle: Text(subtitle, style: titleMedium),
    );
  }
}
