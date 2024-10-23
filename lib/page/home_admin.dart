import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterloginpage/page/editProductPage.dart';
import 'dart:math';
import 'package:flutterloginpage/widget/costomCliper.dart';
import 'package:flutterloginpage/controllers/auth_controller.dart';
import 'package:flutterloginpage/models/user_models.dart';
import 'package:flutterloginpage/models/product_models.dart';
import 'package:flutterloginpage/controllers/product_controller.dart';
import 'package:provider/provider.dart';
import 'package:flutterloginpage/providers/user_provider.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  List<ProductModel> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการออกจากระบบ'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(); // close the dialog
              },
            ),
            TextButton(
              child: const Text('ออกจากระบบ'),
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false)
                    .onLogout(); // เรียกฟังก์ชัน logout จาก controller

                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchProducts() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final productList = await ProductController().getProducts(context);
      setState(() {
        products = productList;
        isLoading = false;
      });

      // พิมพ์ข้อมูลสินค้าเพื่อตรวจสอบ
      print('Products: $products');
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching products: $error';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching products: $error')));
    }
  }

  // ฟังก์ชันสำหรับการแก้ไขสินค้า
  void updateProduct(ProductModel product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product),
      ),
    );
  }

  Future<void> deleteProduct(ProductModel product) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // แสดงกล่องยืนยันก่อนทำการลบ
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบสินค้า'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบสินค้านี้?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(false); // ปิดกล่องและส่งค่ากลับ false
              },
            ),
            TextButton(
              child: const Text('ลบ'),
              onPressed: () {
                Navigator.of(context).pop(true); // ปิดกล่องและส่งค่ากลับ true
              },
            ),
          ],
        );
      },
    );

    // ถ้าผู้ใช้ยืนยันการลบ
    if (confirmDelete == true) {
      try {
        final response =
            await ProductController().deleteProduct(context, product.id);

        if (response.statusCode == 200) {
          Navigator.pushReplacementNamed(context, '/admin');
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('ลบสินค้าสำเร็จ')));
          // เรียกใช้งาน _fetchProducts เพื่อดึงข้อมูลสินค้าใหม่
          await _fetchProducts();
        } else if (response.statusCode == 401) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Refresh token expired. Please login again.')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting product: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 150, 140, 152)
            ], // พื้นหลังแบบไล่สี
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Background
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * .1),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Manage Products',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 0, 0, 0),
                          shadows: [
                            Shadow(
                              blurRadius: 5.0,
                              color: const Color.fromARGB(186, 178, 132, 132),
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Consumer<UserProvider>(
                      builder: (context, UserProvider, _) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(15), // ขอบโค้งมน
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                spreadRadius: 5,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                'Access Token:',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${UserProvider.accessToken}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 60, 54, 248),
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Refresh Token:',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${UserProvider.refreshToken}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 250, 63, 63),
                                ),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  AuthController().refreshToken(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 32, 130, 17),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  shadowColor: Colors.black45,
                                  elevation: 5,
                                ),
                                child: Text(
                                  'Update Token',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/add_product');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 102, 15, 119),
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        shadowColor: Colors.black45,
                        elevation: 5,
                      ),
                      child: Text(
                        'Add Product',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    if (isLoading)
                      CircularProgressIndicator()
                    else if (errorMessage != null)
                      Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red),
                      )
                    else
                      _buildProductList(),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 50.0,
              right: 16.0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
                child: Icon(
                  Icons.logout,
                  color: Color(0xff821131),
                  size: 30,
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black38,
                      offset: Offset(2.0, 2.0),
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

  Widget _buildProductList() {
    return Column(
      children: List.generate(products.length, (index) {
        final product = products[index];
        return Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromARGB(255, 225, 215, 183),
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffC7253E)),
                    ),
                    Text(
                      'ประเภท: ${product.productType}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'ราคา: \$${product.price}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'หน่วย: ${product.unit}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              // Edit and Delete buttons (same as before)
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Color(0xffFABC3F),
                ),
                onPressed: () {
                  updateProduct(product); // เรียกฟังก์ชันแก้ไข
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Color(0xff821131),
                ),
                onPressed: () {
                  deleteProduct(product); // เรียกฟังก์ชันลบ
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
