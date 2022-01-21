library api.asymmetric;

import 'dart:typed_data';

import '../api.dart';

abstract class RSAAsymmetricKey {
  final BigInt? modulus;
  final BigInt? exponent;

  RSAAsymmetricKey(this.modulus, this.exponent);

  BigInt? get n => modulus;
}

class RSAPrivateKey extends RSAAsymmetricKey {
  final BigInt? p;
  final BigInt? q;
  BigInt? _pubExp;

  RSAPrivateKey(
      BigInt modulus,
      BigInt privateExponent,
      this.p,
      this.q,
      [@Deprecated('Public exponent is calculated from the other values')
          BigInt? publicExponent])
      : super(modulus, privateExponent) {
    if (p! * q! != modulus) {
      throw ArgumentError.value('modulus inconsistent with RSA p and q');
    }

    _pubExp =
        privateExponent.modInverse(((p! - BigInt.one) * (q! - BigInt.one)));

    if (publicExponent != null && publicExponent != _pubExp) {
      throw ArgumentError(
          'public exponent inconsistent with RSA private exponent, p and q');
    }
  }

  @Deprecated('Use privateExponent.')
  BigInt? get d => exponent;

  BigInt? get privateExponent => exponent;

  BigInt? get publicExponent => _pubExp;

  @Deprecated('Use publicExponent.')
  BigInt? get pubExponent => publicExponent;

  @override
  bool operator ==(other) {
    if (other is RSAPrivateKey) {
      return other.privateExponent == privateExponent &&
          other.modulus == modulus;
    }
    return false;
  }

  @override
  int get hashCode => modulus.hashCode + privateExponent.hashCode;
}

class RSAPublicKey extends RSAAsymmetricKey {
  RSAPublicKey(BigInt modulus, BigInt exponent) : super(modulus, exponent);

  @Deprecated('Use get publicExponent')
  BigInt? get e => exponent;

  /// Get the public exponent.
  BigInt? get publicExponent => exponent;

  @override
  bool operator ==(other) {
    if (other is RSAPublicKey) {
      return (other.modulus == modulus) &&
          (other.publicExponent == publicExponent);
    }
    return false;
  }

  @override
  int get hashCode => modulus.hashCode + publicExponent.hashCode;
}

/// A [Signature] created with RSA.
class RSASignature implements Signature {
  final Uint8List bytes;

  RSASignature(this.bytes);

  @override
  String toString() => bytes.toString();
  @override
  bool operator ==(other) {
    if (other is! RSASignature) return false;
    if (other.bytes.length != bytes.length) return false;

    for (var i = 0; i < bytes.length; i++) {
      if (bytes[i] != other.bytes[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => bytes.hashCode;
}

/// A [Signature] created with PSS.
class PSSSignature implements Signature {
  final Uint8List bytes;

  PSSSignature(this.bytes);

  @override
  String toString() => bytes.toString();

  @override
  bool operator ==(other) {
    if (other is! PSSSignature) return false;
    if (other.bytes.length != bytes.length) return false;

    for (var i = 0; i < bytes.length; i++) {
      if (bytes[i] != other.bytes[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => bytes.hashCode;
}
