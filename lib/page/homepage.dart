import 'package:boxing_camp_app/page/loginpage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // เปิด drawer เมื่อกดปุ่มเมนู
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Image.asset(
          'assets/images/logomuay.png', // เปลี่ยนเส้นทางเป็นที่อยู่ของภาพโลโก้
          height: 40, // ปรับขนาดตามที่คุณต้องการ
        ),
        elevation: 10,
        backgroundColor: Color.fromARGB(248, 158, 25, 1),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                color: Colors.green,
                width: 3, // เพิ่มความหนาของกรอบที่นี่
              ),
            ),
            child: const Text(
              "Sign In",
              style: TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              child: Image.asset(
                'assets/images/logomuay.png', // โลโก้ใน drawer header
                height: 100,
              ),
            ),
            ListTile(
              title: Text('โปรไฟล์ของฉัน'),
              onTap: () {
                // ปิด drawer และไปที่หน้าโปรไฟล์
                Navigator.pop(context);
                // คุณสามารถนำทางไปยังหน้าโปรไฟล์ที่นี่
              },
            ),
            ListTile(
              title: Text('ติดต่อเรา'),
              onTap: () {
                // ปิด drawer และไปที่หน้าติดต่อเรา
                Navigator.pop(context);
                // คุณสามารถนำทางไปยังหน้าติดต่อเราที่นี่
              },
            ),
            ListTile(
              title: Text('ออกจากระบบ'),
              onTap: () {
                // ปิด drawer และออกจากระบบ
                Navigator.pop(context);
                // การออกจากระบบสามารถทำได้ที่นี่
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
