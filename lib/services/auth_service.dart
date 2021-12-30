import 'package:canary_chat/models/user_data.dart';
import 'package:canary_chat/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserData? _userFromFirebase(User? user) {
    return user != null ? UserData(userId: user.uid) : null;
  }

  Stream<User?> get userState => _auth.authStateChanges();

  String? currentUserID() {
    return _auth.currentUser?.uid;
  }

  String? currentName() {
    return _auth.currentUser?.displayName;
  }

  String? currentEmail() {
    return _auth.currentUser?.email;
  }

  Future signIn(String email, String password, Function(String) onError) async {
    try {
      UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      return user;
    }

    on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        onError('Không tìm thấy tài khoản.');
      } else if (e.code == 'wrong-password') {
        onError('Sai mật khẩu.');
      } else if (e.code == 'invalid-email') {
        onError('Email không hợp lệ');
      }
    }

    catch (e) {
      print(e);
    }
  }

  final _firestore = FireStoreService();

  Future signUp({
    required String name,
    required String email,
    required String password,
    required Function(String) onError,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      final userData = UserData(userId: user!.uid, name: name, email: email);
      user.updateDisplayName(name);
      _firestore.uploadUserInfo(userData);
      return _userFromFirebase(user);
    }

    on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        onError("Mật khẩu quá yếu.");
      } else if (e.code == 'email-already-in-use') {
        onError('Tài khoản đã tồn tại.');
      } else if (e.code == 'invalid-email') {
        onError('Email không hợp lệ');
      }
    }

    catch (e) {
      print(e);
    }
  }

  Future signOut() async {
    await _auth.signOut();
  }
}
