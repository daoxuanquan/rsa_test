part of api;

class RegistryFactoryException implements Exception {
  final String message;

  RegistryFactoryException(this.message);

  RegistryFactoryException.unknown(String algorithm, [Type? type])
      : this('No algorithm registered' +
            (type != null ? ' of type $type' : '') +
            ' with name: $algorithm');

  RegistryFactoryException.invalid(String algorithm, [Type? type])
      : this('Algorithm name $algorithm is invalid' +
            (type != null ? ' of type $type' : ''));

  @override
  String toString() => 'RegistryFactoryException: $message';
}
