part of api;

/// Abstract [CipherParameters] to hold an asymmetric (public or private) key
abstract class AsymmetricKeyParameter<T> implements CipherParameters {
  final T key;

  AsymmetricKeyParameter(this.key);
}
