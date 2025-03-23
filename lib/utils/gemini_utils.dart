import 'dart:convert';

class GeminiUtils {
  static List<dynamic>? geminiResponseParse(String body) {
    final Map<String, dynamic> data = jsonDecode(body);
    String? generatedText =
    data['candidates']?[0]['content']?["parts"]?[0]["text"];
    if (generatedText != null) {
      generatedText = generatedText
          .replaceAll('```json', '')
          .replaceAll('```', '')
          .trim();
      return jsonDecode(generatedText);
    } else {
      return null;
    }
  }
}