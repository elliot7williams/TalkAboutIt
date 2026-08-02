// AuthService.swift
import FirebaseAuth

class AuthService {
    static func signUp(email: String, password: String, name: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        try await Firestore.firestore().collection("users").document(result.user.uid).setData([
            "name": name,
            "email": email,
            "uid": result.user.uid
        ])
    }
    
    static func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }
}