//
//  ViewController.swift
//  Geofencing For Noobs
//
//  Created by Hilton Pintor Bezerra Leite on 25/04/2018.
//  Copyright © 2018 Hilton Pintor Bezerra Leite. All rights reserved.
//

import UIKit
import CoreLocation
import LocalAuthentication
import AVFoundation

//jesse.AcademyJournal

class ViewController: UIViewController {
    
    @IBOutlet weak var reflectionTableView: UITableView!
    
    var listOfRecording = [String]()
    var recordingDates = [String]()
    var recordNumber:Int = 0
    var audioPlayer: AVAudioPlayer!
    var isPlaying:Bool = false
    var selectedIndex:Int = 100
    var previousSelectedIndex:IndexPath?
    
    let locationManager = CLLocationManager()
    var context = LAContext()
    
    enum AuthenticationState {
        case loggedin, loggedout
    }
    
    /// The current authentication state.
    var state = AuthenticationState.loggedout 
    //    var currentLocationManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let defaults = UserDefaults.standard
        listOfRecording = defaults.object(forKey:"nameArray") as? [String] ?? [String]()
        recordingDates  = defaults.object(forKey: "dateArray") as? [String] ?? [String]()
        listOfRecording.reverse()
        recordingDates.reverse()

        reflectionTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SIRI
        let activity = NSUserActivity(activityType: "jesse.AcademyJournal.Add a Journal")
        activity.title = "Add a Journal"
        activity.isEligibleForSearch = true
        if #available(iOS 12.0, *) {
            activity.isEligibleForPrediction = true
        } else {
            // Fallback on earlier versions
        }
        
        self.userActivity = activity
        self.userActivity?.becomeCurrent()
        
        self.locationManager.requestAlwaysAuthorization()
        
        // Your coordinates go here (lat, lon)
        let geofenceRegionCenter = CLLocationCoordinate2D(
            latitude: -6.302032470703125,
            longitude: 106.65222012648022
        )
        
        /* Create a region centered on desired location,
         choose a radius for the region (in meters)
         choose a unique identifier for that region */
        let geofenceRegion = CLCircularRegion(
            center: geofenceRegionCenter,
            radius: 100,
            identifier: "UniqueIdentifier"
        )
        
        
        geofenceRegion.notifyOnEntry = true
        geofenceRegion.notifyOnExit = true
        
        self.locationManager.startMonitoring(for: geofenceRegion)
        self.locationManager.allowsBackgroundLocationUpdates = true
        
        
        //TABLE VIEW DELEGATES
        reflectionTableView.delegate = self
        reflectionTableView.dataSource = self
        
        //USER DEFAULTS
        let defaults = UserDefaults.standard
        listOfRecording = defaults.object(forKey:"nameArray") as? [String] ?? [String]()
        recordingDates  = defaults.object(forKey: "dateArray") as? [String] ?? [String]()
        
        //LOCAL AUTH
//        context = LAContext()
        
//        context.localizedCancelTitle = "Enter Username/Password"
//
//        // First check if we have the needed hardware support.
//        var error: NSError?
//        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
//
//            let reason = "Log in to your account"
//            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
//
//                if success {
//                    // Move to the main thread because a state update triggers UI changes.
//                    DispatchQueue.main.async { [unowned self] in
//                        self.state = .loggedin
//                    }
//                } else {
//                    print(error?.localizedDescription ?? "Failed to authenticate")
//                    // Fall back to a asking for username and password.
//                    // ...
//                }
//            }
//        } else {
//            print(error?.localizedDescription ?? "Can't evaluate policy")
//            // Fall back to a asking for username and password.
//            // ...
//        }
        
    }
    
    func addRecord(name: String) {
        listOfRecording.append(name)
        print("Appended !!!!!!")
    }
    
    func addRecordDates(date: String) {
        recordingDates.append(date)
        print("Appended !!!!!!")
    }
}

extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfRecording.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        listOfRecording.reverse()
//        recordingDates.reverse()
        let row = listOfRecording[indexPath.row]
        print(recordingDates)
        let date = recordingDates[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "reflectionCell") as? ReflectionTableViewCell
        cell?.setUI(title: row,date: date)
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recordNumber = indexPath.row+1
        
        let cell = tableView.cellForRow(at: indexPath) as! ReflectionTableViewCell
        
        if previousSelectedIndex != nil{
            let prevCell = tableView.cellForRow(at: previousSelectedIndex!) as! ReflectionTableViewCell
            
            if previousSelectedIndex == indexPath{
                prevCell.playImage.image = #imageLiteral(resourceName: "Play Button")
                audioPlayer.stop()
                previousSelectedIndex = nil
                return
            }else{
                prevCell.playImage.image = #imageLiteral(resourceName: "Play Button")
                cell.playImage.image = #imageLiteral(resourceName: "StopButton")
                previousSelectedIndex = indexPath
            }
        }else{
            cell.playImage.image = #imageLiteral(resourceName: "StopButton")
            previousSelectedIndex = indexPath
        }
        
        let audioFilename = getDocumentsDirectory().appendingPathComponent("\(listOfRecording.count-recordNumber+1).m4a")
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer.play()
            isPlaying = true
            selectedIndex = indexPath.row
            previousSelectedIndex = indexPath
        } catch {
            print("Cannot Load")
        }
        
        //        performSegue(withIdentifier: "viewReflectionSegue", sender: self)
        //
        //        print("You select row \(recordNumber), Tryin to open recording\(recordNumber).m4a")
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "viewReflectionSegue"{
    //            guard let result = segue.destination as? OpenReflectionViewController else {return}
    //            result.numberOfRecordingThatWillBeOpened = recordNumber
    //        }
    //    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
