part of api;

abstract class KeyGeneratorParameters implements CipherParameters {
  final int bitStrength;

  KeyGeneratorParameters(this.bitStrength);
}
