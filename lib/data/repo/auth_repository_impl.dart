import '../../domain/entity/auth_user.dart';
import '../../domain/repo/auth_repository.dart';
import '../model/auth_user_model.dart';
import '../sources/remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<AuthUser> login(String email, String password) async {
    AuthUserModel userModel = await remoteDataSource.login(email, password);
    return AuthUser(
      id: userModel.id,
      email: userModel.email,
    );
  }

  @override
  Future<AuthUser> signUp(String email, String password) async {
    AuthUserModel userModel = await remoteDataSource.signUp(email, password);
    return AuthUser(
      id: userModel.id,
      email: userModel.email,
    );
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }
}
