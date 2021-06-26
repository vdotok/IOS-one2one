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
        guard let users = users else {return}
        let refIds = users.map({$0.refID})
        vtokSdk.makeCall(to: refIds, sessionDelegate: self, with: mediaType)
    }
}

extension CallingViewModelImpl: SessionDelegate {
    func sessionDidConnnect(session: VTokBaseSession) {
        stopSound()
        switch session.sessionMediaType {
        case .audioCall:
            output?(.udapteAudio(baseSession: session))
            break
        case .videoCall:
            output?(.update(Session: session))
            break
        case .screenshare:
            break
        }
        
    }
    
    func sessionDidFail(session: VTokBaseSession, error: Error) {
        
    }
    
    func sessionDidDisconnect(session: VTokBaseSession, error: Error?) {
        
    }
    
    func sessionWasRejected(session: VTokBaseSession, message: String) {
        output?(.dismissCallView)
        stopSound()
    }
    
    func userBusyFor(session: VTokBaseSession, message: String) {
        
        output?(.update(Session: session))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            self?.output?(.dismissCallView)
        })
    }
    
    func sessionDidHangUp(session: VTokBaseSession, message: String) {
        DispatchQueue.main.async {[weak self] in
            
            self?.output?(.dismissCallView)
        }
       
    }
    
    func configureLocalViewFor(session: VTokBaseSession, renderer: UIView) {
        output?(.updateLocalView(session: session, view: renderer))
    }
    
    func configureRemoteFor(session: VTokBaseSession, renderer: UIView) {
        output?(.updateRemoteView(session: session, view: renderer))
    }
    
    func configureRemoteViews(for streams: [UserStream]) {
        
    }
    
    
    func remoteParticipantDidRemove() {
        
    }
    
    func handle(stateInformation: StateInformation, for session: VTokBaseSession) {
        switch session.sessionMediaType {
        case .audioCall:
            break
        case .videoCall:
            output?(.updateState(information: stateInformation))
        default:
            break
        }
    }
    
    func sessionTryingToConnect(session: VTokBaseSession) {
        
        switch session.sessionMediaType {
        case .audioCall:
            output?(.udapteAudio(baseSession: session))
        case .videoCall:
            output?(.update(Session: session))
        default:
            break
        }
    }
    
    func sessionMissed(session: VTokBaseSession, message: String) {
        DispatchQueue.main.async {[weak self] in
            self?.output?(.dismissCallView)
        }
        stopSound()
    }
    
    func sessionRinging(session: VTokBaseSession, message: String) {
        output?(.update(Session: session))
    }
    
    func invalid(session: VTokBaseSession, message: String) {
        output?(.update(Session: session))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { [weak self] in
            self?.output?(.dismissCallView)
        })
    }
    
    func sessionDidUpdate(session: VTokBaseSession) {
        
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
        default:
            break
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
