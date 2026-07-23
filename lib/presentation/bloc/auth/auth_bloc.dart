import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthBloc({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginRequestedEvent>(_onLoginRequested);
    on<RegisterRequestedEvent>(_onRegisterRequested);
    on<GoogleSignInRequestedEvent>(_onGoogleSignInRequested);
    on<LogoutRequestedEvent>(_onLogoutRequested);
  }

  void _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  void _onLoginRequested(LoginRequestedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      if (userCredential.user != null) {
        emit(Authenticated(userCredential.user!));
      } else {
        emit(const AuthError('Login failed.'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'An unknown error occurred.'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onRegisterRequested(RegisterRequestedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(event.name);
        emit(Authenticated(userCredential.user!));
      } else {
        emit(const AuthError('Registration failed.'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'An unknown error occurred.'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onGoogleSignInRequested(GoogleSignInRequestedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(Unauthenticated()); // User canceled the sign-in
        return;
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      if (userCredential.user != null) {
        emit(Authenticated(userCredential.user!));
      } else {
        emit(const AuthError('Google Sign-In failed.'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'An unknown error occurred.'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onLogoutRequested(LogoutRequestedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
    emit(Unauthenticated());
  }
}
