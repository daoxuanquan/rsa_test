part of api;

class PrivateKeyParameter<T> extends AsymmetricKeyParameter<T> {
  PrivateKeyParameter(key) : super(key as T);
}
