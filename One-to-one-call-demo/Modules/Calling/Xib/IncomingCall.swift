//
//  IncomingCall.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 09/06/2021.
//

import UIKit
import iOSSDKStreaming

protocol IncomingCallDelegate: class {
    func didReject(session: VTokBaseSession)
    func didAccept(session: VTokBaseSession, users: [User])
}

class IncomingCall: UIView {
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var title: UILabel!
    
    weak var delegate: IncomingCallDelegate?
    var session: VTokBaseSession?
    var users: [User]!
    
    
    
    func configureView(with users: [User], and baseSession: VTokBaseSession) {
        self.userName.text = users.first?.fullName
        self.session = baseSession
        self.users = users
        
        switch baseSession.sessionMediaType {
        case .audioCall:
            title.text = "Incoming Audio Call from"
            acceptButton.setImage(UIImage(named: "Accept"), for: .normal)
            break
        case .videoCall:
            title.text = "Incoming Video Call from"
            acceptButton.setImage(UIImage(named: "StopVideo"), for: .normal)
        default:
            break
        }
    }
    
    @IBAction func didTapAccept(_ sender: UIButton) {
        guard let sessionRequest = session else {return}
        delegate?.didAccept(session: sessionRequest, users: users)
    }
    
    @IBAction func didTapReject(_ sender: UIButton) {
        guard let sessionRequest = session else {return}
        delegate?.didReject(session: sessionRequest)
    }

    static func loadView() -> IncomingCall {
        let viewsArray = Bundle.main.loadNibNamed("IncomingCall", owner: self, options: nil) as AnyObject as? NSArray
            guard (viewsArray?.count)! < 0 else{
                let view = viewsArray?.firstObject as! IncomingCall
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }
        return IncomingCall()
    }

}
