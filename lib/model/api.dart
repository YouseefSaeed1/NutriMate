import 'dart:convert';
import 'package:http/http.dart' as http;

class FoodApi {
  static const String _apiKey = "SQ5DgEJa3bqo9XDouuQeJgfPUn7WNYYSkMXamWJw";
  static const String _baseUrl = "https://api.nal.usda.gov/fdc/v1/foods/search";

  static Future<double?> getCalories(String foodName) async {
    final url = Uri.parse(
      "$_baseUrl?query=$foodName&pageSize=1&api_key=$_apiKey",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode != 200) return null;

      final data = json.decode(response.body);

      if (data["foods"] == null || (data["foods"] as List).isEmpty) return null;

      final nutrients = data["foods"][0]["foodNutrients"] as List;

      for (final nutrient in nutrients) {
        if (nutrient["nutrientName"] == "Energy" &&
            nutrient["unitName"] == "KCAL") {
          return (nutrient["value"] as num?)?.toDouble();
        }
      }
    } catch (e) {
      return null;
    }

    return null;
  }
}
