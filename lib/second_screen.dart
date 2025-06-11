import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';
import 'login_screen.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllUsers();
  }

  Future<void> _loadAllUsers() async {
    setState(() => _isLoading = true);
    try {
      final usersPage1 = await AuthService.fetchUsers(1);
      final usersPage2 = await AuthService.fetchUsers(2);
      setState(() {
        _users = [...usersPage1, ...usersPage2];
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки: $e')),
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Пользователи (${_users.length})'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAllUsers,
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Первая колонка: Пользователь
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(user['avatar']),
                                ),
                                SizedBox(width: 12),
                                Expanded( 
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${user['first_name']} ${user['last_name']}'),
                                      Text(user['email'], 
                                        style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Вторая колонка: ID
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'ID: ${user['id']}',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}