import 'package:flutter/material.dart';

class ListTilePhoto extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function() onTap;
  const ListTilePhoto({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleLarge = theme.textTheme.titleLarge!;

    return Card(
      color: theme.colorScheme.inversePrimary,
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        onTap: onTap,
        title: Align(child: Text(title, style: titleLarge)),
        subtitle: Image.network(subtitle, width: 40, height: 70),
      ),
    );
  }
}
