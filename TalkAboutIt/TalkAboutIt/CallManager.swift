// CallManager.swift
class CallManager: ObservableObject {
    @Published var inCall = false
    @Published var isVideoEnabled = true
    @Published var remoteUser: User?
    
    private let webRTCManager = WebRTCManager()
    private let signalingService = SignalingService()
    
    func startCall(with user: User) async {
        remoteUser = user
        webRTCManager.createPeerConnection()
        
        do {
            let offer = try await webRTCManager.createOffer()
            signalingService.sendOffer(to: user.uid, sdp: offer)
            inCall = true
        } catch {
            print("Offer creation failed: \(error)")
        }
    }
    
    func endCall() {
        // Cleanup WebRTC resources
        inCall = false
    }
}