import 'package:shared_preferences/shared_preferences.dart';
import '../models/walrus_file.dart';

class StorageService {
  static const String _key = 'walrus_history_v1';

  Future<void> saveFile(WalrusFile file) async {
    final prefs = await SharedPreferences.getInstance();
    List<WalrusFile> list = await getHistory();
    list.insert(0, file); // Thêm vào đầu danh sách
    List<String> data = list.map((e) => e.toJson()).toList();
    await prefs.setStringList(_key, data);
  }

  Future<List<WalrusFile>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? data = prefs.getStringList(_key);
    if (data == null) return [];
    return data.map((e) => WalrusFile.fromJson(e)).toList();
  }
}