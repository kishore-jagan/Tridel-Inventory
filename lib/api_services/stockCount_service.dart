// ignore_for_file: file_names, depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:inventory/api_services/api_config.dart';

class StockCountController extends GetxController {
  var electricalCount = ''.obs;
  var mechanicalCount = ''.obs;
  var itCount = ''.obs;
  var vendorcount = ''.obs;
  var employeecount = ''.obs;

  Future<void> productsCount() async {
    var response = await http
        .get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.stockCount}'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      electricalCount.value = data['table1_total_rows'];
      mechanicalCount.value = data['table2_total_rows'];
      itCount.value = data['table3_total_rows'];
    }
  }

  Future<void> vendorCount() async {
    var response = await http
        .get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.vendorCount}'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      vendorcount.value = data['total_rows'];
    }
  }

  Future<void> employeeCount() async {
    var response = await http
        .get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.employeeCount}'));
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      employeecount.value = data['total_rows'];
    }
  }
}
