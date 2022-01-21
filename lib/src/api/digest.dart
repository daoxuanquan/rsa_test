part of api;

abstract class Digest extends Algorithm {
  factory Digest(String algorithmName) =>
      registry.create<Digest>(algorithmName);

  int get digestSize;
  int get byteLength;
  void reset();
  Uint8List process(Uint8List data);
  void updateByte(int inp);
  void update(Uint8List inp, int inpOff, int len);
  int doFinal(Uint8List out, int outOff);
}
