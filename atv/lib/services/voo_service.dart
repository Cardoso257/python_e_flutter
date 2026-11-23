import 'dart:convert';
import 'package:http/http.dart' as http;

class VooService {
  // URL base da API Python rodando localmente
  // DICA: Se testar na Web use 127.0.0.1 ou localhost.
  // Se testar no Emulador Android, use 10.0.2.2 ao invés de 127.0.0.1.
  final String _baseUrl = 'http://127.0.0.1:5001/api/voos';

  Future<List<dynamic>> fetchVoos({
    required String aeroporto,
    required String tipo,
  }) async {
    // Monta a URL com os parâmetros de busca: ?aeroporto=SBGR&tipo=chegadas
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {'aeroporto': aeroporto, 'tipo': tipo});

    // Executa a requisição GET
    final response = await http.get(uri).timeout(const Duration(seconds: 25));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);

    
    if (decodedData is Map<String, dynamic>) {
        // Altere 'voos' ou 'dados' de acordo com o nome da chave retornada pelo Python
        final lista = decodedData['voos'] ?? decodedData['data'];
        if (lista is List) return lista;
        throw const FormatException('A API não retornou uma lista de voos.'); 
      } 
      // Se já for uma Lista direta:
      else if (decodedData is List) {
        return decodedData;
      }

      throw const FormatException('Formato de resposta inesperado da API.');
    } else {
      throw Exception('Falha ao carregar voos: ${response.statusCode}');
    }

  }
} 