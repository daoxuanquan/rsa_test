part of api;

class ParametersWithRandom<UnderlyingParameters extends CipherParameters>
    implements CipherParameters {
  final UnderlyingParameters parameters;

  ParametersWithRandom(this.parameters);
}
