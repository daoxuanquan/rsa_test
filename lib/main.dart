import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert' show utf8;
import '/export.dart';

AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(
    {int bitLength = 2048,
    BigInt? initP,
    BigInt? initQ,
    BigInt? initN,
    BigInt? initE,
    BigInt? initd}) {
  final keyGen = RSAKeyGenerator();

  keyGen.init(
    ParametersWithRandom(
        RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64)),
  );
  var pair;
  // Use the generator
  if (initN != null &&
      initP != null &&
      initQ != null &&
      initd != null &&
      initE != null) {
    print("run key nhap");
    pair = keyGen.generateKeyPair(
        initP: initP, initE: initE, initQ: initQ, initd: initd, initN: initN);
  } else {
    print("run key nhap");
    pair = keyGen.generateKeyPair(
        initP: initP, initE: initE, initQ: initQ, initd: initd, initN: initN);
  }

  // Examine the generated key-pair

  final myPublic = pair.publicKey as RSAPublicKey;
  final myPrivate = pair.privateKey as RSAPrivateKey;

  assert(myPublic.modulus == myPrivate.modulus);
  assert(myPrivate.p! * myPrivate.q! == myPrivate.modulus, 'p.q != n');
  final phi = (myPrivate.p! - BigInt.one) * (myPrivate.q! - BigInt.one);
  assert((myPublic.exponent! * myPrivate.exponent!) % phi == BigInt.one);

  return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
}

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
  final tamperedData = Uint8List.fromList(original);
  tamperedData[tamperedData.length - 1] ^= 0x01;

  return tamperedData;
}

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
String encodeRsaBank(text) {
  var verbose = true;
  final BigInt keyN = BigInt.from(158549);
  final BigInt keyD = BigInt.from(120053);
  final BigInt keyP = BigInt.from(479);
  final BigInt keyQ = BigInt.from(331);
  final BigInt keyE = BigInt.from(65537);
  // Generate an RSA key pair
  final rsaPair = generateRSAkeyPair(
      bitLength: 32,
      initd: keyD,
      initQ: keyQ,
      initP: keyP,
      initE: keyE,
      initN: keyN);

  print(dumpRsaKeys(rsaPair, verbose: verbose));
  print(rsaPair.publicKey);
  print('Plaintext: $text\n');
  final bytes = utf8.encode(text);
  final cipherText = rsaEncrypt(rsaPair.publicKey, Uint8List.fromList(bytes));
  return bin2hex(cipherText, wrap: 64);
}

String decodeRsaBank(String text) {
  var verbose = true;
  final BigInt keyN = BigInt.from(158549);
  final BigInt keyD = BigInt.from(120053);
  final BigInt keyP = BigInt.from(479);
  final BigInt keyQ = BigInt.from(331);
  final BigInt keyE = BigInt.from(65537);

  final rsaPair = generateRSAkeyPair(
      bitLength: 32,
      initd: keyD,
      initQ: keyQ,
      initP: keyP,
      initE: keyE,
      initN: keyN);

  final decryptedBytes = rsaDecrypt(rsaPair.privateKey, hex2bin(text));

  if (isUint8ListEqual(decryptedBytes, hex2bin(text))) {
    if (verbose) {
      print('Decrypted:\n"${utf8.decode(decryptedBytes)}"');
      return utf8.decode(decryptedBytes);
    }
  } else {
    print('Decrypted:\n"${utf8.decode(decryptedBytes, allowMalformed: true)}"');
    return 'fail: decrypted does not match plaintext';
  }
  return 'fail: decrypted does not match plaintext';
}

//----------------------------------------------------------------
String encodeRsaGateWay(text) {
  var verbose = true;
  final BigInt keyN = BigInt.from(2476163479);
  final BigInt keyD = BigInt.from(308180633);
  final BigInt keyP = BigInt.from(61949);
  final BigInt keyQ = BigInt.from(39971);
  final BigInt keyE = BigInt.from(65537);

  final rsaPair = generateRSAkeyPair(
      bitLength: 32,
      initd: keyD,
      initQ: keyQ,
      initP: keyP,
      initE: keyE,
      initN: keyN);

  print(dumpRsaKeys(rsaPair, verbose: verbose));
  print(rsaPair.publicKey);
  print('Plaintext: $text\n');
  final bytes = utf8.encode(text);
  final cipherText = rsaEncrypt(rsaPair.publicKey, Uint8List.fromList(bytes));
  return bin2hex(cipherText, wrap: 64);
}

String decodeRsaGateWay(String text) {
  var verbose = true;
  final BigInt keyN = BigInt.from(2476163479);
  final BigInt keyD = BigInt.from(308180633);
  final BigInt keyP = BigInt.from(61949);
  final BigInt keyQ = BigInt.from(39971);
  final BigInt keyE = BigInt.from(65537);
  // Generate an RSA key pair

  final rsaPair = generateRSAkeyPair(
      bitLength: 32,
      initd: keyD,
      initQ: keyQ,
      initP: keyP,
      initE: keyE,
      initN: keyN);

  final decryptedBytes = rsaDecrypt(rsaPair.privateKey, hex2bin(text));

  if (isUint8ListEqual(decryptedBytes, hex2bin(text))) {
    if (verbose) {
      print('Decrypted:\n"${utf8.decode(decryptedBytes)}"');
      return utf8.decode(decryptedBytes);
    }
  } else {
    print('Decrypted:\n"${utf8.decode(decryptedBytes, allowMalformed: true)}"');
    return 'fail: decrypted does not match plaintext';
  }
  return 'fail: decrypted does not match plaintext';
}

void main() async {
  final HttpServer server = await HttpServer.bind("localhost", 8080);

  server.listen((HttpRequest event) async {
    try {
      if (event.uri.toString() == "/encode_gateway" ||
          event.uri.toString() == "/encode_bank") {
        if (event.uri.toString() == "/encode_gateway") {
          await utf8.decodeStream(event).then((body) => {
                event.response
                    .write(encodeRsaGateWay(jsonDecode(body)["message"]))
              });
        } else {
          await utf8.decodeStream(event).then((body) => {
                event.response.write(encodeRsaBank(jsonDecode(body)["message"]))
              });
        }
        print(event);
      } else if (event.uri.toString() == "/decode_bank" ||
          event.uri.toString() == "/decode_gateway") {
        if (event.uri.toString() == "/decode_bank") {
          await utf8.decodeStream(event).then((body) => {
                event.response.write(decodeRsaBank(jsonDecode(body)["message"]))
              });
        } else {
          await utf8.decodeStream(event).then((body) => {
                event.response
                    .write(decodeRsaGateWay(jsonDecode(body)["message"]))
              });
        }
        print(event);
      } else {
        event.response.write({"message": "bad request"});
      }
    } finally {
      event.response.close();
    }
  });
}

Uint8List hex2bin(String hexStr) {
  if (hexStr.length % 2 != 0) {
    throw const FormatException('not an even number of hexadecimal characters');
  }
  final result = Uint8List(hexStr.length ~/ 2);
  for (var i = 0; i < result.length; i++) {
    result[i] = int.parse(hexStr.substring(2 * i, 2 * (i + 1)), radix: 16);
  }
  return result;
}
