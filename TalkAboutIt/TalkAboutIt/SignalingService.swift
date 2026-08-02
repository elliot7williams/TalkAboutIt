// SignalingService.swift
class SignalingService {
    private var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference()
    }
    
    func sendOffer(to userId: String, sdp: RTCSessionDescription) {
        let offerData: [String: Any] = [
            "type": "offer",
            "sdp": sdp.sdp
        ]
        ref.child("signaling/\(userId)/offer").setValue(offerData)
    }
    
    func listenForOffers(completion: @escaping (RTCSessionDescription) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ref.child("signaling/\(uid)/offer").observe(.value) { snapshot in
            guard let data = snapshot.value as? [String: Any],
                  let sdp = data["sdp"] as? String else { return }
            
            let offer = RTCSessionDescription(type: .offer, sdp: sdp)
            completion(offer)
        }
    }
}