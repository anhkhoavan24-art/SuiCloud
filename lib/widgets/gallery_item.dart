import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Để load ảnh mượt hơn
import 'package:flutter/services.dart'; // Để copy link vào clipboard
import '../models/walrus_file.dart';

class GalleryItem extends StatelessWidget {
  final WalrusFile file;

  const GalleryItem({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05), // Bóng mờ rất nhẹ
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge, // Cắt ảnh theo khung bo tròn
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. LỚP ẢNH
          CachedNetworkImage(
            imageUrl: file.shareLink,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[100],
              child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.broken_image, color: Colors.grey),
          ),

          // 2. LỚP PHỦ MỜ (Gradient) ở dưới đáy để làm nổi nút bấm
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues (alpha: 0.6)],
                ),
              ),
            ),
          ),

          // 3. NÚT CHỨC NĂNG (Copy Link)
          Positioned(
            bottom: 5,
            right: 5,
            child: IconButton(
              icon: const Icon(Icons.copy, color: Colors.white, size: 20),
              tooltip: 'Copy Link',
              onPressed: () {
                // Copy link vào bộ nhớ tạm
                Clipboard.setData(ClipboardData(text: file.shareLink));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã copy link ảnh!'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating, // Thông báo nổi lên
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}