// modules/attendance/utils/image_compress_helper.dart
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageCompressHelper {
  static Future<File> compress(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // ⬇️ RETURN XFile? di flutter_image_compress 2.4.0
    final XFile? compressed = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 60, // ideal 60–70
      format: CompressFormat.jpeg,
    );

    // kalau gagal compress, pakai file asli
    if (compressed == null) {
      return file;
    }

    // 🔥 CONVERT XFile → File (WAJIB)
    return File(compressed.path);
  }
}
