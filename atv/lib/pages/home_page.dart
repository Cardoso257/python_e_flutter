import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/voo_provider.dart';
import 'detalhes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _aeroportoController = TextEditingController(text: 'SBGR');
  String _tipoSelecionado = 'todos';

  @override
  void initState() {
    super.initState();
    // Busca inicial ao abrir a tela
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buscar();
    });
  }

  void _buscar() {
    final aeroporto = _aeroportoController.text.trim().toUpperCase();
    if (aeroporto.isNotEmpty) {
      Provider.of<VooProvider>(context, listen: false)
          .buscarVoos(aeroporto: aeroporto, tipo: _tipoSelecionado);
    }
  }

  @override
  void dispose() {
    _aeroportoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de Voos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de busca por Aeroporto (Parte 4)
            TextField(
              controller: _aeroportoController,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _buscar(),
              decoration: InputDecoration(
                labelText: 'Aeroporto (código ICAO)',
                hintText: 'Ex.: SBGR ou SBSP',
                prefixIcon: const Icon(Icons.flight),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _buscar,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Filtro por Tipo de Voo (Parte 5)
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'chegadas', label: Text('Chegadas')),
                ButtonSegment(value: 'partidas', label: Text('Partidas')),
                ButtonSegment(value: 'todos', label: Text('Todos')),
              ],
              selected: {_tipoSelecionado},
              onSelectionChanged: (newSelection) {
                setState(() {
                  _tipoSelecionado = newSelection.first;
                });
                _buscar();
              },
            ),
            const SizedBox(height: 20),

            // Exibição dos dados consumindo o Provider
            Expanded(
              child: Consumer<VooProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.errorMessage.isNotEmpty) {
                    return Center(child: Text(provider.errorMessage));
                  }

                  if (provider.voos.isEmpty) {
                    return const Center(child: Text('Nenhum voo encontrado.'));
                  }

                  return ListView.builder(
                    itemCount: provider.voos.length,
                    itemBuilder: (context, index) {
                      final voo = provider.voos[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          leading: const CircleAvatar(
                            child: Icon(Icons.airplanemode_active),
                          ),
                          title: Text(
                            voo['voo'] ?? voo['identificacao'] ?? 'Voo sem nome',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('Origem/Destino: ${voo['origem_destino'] ?? voo['origem'] ?? 'N/A'}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // Navegação para a Tela de Detalhes
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalhesPage(voo: voo),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}