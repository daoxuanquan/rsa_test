library src.registry.impl;

import 'package:test_rsa_lib/export.dart';
import 'package:test_rsa_lib/src/registry/registry.dart';

void registerFactories(FactoryRegistry registry) {
  _registerAsymmetricCiphers(registry);
  _registerKeyGenerators(registry);
  _registerPaddings(registry);
}

void _registerAsymmetricCiphers(FactoryRegistry registry) {
  registry.register(RSAEngine.factoryConfig);
}

void _registerKeyGenerators(FactoryRegistry registry) {
  registry.register(RSAKeyGenerator.factoryConfig);
}

void _registerPaddings(FactoryRegistry registry) {}
