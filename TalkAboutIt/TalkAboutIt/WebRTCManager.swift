// WebRTCManager.swift
import WebRTC

class WebRTCManager: NSObject {
    private var peerConnection: RTCPeerConnection?
    private let factory: RTCPeerConnectionFactory
    private var localVideoTrack: RTCVideoTrack?
    private var remoteVideoTrack: RTCVideoTrack?
    
    override init() {
        factory = RTCPeerConnectionFactory()
        super.init()
    }
    
    func setupLocalVideo() -> RTCVideoTrack {
        let videoSource = factory.videoSource()
        localVideoTrack = factory.videoTrack(with: videoSource, trackId: "video0")
        
        // Setup camera
        let capturer = RTCCameraVideoCapturer(delegate: videoSource)
        guard let frontCamera = (RTCCameraVideoCapturer.captureDevices().first { $0.position == .front }) else { return localVideoTrack! }
        
        let format = RTCCameraVideoCapturer.supportedFormats(for: frontCamera).last!
        capturer.startCapture(with: frontCamera, format: format, fps: 30)
        
        return localVideoTrack!
    }
    
    func createPeerConnection() {
        let config = RTCConfiguration()
        config.iceServers = [RTCIceServer(urlStrings: ["stun:stun.l.google.com:19302"])]
        
        let constraints = RTCMediaConstraints(
            mandatoryConstraints: nil,
            optionalConstraints: nil
        )
        
        peerConnection = factory.peerConnection(with: config, constraints: constraints, delegate: self)
    }
    
    func createOffer() async throws -> RTCSessionDescription {
        let constraints = RTCMediaConstraints(
            mandatoryConstraints: [
                "OfferToReceiveVideo": "true",
                "OfferToReceiveAudio": "true"
            ],
            optionalConstraints: nil
        )
        
        let offer = try await peerConnection!.offer(for: constraints)
        try await peerConnection!.setLocalDescription(offer)
        return offer
    }
}

extension WebRTCManager: RTCPeerConnectionDelegate {
    func peerConnection(_ peerConnection: RTCPeerConnection, didChange stateChanged: RTCSignalingState) {}
    
    func peerConnection(_ peerConnection: RTCPeerConnection, didAdd stream: RTCMediaStream) {
        if let track = stream.videoTracks.first {
            remoteVideoTrack = track
        }
    }
}