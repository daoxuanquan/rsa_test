// See file LICENSE for more information.

part of api;

/// A [CipherParameters] to hold an asymmetric public key
class PublicKeyParameter<T> extends AsymmetricKeyParameter<T> {
  PublicKeyParameter(key) : super(key as T);
}
