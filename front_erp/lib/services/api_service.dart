import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';
import '../models/supplier.dart';

class ApiService {
  static const String baseUrl = 'http://polyedre.eu:8000/polyfx/cgi';

  Future<List<Supplier>> fetchSuppliers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getfrstd1.cgi'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Supplier.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des fournisseurs');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }

  Future<List<Article>> fetchArticles(String supplierId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getart.cgi?frs=$supplierId'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la récupération des articles');
      }
    } catch (e) {
      throw Exception('Erreur: $e');
    }
  }
}
