// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inventory/Widgets/custom_text_field.dart';
import 'package:inventory/Widgets/dropdown.dart';
import 'package:inventory/Widgets/elevated_button.dart';
import 'package:inventory/api_services/addinventory_service.dart';

import '../../Constants/controllers.dart';
import '../../Constants/toaster.dart';
import '../../Widgets/custom_text.dart';
import '../../api_services/products_service_controller.dart';
import '../../helpers/responsiveness.dart';
import 'widgets/vendor_search.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({
    super.key,
  });

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final ProductsController productsController = Get.put(ProductsController());
  final InventoryController inventoryController =
      Get.put(InventoryController());
  final GlobalKey<VendorSearchState> vendorSearchKey =
      GlobalKey<VendorSearchState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => inventoryController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.lightBlue,
              ))
            : SingleChildScrollView(
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: ResponsiveWidget.isSmallScreen(context)
                                  ? 56
                                  : 6),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomText(
                              text: menuController.activeItem.value,
                              size: 24,
                              weight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                offset: const Offset(0, 2),
                                blurRadius: 2)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Item Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 24),
                            ),
                            Row(
                              children: [
                                Flexible(
                                    child: CustomTextField(
                                  fieldTitle: 'Product Name',
                                  textEditingController:
                                      inventoryController.nameController,
                                  // hintText: 'Enter Product Name',
                                )),
                                const SizedBox(width: 50),
                                Flexible(
                                    child: CustomTextField(
                                  textEditingController:
                                      inventoryController.serialController,
                                  // hintText: 'Model Number',
                                  fieldTitle: 'Enter Serial Number',
                                )),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                Flexible(
                                    child: CustomTextField(
                                  textEditingController:
                                      inventoryController.modelController,
                                  // hintText: 'Model Number',
                                  fieldTitle: 'Enter Model Number',
                                )),
                                const SizedBox(
                                  width: 50,
                                ),
                                Flexible(
                                  child: Row(
                                    children: [
                                      Flexible(
                                          child: CustomTextField(
                                        textEditingController:
                                            inventoryController.qtyController,
                                        fieldTitle: 'Enter Quantity',
                                        keyboard: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        textInput: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}$'),
                                          ),
                                        ],
                                      )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                          child: CustomTextField(
                                        textEditingController:
                                            inventoryController.priceController,
                                        fieldTitle: 'Enter Price',
                                        keyboard: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        textInput: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}$'),
                                          ),
                                        ],
                                      )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                Flexible(
                                  child: CustomDropDown(
                                      fieldTitle: 'Category',
                                      items: inventoryController.categoriesList,
                                      val: inventoryController
                                          .selectedCategory.value,
                                      onChanged: (newValue) {
                                        setState(() {
                                          inventoryController.selectedCategory
                                              .value = newValue!;
                                        });
                                      }),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Flexible(
                                    child: CustomDropDown(
                                        items: inventoryController.typeList,
                                        val: inventoryController
                                            .selectedType.value,
                                        onChanged: (newValue) {
                                          setState(() {
                                            inventoryController
                                                .selectedType.value = newValue!;
                                          });
                                        },
                                        fieldTitle: 'Type')),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Flexible(
                                    child: CustomDropDown(
                                        items: inventoryController.locationList,
                                        val: inventoryController
                                            .selectedLocation.value,
                                        onChanged: (newValue) {
                                          setState(() {
                                            inventoryController.selectedLocation
                                                .value = newValue!;
                                          });
                                        },
                                        fieldTitle: 'Location')),
                                const SizedBox(
                                  width: 50,
                                ),
                                Flexible(
                                    child: CustomTextField(
                                        textEditingController:
                                            inventoryController
                                                .remarksController,
                                        fieldTitle: 'Remarks'))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                offset: const Offset(0, 2),
                                blurRadius: 2)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Vendor Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 24),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0, top: 8.0, bottom: 4.0),
                                        child: Text(
                                          'Vendor name',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                      VendorSearch(
                                          key: vendorSearchKey,
                                          controller: inventoryController
                                              .vendorNameController),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Flexible(
                                  child: CustomTextField(
                                    textEditingController:
                                        inventoryController.dateController,
                                    fieldTitle: 'Date',
                                    suffixIcon: const Icon(
                                      Icons.calendar_today,
                                      size: 20,
                                    ),
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101),
                                      );

                                      if (pickedDate != null &&
                                          pickedDate != DateTime.now()) {
                                        // Format the selected date as needed
                                        String formattedDate =
                                            "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                                        // Update the text field with the selected date
                                        inventoryController.dateController
                                            .text = formattedDate;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            CustomTextField(
                                textEditingController:
                                    inventoryController.descriptionController,
                                fieldTitle: 'Description'),
                            const SizedBox(
                              height: 20,
                            ),
                            Button(
                                onPressed: () async {
                                  try {
                                    setState(() {
                                      vendorSearchKey.currentState
                                          ?.setSelectedVendor();
                                    });
                                    inventoryController.isLoading.value = true;
                                    if (inventoryController.nameController.text.isNotEmpty &&
                                        inventoryController
                                            .modelController.text.isNotEmpty &&
                                        inventoryController
                                            .serialController.text.isNotEmpty &&
                                        inventoryController
                                            .qtyController.text.isNotEmpty &&
                                        inventoryController
                                            .priceController.text.isNotEmpty &&
                                        inventoryController
                                            .selectedType.value.isNotEmpty &&
                                        inventoryController.selectedLocation
                                            .value.isNotEmpty &&
                                        inventoryController.selectedCategory
                                            .value.isNotEmpty &&
                                        inventoryController.vendorNameController
                                            .text.isNotEmpty &&
                                        inventoryController
                                            .dateController.text.isNotEmpty) {
                                      // print("Started");

                                      await inventoryController.saveData();
                                      productsController.fetchListProducts();

                                      // print("End");
                                    } else {
                                      inventoryController.isLoading.value =
                                          false;
                                      print("null value handled");
                                      Toaster().showsToast(
                                          'Please fill all fields',
                                          Colors.red,
                                          Colors.white);
                                    }
                                  } catch (e) {
                                    print('error: $e');
                                    inventoryController.isLoading.value = false;
                                  }
                                },
                                text: "Add"),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // ElevatedButton(
                            //   onPressed: () async {
                            //     try {
                            //       setState(() {
                            //         vendorSearchKey.currentState
                            //             ?.setSelectedVendor();
                            //       });
                            //       inventoryController.isLoading.value = true;
                            //       if (inventoryController.nameController.text.isNotEmpty &&
                            //           inventoryController
                            //               .modelController.text.isNotEmpty &&
                            //           inventoryController
                            //               .serialController.text.isNotEmpty &&
                            //           inventoryController
                            //               .qtyController.text.isNotEmpty &&
                            //           inventoryController
                            //               .priceController.text.isNotEmpty &&
                            //           inventoryController
                            //               .selectedType.value.isNotEmpty &&
                            //           inventoryController
                            //               .selectedLocation.value.isNotEmpty &&
                            //           inventoryController
                            //               .selectedCategory.value.isNotEmpty &&
                            //           inventoryController.descriptionController
                            //               .text.isNotEmpty &&
                            //           inventoryController.vendorNameController
                            //               .text.isNotEmpty &&
                            //           inventoryController
                            //               .dateController.text.isNotEmpty &&
                            //           inventoryController
                            //               .remarksController.text.isNotEmpty) {
                            //         // print("Started");

                            //         await inventoryController.saveData();
                            //         productsController.fetchListProducts();

                            //         // print("End");
                            //       } else {
                            //         inventoryController.isLoading.value = false;
                            //         print("null value handled");
                            //         Toaster().showsToast(
                            //             'Please fill all fields',
                            //             Colors.red,
                            //             Colors.white);
                            //       }
                            //     } catch (e) {
                            //       print('error: $e');
                            //       inventoryController.isLoading.value = false;
                            //     }
                            //   },
                            //   style: ButtonStyle(
                            //     backgroundColor: MaterialStateProperty.all(
                            //         Colors
                            //             .lightBlue), // Button background color
                            //     padding: MaterialStateProperty.all(
                            //         const EdgeInsets.symmetric(
                            //             horizontal: 50,
                            //             vertical: 15)), // Button padding
                            //     elevation: MaterialStateProperty.all(
                            //         3), // Button elevation
                            //     shape: MaterialStateProperty.all<
                            //         RoundedRectangleBorder>(
                            //       RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(
                            //             30.0), // Button border radius
                            //       ),
                            //     ),
                            //   ),
                            //   child: const Text(
                            //     "Add",
                            //     style: TextStyle(
                            //       fontSize: 18,
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.white,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
      ),
    );
  }
}
