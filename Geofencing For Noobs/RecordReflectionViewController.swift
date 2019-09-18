//
//  RecordReflectionViewController.swift
//  Geofencing For Noobs
//
//  Created by Jesse Joseph on 17/09/19.
//  Copyright © 2019 Hilton Pintor Bezerra Leite. All rights reserved.
//

import UIKit
import AVFoundation

class RecordReflectionViewController: UIViewController,AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playbackButton: UIButton!
    
    var recordingSession:AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    var numberOfRecords = 0
    var playbackIsPlaying:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let number:Int = UserDefaults.standard.object(forKey: "myNumber") as? Int{
            numberOfRecords = number
            print(numberOfRecords)
        }
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            try recordingSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            recordingSession.requestRecordPermission { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        
                    } else {
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        if audioRecorder == nil{
            numberOfRecords += 1
            print(numberOfRecords)
            let fileName = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            let settings = [AVFormatIDKey : Int(kAudioFormatMPEG4AAC), AVSampleRateKey : 44100, AVNumberOfChannelsKey : 1, AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue]
            
            //startRecording
            do{
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                recordButton.setTitle("Stop Recording", for: .normal)
            }catch{
                displayAlert(title: "Oops", message: "Recording went wrong :(")
            }
        }else{
            audioRecorder.stop()
            audioRecorder = nil
             recordButton.setTitle("Start Recording", for: .normal)
            
            UserDefaults.standard.set(numberOfRecords, forKey: "myNumber")
            saveRecording()
            print("record saved")
            
//            performSegue(withIdentifier: "toHome", sender: self)
        }
    }
    
    func getDirectory()->URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    func displayAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let segueToAllRecord = segue.destination as? ViewController
        
        // Function to append to AllRecordViewController
        segueToAllRecord?.addRecord(name: "Recording\(numberOfRecords)")
        segueToAllRecord?.reflectionTableView.reloadData()
        
        print("=====================================")
        print("Record added with \(numberOfRecords)")
    }
    
    func saveRecording() {
        let defaults = UserDefaults.standard
        var nameRecordingArray = defaults.object(forKey:"nameArray") as? [String] ?? [String]()
        nameRecordingArray.append("Recording\(numberOfRecords)")
        defaults.set(nameRecordingArray, forKey: "nameArray")
    }
    
    @IBAction func playbackRecording(_ sender: Any) {
        if playbackIsPlaying == false{
            let fileName = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            do{
                try audioPlayer = AVAudioPlayer(contentsOf: fileName, fileTypeHint: "m4a")
                audioPlayer.play()
                playbackButton.setTitle("StopPlayback", for: .normal)
                playbackIsPlaying = true
            }catch{
                
            }
        }else{
            audioPlayer.stop()
            playbackButton.setTitle("StartPlayback", for: .normal)
            playbackIsPlaying = false
        }
    }
    @IBAction func backToHome(_ sender: Any) {
        performSegue(withIdentifier: "toHome", sender: self)
    }
}

