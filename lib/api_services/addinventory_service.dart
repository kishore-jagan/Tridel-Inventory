// ignore_for_file: unused_local_variable, depend_on_referenced_packages, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:inventory/Constants/toaster.dart';
import 'dart:convert';
import 'api_config.dart';

class InventoryController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController serialController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController vendorNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  RxString selectedCategory = "Electrical".obs;
  List<String> categoriesList = ["Electrical", "Mechanical", "IT"];

  RxString selectedType = "Rental".obs;
  List<String> typeList = ["Rental", "Assets"];

  RxString selectedLocation = "Inhouse".obs;
  List<String> locationList = ["Inhouse", "Warehouse"];

  RxBool isLoading = false.obs;

  Future<void> saveData() async {
    try {
      double qty = double.parse(qtyController.text);
      double price = double.parse(priceController.text);
      double totalPrice = qty * price;

      isLoading.value = true;

      var response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.addInventory}'),
        headers: {
          "content-type": "application/x-www-form-urlencoded",
        },
        body: {
          "name": nameController.text,
          "model_no": modelController.text,
          "serial_no": serialController.text,
          "qty": qtyController.text,
          "price": priceController.text,
          "total_price": totalPrice.toString(),
          "category": selectedCategory.value,
          "location": selectedLocation.value,
          "status": remarksController.text,
          "type": selectedType.value,
          "vendor_name": vendorNameController.text,
          "date": dateController.text,
          "Stock_in_out": 'Stock In',
          "Desc": descriptionController.text,
        },
      );

      if (response.statusCode == 200) {
        // print('response body : ${response.body}');
        Map<String, dynamic> data = json.decode(response.body);
        // print("Response: $data");

        if (data['status'] == 'success') {
          final String remark = data['remark'];
          Toaster().showsToast(remark, Colors.green, Colors.white);

          await addVendor();
          nameController.clear();
          modelController.clear();
          serialController.clear();
          qtyController.clear();
          priceController.clear();
          remarksController.clear();
          vendorNameController.clear();
          dateController.clear();
          descriptionController.clear();
          isLoading.value = false;
        } else {
          final String message = data['remark'];
          Toaster().showsToast(message, Colors.red, Colors.white);

          isLoading.value = false;
        }
      } else {
        print("Failed to save data. Status code: ${response.statusCode}");
        // print('Response body: ${response.body}');
        isLoading.value = false;
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addVendor() async {
    try {
      isLoading.value = true;
      var response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.addVendor}'),
        headers: {
          "content-type": "application/x-www-form-urlencoded",
        },
        body: {
          "vendorName": vendorNameController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // print("Vendor added: $data");
        isLoading.value = false;
      } else {
        print("Failed to add vendor. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error adding vendor: $e');
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    modelController.dispose();
    serialController.dispose();
    qtyController.dispose();
    priceController.dispose();
    typeController.dispose();
    locationController.dispose();
    remarksController.dispose();
    vendorNameController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
