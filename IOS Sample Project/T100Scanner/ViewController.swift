//
//  ViewController.swift
//  T100Scanner
//
//  Created by Shane Cowherd on 1/31/16.
//  Copyright © 2016 Shane Cowherd. All rights reserved.
//

import UIKit
import CocoaAsyncSocket

class ViewController: UIViewController, GCDAsyncUdpSocketDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBAction func clearServers(sender: AnyObject) {
        self.servers.removeAll()
    }
    @IBOutlet weak var tableView: UITableView!
    var servers = Dictionary<String, String>()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let ssdpAddres          = "224.0.0.1"
        let ssdpPort:UInt16     = 1612
        
        // send search message
        
        
        //setup receiving
        let ssdpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())
        try! ssdpSocket.bindToPort(ssdpPort)
        try! ssdpSocket.enableBroadcast(true)
        try! ssdpSocket.beginReceiving()
        try! ssdpSocket.joinMulticastGroup(ssdpAddres)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!, withFilterContext filterContext: AnyObject!) {
        let json = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
        if let result = json as? Dictionary<String, String> {
            if let server:String = result["server"], status:String = result["status"] {
                //print("\(server) : \(status)")
                if status == "true" {
                  self.servers[server] = "Recording"
                }
                if status == "false" {
                  self.servers[server] = ""
                }
                
            }
            self.tableView.reloadData()
        }

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:
        NSIndexPath) -> UITableViewCell {
        let serverArray = servers.map {"\($0) \($1)"}
        let sortedServers = serverArray.sort { $0 < $1 }
        let new = UITableViewCell()
        new.textLabel!.text = sortedServers[indexPath.row]
        return new
    }
}

