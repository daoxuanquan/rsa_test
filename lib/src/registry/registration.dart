library src.registry.impl;

import 'package:test_rsa_lib/block/aes.dart';
import 'package:test_rsa_lib/digests/sm3.dart';
import 'package:test_rsa_lib/export.dart';
import 'package:test_rsa_lib/src/registry/registry.dart';

void registerFactories(FactoryRegistry registry) {
  _registerAsymmetricCiphers(registry);
  _registerBlockCiphers(registry);
  _registerDigests(registry);
  _registerKeyGenerators(registry);
  _registerPaddedBlockCiphers(registry);
  _registerPaddings(registry);
  _registerRandoms(registry);
  _registerSigners(registry);
}

void _registerAsymmetricCiphers(FactoryRegistry registry) {
  registry.register(OAEPEncoding.factoryConfig);
  registry.register(PKCS1Encoding.factoryConfig);
  registry.register(RSAEngine.factoryConfig);
}

void _registerBlockCiphers(FactoryRegistry registry) {
  registry.register(AESEngine.factoryConfig);

  // modes
  registry.register(CBCBlockCipher.factoryConfig);
  registry.register(CFBBlockCipher.factoryConfig);
  registry.register(ECBBlockCipher.factoryConfig);
  registry.register(GCTRBlockCipher.factoryConfig);
  registry.register(OFBBlockCipher.factoryConfig);
  registry.register(GCMBlockCipher.factoryConfig);
  registry.register(IGEBlockCipher.factoryConfig);
}

void _registerDigests(FactoryRegistry registry) {
  registry.register(Blake2bDigest.factoryConfig);
  registry.register(MD2Digest.factoryConfig);
  registry.register(MD4Digest.factoryConfig);
  registry.register(MD5Digest.factoryConfig);
  registry.register(RIPEMD128Digest.factoryConfig);
  registry.register(RIPEMD160Digest.factoryConfig);
  registry.register(RIPEMD256Digest.factoryConfig);
  registry.register(RIPEMD320Digest.factoryConfig);
  registry.register(SHA1Digest.factoryConfig);
  registry.register(SHA3Digest.factoryConfig);
  registry.register(KeccakDigest.factoryConfig);
  registry.register(SHA224Digest.factoryConfig);
  registry.register(SHA256Digest.factoryConfig);
  registry.register(SHA384Digest.factoryConfig);
  registry.register(SHA512Digest.factoryConfig);
  registry.register(SHA512tDigest.factoryConfig);
  registry.register(TigerDigest.factoryConfig);
  registry.register(WhirlpoolDigest.factoryConfig);
  registry.register(SHAKEDigest.factoryConfig);
  registry.register(CSHAKEDigest.factoryConfig);
  registry.register(SM3Digest.factoryConfig);
}

void _registerKeyGenerators(FactoryRegistry registry) {
  registry.register(RSAKeyGenerator.factoryConfig);
}

void _registerPaddedBlockCiphers(FactoryRegistry registry) {
  registry.register(PaddedBlockCipherImpl.factoryConfig);
}

void _registerPaddings(FactoryRegistry registry) {
  registry.register(PKCS7Padding.factoryConfig);
  registry.register(ISO7816d4Padding.factoryConfig);
}

void _registerRandoms(FactoryRegistry registry) {
  registry.register(AutoSeedBlockCtrRandom.factoryConfig);
  registry.register(BlockCtrRandom.factoryConfig);
  registry.register(FortunaRandom.factoryConfig);
}

void _registerSigners(FactoryRegistry registry) {
  registry.register(RSASigner.factoryConfig);
}

