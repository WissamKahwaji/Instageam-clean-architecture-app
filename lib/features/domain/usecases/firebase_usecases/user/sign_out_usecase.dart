import '../../../repository/firebase_repository.dart';

class SignOutUserUseCase {
  final FirebaseRepository repository;

  SignOutUserUseCase({required this.repository});

  Future<void> call() {
    return repository.signOut();
  }
}
