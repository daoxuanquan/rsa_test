library impl.entropy;

import 'dart:typed_data';

abstract class EntropySource {
  Uint8List getBytes(int len);
}
