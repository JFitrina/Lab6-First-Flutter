import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutterloginpage/widget/costomCliper.dart';
import 'package:flutterloginpage/controllers/product_controller.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final ProductController _productController =
      ProductController(); // Create ProductController instance
  String productName = '';
  String productType = '';
  double price = 0.00;
  String unit = '';

  // แยกฟังก์ชันสำหรับเพิ่มสินค้า
  void _addNewProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // บันทึกข้อมูลสินค้าใหม่โดยเรียกฟังก์ชัน insertProduct
      _productController.InsertProduct(
        context,
        productName,
        productType,
        price,
        unit,
      ).then((response) {
        // ตรวจสอบว่าการเพิ่มสินค้าสำเร็จหรือไม่
        if (response.statusCode == 201) {
          // Success action here (e.g. navigate back or show success message)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เพิ่มสินค้าเรียบร้อยแล้ว')),
          );
          Navigator.pushReplacementNamed(context, '/admin');
        } else if (response.statusCode == 401) {
          // แสดงข้อความเมื่อเกิดข้อผิดพลาดในการเพิ่มสินค้า
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Refresh token expired. Please login again.')),
          );
        }
      }).catchError((error) {
        // แสดงข้อความเมื่อเกิดข้อผิดพลาด
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height, // กำหนดให้ Container มีขนาดเต็มหน้าจอ
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xffE8EAF6),
              Color.fromARGB(255, 229, 236, 121)
            ], // กำหนดสีพื้นหลังแบบ Gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // ฟอร์ม
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: height * .1),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'NEW',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color(0xffC7253E),
                        ),
                        children: [
                          TextSpan(
                            text: ' Products',
                            style: TextStyle(
                              color: Color(0xff3E4A89),
                              fontSize: 35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              _buildTextField(
                                label: 'ชื่อสินค้า',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกชื่อสินค้า';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  productName = value!;
                                },
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'ประเภทสินค้า',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกประเภทสินค้า';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  productType = value!;
                                },
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'ราคา',
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกราคา';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'กรุณากรอกจำนวนเต็มที่ถูกต้อง';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  price = double.parse(value!);
                                },
                              ),
                              SizedBox(height: 16),
                              _buildTextField(
                                label: 'หน่วย',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'กรุณากรอกหน่วย';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  unit = value!;
                                },
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: _addNewProduct,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 23, 130, 17),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0, vertical: 12.0),
                                      child: Text(
                                        'บันทึก',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/admin');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff676767),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24.0, vertical: 12.0),
                                      child: Text(
                                        'ยกเลิก',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}
