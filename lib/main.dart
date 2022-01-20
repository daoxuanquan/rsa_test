import 'dart:convert';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';
import 'dart:convert' show utf8;
// When not using the registry:
import 'package:test_rsa_lib/export.dart';

//================================================================
// Test data

const shortPlaintext = 'What hath God wrought!';

const longPlaintext = '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore
eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt
in culpa qui officia deserunt mollit anim id est laborum.''';

//================================================================
// Key generation

//----------------------------------------------------------------
/// Generate an RSA key pair.

AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(
    {int bitLength = 2048}) {
  // Create an RSA key generator and initialize it

  // final keyGen = KeyGenerator('RSA'); // Get using registry
  final keyGen = RSAKeyGenerator(); // Get directly

  keyGen.init(
    ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64)),
  );

  // Use the generator

  final pair = keyGen.generateKeyPair();

  // Examine the generated key-pair

  final myPublic = pair.publicKey as RSAPublicKey;
  final myPrivate = pair.privateKey as RSAPrivateKey;

  // The RSA numbers will always satisfy these properties

  assert(myPublic.modulus == myPrivate.modulus);
  assert(myPrivate.p! * myPrivate.q! == myPrivate.modulus, 'p.q != n');
  final phi = (myPrivate.p! - BigInt.one) * (myPrivate.q! - BigInt.one);
  assert((myPublic.exponent! * myPrivate.exponent!) % phi == BigInt.one);

  return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
}

/// rsa = use RSAEngine without an Asymmetric Block Cipher.

enum AsymBlockCipherToUse { rsa }

//----------------------------------------------------------------

AsymmetricBlockCipher _createBlockCipher() {
  return RSAEngine();
}

Uint8List rsaEncrypt(
  RSAPublicKey myPublic,
  Uint8List dataToEncrypt,
) {
  var encryptor = _createBlockCipher();

  encryptor.init(
    true,
    PublicKeyParameter<RSAPublicKey>(myPublic),
  ); // true=encrypt

  return _processInBlocks(encryptor, dataToEncrypt);
}

//----------------------------------------------------------------

Uint8List rsaDecrypt(
  RSAPrivateKey myPrivate,
  Uint8List cipherText,
) {
  var decryptor = _createBlockCipher();

  decryptor.init(
    false,
    PrivateKeyParameter<RSAPrivateKey>(myPrivate),
  ); // false=decrypt

  return _processInBlocks(decryptor, cipherText);
}

//----------------------------------------------------------------

Uint8List _processInBlocks(AsymmetricBlockCipher engine, Uint8List input) {
  // tính số khối
  final numBlocks = input.length ~/ engine.inputBlockSize +
      ((input.length % engine.inputBlockSize != 0) ? 1 : 0);

  final output = Uint8List(numBlocks * engine.outputBlockSize);

  var inputOffset = 0;
  var outputOffset = 0;
  while (inputOffset < input.length) {
    // tính kích thước của từng đoạn dữ liệu
    final chunkSize = (inputOffset + engine.inputBlockSize <= input.length)
        ? engine.inputBlockSize
        : input.length - inputOffset;

    outputOffset += engine.processBlock(
        input, inputOffset, chunkSize, output, outputOffset);

    inputOffset += chunkSize;
  }

  return (output.length == outputOffset)
      ? output
      : output.sublist(0, outputOffset);
}

Uint8List tamperWithData(Uint8List original) {
// Tampered with data does not verify

  final tamperedData = Uint8List.fromList(original);
  tamperedData[tamperedData.length - 1] ^= 0x01; // XOR to flip one bit

  return tamperedData;
}

//----------------------------------------------------------------
// Print out the RSA key pair

String dumpRsaKeys(AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> k,
    {bool verbose = false}) {
  final bitLength = k.privateKey.modulus!.bitLength;
  final buf = StringBuffer('RSA key generated (bit-length: $bitLength)');

  if (verbose) {
    buf.write('''
  e = ${k.publicKey.exponent}
  n = ${k.publicKey.modulus}
Private:
  n = ${k.privateKey.modulus}
  d = ${k.privateKey.exponent}
  p = ${k.privateKey.p}
  q = ${k.privateKey.q}
''');
  }
  return buf.toString();
}

//----------------------------------------------------------------
/// Represent bytes in hexadecimal
///
/// If a [separator] is provided, it is placed the hexadecimal characters
/// representing each byte. Otherwise, all the hexadecimal characters are
/// simply concatenated together.

String bin2hex(Uint8List bytes, {String? separator, int? wrap}) {
  var len = 0;
  final buf = StringBuffer();
  for (final b in bytes) {
    final s = b.toRadixString(16);
    if (buf.isNotEmpty && separator != null) {
      buf.write(separator);
      len += separator.length;
    }

    if (wrap != null && wrap < len + 2) {
      buf.write('\n');
      len = 0;
    }

    buf.write('${(s.length == 1) ? '0' : ''}$s');
    len += 2;
  }
  return buf.toString();
}

//----------------------------------------------------------------
/// Tests two Uint8List for equality.
///
/// Returns true if they contain all the same bytes. Otherwise false.

bool isUint8ListEqual(Uint8List a, Uint8List b) {
  if (a.length == b.length) {
    for (var x = 0; x < a.length; x++) {
      if (a[x] != b[x]) {
        return false;
      }
    }
  }
  return true;
}
//----------------------------------------------------------------

String? _testEncryptAndDecrypt(
    AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> rsaPair,
    Uint8List plaintext,
    bool verbose) {
  try {
    if (verbose) {
      print('\nEncrypting with rsa:');
    }
    final cipherText = rsaEncrypt(rsaPair.publicKey, plaintext);
    if (verbose) {
      print('Ciphertext:\n${bin2hex(cipherText, wrap: 64)}');
      print("cipherText: $cipherText");
      return bin2hex(cipherText, wrap: 64);
    }

    final decryptedBytes = rsaDecrypt(rsaPair.privateKey, cipherText);

    if (isUint8ListEqual(decryptedBytes, plaintext)) {
      if (verbose) {
        print('Decrypted:\n"${utf8.decode(decryptedBytes)}"');
        return utf8.decode(decryptedBytes);
      }
    } else {
      print(
          'Decrypted:\n"${utf8.decode(decryptedBytes, allowMalformed: true)}"');
      print('fail: decrypted does not match plaintext');
    }
  } catch (e, st) {
    print('fail: threw unexpected exception: ${e.runtimeType}');
    if (verbose) {
      print('$e\n$st\n');
    }
  }
}
//----------------------------------------------------------------

String? main() {
  var verbose = true;

  // Generate an RSA key pair

  final rsaPair = generateRSAkeyPair(bitLength: 32);
  print(dumpRsaKeys(rsaPair, verbose: true));

  // Use the key pair

  const plaintext =
      "{\"card_number\":\"1111222233334444\",\"card_holder\":\"NguyenVanA\",\"CVV\":888,\"expired_date\":\"02/2030\"}";
  if (verbose) {
    print('\n\n\n\n\n');
    print('=====Start program============\n\n\n\n\n');
    print('Plaintext: $plaintext\n');
  }
  final bytes = utf8.encode(plaintext);
  print(bytes);
  return _testEncryptAndDecrypt(rsaPair, Uint8List.fromList(bytes), true);
}

void main_test() async {
  final HttpServer server = await HttpServer.bind("localhost", 8080);

  server.listen((HttpRequest event) async {
    try {
      print(event.uri);
      await utf8
          .decodeStream(event)
          .then((data) => {print(data), event.response.write("main_test()")});
      print(event);
    } finally {
      event.response.close();
    }
  });
}
