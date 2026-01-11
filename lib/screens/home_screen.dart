// File: lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/walrus_file.dart';
import '../services/storage_service.dart'; // Đã sửa đường dẫn đúng
import '../widgets/gallery_item.dart';
import 'upload_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Đã sửa tên class service cho đúng với file mới
  final StorageService _storageService = StorageService();
  List<WalrusFile> _files = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await _storageService.getHistory();
    setState(() {
      _files = history;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SuiCloud Gallery"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadHistory,
          )
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UploadScreen()),
          );

          if (result == true) {
            _loadHistory();
          }
        },
        label: const Text("Upload"),
        icon: const Icon(Icons.cloud_upload),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _files.isEmpty
          ? _buildEmptyState()
          : Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.8,
          ),
          itemCount: _files.length,
          itemBuilder: (context, index) {
            return GalleryItem(file: _files[index]);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "Chưa có ảnh nào được lưu",
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          const Text("Bấm nút Upload bên dưới để bắt đầu", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}