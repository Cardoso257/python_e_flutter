import 'package:flutter/material.dart';
import '../services/voo_service.dart';

class VooProvider extends ChangeNotifier {
  // Instância do serviço HTTP
  final VooService _vooService = VooService();

  // Variáveis de estado
  List<dynamic> _voos = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters para expor os dados para a interface (Pages)
  List<dynamic> get voos => _voos;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Função principal para buscar os voos
  Future<void> buscarVoos({String aeroporto = 'SBGR', String tipo = 'todos'}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners(); // Avisa a tela para mostrar o indicador de carregamento (spinner)

    try {
      // Chama o Service responsável pelo HTTP
      _voos = await _vooService.fetchVoos(aeroporto: aeroporto, tipo: tipo);
    } catch (e) {
      _errorMessage = 'Erro ao carregar voos: ${e.toString()}';
      _voos = [];
    } finally {
      _isLoading = false;
      notifyListeners(); // Avisa a tela que o carregamento terminou para atualizar os dados
    }
  }
}

