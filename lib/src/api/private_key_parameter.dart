// See file LICENSE for more information.

part of api;

/// A [CipherParameters] to hold an asymmetric private key
class PrivateKeyParameter<T> extends AsymmetricKeyParameter<T> {
  PrivateKeyParameter(key) : super(key as T);
}
