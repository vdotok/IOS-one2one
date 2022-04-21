//
//  AvailableDevicesController.swift
//  One-to-one-call-demo
//
//  Created by usama farooq on 15/04/2022.
//  Copyright © 2022 VDOTOK. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol AvailableDeviceDelegate: AnyObject {
    func didSelect(peer: MCPeerID)
}

class AvailableDevicesController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var peerID: [MCPeerID] = []
    weak var delegate: AvailableDeviceDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "AvailableDeviceCell", bundle: nil), forCellReuseIdentifier: "AvailableDeviceCell")
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapDismiss() {
        self.dismiss(animated: true)
    }
}

extension AvailableDevicesController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peerID.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvailableDeviceCell", for: indexPath) as! AvailableDeviceCell
        cell.configure(with: peerID[indexPath.row].displayName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPeer = peerID[indexPath.row]
        delegate?.didSelect(peer: selectedPeer)
        self.dismiss(animated: true)
    }
}
