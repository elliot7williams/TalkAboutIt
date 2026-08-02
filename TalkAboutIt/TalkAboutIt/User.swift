// User.swift
struct User: Codable, Identifiable {
    @DocumentID var id: String?
    let name: String
    let email: String
    let uid: String
}