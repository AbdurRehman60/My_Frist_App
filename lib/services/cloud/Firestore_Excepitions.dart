import 'package:flutter/foundation.dart';

@immutable
class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CloudNotCreatNoteException extends CloudStorageException {}

class CloudNoteGetAllException extends CloudStorageException {}

class CloudNotUpdateNoteException extends CloudStorageException {}

class CloudNoteDeletNoteException extends CloudStorageException {}
