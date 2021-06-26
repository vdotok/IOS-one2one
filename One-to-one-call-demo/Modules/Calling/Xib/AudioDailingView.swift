//
//  AudioView.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 09/06/2021.
//

import UIKit
import iOSSDKStreaming
protocol AudioDelegate: class {
    func didTapHangUp(VTokBaseSession: VTokBaseSession)
    func didTapMuteFor(VTokBaseSession: VTokBaseSession, state: AudioState)
    func didTapSpeakerFor(VTokBaseSession: VTokBaseSession, state: SpeakerState)
}

class AudioDailingView: UIView {
    @IBOutlet weak var tryingUserName: UILabel!
    @IBOutlet weak var connectedUserName: UILabel!
    @IBOutlet weak var tryingStack: UIStackView!
    @IBOutlet weak var connectedStack: UIStackView!
    @IBOutlet weak var callState: UILabel!
    @IBOutlet weak var callTime: UILabel!
    @IBOutlet weak var speakerButton: UIButton!
    weak var delegate: AudioDelegate?
    private var counter: Int = 0
    private weak var timer: Timer?
    var VTokBaseSession: VTokBaseSession?
    
    @IBAction func didTapEnd(_ sender: UIButton) {
        guard let VTokBaseSession = VTokBaseSession else {return}
        delegate?.didTapHangUp(VTokBaseSession: VTokBaseSession)
    }
    
    @IBAction func didTapMute(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let VTokBaseSession = VTokBaseSession else {return}
        delegate?.didTapMuteFor(VTokBaseSession: VTokBaseSession, state: sender.isSelected ? .mute : .unMute)
    }
    
    @IBAction func didTapSpeaker(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        guard let VTokBaseSession = VTokBaseSession else {return}
        delegate?.didTapSpeakerFor(VTokBaseSession: VTokBaseSession, state: sender.isSelected ? .onSpeaker : .onEarPiece)
    }
    
    func configure(with user: [User]) {
        tryingUserName.text = user.first?.fullName
        connectedUserName.text = user.first?.fullName
    }
    
    func update(with session:  VTokBaseSession) {
        VTokBaseSession = session
        switch session.state {
        case .busy:
            configureBusyState() 
        case .calling:
            configureTryingState()
            break
        case .connected:
            configureConnectedState()
            break
        case .ringing:
            configureRinginState()
        case .invalidTarget:
            configureInvalidState()
            break
        default:
        break
        }
    }
    
    private func configureInvalidState() {
        callTime.isHidden = true
        callState.text = "Invalid target..."
        tryingStack.isHidden = false
        connectedStack.isHidden = true
    }
    
    private func configureBusyState() {
        callTime.isHidden = true
        callState.text = "User busy..."
        tryingStack.isHidden = false
        connectedStack.isHidden = true
    }
    
    private func configureTryingState() {
        callTime.isHidden = true
        callState.text = "Calling..."
        tryingStack.isHidden = false
        connectedStack.isHidden = true
        
    }
    
    private func configureConnectedState() {
        callTime.isHidden = false
        tryingStack.isHidden = true
        connectedStack.isHidden = false
        speakerButton.isSelected = false
        configureTimer()
    }
    private func configureRinginState() {
        callTime.isHidden = true
        callState.text = "Ringing..."
        speakerButton.isSelected = false
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
        callTime.text = timeString
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
    
    static func getView() -> AudioDailingView {
        let viewsArray = Bundle.main.loadNibNamed("AudioDailingView", owner: self, options: nil) as AnyObject as? NSArray
            guard (viewsArray?.count)! < 0 else{
                let view = viewsArray?.firstObject as! AudioDailingView
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }
        return AudioDailingView()
    }

}
