//  
//  CallingViewModel.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 09/06/2021.
//

import Foundation
import iOSSDKStreaming
import  AVFoundation

enum CallState {
    case calling
    case ringing
    case connected
    case busy
}


typealias CallingViewModelOutput = (CallingViewModelImpl.Output) -> Void

protocol CallingViewModelInput {
    
    var screenType: ScreenType {get set}
    func rejectCall(session: VTokBaseSession)
    func acceptCall(session: VTokBaseSession, user: [User])
    func hangupCall(session: VTokBaseSession)
    func flipCamera(session: VTokBaseSession, state: CameraType)
    func mute(session: VTokBaseSession, state: AudioState)
    func speaker(session: VTokBaseSession, state: SpeakerState)
    func disableVideo(session: VTokBaseSession, state: VideoState)
    
    
}

protocol CallingViewModel: CallingViewModelInput {
    var output: CallingViewModelOutput? { get set}
    
    func viewModelDidLoad()
    func viewModelWillAppear()
}

class CallingViewModelImpl: CallingViewModel, CallingViewModelInput {

    private let router: CallingRouter
    var output: CallingViewModelOutput?
    var screenType: ScreenType
    var vtokSdk: VTokSDK
    var users: [User]?
    var session: VTokBaseSession?
    var player: AVAudioPlayer?
    
    init(router: CallingRouter, screenType: ScreenType, vtokSdk: VTokSDK, users: [User]? = nil, session: VTokBaseSession? = nil) {
        self.router = router
        self.screenType = screenType
        self.vtokSdk = vtokSdk
        self.users = users
        self.session = session
    }
    
    func viewModelDidLoad() {
        if let baseSession = session, baseSession.state == .receivedSessionInitiation {
            vtokSdk.set(sessionDelegate: self, for: baseSession)
        }
        loadViews()
    }
    
    func viewModelWillAppear() {
        
    }
    
    //For all of your viewBindings
    enum Output {
        case loadVideoView(user: [User])
        case loadAudioView(user: [User])
        case loadIncomignCall(user: [User], session: VTokBaseSession)
        case udapteAudio(baseSession: VTokBaseSession)
        case dismissCallView
        case updateLocalView(session: VTokBaseSession,view: UIView)
        case updateRemoteView(session: VTokBaseSession, view: UIView)
        case update(Session: VTokBaseSession)
        case updateState(information: StateInformation)
        case removeRemoteView
        
        
    }
}

extension CallingViewModelImpl {
    func loadViews() {
        guard let users = users else {return}
        
        switch screenType {
        case .audioView:
            output?(.loadAudioView(user: users))
            callToParticipants(with: .audioCall)

        case .videoView:
            output?(.loadVideoView(user: users))
            callToParticipants(with: .videoCall)
           
            
        case .incomingCall:
            guard let baseSession = session else {return}
            output?(.loadIncomignCall(user: users, session: baseSession))
            playSound()
        }
    }
    
    func callToParticipants(with mediaType: SessionMediaType) {
        guard let user = VDOTOKObject<UserResponse>().getData(), let refID = user.refID else {return}
        guard let users = users else {return}
        let refIds = users.map({$0.refID})
        let requestID = getRequestId()
        let session = VTokBaseSessionInit(from: refID, to: refIds, sessionUUID: requestID, sessionMediaType: mediaType ,callType: .onetoone, connectedUsers: [])
        vtokSdk.initiate(session: session, sessionDelegate: self)
    }
    func getRequestId() -> String {
        let generatable = IdGenerator()
        guard let response = VDOTOKObject<UserResponse>().getData() else {return ""}
        let timestamp = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timestamp)
        let time = Date(timeIntervalSince1970: TimeInterval(myTimeInterval)).stringValue()
        let tenantId = "12345"
        let token = generatable.getUUID(string: time + tenantId + response.refID!)
        return token
        
    }
    
}

extension CallingViewModelImpl: SessionDelegate {
    func didGetPublicUrl(for session: VTokBaseSession, with url: String) {
    }
    
    func configureLocalViewFor(session: VTokBaseSession, renderer: UIView) {
        output?(.updateLocalView(session: session, view: renderer))
    }
    
    func configureRemoteViews(for session: VTokBaseSession, with streams: [UserStream]) {
        guard let view = streams.first?.renderer else {return}
        output?(.updateRemoteView(session: session, view: view))
    }
    
    func stateDidUpdate(for session: VTokBaseSession) {
        switch session.state {
        case .ringing:
            output?(.update(Session: session))
        case .connected:
            stopSound()
            switch session.sessionMediaType {
            case .audioCall:
                output?(.udapteAudio(baseSession: session))
                break
            case .videoCall:
                output?(.update(Session: session))
                break
            }
        case .rejected:
            output?(.dismissCallView)
            stopSound()
        case .missedCall:
            DispatchQueue.main.async {[weak self] in
                self?.output?(.dismissCallView)
            }
            stopSound()
        case .hangup:
            DispatchQueue.main.async {[weak self] in
                self?.output?(.dismissCallView)
            }
        case .tryingToConnect:
            switch session.sessionMediaType {
            case .audioCall:
                output?(.udapteAudio(baseSession: session))
            case .videoCall:
                output?(.update(Session: session))
          
            }
        case .invalidTarget:
            output?(.update(Session: session))
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
                self?.output?(.dismissCallView)
            })
        default:
            break
        }
    }
    
    
}

extension CallingViewModelImpl {
    func rejectCall(session: VTokBaseSession) {
        vtokSdk.reject(session: session)
        output?(.dismissCallView)
        stopSound()
    }
    
    func acceptCall(session: VTokBaseSession, user: [User]) {
        
        stopSound()
        switch session.sessionMediaType {
        case .audioCall:
            output?(.loadAudioView(user: user))
        case .videoCall:
            output?(.loadVideoView(user: user))
      
        }

        vtokSdk.accept(session: session)
        
    }
    
    func setSessionDelegate() {
        guard let baseSession = session else {return}
        vtokSdk.set(sessionDelegate: self, for: baseSession)
    }
    
    func flipCamera(session: VTokBaseSession, state: CameraType) {
        
        vtokSdk.switchCamera(session: session, to: state)
    }
    
    func hangupCall(session: VTokBaseSession) {
        vtokSdk.hangup(session: session)
        output?(.dismissCallView)
        stopSound()
    }
    
    func speaker(session: VTokBaseSession, state: SpeakerState) {
        vtokSdk.speaker(session: session, state: state)
    }
    
    func mute(session: VTokBaseSession, state: AudioState) {
        vtokSdk.mute(session: session, state: state)
    }
    
    func disableVideo(session: VTokBaseSession, state: VideoState) {
        vtokSdk.disableVideo(session: session, State: state)
    }
    
    func stopSound() {
        player?.stop()
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "iphone_11_pro", withExtension: "mp3") else {
            print("url not found")
            return
        }

        do {
            /// this codes for making this app ready to takeover the device audio
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)

            /// change fileTypeHint according to the type of your audio file (you can omit this)

            /// for iOS 11 onward, use :
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /// else :
            /// player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3)

            // no need for prepareToPlay because prepareToPlay is happen automatically when calling play()
            player!.numberOfLoops = 3
            player!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
}
