import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _backendUrl = 'http://localhost:3000';
  static const String _decomposeEndpoint = '/api/decompose';

  /// 調用後端 API 進行任務分解
  /// @param taskDescription 任務描述
  /// @return 模型返回的任務分解結果文字
  static Future<String> decomposeTask(String taskDescription) async {
    try {
      final url = Uri.parse('$_backendUrl$_decomposeEndpoint');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'taskDescription': taskDescription,
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('請求超時，請檢查後端服務是否運行中'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['status'] == 'success') {
          return data['data']['output'] as String;
        } else {
          throw Exception(data['error'] ?? '未知錯誤');
        }
      } else {
        throw Exception('伺服器錯誤 (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      throw Exception('任務分解失敗: $e');
    }
  }

  /// 檢查後端健康狀態
  static Future<bool> checkHealth() async {
    try {
      final url = Uri.parse('$_backendUrl/health');
      
      final response = await http.get(url).timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw Exception('後端服務未回應'),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
