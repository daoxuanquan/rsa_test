library src.registry.impl;

import 'package:test_rsa_lib/export.dart';
import 'package:test_rsa_lib/src/registry/registry.dart';

void registerFactories(FactoryRegistry registry) {
  _registerAsymmetricCiphers(registry);
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


void _registerDigests(FactoryRegistry registry) {
  registry.register(SHA1Digest.factoryConfig);
  registry.register(SHA256Digest.factoryConfig);
  registry.register(SHA512Digest.factoryConfig);
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

