library src.registry.impl;

import 'package:test_rsa_lib/export.dart';
import 'package:test_rsa_lib/src/registry/registry.dart';

void registerFactories(FactoryRegistry registry) {
  _registerAsymmetricCiphers(registry);
  _registerDigests(registry);
  _registerKeyGenerators(registry);
  _registerPaddings(registry);
  _registerRandoms(registry);
}

void _registerAsymmetricCiphers(FactoryRegistry registry) {
  registry.register(RSAEngine.factoryConfig);
}

void _registerDigests(FactoryRegistry registry) {
  registry.register(SHA1Digest.factoryConfig);
  registry.register(SHA256Digest.factoryConfig);
}

void _registerKeyGenerators(FactoryRegistry registry) {
  registry.register(RSAKeyGenerator.factoryConfig);
}

void _registerPaddings(FactoryRegistry registry) {}

void _registerRandoms(FactoryRegistry registry) {
  registry.register(AutoSeedBlockCtrRandom.factoryConfig);
  registry.register(BlockCtrRandom.factoryConfig);
  registry.register(FortunaRandom.factoryConfig);
}
