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
//    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var micImage: UIImageView!
    @IBOutlet weak var exitButton: UIButton!
    
    var recordingSession:AVAudioSession!
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    var numberOfRecords = 0
    var playbackIsPlaying:Bool = false
    
   lazy var pulse=Pulsing(numberOfPulses: Float.infinity, radius: 200, position:micImage.center)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
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
            addPulse()
            exitButton.isEnabled = false
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
            pulse.removeFromSuperlayer()
            audioRecorder.stop()
            exitButton.isEnabled = true
            audioRecorder = nil
             recordButton.setTitle("Start Recording", for: .normal)
            
            UserDefaults.standard.set(numberOfRecords, forKey: "myNumber")
            saveRecording()
            print("record saved")
            
            performSegue(withIdentifier: "addTitle", sender: self)
//            displayCompletionAlert()
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
    
//    func displayCompletionAlert(){
//        let alert = UIAlertController(title: "Recording Successful", message: "Your Reflection Has Been Saved, Yay!", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Go to Home", style: .default, handler: { (action) in
//            alert.dismiss(animated: true, completion: nil)
//             self.performSegue(withIdentifier: "toHome", sender: self)
//        }))
//        present(alert, animated: true, completion: nil)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let segueToAllRecord = segue.destination as? ViewController
        
        // Function to append to AllRecordViewController
        
//        let recordingName = titleTextField.text ?? "Recording \(numberOfRecords)"
        
//        segueToAllRecord?.addRecord(name: recordingName)
        segueToAllRecord?.addRecordDates(date: getDate())
        print(segueToAllRecord?.recordingDates)
        segueToAllRecord?.reflectionTableView.reloadData()
        
        print("=====================================")
        print("Record added with \(numberOfRecords)")
    }
    
    func saveRecording() {
        let defaults = UserDefaults.standard
//        var nameRecordingArray = defaults.object(forKey:"nameArray") as? [String] ?? [String]()
        var dateRecordingArray = defaults.object(forKey:"dateArray") as? [String] ?? [String]()
//        let recordingName = titleTextField.text ?? "Recording \(numberOfRecords)"
        
//        print(recordingName)
        
        let formattedDate = getDate()
        dateRecordingArray.append(formattedDate)
//       nameRecordingArray.append(recordingName)
//        defaults.set(nameRecordingArray, forKey: "nameArray")
        defaults.set(dateRecordingArray, forKey: "dateArray")
    }
    
    func getDate()->String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd "
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    
    func addPulse(){
        pulse=Pulsing(numberOfPulses: Float.infinity, radius: 200, position:micImage.center)
        pulse.animationDuration = 0.8
        pulse.backgroundColor = UIColor.blue.cgColor
        self.view.layer.insertSublayer(pulse, below: micImage.layer)
    }
    @IBAction func exitVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension UIViewController{
    //tap anywhere to dismiss keyboard
    func hideKeyboard(){
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
}

extension UIViewController:UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
    
//    @IBAction func playbackRecording(_ sender: Any) {
//        if playbackIsPlaying == false{
//            let fileName = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
//            do{
//                try audioPlayer = AVAudioPlayer(contentsOf: fileName, fileTypeHint: "m4a")
//                audioPlayer.play()
//                playbackButton.setTitle("StopPlayback", for: .normal)
//                playbackIsPlaying = true
//            }catch{
//
//            }
//        }else{
//            audioPlayer.stop()
//            playbackButton.setTitle("StartPlayback", for: .normal)
//            playbackIsPlaying = false
//        }
//    }
//    @IBAction func backToHome(_ sender: Any) {
//        performSegue(withIdentifier: "toHome", sender: self)
//    }
//}

