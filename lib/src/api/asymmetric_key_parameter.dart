part of api;

abstract class AsymmetricKeyParameter<T> implements CipherParameters {
  final T key;

  AsymmetricKeyParameter(this.key);
}
