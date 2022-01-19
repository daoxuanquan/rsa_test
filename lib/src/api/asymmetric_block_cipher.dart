// See file LICENSE for more information.

part of api;

abstract class AsymmetricBlockCipher extends Algorithm {
  // tạo ra block cipher ddựa trên algorithmName
  factory AsymmetricBlockCipher(String algorithmName) =>
      registry.create<AsymmetricBlockCipher>(algorithmName);

  // lấy kichs thước block tối đa
  int get inputBlockSize;

  // lấy kích thước block output tối đa
  int get outputBlockSize;

  /// Sử dụng đối số [forEncryption] để cho mật mã biết bạn muốn mã hóa hay giải mã dữ liệu.
  void init(bool forEncryption, CipherParameters params);

  /// Xử lý toàn bộ khối [data] cùng một lúc, trả về kết quả trong một mảng byte.
  Uint8List process(Uint8List data);

  /// xử lý một khối [len] bytes cho bởi [inp] bắt đầu tại offset [inpOff] luw output cipher text vào [out]
  /// bắt đầu tại vị trí [outOff].
  ///
  /// This method returns the total bytes put in the output buffer.
  int processBlock(
      Uint8List inp, int inpOff, int len, Uint8List out, int outOff);
}
