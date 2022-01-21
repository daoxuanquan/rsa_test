part of api;

class PublicKeyParameter<T> extends AsymmetricKeyParameter<T> {
  PublicKeyParameter(key) : super(key as T);
}
