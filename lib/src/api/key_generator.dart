part of api;

abstract class KeyGenerator extends Algorithm {
  factory KeyGenerator(String algorithmName) =>
      registry.create<KeyGenerator>(algorithmName);
  void init(CipherParameters params);
  AsymmetricKeyPair generateKeyPair();
}
