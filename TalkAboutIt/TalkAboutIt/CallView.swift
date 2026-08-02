// CallView.swift
struct CallView: View {
    @ObservedObject var callManager: CallManager
    let localVideoView: UIViewRepresentable
    let remoteVideoView: UIViewRepresentable

    var body: some View {
        ZStack {
            remoteVideoView
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                localVideoView
                    .frame(width: 120, height: 160)
                    .cornerRadius(8)
                    .padding()
                
                Spacer()
                
                HStack {
                    Button(action: callManager.endCall) {
                        Image(systemName: "phone.down.fill")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .clipShape(Circle())
                    }
                    
                    Button(action: { callManager.isVideoEnabled.toggle() }) {
                        Image(systemName: callManager.isVideoEnabled ? "video" : "video.slash")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray)
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }
}