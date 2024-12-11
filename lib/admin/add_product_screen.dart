import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/app_colors.dart';
import 'package:fooddelivery/services/database.dart';
import 'package:fooddelivery/widgets/button_widget.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final List categoryItems = ["Ice-cream", "Burger", "Pizza", "Salad"];
  String? selectedCategory;

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _itemPriceController = TextEditingController();
  final TextEditingController _itemDescriptionController =
      TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? selectedFile;

  Future<void> getImage() async {
    var pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      selectedFile = File(pickedImage!.path);
    });
    print(selectedFile);
  }

  Future uploadItem() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      if (selectedFile != null ||
          _itemPriceController.text != "" ||
          _itemPriceController.text != "" ||
          _itemDescriptionController.text != "") {
        Map<String, dynamic> addItem = {
          "imageUrl": selectedFile.toString(),
          "name": _itemNameController.text,
          "price": double.parse(_itemPriceController.text),
          "description": _itemDescriptionController.text,
          "category": selectedCategory,
        };

        await DatabaseMethod().addFoodItem(addItem, selectedCategory!).then(
          (value) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.greenColor,
                  content: Text("Add Item successfully"),
                ),
              );
            }
          },
        );
        _itemNameController.clear();
        _itemPriceController.clear();
        _itemDescriptionController.clear();
      }
    }
    setState(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemPriceController.dispose();
    _itemDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Products',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload the item picture",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: getImage,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.greyColor.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: selectedFile == null
                        ? const Icon(
                            Icons.camera_alt_outlined,
                            size: 50,
                            color: AppColors.greyColor,
                          )
                        : Image.file(
                            selectedFile!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: const Color(0XFFececf8),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: TextFormField(
                        controller: _itemNameController,
                        decoration: const InputDecoration(
                            hintText: "Enter Item Name",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: const Color(0XFFececf8),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: TextFormField(
                        controller: _itemPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            hintText: "Enter Item Price",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: const Color(0XFFececf8),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: TextFormField(
                        controller: _itemDescriptionController,
                        maxLines: 6,
                        decoration: const InputDecoration(
                            hintText: "Enter Item details",
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: const Color(0XFFececf8),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: selectedCategory,
                          items: categoryItems.map(
                            (categoryItem) {
                              return DropdownMenuItem(
                                value: categoryItem,
                                child: Text(categoryItem),
                              );
                            },
                          ).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value!
                                  .toString(); // Update the selectedCategory
                            });
                          },
                          hint: const Text("Select a category"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              color: AppColors.mainColor,
                            ),
                          )
                        : SizedBox(
                            width: double.maxFinite,
                            child: ButtonWidget(
                              title: "Add Product",
                              onTap: uploadItem,
                            ),
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
