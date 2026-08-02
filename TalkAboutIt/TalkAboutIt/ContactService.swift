// ContactService.swift
class ContactService {
    static func fetchContacts() async throws -> [User] {
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: User.self) }
    }
    
    static func addContact(uid: String) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(currentUID)
            .updateData(["contacts": FieldValue.arrayUnion([uid])])
    }
}