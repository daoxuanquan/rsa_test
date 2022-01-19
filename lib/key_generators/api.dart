// See file LICENSE for more information.

library api.key_generators;

import 'package:test_rsa_lib/api.dart';

/// Abstract [CipherParameters] to init an RSA key generator.
class RSAKeyGeneratorParameters extends KeyGeneratorParameters {
  final BigInt publicExponent;
  final int certainty;

  RSAKeyGeneratorParameters(
      this.publicExponent, int bitStrength, this.certainty)
      : super(bitStrength);
}
