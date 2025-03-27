import 'package:flutter/material.dart';

class ListTileCustom extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function() onTap;
  const ListTileCustom({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final titleLarge = Theme.of(context).textTheme.titleLarge!;
    final titleMedium = Theme.of(context).textTheme.titleMedium!;
    return ListTile(
      onTap: onTap,
      title: Text(title, style: titleLarge),
      subtitle: Text(subtitle, style: titleMedium),
    );
  }
}
