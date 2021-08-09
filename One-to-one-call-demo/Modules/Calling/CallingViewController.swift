//  
//  CallingViewController.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 09/06/2021.
//

import UIKit
import iOSSDKStreaming

public class CallingViewController: UIViewController {

    var viewModel: CallingViewModel!
    var audioView: AudioDailingView?
    var videoView: VideoDailingView?
    var incomingCallView: IncomingCall?
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        bindViewModel()
        viewModel.viewModelDidLoad()
    }
    
    deinit {
        print("calling viewcontroller destroyed")
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewModelWillAppear()
    }
    
    fileprivate func bindViewModel() {

        viewModel.output = { [unowned self] output in
            //handle all your bindings here
            switch output {
            case .loadAudioView(let users):
                incomingCallView?.removeFromSuperview()
                loadAudioView(with: users)
            case .loadVideoView(let users):
                loadVideoView(users: users)
            case .loadIncomignCall(let users, let baseSession):
                loadIncomingCallView(users: users, baseSession: baseSession)
            case .udapteAudio(let state):
                audioView?.update(with: state)
            case .update(let baseSession):
                update(baseSession: baseSession)
            case .updateLocalView(let session, let localView):
                    videoView?.updateLocal(view: localView)
            case .updateRemoteView(let session, let remoteView):
                videoView?.updateRemote(view: remoteView)
            case .removeRemoteView:
                videoView?.removeRemoteView()
            case .updateState(let stateInformation):
                videoView?.update(stateInformation: stateInformation)
            break
            case .dismissCallView:
                self.dismiss(animated: true, completion: nil)
              
            default:
                break
            }
        }
    }
    
    private func update(baseSession: VTokBaseSession) {
        switch baseSession.sessionMediaType {
        case .audioCall:
            audioView?.update(with: baseSession)
        case .videoCall:
            videoView?.update(with: baseSession)
        }
    }
    

}

extension CallingViewController {
    func configureAppearance() {
     
        
    }
    
    private func loadAudioView(with users: [User]) {
        let view = AudioDailingView.getView()
        view.configure(with: users)
        view.delegate = self
        self.audioView = view
        guard let audioView = self.audioView else { return }
        audioView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(audioView)
        
        NSLayoutConstraint.activate([
            audioView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            audioView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor),
            audioView.topAnchor.constraint(equalTo: self.view.topAnchor),
            audioView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func loadVideoView(users: [User]) {
        let view = VideoDailingView.getView()
        view.configure(users: users)
        view.delegate = self
        self.videoView = view
        guard let videoView = self.videoView else { return }
        videoView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(videoView)
        
        NSLayoutConstraint.activate([
            videoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor),
            videoView.topAnchor.constraint(equalTo: self.view.topAnchor),
            videoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func loadIncomingCallView(users: [User], baseSession: VTokBaseSession) {
        let view = IncomingCall.loadView()
        view.configureView(with: users, and: baseSession)
        view.delegate = self
        self.incomingCallView = view
        guard let incomingCallView = self.incomingCallView else{return}
        incomingCallView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(incomingCallView)
        
        NSLayoutConstraint.activate([
            incomingCallView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            incomingCallView.trailingAnchor.constraint(equalTo:self.view.trailingAnchor),
            incomingCallView.topAnchor.constraint(equalTo: self.view.topAnchor),
            incomingCallView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
}


extension CallingViewController: AudioDelegate {
    func didTapHangUp(VTokBaseSession baseSession: VTokBaseSession) {
        viewModel.hangupCall(session: baseSession)
    }
    
    func didTapMuteFor(VTokBaseSession baseSession: VTokBaseSession, state: AudioState) {
        viewModel.mute(session: baseSession, state: state)
    }
    
    func didTapSpeakerFor(VTokBaseSession baseSession: VTokBaseSession, state: SpeakerState) {
        viewModel.speaker(session: baseSession, state: state)
    }
    
    
  
}

extension CallingViewController: VideoDelegate {
    
    func didTapVideo(for baseSession: VTokBaseSession, state: VideoState) {
        viewModel.disableVideo(session: baseSession, state: state)
    }
    
    func didTapMute(for baseSession: VTokBaseSession, state: AudioState) {
        viewModel.mute(session: baseSession, state: state)
    }
    
    func didTapEnd(for baseSession: VTokBaseSession) {
        viewModel.hangupCall(session: baseSession)
    }
    
    func didTapFlip(for baseSession: VTokBaseSession, type: CameraType) {
        viewModel.flipCamera(session: baseSession, state: type)
    }
    
    func didTapSpeaker(baseSession: VTokBaseSession, state: SpeakerState) {
        viewModel.speaker(session: baseSession, state: state)
    }
    
    
}

extension CallingViewController: IncomingCallDelegate {
    func didReject(session: VTokBaseSession) {
        viewModel.rejectCall(session: session)
    }
    
    func didAccept(session: VTokBaseSession, users: [User]) {
        viewModel.acceptCall(session: session, user: users)
    }

    
}
