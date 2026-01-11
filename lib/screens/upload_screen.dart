import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/walrus_file.dart';
import '../services/walrus_service.dart';
import '../services/storage_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _selectedFile;
  bool _isUploading = false;
  final WalrusService _walrusService = WalrusService();
  final StorageService _storageService = StorageService();

  // Hàm chọn ảnh
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  // Hàm thực hiện Upload
  Future<void> _doUpload() async {
    if (_selectedFile == null) return;

    setState(() => _isUploading = true);

    try {
      // 1. Upload lên Walrus
      String blobId = await _walrusService.uploadFile(_selectedFile!);

      // 2. Tạo đối tượng WalrusFile
      final newFile = WalrusFile(
        blobId: blobId,
        shareLink: WalrusFile.createLink(blobId),
        uploadDate: DateTime.now(),
      );

      // 3. Lưu vào lịch sử máy
      await _storageService.saveFile(newFile);

      // 4. Thông báo và quay về màn hình chính
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload thành công!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true); // Trả về 'true' để màn hình chính biết mà reload
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload lên Walrus")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Khu vực hiển thị ảnh preview
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey.shade100,
                ),
                child: _selectedFile == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.image, size: 60, color: Colors.grey),
                    TextButton(
                      onPressed: _pickFile,
                      child: const Text("Chọn ảnh từ thư viện"),
                    )
                  ],
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(_selectedFile!, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Nút bấm Upload
            SizedBox(
              width: double.infinity,
              height: 50,
              child: _isUploading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                onPressed: _selectedFile != null ? _doUpload : null,
                icon: const Icon(Icons.cloud_upload),
                label: const Text("Bắt đầu Upload"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}