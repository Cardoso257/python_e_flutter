import 'package:flutter/material.dart';

class DetalhesPage extends StatelessWidget {
  final Map<String, dynamic> voo;

  const DetalhesPage({super.key, required this.voo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do voo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: voo.entries.map((entry) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(
                  entry.key.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(entry.value?.toString() ?? 'Não informado'),
                isThreeLine: false,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}