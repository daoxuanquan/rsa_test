part of api;

class ParametersWithIV<UnderlyingParameters extends CipherParameters?>
    implements CipherParameters {
  final Uint8List iv;
  final UnderlyingParameters? parameters;

  ParametersWithIV(this.parameters, this.iv);
}
