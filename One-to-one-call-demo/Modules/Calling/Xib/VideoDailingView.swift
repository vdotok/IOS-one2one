//
//  VideoView.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 09/06/2021.
//  Copyright © 2021 VDOTOK. All rights reserved.
//

import UIKit
import iOSSDKStreaming

protocol VideoDelegate: class {
   
    func didTapVideo(for baseSession: VTokBaseSession, state: VideoState)
    func didTapMute(for baseSession: VTokBaseSession, state: AudioState)
    func didTapEnd(for baseSession: VTokBaseSession)
    func didTapFlip(for baseSession: VTokBaseSession, type: CameraType)
    func didTapSpeaker(baseSession: VTokBaseSession, state: SpeakerState)
}

class VideoDailingView: UIView {
    
    @IBOutlet weak var localView: DraggableView! 
    @IBOutlet weak var remoteView: UIView!
    @IBOutlet weak var tryingStack: UIStackView!
    @IBOutlet weak var connectedStack: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var connectedUserName: UILabel!
    @IBOutlet weak var tryingUserName: UILabel!
    @IBOutlet weak var callState: UILabel!
    @IBOutlet weak var personAvatar: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var speakerButton: UIButton!
    
    weak var delegate: VideoDelegate?
    var session: VTokBaseSession?
    var users: [User]?
    private var counter: Int = 0
    private weak var timer: Timer?
    
    @IBAction func didTapVideo(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let baseSession = session else {return }
        localView.isHidden = sender.isSelected ? true : false
        cameraButton.isEnabled = sender.isSelected ? false : true
        delegate?.didTapVideo(for: baseSession, state: sender.isSelected ? .videoDisabled :.videoEnabled )
    }
    
    @IBAction func didTapMute(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let baseSession = session else {return }
        delegate?.didTapMute(for: baseSession, state: sender.isSelected ? .mute : .unMute)
    }
    
    @IBAction func didTapEnd(_ sender: UIButton) {
        guard let baseSession = session else {return }
        delegate?.didTapEnd(for: baseSession)
    }
    
    @IBAction func didTapFlip(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let baseSession = session else {return }
        delegate?.didTapFlip(for: baseSession, type: sender.isSelected ? .front : .rear)
    }
    
    @IBAction func didTapSpeaker(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let baseSession = session else {return }
        delegate?.didTapSpeaker(baseSession: baseSession , state: sender.isSelected ? .onSpeaker : .onEarPiece)
    }
    
    func configure( users: [User]) {
        tryingUserName.text = users.first?.fullName
        connectedUserName.text = users.first?.fullName
        self.users = users
        
        
    }
    
    func update(with baseSession: VTokBaseSession) {
        session = baseSession
        switch baseSession.state {
        case .busy:
            configureBusyState()
        case .calling:
            configureTryingState()
        case .connected:
            
            configureConnectedState()
        case .ringing:
            configureRinginState()
        case .invalidTarget:
            configureInvalidState()
        case .insufficientBalance:
            configureInsufficientBalance()
            
        default:
            break
        }
    }
    
    

    func updateLocal(view: UIView) {
            self.localView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.localView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo:self.localView.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.localView.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.localView.bottomAnchor)
        ])
    
    }
    
    func updateRemote(streams: [UserStream]) {
        guard let remoteStream = streams.filter({$0.streamDirection == .incoming}).first else {return}
        configureRemoteView(renderer: remoteStream.renderer)
        
        guard let localStream = streams.filter({$0.streamDirection == .outgoing}).first else {return}
        updateLocal(view: localStream.renderer)
        
    }
    
    func configureRemoteView(renderer: UIView) {
        for subView in remoteView.subviews {
            subView.removeFromSuperview()
        }
        remoteView.addSubview(renderer)
        renderer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            renderer.leadingAnchor.constraint(equalTo: self.remoteView.leadingAnchor),
            renderer.trailingAnchor.constraint(equalTo:self.remoteView.trailingAnchor),
            renderer.topAnchor.constraint(equalTo: self.remoteView.topAnchor),
            renderer.bottomAnchor.constraint(equalTo: self.remoteView.bottomAnchor)
        ])
    }
    
    func removeRemoteView() {
        for view in self.remoteView.subviews {
            view.removeFromSuperview()
        }
    }
    
    private func configureInsufficientBalance() {
        timeLabel.isHidden = true
        callState.text = "Insufficient funds..."
        tryingStack.isHidden = false
        connectedStack.isHidden = true
    }
    
    private func configureInvalidState() {
        timeLabel.isHidden = true
        callState.text = "Invalid target..."
        tryingStack.isHidden = false
        connectedStack.isHidden = true
    }
    private func configureBusyState() {
        timeLabel.isHidden = true
        callState.text = "User busy..."
        tryingStack.isHidden = false
        connectedStack.isHidden = true
    }
    
    private func configureTryingState() {
        timeLabel.isHidden = true
        callState.text = "Calling..."
        tryingStack.isHidden = false
        connectedStack.isHidden = true
        cameraButton.isEnabled = false
        speakerButton.isEnabled = false
    }
    
    private func configureConnectedState() {
        timeLabel.isHidden = false
        tryingStack.isHidden = true
        connectedStack.isHidden = false
        personAvatar.isHidden = true
        cameraButton.isEnabled = true
        speakerButton.isEnabled = true
        speakerButton.isSelected = true
        if timer == nil {
            configureTimer()
        }
       
    }
    private func configureRinginState() {
        timeLabel.isHidden = true
        callState.text = "Ringing..."
    }
    
    
    func update(stateInformation: StateInformation) {
        if stateInformation.videoInformation == 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {[weak self] in
                self?.remoteView.isHidden = false
                self?.personAvatar.isHidden = true
            }
          
            
        } else {
            remoteView.isHidden = true
            personAvatar.isHidden = false
        }
    }
    
    private func configureTimer() {
        timer?.invalidate()
        timer = nil
        counter = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc private func timerAction() {
        counter += 1
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: counter)
        var timeString = ""
        if h > 0 {
            timeString += intervalFormatter(interval: h) + ":"
        }
        timeString += intervalFormatter(interval: m) + ":" +
                        intervalFormatter(interval: s)
        timeLabel.text = timeString
    }
    
    private func intervalFormatter(interval: Int) -> String {
        if interval < 10 {
            return "0\(interval)"
        }
        return "\(interval)"
    }
    
    private func secondsToHoursMinutesSeconds (seconds :Int) -> (hours: Int, minutes: Int, seconds: Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    static func getView() -> VideoDailingView {
        let viewsArray = Bundle.main.loadNibNamed("VideoDailingView", owner: self, options: nil) as AnyObject as? NSArray
            guard (viewsArray?.count)! < 0 else{
                let view = viewsArray?.firstObject as! VideoDailingView
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }
        return VideoDailingView()
    }
   
}

